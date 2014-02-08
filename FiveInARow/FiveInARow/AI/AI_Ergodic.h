//
//  AI_Ergodic.h
//  FiveInARow
//
//  Created by brook on 2/7/14.
//  Copyright (c) 2014 brook. All rights reserved.
//

#import "AI_Base.h"
#import "Tactics.h"

@interface AI_Ergodic : AI_Base
{
    Tactics* tactic;
}
@property (nonatomic,retain) Tactics* tactic;

- (bool) Init:(int)row column:(int)column matrix:(int **)matrix;
- (int) countLevel:(int)x y:(int)y value:(int)value;
- (void) FoundDrop:(int)value x:(int*)x y:(int*)y;

@end