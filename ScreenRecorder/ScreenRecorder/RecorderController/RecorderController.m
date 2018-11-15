//
//  RecorderController.m
//  ScreenRecorder
//
//  Created by Brook Zhang on 4/9/16.
//  Copyright © 2016 HowDo. All rights reserved.
//

#import "RecorderController.h"
#import "AudioRecorder.h"
#import "ASScreenRecorder.h"
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

#define USE_AVAudeoRecorder

@interface RecorderController()
@property (nonatomic, strong) AudioRecorder*    audioRecorder;
@property (nonatomic, strong) ASScreenRecorder* screenRecorder;
@property (nonatomic, strong) NSString*         saveDir;
@end

@implementation RecorderController

-(id) init
{
    self = [super init];
    if (self)
    {
        _audioRecorder = [[AudioRecorder alloc] init];
        _screenRecorder = [[ASScreenRecorder alloc] init];
    }
    return self;
}

-(BOOL) start:(NSString*) saveDir
{
    _saveDir = saveDir;
    //if dir is not exist , create it
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:saveDir])
    {
        if (![fileManager createDirectoryAtPath:saveDir withIntermediateDirectories:NO attributes:nil error:NULL])
        {
            return NO;
        }
    }
    NSString* audiofilePath = @"";
#ifdef USE_AVAudeoRecorder
    audiofilePath = [NSString stringWithFormat:@"%@/%@",_saveDir,@"audio.caf"];
    _audioRecorder.enum_audioRecorder = EA_AVAudioRecorder;
#else
    audiofilePath = [NSString stringWithFormat:@"%@/%@",_saveDir,@"audio.acc"];
    _audioRecorder.enum_audioRecorder = EA_AudioQueue;
#endif
    [self removeTempFilePath:audiofilePath];
    [self removeTempFilePath:[NSString stringWithFormat:@"%@/%@",_saveDir,@"video.mp4"]];
    [_audioRecorder start:audiofilePath];
    _screenRecorder.videoURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",saveDir,@"video.mp4"]];
    _screenRecorder.fps = 20;
    [_screenRecorder startRecording];
    return YES;
}

-(BOOL) stop
{
    [_audioRecorder stop];
    [_screenRecorder stopRecordingWithCompletion:^{
        NSString* audiofilePath = @"";
#ifdef USE_AVAudeoRecorder
        audiofilePath = [NSString stringWithFormat:@"%@/%@",_saveDir,@"audio.caf"];
#else
        audiofilePath = [NSString stringWithFormat:@"%@/%@",_saveDir,@"audio.acc"];
#endif
        [self merge:audiofilePath
              video:[NSString stringWithFormat:@"%@/%@",_saveDir,@"video.mp4"]];
    }];
    return YES;
}

//merge the audio and video
- (BOOL)merge:(NSString*)audio video:(NSString*)video
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:audio] || ![fileManager fileExistsAtPath:video])
    {
        return NO;
    }
    
    //input audio
    NSURL *audioInputUrl = [NSURL fileURLWithPath:audio];
    //input video
    NSURL *videoInputUrl = [NSURL fileURLWithPath:video];
    NSLog(@"Merge start");
    //out put merge file
    NSURL *outputFileUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",_saveDir,@"Merge.mp4"]];
    //start time
    CMTime nextClistartTime = kCMTimeZero;
    AVMutableComposition *comosition = [AVMutableComposition composition];
    
    //video asset
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:videoInputUrl options:nil];
    //video time range
    CMTimeRange videoTimeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    AVMutableCompositionTrack *videoTrack = [comosition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    //video asset track
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    //add the track data into the compositon track
    [videoTrack insertTimeRange:videoTimeRange ofTrack:videoAssetTrack atTime:nextClistartTime error:nil];
    
    //audio asset
    AVURLAsset *audioAsset = [[AVURLAsset alloc] initWithURL:audioInputUrl options:nil];
    //we just consider the audio time range is equal video time range.
    CMTimeRange audioTimeRange = videoTimeRange;
    AVMutableCompositionTrack *audioTrack = [comosition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //audio asset track
    AVAssetTrack *audioAssetTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    //add the track data into the compositon track
    [audioTrack insertTimeRange:audioTimeRange ofTrack:audioAssetTrack atTime:nextClistartTime error:nil];
    
    //export session
    AVAssetExportSession *assetExport = [[AVAssetExportSession alloc] initWithAsset:comosition presetName:AVAssetExportPresetHighestQuality];
    //export type
    assetExport.outputFileType = AVFileTypeMPEG4;
    assetExport.outputURL = outputFileUrl;
    assetExport.shouldOptimizeForNetworkUse = NO;
    //finished
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        /*dispatch_async(dispatch_get_main_queue(), ^{
        });*/
        NSLog(@"Merge finished.");
    }];
    return YES;
}

- (void)removeTempFilePath:(NSString*)filePath
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError* error;
        if ([fileManager removeItemAtPath:filePath error:&error] == NO) {
            NSLog(@"Could not delete old recording:%@", [error localizedDescription]);
        }
    }
}

@end
