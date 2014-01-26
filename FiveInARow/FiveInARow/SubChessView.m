//
//  SubChessView.m
//  FiveInARow
//
//  Created by brook on 1/26/14.
//  Copyright (c) 2014 brook. All rights reserved.
//

#import "SubChessView.h"

@implementation SubChessView

@synthesize iRow;
@synthesize iColumn;
@synthesize imgChess;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    imgChess = nil;
    
    return self;
}

- (void) addChess:(NSString*)imgurl
{
    if (imgChess != nil) {
        return;
    }
    
    imgChess = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgurl]];
    
    [self addSubview:imgChess];
}

- (void) removeChess
{
    [imgChess removeFromSuperview];
    imgChess = nil;
}

- (void) setCoordinate:(int)x y:(int)y
{
    iRow = x;
    iColumn = y;
}

- (int) getRow
{
    return iRow;
}
- (int) getColumn
{
    return iColumn;
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
