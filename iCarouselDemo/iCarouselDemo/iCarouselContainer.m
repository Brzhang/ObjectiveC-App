//
//  iCarouselContainer.m
//  iCarouselDemo
//
//  Created by Brook Zhang on 5/20/16.
//  Copyright © 2016 HowDo. All rights reserved.
//

#import "iCarouselContainer.h"
#import <iCarousel.h>

@interface iCarouselContainer() <iCarouselDelegate, iCarouselDataSource>
@property (nonatomic, strong) iCarousel *iCarousel;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSMutableArray *selectedImages;
@property (nonatomic, strong) UIButton* finishBtn;
@end

@implementation iCarouselContainer

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.iCarousel.frame = CGRectMake(0, 30, self.frame.size.width, 132);
        self.finishBtn.frame = CGRectMake(self.frame.size.width-100,0,100,30);
        [self addSubview:_iCarousel];
        [self addSubview:_finishBtn];
    }
    return self;
}

#pragma mark -public methods
- (void) loadImageArray:(NSArray*) array
{
    _imageArray = array;
    if (_imageArray.count > 0) {
        [_iCarousel reloadData];
    }
}
- (NSArray*) getSelectImageArray
{
    return _selectedImages;
}

#pragma mark private methods
- (void)finishBtnClicked
{
    if ([_delegate respondsToSelector:@selector(selectImageArray:)]) {
        [_delegate selectImageArray:_imageArray];
    }
}

#pragma mark -iCarousel delegate

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return _imageArray.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (_imageArray.count <= index) {
        return view;
    }
    if (view) {
        [view removeFromSuperview];
    }
    
    if (view == nil) {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 171, 132)];
        view.backgroundColor = [UIColor whiteColor];
        view.contentMode = UIViewContentModeScaleAspectFit;
        view.layer.borderWidth = 2;
        view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
    ((UIImageView*)view).image = [UIImage imageWithContentsOfFile:_imageArray[index]];
    if ([self.selectedImages containsObject:[NSNumber numberWithInteger:index]]) {
        view.layer.borderColor = [UIColor redColor].CGColor;
    }
    else{
        view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return view;
}

-(void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    //    NSInteger current = self.smallImageView.currentItemIndex + 1;
    //    self.notePages.text = [NSString stringWithFormat:@"%lu/%lu",current,self.smallImages.count];
    
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

-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    if ([self.selectedImages containsObject:[NSNumber numberWithInteger:index]]) {
        [self.selectedImages removeObject:[NSNumber numberWithInteger:index]];
        [carousel itemViewAtIndex:index].layer.borderColor = [UIColor grayColor].CGColor;
        NSLog(@"selectedImage remove:%ld", (long)index);
    }
    else{
        [self.selectedImages addObject:[NSNumber numberWithInteger:index]];
        [carousel itemViewAtIndex:index].layer.borderColor = [UIColor redColor].CGColor;
        NSLog(@"selectedImage add:%ld", (long)index);
    }
    NSLog(@"selectedImage conut:%lu", (unsigned long)self.selectedImages.count);
}

#pragma mark - lazy init
-(iCarousel *)iCarousel{
    if (_iCarousel ==  nil) {
        _iCarousel = [[iCarousel alloc] init];
        _iCarousel.delegate = self;
        _iCarousel.dataSource = self;
        _iCarousel.type = iCarouselTypeLinear;
        _iCarousel.clipsToBounds = YES;
    }
    return _iCarousel;
}

-(NSMutableArray *)selectedImages{
    if (_selectedImages == nil) {
        _selectedImages = [[NSMutableArray alloc] init];
    }
    return _selectedImages;
}

- (UIButton*)finishBtn
{
    if(_finishBtn == nil)
    {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_finishBtn setTitle:@"确定" forState:UIControlStateNormal];
        //[_finishBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        //[_finishBtn setBackgroundColor:[UIColor clearColor]];
        //_finishBtn.layer.cornerRadius = 5;
        //_finishBtn.layer.borderWidth = 2;
        //_finishBtn.layer.borderColor = [UIColor blueColor].CGColor;
        //_finishBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [_finishBtn addTarget:self action:@selector(finishBtnClicked)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}
@end
