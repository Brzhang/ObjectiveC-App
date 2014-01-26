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
    
    imgChess = nil;
    
    return self;
}

- (void) addChess: (NSInteger)type imgurl:(NSString*)url
{
    if (imgChess != nil) {
        return;
    }
    
    imgChess = [[UIImageView alloc]initWithImage:[UIImage imageNamed:url]];
    
    [self addSubview:imgChess];
}

- (void) removeChess
{
    [imgChess removeFromSuperview];
    imgChess = nil;
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
