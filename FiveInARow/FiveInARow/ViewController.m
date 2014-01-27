//
//  ViewController.m
//  FiveInARow
//
//  Created by brook on 1/24/14.
//  Copyright (c) 2014 brook. All rights reserved.
//

#import "ViewController.h"
#import "UIView_Chess.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize viewchess;
@synthesize btnReStart;
@synthesize btnExit;


#define iRow  10
#define iLineHigh 32
int iMatrix[iRow][iRow];
int iOwner;
bool bfinished;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGRect rect = [[UIScreen mainScreen] bounds];
  
    iOwner = 0;
    bfinished = false;
    
    viewchess = [UIView_Chess alloc];
    [viewchess CreateChess:0 top:(rect.size.height-iRow*iLineHigh)/2 row:iRow column:iRow hight:iLineHigh width:iLineHigh];
    [self.view addSubview:viewchess];
    viewchess.tag = 100;
    
    for (int i=0; i<iRow; ++i)
    {
        for (int j=0; j<iRow; ++j) {
            iMatrix[i][j] = 0;
        }
    }
}

- (void) addPoint:(UIView*)view
{
    NSString *strPoint = nil;
    if (iOwner & 0x1)
    {
        strPoint = @"black.png";
    }
    else
    {
        strPoint = @"white.png";
    }
    
    [viewchess addChess:view imgUrl:strPoint];
    
    int i = [viewchess getRow:view];
    int j = [viewchess getColumn:view];
    
    if (iOwner & 0x1)
    {
        iMatrix[i][j] = -1;
    }
    else
    {
        iMatrix[i][j] = 1;
    }
    ++iOwner;
    
    [self CountWar:i y:j];
}


- (void) assertWinner: (int*)iSum
{
    if (*iSum == 5)
    {
        bfinished = true;
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"title" message:@"白子胜。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else if(*iSum == -5)
    {
        bfinished = true;
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"title" message:@"黑子胜。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    *iSum = 0;
}

- (void) CountWar: (NSInteger)x y:(NSInteger)y
{
    int iSum = 0;
    if (x - 4 >= 0) {
        
        for(int i = 0; i < 5; ++i)
            iSum += iMatrix[x-i][y];
    }
    [self assertWinner:&iSum];
    
    if (x + 4 < iRow) {
        
        for(int i = 0; i < 5; ++i)
            iSum += iMatrix[x+i][y];
    }
    [self assertWinner:&iSum];
    
    if (y - 4 >= 0) {
        
        for(int i = 0; i < 5; ++i)
            iSum += iMatrix[x][y-i];
    }
    [self assertWinner:&iSum];

    if (y + 4 < iRow) {
        
        for(int i = 0; i < 5; ++i)
            iSum += iMatrix[x][y+i];
    }
    [self assertWinner:&iSum];
    
    if (x-4>=0 && y-4>=0) {
        for(int i = 0; i < 5; ++i)
            iSum += iMatrix[x-i][y-i];

    }
    [self assertWinner:&iSum];
    
    if (x-4>=0 && y+4<iLineHigh) {
        for(int i = 0; i < 5; ++i)
            iSum += iMatrix[x-i][y+i];
        
    }
    [self assertWinner:&iSum];
    
    if (x+4<iLineHigh && y-4>=0) {
        for(int i = 0; i < 5; ++i)
            iSum += iMatrix[x+i][y-i];
        
    }
    [self assertWinner:&iSum];
    
    if (x+4<iLineHigh && y+4<iLineHigh) {
        for(int i = 0; i < 5; ++i)
            iSum += iMatrix[x+i][y+i];
        
    }
    [self assertWinner:&iSum];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];    //return all objects relational
    UITouch *touch = [allTouches anyObject];   //return all objects in the view
    //CGPoint point = [touch locationInView:[touch view]]; //return the coordinate of the touch point
    
    if(touch.view.backgroundColor == [UIColor lightGrayColor] || touch.view.backgroundColor == [UIColor grayColor])
    {
       [self addPoint:touch.view];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) shouldAutorotate
{
    return TRUE;
}

- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
   if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
   {
       for (UIView *View in [self.view subviews])
       {
           if (View.tag == 100)
           {
               int x = View.frame.origin.x;
               int y = View.frame.origin.y;
               int width = View.frame.size.width;
               int height = View.frame.size.height;
        
               View.frame = CGRectMake(y, x, width, height);
           }
       }
    }
}

-(IBAction)ReStartPressUp:(id)sender
{
    [viewchess clearChess];
    
    for (int i=0; i<iRow; ++i)
    {
        for (int j=0; j<iRow; ++j) {
            iMatrix[i][j] = 0;
        }
    }
}

-(IBAction)ExitPressUp:(id)sender
{
    exit(0);
}

@end
