//
//  AI_Ergodic.m
//  FiveInARow
//
//  Created by brook on 2/7/14.
//  Copyright (c) 2014 brook. All rights reserved.
//

#import "AI_Ergodic.h"
#import "../Tactics.h"

@implementation AI_Ergodic
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
    int relx[4] = {-1,-1,-1,-1};
    int rely[4] = {-1,-1,-1,-1};
    //count the level of (x,y) in chess
    //first count the level in row, column, left diagonal and right diagonal, then select the largest as the level of (x,y)
    SeqInfo info[4];
    info[0] = [tactic makeSeqRow:x y:y value:value relx:relx rely:rely];
    iLevelTemp = [self countLevelEx:info[0]];
    if (iLevel < iLevelTemp)
    {
        iLevel = iLevelTemp;
    }
    
    info[1] = [tactic makeSeqColumn:x y:y value:value relx:relx rely:rely];
    iLevelTemp = [self countLevelEx:info[1]];
    if (iLevel < iLevelTemp)
    {
        iLevel = iLevelTemp;
    }
    
    info[2] = [tactic makeSeqLeftDiagonal:x y:y value:value relx:relx rely:rely];
    iLevelTemp = [self countLevelEx:info[2]];
    if (iLevel < iLevelTemp)
    {
        iLevel = iLevelTemp;
    }
    
    info[3] = [tactic makeSeqRightDiagonal:x y:y value:value relx:relx rely:rely];
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
    int iLevelTemp = 0;
    //assert if drop chess here , the max level value
    for (int i=0; i<tactic.m_iRow; ++i)
    {
        for (int j=0; j<tactic.m_iColumn; ++j)
        {
            //only count the place where could drop chess
            if (tactic.m_iMatrix[i][j] != 0)
            {
                continue;
            }
            
            //count enemy's chess
            tactic.m_iMatrix[i][j] = -value;
            iLevel = [self countLevel:i y:j value:-value];
            if (abs(iLevel) > abs(iLevelTemp))
            {
                iLevelTemp = iLevel;
                *x = i;
                *y = j;
            }
            tactic.m_iMatrix[i][j] = 0;
        }
    }
    
    for (int i=0; i<tactic.m_iRow; ++i)
    {
        for (int j=0; j<tactic.m_iColumn; ++j)
        {
            //only count the place where could drop chess
            if (tactic.m_iMatrix[i][j] != 0)
            {
                continue;
            }

            tactic.m_iMatrix[i][j] = value;
            iLevel = [self countLevel:i y:j value:value];
            if (abs(iLevel) > abs(iLevelTemp))
            {
                iLevelTemp = iLevel;
                *x = i;
                *y = j;
            }
            tactic.m_iMatrix[i][j] = 0;
        }
    }

    NSLog(@"FoundDrop: %d, %d, %d",*x,*y,iLevelTemp);
}
@end
