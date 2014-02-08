//
//  AI_Base.h
//  FiveInARow
//
//  Created by brook on 1/28/14.
//  Copyright (c) 2014 brook. All rights reserved.
//

#import "AppDelegate.h"
#import <math.h>

@interface AI_Base : AppDelegate
typedef enum
{
    MAKEFIVE = 100,
    MAKELIVEFOUR = 99,
    MAKEDIEFOUR = 90,
    MAKELIVETHREE = 80,
    MAKEDIETHREE = 40,
    MAKELIVETWO = 35,
    MAKEDIETWO = 20,
    MAKELIVEONE = 15,
    MAKEDIEONE = 5
}MakeLevel;

#define PI 3.1415926535
#define CHESS_LEVEL_FUN(x,y) sin((x)*PI/(y))*100
@end
