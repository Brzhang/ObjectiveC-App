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

- (Winner) CountWar: (int)x y:(int)y
{
    SeqInfo info[4];
    info[0] = [self makeSeqRow:x y:y value:m_iMatrix[x][y]];
    info[1] = [self makeSeqColumn:x y:y value:m_iMatrix[x][y]];
    info[2] = [self makeSeqLeftDiagonal:x y:y value:m_iMatrix[x][y]];
    info[3] = [self makeSeqRightDiagonal:x y:y value:m_iMatrix[x][y]];
    
    //double live three or four , if first player made double three then the opponent will win.
    int iCount = 0;
    for (int i = 0; i<4; ++i)
    {
        if(info[i].ilength >= 3 && (info[i].state == LIVE || info[i].state == LIVEJUMP))
            ++iCount;
        
         //five in a row is win
        if (info[i].ilength == 5)
        {
            return m_iMatrix[x][y] == 1?BALCK:WHITE;
        }
    }
    if (iCount>=2 && m_iMatrix[x][y] == 1) {
        return WHITE;
    }
    return NOWINNER;
}

- (SeqInfo) makeSeqRow:(int)x y:(int)y value:(int)value
{
    bool bflag = false;
    SeqInfo seq = {0};
    int i = x;
    while (i>=0 && i< m_iRow)
    {
        if (m_iMatrix[i][y] == value)
        {
            ++seq.ilength;
        }
        else
        {
            if (m_iMatrix[i][y] != 0)
            {
                bflag = true;
            }
            break;
        }
        --i;
    }
    i = x+1;
    while (i>=0 && i< m_iRow)
    {
        if (m_iMatrix[i][y] == value)
        {
            ++seq.ilength;
        }
        else
        {
            if (m_iMatrix[i][y] != 0)
            {
                bflag = true;
            }
            break;
        }
        ++i;
    }
    
    if (bflag) {
        seq.state = DIED;
    }
    else
    {
        seq.state = LIVE;
    }
    return seq;
}
- (SeqInfo) makeSeqColumn:(int)x y:(int)y value:(int)value
{
    bool bflag = false;
    SeqInfo seq = {0};
    int i = y;
    while (i>=0 && i< m_iRow)
    {
        if (m_iMatrix[x][i] == value)
        {
            ++seq.ilength;
        }
        else
        {
            if (m_iMatrix[i][y] != 0)
            {
                bflag = true;
            }
            break;
        }
        --i;
    }
    i = y+1;
    while (i>=0 && i< m_iRow)
    {
        if (m_iMatrix[x][i] == value)
        {
            ++seq.ilength;
        }
        else
        {
            if (m_iMatrix[i][y] != 0)
            {
                bflag = true;
            }
            break;
        }
        ++i;
    }
    if (bflag) {
        seq.state = DIED;
    }
    else
    {
        seq.state = LIVE;
    }
    return seq;}
 
- (SeqInfo) makeSeqLeftDiagonal:(int)x y:(int)y value:(int)value
{
    bool bflag = false;
    SeqInfo seq = {0};
    int i = x;
    int j = y;
    while (i>=0 && i< m_iRow && j>=0 && j<m_iColumn)
    {
        if (m_iMatrix[i][j] == value)
        {
            ++seq.ilength;
        }
        else
        {
            if (m_iMatrix[i][j] != 0)
            {
                bflag = true;
            }
            break;
        }
        --i;
        --j;
    }
    i = x+1;
    j = y+1;
    while (i>=0 && i< m_iRow && j>=0 && j<m_iColumn)
    {
        if (m_iMatrix[i][j] == value)
        {
            ++seq.ilength;
        }
        else
        {
            if (m_iMatrix[i][j] != 0)
            {
                bflag = true;
            }
            break;
        }
        ++i;
        ++j;
    }
    if (bflag) {
        seq.state = DIED;
    }
    else
    {
        seq.state = LIVE;
    }
    return seq;
}

- (SeqInfo) makeSeqRightDiagonal:(int)x y:(int)y value:(int)value
{
    bool bflag = false;
    SeqInfo seq = {0};
    int i = x;
    int j = y;
    while (i>=0 && i< m_iRow && j>=0 && j<m_iColumn)
    {
        if (m_iMatrix[i][j] == value)
        {
            ++seq.ilength;
        }
        else
        {
            if (m_iMatrix[i][j] != 0)
            {
                bflag = true;
            }
            break;
        }
        --i;
        ++j;
    }
    i = x+1;
    j = y-1;
    while (i>=0 && i< m_iRow && j>=0 && j<m_iColumn)
    {
        if (m_iMatrix[i][j] == value)
        {
            ++seq.ilength;
        }
        else
        {
            if (m_iMatrix[i][j] != 0)
            {
                bflag = true;
            }
            break;
        }
        ++i;
        --j;
    }
    if (bflag) {
        seq.state = DIED;
    }
    else
    {
        seq.state = LIVE;
    }
    return seq;}


@end
