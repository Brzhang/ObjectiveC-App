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

- (bool) Init:(int)row column:(int)column;
- (Winner) CountWar: (int)x y:(int)y;
- (void) setMatrixValue: (int)x y:(int)y value:(int)value;
- (void) clearMatrix;
- (SeqInfo) makeSeqRow:(int)x y:(int)y value:(int)value;
- (SeqInfo) makeSeqColumn:(int)x y:(int)y value:(int)value;
- (SeqInfo) makeSeqLeftDiagonal:(int)x y:(int)y value:(int)value;
- (SeqInfo) makeSeqRightDiagonal:(int)x y:(int)y value:(int)value;
@end
