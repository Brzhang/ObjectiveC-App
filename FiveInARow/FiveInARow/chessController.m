//
//  chessController.m
//  FiveInARow
//
//  Created by brook on 2/8/14.
//  Copyright (c) 2014 brook. All rights reserved.
//

#import "chessController.h"

@implementation chessController
@synthesize tactic;
@synthesize ai_ergodic;
@synthesize m_iMatrix;
@synthesize m_iRow;
@synthesize m_iColumn;

- (bool) Init:(int)row column:(int)column
{
    m_iRow = row;
    m_iColumn = column;
    
    m_iMatrix = malloc(sizeof(int)*row);
    if (m_iMatrix) {
        for (int i=0; i<column; ++i) {
            m_iMatrix[i] = malloc(sizeof(int)*column);
        }
    }
    
    if (m_iMatrix)
    {
        [self clearMatrix];
        
        tactic = [Tactics alloc];
        if (tactic)
        {
            if(![tactic Init:m_iRow column:m_iColumn matrix:m_iMatrix])
                return false;
        }
        return true;
    }
    else
    {
        return false;
    }
}

- (void) clearMatrix
{
    for (int i=0; i<m_iRow; ++i) {
        for (int j=0; j<m_iColumn; ++j) {
            m_iMatrix[i][j] = 0;
        }
    }
}

- (void) setMatrixValue: (int)x y:(int)y value:(int)value
{
    m_iMatrix[x][y] = value;
}

- (bool) enableAI:(int)level
{
    switch (level)
    {
        case EASY:
        {
            ai_ergodic = [AI_Ergodic alloc];
            if (ai_ergodic)
            {
                if ([ai_ergodic Init:m_iRow column:m_iColumn matrix:m_iMatrix])
                {
                    return true;
                }
            }
        }
        default:
            break;
    }
    return false;
}

- (bool) isAIenabled
{
    if (ai_ergodic) {
        return true;
    }
    return false;
}

- (Winner) CountWar: (int)x y:(int)y
{
    return [tactic CountWar:x y:y];
}

- (void) AIDropChess:(int*)x y:(int*)y value:(int)value
{
    [ai_ergodic FoundDrop:value x:x y:y];
}

@end
