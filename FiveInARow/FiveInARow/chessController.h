//
//  chessController.h
//  FiveInARow
//
//  Created by brook on 2/8/14.
//  Copyright (c) 2014 brook. All rights reserved.
//

#import "AppDelegate.h"
#import "Tactics.h"
#import "AI_Ergodic.h"

typedef enum{
    EASY,
    MIDDLE,
    HARD
}AI_LEVEL;

@interface chessController : AppDelegate
{
    Tactics* tactic;
    AI_Ergodic* ai_ergodic;
    
    int** m_iMatrix;
    int m_iRow;
    int m_iColumn;
}

@property (nonatomic,retain) Tactics* tactic;
@property (nonatomic,retain) AI_Ergodic* ai_ergodic;
@property (nonatomic)int** m_iMatrix;
@property (nonatomic)int m_iRow;
@property (nonatomic)int m_iColumn;

- (bool) Init:(int)row column:(int)column;
- (bool) enableAI:(int)level;
- (bool) isAIenabled;
- (Winner) CountWar: (int)x y:(int)y;
- (void) setMatrixValue: (int)x y:(int)y value:(int)value;
- (void) clearMatrix;
- (void) AIDropChess:(int*)x y:(int*)y value:(int)value;

@end
