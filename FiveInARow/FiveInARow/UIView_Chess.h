//
//  UIView_Chess.h
//  FiveInARow
//
//  Created by brook on 1/26/14.
//  Copyright (c) 2014 brook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView_Chess : UIView
{
    int iRow;
    int icolumn;
    UIImageView* imgChess;
}
@property (nonatomic,retain) UIImageView* imgChess;

- (void) addChess: (NSInteger)type imgurl:(NSString*)url;
- (void) removeChess;

@end
