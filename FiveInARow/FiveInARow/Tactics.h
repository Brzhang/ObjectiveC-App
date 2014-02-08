//
//  Tactics.h
//  FiveInARow
//
//  Created by brook on 1/27/14.
//  Copyright (c) 2014 brook. All rights reserved.
//

#import "AppDelegate.h"

typedef enum
{
    LIVE,
    DIED,
    LIVEJUMP
}SeqState;

typedef struct
{
    int ilength;
    SeqState state;
}SeqInfo;

typedef enum
{
    BALCK,
    WHITE,
    NOWINNER
} Winner;

@interface Tactics : AppDelegate
{
    int** m_iMatrix;
    int m_iRow;
    int m_iColumn;
}
@property (nonatomic)int** m_iMatrix;
@property (nonatomic)int m_iRow;
@property (nonatomic)int m_iColumn;

- (bool) Init:(int)row column:(int)column matrix:(int**)matrix;
- (Winner) CountWar: (int)x y:(int)y;
- (SeqInfo) makeSeqRow:(int)x y:(int)y value:(int)value relx:(int*)rx rely:(int*)ry;
- (SeqInfo) makeSeqColumn:(int)x y:(int)y value:(int)value relx:(int*)rx rely:(int*)ry;
- (SeqInfo) makeSeqLeftDiagonal:(int)x y:(int)y value:(int)value relx:(int*)rx rely:(int*)ry;
- (SeqInfo) makeSeqRightDiagonal:(int)x y:(int)y value:(int)value relx:(int*)rx rely:(int*)ry;
- (void) clearrel:(int*)rel;
@end
