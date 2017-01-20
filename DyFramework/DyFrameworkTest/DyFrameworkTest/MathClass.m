//
//  MathClass.m
//  DyFrameworkTest
//
//  Created by zhangjt on 1/20/17.
//  Copyright © 2017 zhangjt. All rights reserved.
//

#import "MathClass.h"

@implementation MathClass
-(id) add:(NSNumber*)a other:(NSNumber*)b
{
    return [[NSNumber alloc]initWithInt:([a intValue] + [b intValue])];
}
@end
