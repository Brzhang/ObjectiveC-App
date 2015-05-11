//
//  AI_MaxMin.h
//  FiveInARow
//
//  Created by brook on 2/18/14.
//  Copyright (c) 2014 brook. All rights reserved.
//

#import "AI_Base.h"
#import "../Tactics.h"
typedef struct node
{
    int x;
    int y;
    int value;
    int level;
    struct node* lchild;
    struct node* rchild;
}leafNode;

typedef enum
{
    LOW = 3,
    MEDDLE = 5,
    HIGH = 10,
    SUPERHIGH = 20
}rebotLevel;

@interface AI_MaxMin : AI_Base
{
    Tactics* tactic;
}
@property (nonatomic,retain) Tactics* tactic;

- (bool) Init:(int)row column:(int)column matrix:(int **)matrix;
- (int) countLevel:(int)x y:(int)y value:(int)value;
- (void) FoundDrop:(int)value x:(int*)x y:(int*)y;

//max-min search
- (leafNode*) max_minSearch:(leafNode*)node depth:(int)depth value:(int)value;
//create max-min tree
- (void) createTree:(leafNode*)node depth:(int)depth;
//cut alpha beta leafnode
- (void) cutAlphaBeta:(leafNode*)node;
@end
