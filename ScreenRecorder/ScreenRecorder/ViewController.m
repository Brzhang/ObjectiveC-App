//
//  ViewController.m
//  ScreenRecorder
//
//  Created by Brook Zhang on 4/9/16.
//  Copyright © 2016 HowDo. All rights reserved.
//

#import "ViewController.h"
#import "RecorderController.h"

#define SavedFilePath                       [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,\
                                                NSUserDomainMask, YES) firstObject]\
                                                stringByAppendingPathComponent:@"MicroCourse"]

@interface ViewController ()
@property (nonatomic, strong) UILabel* timeLable;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) RecorderController* recorderController;
@property (nonatomic, assign) u_long timecount;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createUI];
    _recorderController = [[RecorderController alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI
{
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(140, 80, 80, 30)];
    button.backgroundColor = [UIColor greenColor];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitle:@"Start" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    _timeLable = [[UILabel alloc] initWithFrame:CGRectMake(160, 300, 50, 50)];
    _timeLable.textAlignment = NSTextAlignmentCenter;
    _timeLable.text = @"0";
    [self.view addSubview:_timeLable];
}

- (void) clickBtnAction:(UIButton*)sender
{
    if ([sender.titleLabel.text isEqualToString:@"Start"]) {
        //start timer and start record
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerProcess) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        _timecount = 0;
        [_recorderController start:SavedFilePath];
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
    }
    else
    {
        //stop timer and stop record
        if (_timer.isValid) {
            [_timer invalidate];
        }
        [_recorderController stop];
        _timecount = 0;
        _timeLable.text = @"0";
        [sender setTitle:@"Start" forState:UIControlStateNormal];
    }
}

- (void) timerProcess
{
    _timeLable.text = [NSString stringWithFormat:@"%ld",++_timecount];
}

-(void) dealloc
{
    if (_timer.isValid) {
        [_timer invalidate];
    }
    [_recorderController stop];
}
@end
