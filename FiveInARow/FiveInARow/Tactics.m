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

int relx[4] = {-1,-1,-1,-1};
int rely[4] = {-1,-1,-1,-1};

- (bool) Init:(int)row column:(int)column matrix:(int**)matrix
{
    m_iRow = row;
    m_iColumn = column;
    if (matrix)
    {
        m_iMatrix = matrix;
        return  true;
    }
    return false;
}

- (void) clearrel:(int*)rel
{
    for (int i=0; i<4; ++i) {
        rel[i] = -1;
    }
}

- (Winner) CountWar: (int)x y:(int)y
{
    SeqInfo info[4];
    [self clearrel:relx];
    [self clearrel:rely];
    info[0] = [self makeSeqRow:x y:y value:m_iMatrix[x][y] relx:relx rely:rely];
    if (info[0].ilength == 5 && info[0].state != LIVEJUMP)
    {
        return m_iMatrix[x][y] == 1?BALCK:WHITE;
    }
    if(info[0].ilength >= 3 && info[0].state == LIVE && m_iMatrix[x][y] == 1)
    {
        SeqInfo Subinfo[3];
        //assert whether it is double three or double four ,if first player made double three then the opponent will win.
        for (int i = 0; i<4; ++i)
        {
            if (relx[i] > 0 && rely[i] > 0)
            {
                Subinfo[0] = [self makeSeqColumn:relx[i] y:rely[i] value:m_iMatrix[relx[i]][rely[i]] relx:NULL rely:NULL];
                Subinfo[1] = [self makeSeqLeftDiagonal:relx[i] y:rely[i] value:m_iMatrix[relx[i]][rely[i]] relx:NULL rely:NULL];
                Subinfo[2] = [self makeSeqRightDiagonal:relx[i] y:rely[i] value:m_iMatrix[relx[i]][rely[i]] relx:NULL rely:NULL];
                for (int j = 0; j<3; ++j)
                {
                    if (Subinfo[j].ilength >= 3 && Subinfo[j].state == LIVE)
                    {
                        return WHITE;
                    }
                }
            }
        }
    }
    
    
    [self clearrel:relx];
    [self clearrel:rely];
    info[1] = [self makeSeqColumn:x y:y value:m_iMatrix[x][y] relx:relx rely:rely];
    if (info[1].ilength == 5 && info[1].state != LIVEJUMP)
    {
        return m_iMatrix[x][y] == 1?BALCK:WHITE;
    }
    if(info[1].ilength >= 3 && info[1].state == LIVE && m_iMatrix[x][y] == 1)
    {
        SeqInfo Subinfo[3];
        //assert whether it is double three or double four ,if first player made double three then the opponent will win.
        for (int i = 0; i<4; ++i)
        {
            if (relx[i] > 0 && rely[i] > 0)
            {
                Subinfo[0] = [self makeSeqRow:relx[i] y:rely[i] value:m_iMatrix[relx[i]][rely[i]] relx:NULL rely:NULL];
                Subinfo[1] = [self makeSeqLeftDiagonal:relx[i] y:rely[i] value:m_iMatrix[relx[i]][rely[i]] relx:NULL rely:NULL];
                Subinfo[2] = [self makeSeqRightDiagonal:relx[i] y:rely[i] value:m_iMatrix[relx[i]][rely[i]] relx:NULL rely:NULL];
                for (int j = 0; j<3; ++j)
                {
                    if (Subinfo[j].ilength >= 3 && Subinfo[j].state == LIVE)
                    {
                        return WHITE;
                    }
                }
            }
        }
    }

    [self clearrel:relx];
    [self clearrel:rely];
    info[2] = [self makeSeqLeftDiagonal:x y:y value:m_iMatrix[x][y] relx:relx rely:rely];
    if (info[2].ilength == 5 && info[2].state != LIVEJUMP)
    {
        return m_iMatrix[x][y] == 1?BALCK:WHITE;
    }
    if(info[2].ilength >= 3 && info[2].state == LIVE && m_iMatrix[x][y] == 1)
    {
        SeqInfo Subinfo[3];
        //assert whether it is double three or double four ,if first player made double three then the opponent will win.
        for (int i = 0; i<4; ++i)
        {
            if (relx[i] > 0 && rely[i] > 0)
            {
                Subinfo[0] = [self makeSeqRow:relx[i] y:rely[i] value:m_iMatrix[relx[i]][rely[i]] relx:NULL rely:NULL];
                Subinfo[1] = [self makeSeqColumn:relx[i] y:rely[i] value:m_iMatrix[relx[i]][rely[i]] relx:NULL rely:NULL];
                Subinfo[2] = [self makeSeqRightDiagonal:relx[i] y:rely[i] value:m_iMatrix[relx[i]][rely[i]] relx:NULL rely:NULL];
                for (int j = 0; j<3; ++j)
                {
                    if (Subinfo[j].ilength >= 3 && Subinfo[j].state == LIVE)
                    {
                        return WHITE;
                    }
                }
            }
        }
    }

    [self clearrel:relx];
    [self clearrel:rely];
    info[3] = [self makeSeqRightDiagonal:x y:y value:m_iMatrix[x][y] relx:relx rely:rely];
    if (info[3].ilength == 5 && info[3].state != LIVEJUMP)
    {
        return m_iMatrix[x][y] == 1?BALCK:WHITE;
    }
    if(info[3].ilength >= 3 && info[3].state == LIVE && m_iMatrix[x][y] == 1)
    {
        SeqInfo Subinfo[3];
        //assert whether it is double three or double four ,if first player made double three then the opponent will win.
        for (int i = 0; i<4; ++i)
        {
            if (relx[i] > 0 && rely[i] > 0)
            {
                Subinfo[0] = [self makeSeqRow:relx[i] y:rely[i] value:m_iMatrix[relx[i]][rely[i]] relx:NULL rely:NULL];
                Subinfo[1] = [self makeSeqColumn:relx[i] y:rely[i] value:m_iMatrix[relx[i]][rely[i]] relx:NULL rely:NULL];
                Subinfo[2] = [self makeSeqLeftDiagonal:relx[i] y:rely[i] value:m_iMatrix[relx[i]][rely[i]] relx:NULL rely:NULL];
                for (int j = 0; j<3; ++j)
                {
                    if (Subinfo[j].ilength >= 3 && Subinfo[j].state == LIVE)
                    {
                        return WHITE;
                    }
                }
            }
        }
    }
    
    return NOWINNER;
}

