//
//  UIView_Chess.h
//  FiveInARow
//
//  Created by brook on 1/26/14.
//  Copyright (c) 2014 brook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubChessView.h"

@interface UIView_Chess : UIView
{
}

- (void) CreateChess:(int)left top:(int)top row:(int)row column:(int)column hight:(int)hight width:(int)width;

- (bool) addChess:(UIView*)view imgUrl:(NSString*)imgurl;
- (void) removeChess:(UIView*)view;

- (int) getRow:(UIView*)view;
- (int) getColumn:(UIView*)view;
- (void) clearChess;
@end
