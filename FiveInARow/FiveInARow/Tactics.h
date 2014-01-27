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
    WHITEWIN,
    BLACKWIN,
    NOWIN
}winner;

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
- (winner) assertWinner: (int*)iSum;
- (winner) CountWar: (int)x y:(int)y;
- (void) setMatrixValue: (int)x y:(int)y value:(int)value;
- (void) clearMatrix;
@end