- (SeqInfo) makeSeqRow:(int)x y:(int)y value:(int)value relx:(int*)rx rely:(int*)ry
{
    bool bflag = false;
    bool bjump = false;
    SeqInfo seq = {0};
    int i = x;
    while (i>=0 && i< m_iRow)
    {
        if (m_iMatrix[i][y] != 0 && m_iMatrix[i][y] != value)
        {
            bflag = true;
            ++i;
            break;
        }
        else if (m_iMatrix[i][y] == 0)
        {
            if (i>0  && m_iMatrix[i-1][y] == value)
            {
                --i;
                continue;
            }
            else
            {
                ++i;
                break;
            }
        }
        if (i == 0)
        {
            break;
        }
        --i;
    }
    while (i>=0 && i < m_iRow)
    {
        if (m_iMatrix[i][y] == value)
        {
            if (rx != NULL && ry != NULL)
            {
                relx[seq.ilength] = i;
                rely[seq.ilength] = y;
            }
            ++seq.ilength;
        }
        else
        {
            if (m_iMatrix[i][y] != 0)
            {
                bflag = true;
                break;
            }
            if (i < m_iRow-1)
            {
                if(m_iMatrix[i+1][y] != value)
                    break;
                else
                    bjump = true;
            }
        }
        ++i;
    }
    
    if (bflag) {
        seq.state = DIED;
    }
    else if(bjump)
    {
        seq.state = LIVEJUMP;
    }
    else
    {
        seq.state = LIVE;
    }
    return seq;
}
- (SeqInfo) makeSeqColumn:(int)x y:(int)y value:(int)value relx:(int*)rx rely:(int*)ry
{
    bool bflag = false;
    bool bjump = false;
    SeqInfo seq = {0};
    int i = y;
    while (i>=0 && i< m_iColumn)
    {
        if (m_iMatrix[x][i] != 0 && m_iMatrix[x][i] != value)
        {
            bflag = true;
            ++i;
            break;
        }
        else if (m_iMatrix[x][i] == 0)
        {
            if (i>0  && m_iMatrix[x][i-1] == value)
            {
                --i;
                continue;
            }
            else
            {
                ++i;
                break;
            }
        }
        if (i==0) {
            break;
        }
        --i;
    }
    while (i>=0 && i< m_iRow)
    {
        if (m_iMatrix[x][i] == value)
        {
            if (rx != NULL && ry != NULL)
            {
                relx[seq.ilength] = x;
                rely[seq.ilength] = i;
            }
            ++seq.ilength;
        }
        else
        {
            if (m_iMatrix[x][i] != 0)
            {
                bflag = true;
                break;
            }
            if (i < m_iColumn-1)
            {
                if (m_iMatrix[x][i+1] != value)
                    break;
                else
                    bjump = true;
            }
        }
        ++i;
    }
    if (bflag) {
        seq.state = DIED;
    }
    else if(bjump)
    {
        seq.state = LIVEJUMP;
    }
    else
    {
        seq.state = LIVE;
    }
    return seq;
}
 
