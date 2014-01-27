//
//  SubChessView.h
//  FiveInARow
//
//  Created by brook on 1/26/14.
//  Copyright (c) 2014 brook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubChessView : UIView
{
    int iRow;
    int iColumn;
    UIImageView* imgChess;
}
@property (nonatomic,retain) UIImageView* imgChess;
@property (nonatomic)int iRow;
@property (nonatomic)int iColumn;

- (bool) addChess:(NSString*)imgurl;
- (void) removeChess;
- (void) setCoordinate:(int)x y:(int)y;

- (int) getRow;
- (int) getColumn;

@end
