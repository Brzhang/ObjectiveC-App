//
//  ViewController.m
//  ScreenRecorder
//
//  Created by Brook Zhang on 4/9/16.
//  Copyright © 2016 HowDo. All rights reserved.
//

#import "ViewController.h"
#import "RecorderController.h"
#import <MediaPlayer/MPMoviePlayerController.h>

#define SavedFilePath                       [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,\
                                                NSUserDomainMask, YES) firstObject]\
                                                stringByAppendingPathComponent:@"MicroCourse"]
static NSString* languageFilePath = @"";
#define HDNSLocalizedString(key)        [[NSBundle bundleWithPath:languageFilePath] \
                                            localizedStringForKey:(key) \
                                            value:@"" table:@"Language"]
@interface ViewController ()
@property (nonatomic, strong) UILabel* timeLable;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) RecorderController* recorderController;
@property (nonatomic, assign) u_long timecount;
@property (nonatomic, strong) MPMoviePlayerController* moviePlayer;
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, strong) UIButton* btnController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _recorderController = [[RecorderController alloc] init];
    languageFilePath = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
    _isRecording = NO;
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI
{
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 400)];
    UIImage* image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pic" ofType:@"jpg"]];
    imageView.image= image;
    [self.view addSubview:imageView];
    
    _btnController = [[UIButton alloc] initWithFrame:CGRectMake(100, 50, 80, 30)];
    _btnController.backgroundColor = [UIColor greenColor];
    _btnController.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btnController setTitle:HDNSLocalizedString(@"StrButtonStart") forState:UIControlStateNormal];
    [_btnController addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnController];
    
    _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tryEverything" ofType:@"mp4"]]];
    [self installMovieNotificationObservers];
    _moviePlayer.view.frame = CGRectMake(0, 400, self.view.frame.size.width, self.view.frame.size.height - 400);
    [_moviePlayer setMovieSourceType:MPMovieSourceTypeFile];
    
    [self.view addSubview:_moviePlayer.view];
    
    _timeLable = [[UILabel alloc] initWithFrame:CGRectMake(100, 300, 200, 100)];
    _timeLable.textAlignment = NSTextAlignmentCenter;
    _timeLable.text = @"0";
    _timeLable.font = [UIFont systemFontOfSize:64];
    _timeLable.textColor = [UIColor whiteColor];
    [self.view addSubview:_timeLable];
    
    UISegmentedControl * languageSelector = [[UISegmentedControl alloc] initWithItems:[[NSArray alloc] initWithObjects:@"chinese",@"english",@"mongolia", nil]];
    languageSelector.frame = CGRectMake(200, 50, 200, 30);
    [self.view addSubview:languageSelector];
    [languageSelector addTarget:self action:@selector(segmentDidClick:) forControlEvents:UIControlEventValueChanged];
}
- (void) clickBtnAction:(UIButton*)sender
{
    if (!_isRecording) {
        //start timer and start record
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerProcess) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        _timecount = 0;
        [_recorderController start:SavedFilePath];
        [sender setTitle:HDNSLocalizedString(@"StrButtonEnd") forState:UIControlStateNormal];

        [_moviePlayer play];
        _isRecording = YES;
    }
    else
    {
        [_moviePlayer stop];
        //stop timer and stop record
        if (_timer.isValid) {
            [_timer invalidate];
        }
        [_recorderController stop];
        _timecount = 0;
        _timeLable.text = @"0";
        [sender setTitle:HDNSLocalizedString(@"StrButtonStart")  forState:UIControlStateNormal];
        _isRecording = NO;
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

- (void)segmentDidClick:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            //chinese;
            languageFilePath = [[NSBundle mainBundle] pathForResource:@"Base" ofType:@"lproj"];
            break;
        }
        case 1:
        {
            languageFilePath = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
            //english
            break;
        }
        case 2:
        {
            //mongulia
            languageFilePath = [[NSBundle mainBundle] pathForResource:@"mn-MN" ofType:@"lproj"];
            break;
        }
        default:
            break;
    }
    if (_isRecording) {
        [_btnController setTitle:HDNSLocalizedString(@"StrButtonEnd") forState:UIControlStateNormal];
    }
    else{
        [_btnController setTitle:HDNSLocalizedString(@"StrButtonStart") forState:UIControlStateNormal];
    }
}

-(void)installMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:_moviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_moviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_moviePlayer];
}

- (void) loadStateDidChange:(NSNotification*)notification
{}
- (void) moviePlayBackDidFinish:(NSNotification*)notification
{}
- (void) mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{}
- (void) moviePlayBackStateDidChange:(NSNotification*)notification
{}
@end
