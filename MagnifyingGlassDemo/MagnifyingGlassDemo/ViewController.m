//
//  ViewController.m
//  MagnifyingGlassDemo
//
//  Created by Brook on 25/07/15.
//  Copyright (c) 2015 Brook. All rights reserved.
//

#import "ViewController.h"
#import "MagnifierView.h"

@interface ViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) MagnifierView*    magnifyingGlassView;    /**< magnifying glass show view */
@property (nonatomic, strong) UIImageView*      imageView;              /**< hold image needed to enlarge */
@property (nonatomic, strong) UIView*           selectedView;           /**< selected view to enlarge */
@end

@implementation ViewController

typedef enum
{
    EGT_Pan = 1,
    EGT_Pinch = 1<<1,
    EGT_Rotation = 1<<2,
    EGT_Tap = 1<<3
}ENUM_Gesture_Type;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    _magnifyingGlassView = [[MagnifierView alloc] initWithFrame:
                           CGRectMake(screenRect.origin.x ,
                                      screenRect.origin.y + screenRect.size.height - 200,
                                      screenRect.size.width, 200)];
    
    _selectedView = [[UIView alloc] initWithFrame:
                    CGRectMake(10, 0, _magnifyingGlassView.frame.size.width/2,
                               _magnifyingGlassView.frame.size.height/2)];
    _selectedView.backgroundColor = [UIColor clearColor];
    _selectedView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _selectedView.layer.borderWidth = 2;
    _imageView = [[UIImageView alloc] initWithFrame:
                 CGRectMake(0, 0, screenRect.size.width, screenRect.size.height - 200)];
   
    [self.view addSubview:_magnifyingGlassView];
    _magnifyingGlassView.userInteractionEnabled = YES;
    [self.view addSubview:_imageView];
    _imageView.userInteractionEnabled = YES;
    [self.view addSubview:_selectedView];
    _selectedView.userInteractionEnabled = YES;
    [self showBackgroundImage];
    [self addGesture:EGT_Pan view:_selectedView];
    _magnifyingGlassView.viewToMagnify = _imageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showBackgroundImage
{
    UIImage* image = [[UIImage alloc] initWithContentsOfFile:
                      [[NSBundle mainBundle] pathForResource:@"apple" ofType:@"jpg"]];
    _imageView.image = image;
}

- (void) addGesture:(ENUM_Gesture_Type)type view:(UIView*)view
{
    if (type & EGT_Pan) {
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
        [view addGestureRecognizer:panGestureRecognizer];
    }
    if (type & EGT_Pinch) {
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
        [view addGestureRecognizer:pinchGestureRecognizer];
    }
    if (type & EGT_Rotation) {
        UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationView:)];
        [view addGestureRecognizer:rotationGestureRecognizer];
    }
    if (type & EGT_Tap) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
        [view addGestureRecognizer:tapGestureRecognizer];
    }
}

-(void)panView:(UIPanGestureRecognizer *)gesture
{
    UIView *view = gesture.view;
    if(gesture.state == UIGestureRecognizerStateChanged
       || gesture.state == UIGestureRecognizerStateBegan){
        CGPoint translation=[gesture translationInView:view.superview];
        float centerX = view.center.x + translation.x;
        float centerY = view.center.y + translation.y;
        CGRect oldFrame = view.frame;
        [view setCenter:(CGPoint){centerX,centerY}];
        if(![self isInView:view.frame])
        {
            view.frame=oldFrame;
        }
        [gesture setTranslation:CGPointZero inView:view.superview];
        [_magnifyingGlassView setEnlargedRect:_selectedView.frame];
        [_magnifyingGlassView setNeedsDisplay];
    }
    if(gesture.state == UIGestureRecognizerStateEnded){
        [view becomeFirstResponder];
    }
}

-(void)pinchView:(UIPinchGestureRecognizer *)gesture
{
    UIView *view= gesture.view;
    CGAffineTransform oldTransForm=view.transform;
    if (gesture.state == UIGestureRecognizerStateBegan ||
        gesture.state == UIGestureRecognizerStateChanged) {
        
        if(![self isInView:view.frame])
        {
            if (gesture.scale >= 1.0f)
            {
                return;
            }
        }
        
        view.transform = CGAffineTransformScale(view.transform, gesture.scale, gesture.scale);
        if (![self isInView:view.frame]) {
            view.transform = oldTransForm;
        }
        gesture.scale = 1;
    }
    if(gesture.state == UIGestureRecognizerStateEnded)
    {
        [view becomeFirstResponder];
    }
}

-(void)rotationView:(UIRotationGestureRecognizer *)gesture
{
    UIView *view = gesture.view;
    if (gesture.state == UIGestureRecognizerStateBegan
        || gesture.state == UIGestureRecognizerStateChanged) {
        CGRect oldFrame = view.frame;
        view.transform = CGAffineTransformRotate(view.transform, gesture.rotation);
        if(![self isInView:view.frame])
        {
            view.frame = oldFrame;
        }
        gesture.rotation = 0;
    }
    if(gesture.state == UIGestureRecognizerStateEnded)
    {
        [view becomeFirstResponder];
    }
}

-(void)tapView:(UITapGestureRecognizer *)gesture
{
    NSLog(@"tap view");
}

-(BOOL)isInView:(CGRect)frame
{
    BOOL isIn = YES;
    
    CGRect convertedRect = [self.view convertRect:frame toView:self.view];
    
    if (convertedRect.origin.x < 0 ||
        convertedRect.origin.y < 0 ||
        convertedRect.origin.x + convertedRect.size.width > _imageView.frame.size.width ||
        convertedRect.origin.y + convertedRect.size.height > _imageView.frame.size.height)
    {
        isIn = NO;
    }
    return isIn;
}

@end
