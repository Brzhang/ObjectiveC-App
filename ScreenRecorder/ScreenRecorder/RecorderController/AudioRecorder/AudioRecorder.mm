//
//  AudioRecorder.m
//  ScreenRecorder
//
//  Created by Brook Zhang on 4/9/16.
//  Copyright © 2016 HowDo. All rights reserved.
//

#import "AudioRecorder.h"
#import <AudioToolbox/AudioQueue.h>
#import <AudioToolbox/AudioFile.h>

//Structure for a recording audio queue
static const int kNumberBuffers = 3;
struct AQRecorderState
{
    AudioStreamBasicDescription  mDataFormat;
    AudioQueueRef                mQueue;
    AudioQueueBufferRef          mBuffers[kNumberBuffers];
    AudioFileID                  mAudioFile;
    UInt32                       bufferByteSize;
    SInt64                       mCurrentPacket;
    bool                         mIsRunning;
};

@interface AudioRecorder()
{
    struct AQRecorderState aqData;
}
@end

@implementation AudioRecorder

//The recording audio queue callback function
static void HandleInputBuffer (void                                 *aqData,
                               AudioQueueRef                        inAQ,
                               AudioQueueBufferRef                  inBuffer,
                               const AudioTimeStamp                 *inStartTime,
                               UInt32                               inNumPackets,
                               const AudioStreamPacketDescription   *inPacketDesc)
{
    AQRecorderState *pAqData = (AQRecorderState *) aqData;
    
    if (inNumPackets == 0 && pAqData->mDataFormat.mBytesPerPacket != 0)
        inNumPackets = inBuffer->mAudioDataByteSize / pAqData->mDataFormat.mBytesPerPacket;
    
    if (AudioFileWritePackets(pAqData->mAudioFile,
                              false,
                              inBuffer->mAudioDataByteSize,
                              inPacketDesc,
                              pAqData->mCurrentPacket,
                              &inNumPackets,
                              inBuffer->mAudioData) == noErr)
    {
        pAqData->mCurrentPacket += inNumPackets;
    }
    if (pAqData->mIsRunning == 0)
        return;
    
    AudioQueueEnqueueBuffer(pAqData->mQueue, inBuffer, 0, NULL);
}

//Deriving a recording audio queue buffer size
void DeriveBufferSize (AudioQueueRef                audioQueue,
                       AudioStreamBasicDescription& ASBDescription,
                       Float64                      seconds,
                       UInt32                       *outBufferSize)
{
    static const int maxBufferSize = 0x50000;
    
    int maxPacketSize = ASBDescription.mBytesPerPacket;
    if (maxPacketSize == 0)
    {
        UInt32 maxVBRPacketSize = sizeof(maxPacketSize);
        AudioQueueGetProperty(audioQueue,
                              kAudioQueueProperty_MaximumOutputPacketSize,
                              // in Mac OS X v10.5, instead use
                              //   kAudioConverterPropertyMaximumOutputPacketSize
                              &maxPacketSize,
                              &maxVBRPacketSize);
    }
    
    Float64 numBytesForTime = ASBDescription.mSampleRate * maxPacketSize * seconds;
    *outBufferSize = UInt32(numBytesForTime < maxBufferSize ? numBytesForTime : maxBufferSize);
}

//Setting a magic cookie for an audio file
OSStatus SetMagicCookieForFile (AudioQueueRef inQueue, AudioFileID inFile)
{
    OSStatus result = noErr;
    UInt32 cookieSize;
    
    if (AudioQueueGetPropertySize(inQueue,
                                  kAudioQueueProperty_MagicCookie,
                                  &cookieSize) == noErr)
    {
        char* magicCookie = (char *) malloc (cookieSize);
        if (AudioQueueGetProperty(inQueue,
                                  kAudioQueueProperty_MagicCookie,
                                  magicCookie,
                                  &cookieSize) == noErr)
        {
            result = AudioFileSetProperty(inFile,
                                          kAudioFilePropertyMagicCookieData,
                                          cookieSize,
                                          magicCookie);
        }
        free (magicCookie);
    }
    return result;
}

