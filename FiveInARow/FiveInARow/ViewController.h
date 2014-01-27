//
//  ViewController.h
//  FiveInARow
//
//  Created by brook on 1/24/14.
//  Copyright (c) 2014 brook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView_Chess.h"

@interface ViewController : UIViewController
{
    UIView_Chess* viewchess;
    IBOutlet UIButton* btnReStart;
    IBOutlet UIButton* btnExit;
}
@property (nonatomic,retain) UIView_Chess* viewchess;
@property (nonatomic,retain) UIButton* btnReStart;
@property (nonatomic,retain) UIButton* btnExit;

-(IBAction)ReStartPressUp:(id)sender;
-(IBAction)ExitPressUp:(id)sender;

- (void) assertWinner: (int*)iSum;
- (void) CountWar: (NSInteger)x y:(NSInteger)y;
@end
