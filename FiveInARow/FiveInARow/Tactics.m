//
//  Tactics.m
//  FiveInARow
//
//  Created by brook on 1/27/14.
//  Copyright (c) 2014 brook. All rights reserved.
//

#import "Tactics.h"

@implementation Tactics
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

- (winner) assertWinner: (int)iSum
{
    if (iSum >= 5)
    {
        return WHITEWIN;
    }
    else if(iSum <= -5)
    {
        return BLACKWIN;
    }
    return NOWIN;
}

- (winner) CountWar: (NSInteger)x y:(NSInteger)y
{
    int iSum = 0;
    int iOldSum = 0;
    winner win;
    //count the subarray if the sum of subarray is 5 or -5 mean the winner been found.
    //row
    for (int i = 0; i<m_iRow; ++i)
    {
        iSum+=m_iMatrix[i][y];
        win = [self assertWinner:iSum];
        if (win != NOWIN) {
            return win;
        }
        if (abs(iSum) < abs(iOldSum)) {
            iSum = 0;
            --i;
        }
        iOldSum = iSum;
    }
    
    //column
    iSum = iOldSum = 0;
    for (int i = 0; i<m_iColumn; ++i)
    {
        iSum+=m_iMatrix[x][i];
        win = [self assertWinner:iSum];
        if (win != NOWIN) {
            return win;
        }
        if (abs(iSum) < abs(iOldSum)) {
            iSum = 0;
            --i;
        }
        iOldSum = iSum;
    }
    
    //X
    iSum = iOldSum = 0;
    int i = x;
    int j = y;
    while (i>0 && j>0) {
        --i;
        --j;
    }
    while (i<m_iRow && j<m_iColumn)
    {
        iSum+=m_iMatrix[i][j];
        win = [self assertWinner:iSum];
        if (win != NOWIN) {
            return win;
        }
        if (abs(iSum) < abs(iOldSum)) {
            iSum = 0;
            --i;
        }
        iOldSum = iSum;
        ++i;
        ++j;
    }
    
    iSum = iOldSum = 0;
    i = x;
    j = y;
    while (i>0 && j<m_iColumn-1) {
        --i;
        ++j;
    }

    while (i<m_iRow && j>=0)
    {
        iSum+=m_iMatrix[i][j];
        win = [self assertWinner:iSum];
        if (win != NOWIN) {
            return win;
        }
        if (abs(iSum) < abs(iOldSum)) {
            iSum = 0;
            --i;
        }
        iOldSum = iSum;
        ++i;
        --j;
    }
    return NOWIN;
}
@end