//Specifying an audio queue’s audio data format
void SetAudioFormat(AudioStreamBasicDescription& format)
{
    /*format.mFormatID         = kAudioFormatMPEG4AAC;
    format.mSampleRate       = 44100.0;
    format.mChannelsPerFrame = 2;
    format.mFramesPerPacket  = 1024;
    format.mFormatFlags      = kMPEG4Object_AAC_LC;*/
    format.mFormatID         = kAudioFormatLinearPCM; // 2
    format.mSampleRate       = 44100.0;               // 3
    format.mChannelsPerFrame = 2;                     // 4
    format.mBitsPerChannel   = 16;                    // 5
    format.mBytesPerPacket   =                        // 6
    format.mBytesPerFrame =
    format.mChannelsPerFrame * sizeof (SInt16);
    format.mFramesPerPacket  = 1;                     // 7
    
    format.mFormatFlags =                             // 9
    kLinearPCMFormatFlagIsBigEndian
    | kLinearPCMFormatFlagIsSignedInteger
    | kLinearPCMFormatFlagIsPacked;
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

- (id) init
{
    self = [super init];
    if (self)
    {
        aqData.mIsRunning = false;
    }
    return self;
}

- (void) dealloc
{
    AudioQueueDispose(aqData.mQueue, true);
    
    AudioFileClose(aqData.mAudioFile);
}

- (BOOL) start: (NSString *) filePath
{
    SetAudioFormat(aqData.mDataFormat);
    
    OSStatus status;
    //Creating a recording audio queue
    status = AudioQueueNewInput(&aqData.mDataFormat,
                                HandleInputBuffer,
                                &aqData,
                                NULL,
                                kCFRunLoopCommonModes,
                                0,
                                &aqData.mQueue);
    if (status)
    {
        return NO;
    }
    
    //Getting the audio format from an audio queue
    UInt32 dataFormatSize = sizeof(aqData.mDataFormat);
    
    status = AudioQueueGetProperty(aqData.mQueue,
                                   kAudioQueueProperty_StreamDescription,
                                   // in Mac OS X, instead use
                                   //    kAudioConverterCurrentInputStreamDescription
                                   &aqData.mDataFormat,
                                   &dataFormatSize);
    if (status)
    {
        return NO;
    }
    
    //Creating an audio file for recording
    CFURLRef audioFileURL = CFURLCreateFromFileSystemRepresentation(NULL,
                                                                    (const UInt8 *)[filePath UTF8String],
                                                                    [filePath length],
                                                                    false);
    AudioFileCreateWithURL(audioFileURL,
                           kAudioFileCAFType,
                           &aqData.mDataFormat,
                           kAudioFileFlags_EraseFile,
                           &aqData.mAudioFile);
    CFRelease(audioFileURL);
    
    //Setting an audio queue buffer size
    DeriveBufferSize(aqData.mQueue,
                     aqData.mDataFormat,
                     0.5,
                     &aqData.bufferByteSize);
    
    //Preparing a set of audio queue buffers
    for (int i=0;i<kNumberBuffers;i++)
    {
        if (AudioQueueAllocateBuffer(aqData.mQueue, aqData.bufferByteSize, &aqData.mBuffers[i]))
        {
            return NO;
        }
        
        if (AudioQueueEnqueueBuffer (aqData.mQueue, aqData.mBuffers[i], 0, NULL))
        {
            return NO;
        }
    }
    // for streaming, magic cookie is unnecessary
    // copy the cookie first to give the file object as much info as we can about the data going in
    // not necessary for pcm, but required for some compressed audio
    //SetMagicCookieForFile(aqData.mQueue, aqData.mAudioFile);

    aqData.mCurrentPacket = 0;
    aqData.mIsRunning = true;
    
    if (AudioQueueStart(aqData.mQueue, NULL))
    {
        return NO;
    }
    return YES;
}

- (BOOL) stop
{
    BOOL ret = NO;;
    if (AudioQueueStop(aqData.mQueue, true))
    {
        ret = NO;
    }
    else
    {
        ret = YES;
    }
    if (AudioFileClose (aqData.mAudioFile))
    {
        ret = NO;
    }
    aqData.mIsRunning = false;
    return ret;
}

- (BOOL) pause
{
    if (AudioQueuePause(aqData.mQueue))
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
@end
