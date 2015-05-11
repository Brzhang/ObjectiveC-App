//
//  AI_MaxMin.m
//  FiveInARow
//
//  Created by brook on 2/18/14.
//  Copyright (c) 2014 brook. All rights reserved.
//

#import "AI_MaxMin.h"

@implementation AI_MaxMin
@synthesize tactic;

- (bool) Init:(int)row column:(int)column matrix:(int **)matrix
{
    tactic = [Tactics alloc];
    if (tactic)
    {
        if(matrix && [tactic Init:row column:column matrix:matrix])
            return true;
    }
    return  false;
}

- (int) countLevelEx: (SeqInfo)info
{
    int iLevel = 0;
    switch (info.ilength)
    {
        case 5:
        {
            if (info.state != LIVEJUMP)
            {
                iLevel = MAKEFIVE;
            }
            break;
        }
        case 4:
        {
            if (info.state != LIVE )
            {
                iLevel = MAKEDIEFOUR;
            }
            else
            {
                iLevel = MAKELIVEFOUR;
            }
            break;
        }
        case 3:
        {
            if (info.state != LIVE )
            {
                iLevel = MAKEDIETHREE;
            }
            else
            {
                iLevel = MAKELIVETHREE;
            }
            break;
        }
        case 2:
        {
            if (info.state != LIVE )
            {
                iLevel = MAKEDIETWO;
            }
            else
            {
                iLevel = MAKELIVETWO;
            }
            break;
        }
        case 1:
        {
            if (info.state != LIVE )
            {
                iLevel = MAKEDIEONE;
            }
            else
            {
                iLevel = MAKELIVEONE;
            }
            break;
        }
        default:
            break;
    }
    return iLevel;
}

- (int) countLevel:(int)x y:(int)y value:(int)value
{
    if (!tactic)
    {
        return 0;
    }
    int iLevel = 0xFFFFFFFF;
    int iLevelTemp = iLevel;
    //int relx[4] = {-1,-1,-1,-1};
    //int rely[4] = {-1,-1,-1,-1};
    //count the level of (x,y) in chess
    //first count the level in row, column, left diagonal and right diagonal, then select the largest as the level of (x,y)
    SeqInfo info[4];
    info[0] = [tactic makeSeqRow:x y:y value:value relx:nil rely:nil];
    iLevelTemp = [self countLevelEx:info[0]];
    if (iLevel < iLevelTemp)
    {
        iLevel = iLevelTemp;
    }
    
    info[1] = [tactic makeSeqColumn:x y:y value:value relx:nil rely:nil];
    iLevelTemp = [self countLevelEx:info[1]];
    if (iLevel < iLevelTemp)
    {
        iLevel = iLevelTemp;
    }
    
    info[2] = [tactic makeSeqLeftDiagonal:x y:y value:value relx:nil rely:nil];
    iLevelTemp = [self countLevelEx:info[2]];
    if (iLevel < iLevelTemp)
    {
        iLevel = iLevelTemp;
    }
    
    info[3] = [tactic makeSeqRightDiagonal:x y:y value:value relx:nil rely:nil];
    iLevelTemp = [self countLevelEx:info[3]];
    if (iLevel < iLevelTemp)
    {
        iLevel = iLevelTemp;
    }
    
    return iLevel*value;
}

- (void) FoundDrop:(int)value x:(int*)x y:(int*)y
{
    int iLevel = 0;
    
    //Create max-min tree and search the best drop
    leafNode head;
    leafNode* nodefind = NULL;
    head.value = value;
    
    [self createTree:&head depth:LOW];
    
    nodefind = [self max_minSearch:&head depth:LOW value:value];
    
    *x = nodefind->x;
    *y = nodefind->y;
    
    NSLog(@"FoundDrop: %d, %d, %d",*x,*y,iLevel);
}

//max-min search
- (leafNode*) max_minSearch:(leafNode*)node depth:(int)depth value:(int)value
{
    //deep search to find the max level for current player or the min level for enemy
    
    return node;
}

//create max-min tree
- (void) createTree:(leafNode*)node depth:(int)depth
{
    if(depth == 0)
    {
        return;
    }
    
    for (int i=0; i<tactic.m_iRow; ++i)
    {
        for (int j=0; j<tactic.m_iColumn; ++j)
        {
            if (tactic.m_iMatrix[i][j] == 0)
            {
                //could be add into the tree
                leafNode* childnode = malloc(sizeof(leafNode));
                childnode->x = i;
                childnode->y = j;
                childnode->value = -node->value;
                //set the level
                childnode->level = [self countLevel:i y:j value:childnode->value];
                node->lchild = childnode;
                
                [self createTree:node->lchild depth:--depth];
            }
        }
    }

}

//cut alpha beta leafnode
- (void) cutAlphaBeta:(leafNode*)node
{
    
}

@end