- (SeqInfo) makeSeqLeftDiagonal:(int)x y:(int)y value:(int)value relx:(int*)rx rely:(int*)ry
{
    bool bflag = false;
    bool bjump = false;
    SeqInfo seq = {0};
    int i = x;
    int j = y;
    while (i>=0 && i< m_iRow && j>=0 && j<m_iColumn)
    {
        if (m_iMatrix[i][j] != 0 && m_iMatrix[i][j] != value)
        {
            bflag = true;
            ++i;
            ++j;
            break;
        }
        else if (m_iMatrix[i][j] == 0)
        {
            if (i>0 && j>0  && m_iMatrix[i-1][j-1] == value)
            {
                --i;
                --j;
                continue;
            }
            else
            {
                ++i;
                ++j;
                break;
            }
        }
        if (i==0 || j==0) {
            break;
        }
        --i;
        --j;
    }
    while (i>=0 && i< m_iRow && j>=0 && j<m_iColumn)
    {
        if (m_iMatrix[i][j] == value)
        {
            if (rx != NULL && ry != NULL)
            {
                relx[seq.ilength] = i;
                rely[seq.ilength] = j;
            }
            ++seq.ilength;
        }
        else
        {
            if (m_iMatrix[i][j] != 0)
            {
                bflag = true;
                break;
            }
            if (i < m_iRow-1 && j < m_iColumn-1 )
            {
                if(m_iMatrix[i+1][j+1] != value)
                    break;
                else
                    bjump = true;
            }
        }
        ++i;
        ++j;
    }
    if (bflag) {
        seq.state = DIED;
    }
    else if(bjump)
    {
        seq.state = LIVEJUMP;
    }
    else
    {
        seq.state = LIVE;
    }
    return seq;
}

- (SeqInfo) makeSeqRightDiagonal:(int)x y:(int)y value:(int)value relx:(int*)rx rely:(int*)ry
{
    bool bflag = false;
    bool bjump = false;
    SeqInfo seq = {0};
    int i = x;
    int j = y;
    while (i>=0 && i< m_iRow && j>=0 && j<m_iColumn)
    {
        if (m_iMatrix[i][j] != 0 && m_iMatrix[i][j] != value)
        {
            bflag = true;
            ++i;
            --j;
            break;
        }
        else if (m_iMatrix[i][j] == 0)
        {
            if (i>0 && j<m_iColumn-1  && m_iMatrix[i-1][j+1] == value)
            {
                --i;
                ++j;
                continue;
            }
            else
            {
                ++i;
                --j;
                break;
            }
        }
        if (i==0 || j== m_iColumn-1) {
            break;
        }
        --i;
        ++j;
    }
    while (i>=0 && i< m_iRow && j>=0 && j<m_iColumn)
    {
        if (m_iMatrix[i][j] == value)
        {
            if (rx != NULL && ry != NULL)
            {
                relx[seq.ilength] = i;
                rely[seq.ilength] = j;
            }
            ++seq.ilength;
        }
        else
        {
            if (m_iMatrix[i][j] != 0)
            {
                bflag = true;
                break;
            }
            if (i < m_iRow-1 && j>0)
            {
                if (m_iMatrix[i+1][j-1] != value)
                    break;
                else
                    bjump = true;
            }
        }
        ++i;
        --j;
    }
    if (bflag) {
        seq.state = DIED;
    }
    else if(bjump)
    {
        seq.state = LIVEJUMP;
    }
    else
    {
        seq.state = LIVE;
    }
    return seq;
}

@end
