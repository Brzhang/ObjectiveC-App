//
//  AudioRecorder.h
//  ScreenRecorder
//
//  Created by Brook Zhang on 4/9/16.
//  Copyright © 2016 HowDo. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    EA_AVAudioRecorder = 0,
    EA_AudioQueue,
}ENUM_AUDIORECORDER;

@interface AudioRecorder : NSObject
@property (nonatomic, assign) ENUM_AUDIORECORDER enum_audioRecorder;
- (BOOL) start: (NSString *) filePath;
- (BOOL) stop;
- (BOOL) pause;
@end
