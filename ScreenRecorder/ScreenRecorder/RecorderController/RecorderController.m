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
    [self removeTempFilePath:[NSString stringWithFormat:@"%@/%@",_saveDir,@"audio.aac"]];
    [self removeTempFilePath:[NSString stringWithFormat:@"%@/%@",_saveDir,@"video.mp4"]];
    [_audioRecorder start:[NSString stringWithFormat:@"%@/%@",saveDir,@"audio.aac"]];
    _screenRecorder.videoURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",saveDir,@"video.mp4"]];
    [_screenRecorder startRecording];
    return YES;
}

-(BOOL) stop
{
    [_audioRecorder stop];
    [self removeTempFilePath:[NSString stringWithFormat:@"%@/%@",_saveDir,@"Merge.mp4"]];
    [_screenRecorder stopRecordingWithCompletion:^{
        [self merge:[NSString stringWithFormat:@"%@/%@",_saveDir,@"audio.aac"]
              video:[NSString stringWithFormat:@"%@/%@",_saveDir,@"video.mp4"]];
    }];
    return YES;
}

// 混合音乐
- (void)merge:(NSString*)audio video:(NSString*)video
{
    NSLog(@"Merge start");
    // 声音来源
    NSURL *audioInputUrl = [NSURL fileURLWithPath:audio];
    // 视频来源
    NSURL *videoInputUrl = [NSURL fileURLWithPath:video];
    
    // 最终合成输出路径
    NSString *outPutFilePath = [NSString stringWithFormat:@"%@/%@",_saveDir,@"Merge.mp4"];
    // 添加合成路径
    NSURL *outputFileUrl = [NSURL fileURLWithPath:outPutFilePath];
    // 时间起点
    CMTime nextClistartTime = kCMTimeZero;
    // 创建可变的音视频组合
    AVMutableComposition *comosition = [AVMutableComposition composition];
    
    
    // 视频采集
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:videoInputUrl options:nil];
    // 视频时间范围
    CMTimeRange videoTimeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    // 视频通道 枚举 kCMPersistentTrackID_Invalid = 0
    AVMutableCompositionTrack *videoTrack = [comosition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    // 视频采集通道
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    //  把采集轨道数据加入到可变轨道之中
    [videoTrack insertTimeRange:videoTimeRange ofTrack:videoAssetTrack atTime:nextClistartTime error:nil];
    
    
    
    // 声音采集
    AVURLAsset *audioAsset = [[AVURLAsset alloc] initWithURL:audioInputUrl options:nil];
    // 因为视频短这里就直接用视频长度了,如果自动化需要自己写判断
    CMTimeRange audioTimeRange = videoTimeRange;
    // 音频通道
    AVMutableCompositionTrack *audioTrack = [comosition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    // 音频采集通道
    AVAssetTrack *audioAssetTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    // 加入合成轨道之中
    [audioTrack insertTimeRange:audioTimeRange ofTrack:audioAssetTrack atTime:nextClistartTime error:nil];
    
    // 创建一个输出
    AVAssetExportSession *assetExport = [[AVAssetExportSession alloc] initWithAsset:comosition presetName:AVAssetExportPresetHighestQuality];
    // 输出类型
    assetExport.outputFileType = AVFileTypeMPEG4;
    // 输出地址
    assetExport.outputURL = outputFileUrl;
    // 优化
    assetExport.shouldOptimizeForNetworkUse = NO;
    // 合成完毕
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        // 回到主线程
        /*dispatch_async(dispatch_get_main_queue(), ^{
            // 调用播放方法
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"合成成功" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alert show];
        });*/
        NSLog(@"Merge finished.");
    }];
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
