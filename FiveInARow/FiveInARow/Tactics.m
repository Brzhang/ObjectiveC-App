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

- (winner) assertWinner: (int*)iSum
{
    if (*iSum == 5)
    {
        *iSum = 0;
        return WHITEWIN;
    }
    else if(*iSum == -5)
    {
        *iSum = 0;
        return BLACKWIN;
    }
    *iSum = 0;
    return NOWIN;
}

- (winner) CountWar: (NSInteger)x y:(NSInteger)y
{
    int iSum = 0;
    winner win;
    if (x - 4 >= 0) {
        
        for(int i = 0; i < 5; ++i)
            iSum += m_iMatrix[x-i][y];
    }
    win = [self assertWinner:&iSum];
    if (win != NOWIN) {
        return win;
    }
    
    if (x + 4 < m_iRow) {
        
        for(int i = 0; i < 5; ++i)
            iSum += m_iMatrix[x+i][y];
    }
    win = [self assertWinner:&iSum];
    if (win != NOWIN) {
        return win;
    }
    
    if (y - 4 >= 0) {
        
        for(int i = 0; i < 5; ++i)
            iSum += m_iMatrix[x][y-i];
    }
    win = [self assertWinner:&iSum];
    if (win != NOWIN) {
        return win;
    }
    
    if (y + 4 < m_iRow) {
        
        for(int i = 0; i < 5; ++i)
            iSum += m_iMatrix[x][y+i];
    }
    win = [self assertWinner:&iSum];
    if (win != NOWIN) {
        return win;
    }
    
    if (x-4>=0 && y-4>=0) {
        for(int i = 0; i < 5; ++i)
            iSum += m_iMatrix[x-i][y-i];
        
    }
    win = [self assertWinner:&iSum];
    if (win != NOWIN) {
        return win;
    }
    
    if (x-4>=0 && y+4<m_iColumn) {
        for(int i = 0; i < 5; ++i)
            iSum += m_iMatrix[x-i][y+i];
        
    }
    win = [self assertWinner:&iSum];
    if (win != NOWIN) {
        return win;
    }
    
    if (x+4<m_iColumn && y-4>=0) {
        for(int i = 0; i < 5; ++i)
            iSum += m_iMatrix[x+i][y-i];
        
    }
    win = [self assertWinner:&iSum];
    if (win != NOWIN) {
        return win;
    }
    
    if (x+4<m_iColumn && y+4<m_iColumn) {
        for(int i = 0; i < 5; ++i)
            iSum += m_iMatrix[x+i][y+i];
        
    }
    win = [self assertWinner:&iSum];
    if (win != NOWIN) {
        return win;
    }
    return NOWIN;
}
@end
