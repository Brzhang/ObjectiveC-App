//
//  PhotoViewController.m
//  photoUtils
//
//  Created by zhangjt on 2018/11/15.
//  Copyright © 2018 zdk. All rights reserved.
//

#import "PhotoViewController.h"
#import <Masonry.h>
#import "ToolViews/SizeView.h"
#import "ToolViews/ColorView.h"
#import "photoFactory.h"
#import <iCarousel.h>

@interface PhotoViewController () <iCarouselDelegate, iCarouselDataSource, SizeViewDelegate, ColorViewDelegate, photoFactoryDelegate>
@property (nonatomic, strong) UIImageView* m_imageView;
@property (nonatomic, strong) photoFactory* m_photoFactory;
@property (nonatomic, strong) iCarousel* m_iCarousel;
@property (nonatomic, strong) NSMutableArray* m_toolsArray;
@end

@implementation PhotoViewController

-(instancetype) init
{
    self = [super init];
    if (self)
    {
        self.m_photoFactory = [[photoFactory alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    [self createUI];
}

-(void) setPhoto:(UIImage*)image
{
    self.m_photoFactory.m_image = image;
    self.m_imageView.image = self.m_photoFactory.m_image;
}

-(void) createUI
{
    SizeView* sizeView = [[SizeView alloc] init];
    sizeView.delegate = self;
    
    ColorView* colorView = [[ColorView alloc] init];
    colorView.delegate = self;
    self.m_toolsArray = [[NSMutableArray alloc] initWithObjects:sizeView, colorView , nil];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.m_imageView = [[UIImageView alloc] init];
    self.m_imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.m_imageView.image = self.m_photoFactory.m_image;
    [self.view addSubview:self.m_imageView];
    [self.view addSubview:self.m_iCarousel];
    
    [self.m_iCarousel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(self.view.mas_bottom).offset(-100);
         make.left.equalTo(self.view.mas_left).offset(10);
         make.width.equalTo(self.view.mas_width).offset(-20);
         make.bottom.equalTo(self.view.mas_bottom).offset(0);
     }];
    
    [self.m_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(20);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.width.equalTo(self.view.mas_width).offset(-20);
        make.bottom.equalTo(self->_m_iCarousel.mas_top).offset(0);
    }];
}

- (void)sizeChanged:(CGSize)size
{
    self.m_photoFactory.m_size = size;
}

- (void)colorChanged:(nonnull UIColor *)color
{
    self.m_photoFactory.m_backgroundColor = color;
}

#pragma mark -iCarousel delegate

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.m_toolsArray.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil) {
        view = self.m_toolsArray[index];
        view.frame = self.m_iCarousel.frame;
    }
    return view;
}

-(void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return NO;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.02f;
        }
        case iCarouselOptionFadeMax:
        {
            if (carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        default:
        {
            return value;
        }
    }
}

-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
}

#pragma mark - lazy init
-(iCarousel *)m_iCarousel{
    if (_m_iCarousel ==  nil) {
        _m_iCarousel = [[iCarousel alloc] init];
        _m_iCarousel.delegate = self;
        _m_iCarousel.dataSource = self;
        _m_iCarousel.type = iCarouselTypeLinear;
        _m_iCarousel.clipsToBounds = YES;
        _m_iCarousel.backgroundColor = [UIColor grayColor];
    }
    return _m_iCarousel;
}
- (void)photoRet:(int)ret withImage:(nonnull UIImage *)image {
    
    if (image)
    {
        self.m_imageView.image = image;
    }
}

@end
