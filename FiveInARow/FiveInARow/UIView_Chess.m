//
//  UIView_Chess.m
//  FiveInARow
//
//  Created by brook on 1/26/14.
//  Copyright (c) 2014 brook. All rights reserved.
//

#import "UIView_Chess.h"

@implementation UIView_Chess

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) CreateChess:(int)left top:(int)top row:(int)row column:(int)column hight:(int)hight width:(int)width
{
    [self initWithFrame:CGRectMake(left, top, width*row, hight*column)];
    
    for (int i = 0; i < row; ++i)
    {
        for (int j = 0; j < row; ++j)
        {
            SubChessView *view = [[SubChessView alloc] initWithFrame:CGRectMake(hight * i, hight * j, width, hight)];
            [view setCoordinate:i y:j];
            
            view.backgroundColor = ((i + j) & 0x1) ? [UIColor lightGrayColor] : [UIColor grayColor];
            [self addSubview:view];
        }
    }
}

- (bool) addChess:(UIView*)view imgUrl:(NSString*)imgurl
{
    return [(SubChessView*)view addChess:imgurl];
}

- (void) removeChess:(UIView*)view
{
    [(SubChessView*)view removeChess];
}

- (int) getRow:(UIView*)view
{
    return [(SubChessView*)view iRow];
}

- (int) getColumn:(UIView*)view
{
    return [(SubChessView*)view iColumn];
}

- (void) clearChess
{
    for (SubChessView *uiview in [self subviews])
    {
        [uiview removeChess];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
