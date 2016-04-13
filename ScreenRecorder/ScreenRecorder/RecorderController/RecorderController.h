//
//  RecorderController.h
//  ScreenRecorder
//
//  Created by Brook Zhang on 4/9/16.
//  Copyright © 2016 HowDo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecorderController : NSObject

-(BOOL) start:(NSString*) saveDir;
-(BOOL) stop;

@end
