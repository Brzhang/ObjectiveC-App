//
//  ViewController.m
//  ToolMenuDemo
//
//  Created by Brook Zhang on 8/6/15.
//  Copyright (c) 2015 HowDo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80,30)];
    button.backgroundColor = [UIColor blackColor];
    [button addTarget:self action:@selector(insertBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)insertBtnClick:(id)sender
{
    NSString *str = [[NSBundle mainBundle] pathForResource:@"apple" ofType:@"jpg"];
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfFile:str]];
    UIImageView * iv = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100,
                                                                    self.view.frame.size.width/2,
                                                                    self.view.frame.size.height/2)];
    iv.image = img;
    [self.view addSubview:iv];
    [self buildPicToolMenu:iv showRect:CGRectMake(0, 10, 50, 30)];
}
/**
 *  建立图片的功能菜单
 *
 *  @param view 要添加菜单的 View
 *  @param rect  菜单要显示的位置
 */
- (void) buildPicToolMenu:(UIView*) view showRect:(CGRect) rect
{
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setTargetRect:rect inView:view];
    UIMenuItem *rotate = [[UIMenuItem alloc]initWithTitle:@"旋转" action:@selector(rotate:)];
    //UIMenuItem *delete=[[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(delete:)];
    UIMenuItem *finish = [[UIMenuItem alloc]initWithTitle:@"完成" action:@selector(finish:)];
    menu.menuItems = [NSArray arrayWithObjects:rotate, /*delete,*/ finish,nil];
    [menu setMenuVisible:YES animated:YES];
    BOOL set = [self becomeFirstResponder];
    NSLog(@"asdfaf%d",set?1:0);
}

-(void) rotate:(id)sender
{
}

-(void) finish:(id)sender
{
}

-(BOOL) canBecomeFirstResponder
{
    return YES;
}

-(BOOL) canPerformAction:(SEL)action withSender:(id)sender
{
    return YES;
}
@end
