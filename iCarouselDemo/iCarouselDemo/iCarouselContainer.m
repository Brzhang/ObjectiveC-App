//
//  iCarouselContainer.m
//  iCarouselDemo
//
//  Created by Brook Zhang on 5/20/16.
//  Copyright © 2016 HowDo. All rights reserved.
//

#import "iCarouselContainer.h"
#import <iCarousel.h>


@interface iCarouseView : UIView
@property (nonatomic, strong) UIImageView* image;
@property (nonatomic, strong) UIImageView* selectSign;
@property (nonatomic, strong) UILabel* lblIndex;
- (void) setSelect:(BOOL)isSeleced;
@end

@implementation iCarouseView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void) setSelect:(BOOL)isSeleced
{
    if (isSeleced) {
        _image.layer.borderColor = [UIColor greenColor].CGColor;
        _image.layer.borderWidth = 2;
        self.selectSign.hidden = NO;
    }
    else
    {
        _image.layer.borderColor = [UIColor grayColor].CGColor;
        _image.layer.borderWidth = 1;
        self.selectSign.hidden = YES;
    }
}

-(UIImageView*) image
{
    if (_image == nil)
    {
        _image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-20)];
        _image.layer.borderWidth = 1;
        _image.layer.borderColor = [UIColor grayColor].CGColor;
        [self addSubview:_image];
    }
    return _image;
}

-(UIImageView*) selectSign
{
    if (_selectSign == nil)
    {
        _selectSign = [[UIImageView alloc] initWithFrame:
                       CGRectMake(self.image.frame.size.width-self.image.frame.size.height/3-5,
                                  self.image.frame.size.height-self.image.frame.size.height/3 -5,
                                  self.image.frame.size.height/3,
                                  self.image.frame.size.height/3)];
        _selectSign.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"selected" ofType:@"png"]];
        _selectSign.hidden = YES;
        [self addSubview:_selectSign];
    }
    return _selectSign;
}

-(UILabel*) lblIndex
{
    if (_lblIndex == nil) {
        _lblIndex = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20)];
        _lblIndex.textAlignment = NSTextAlignmentCenter;
        _lblIndex.font = [UIFont systemFontOfSize:11];
        [self addSubview:_lblIndex];
    }
    return _lblIndex;
}


@end

@interface iCarouselContainer() <iCarouselDelegate, iCarouselDataSource>
@property (nonatomic, strong) iCarousel *iCarousel;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSMutableArray *selectedImageIndex;
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
        self.iCarousel.frame = CGRectMake(0, 30, self.frame.size.width, 152);
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
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (int i = 0; i<self.selectedImageIndex.count; ++i) {
        [array addObject:self.imageArray[[_selectedImageIndex[i] integerValue]]];
    }
    return array;
}

#pragma mark private methods
- (void)finishBtnClicked
{
    if ([_delegate respondsToSelector:@selector(selectImageArray:)]) {
        [_delegate selectImageArray:[self getSelectImageArray]];
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
        view = [[iCarouseView alloc] initWithFrame:CGRectMake(0, 0, 171, 132)];
        view.backgroundColor = [UIColor whiteColor];
        view.contentMode = UIViewContentModeScaleAspectFit;
    }
    ((iCarouseView*)view).lblIndex.text = [NSString stringWithFormat:@"%ld",(long)index+1];
    ((iCarouseView*)view).image.image = [UIImage imageWithContentsOfFile:_imageArray[index]];
    if ([self.selectedImageIndex containsObject:[NSNumber numberWithInteger:index]]) {
        [((iCarouseView*)view) setSelect:YES];
    }
    else{
        [((iCarouseView*)view) setSelect:NO];
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
    if ([self.selectedImageIndex containsObject:[NSNumber numberWithInteger:index]]) {
        [self.selectedImageIndex removeObject:[NSNumber numberWithInteger:index]];
        [((iCarouseView*)[carousel itemViewAtIndex:index]) setSelect:NO];
        NSLog(@"selectedImage remove:%ld", (long)index);
    }
    else{
        [self.selectedImageIndex addObject:[NSNumber numberWithInteger:index]];
        [((iCarouseView*)[carousel itemViewAtIndex:index]) setSelect:YES];
        NSLog(@"selectedImage add:%ld", (long)index);
    }
    NSLog(@"selectedImage conut:%lu", (unsigned long)self.selectedImageIndex.count);
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

-(NSMutableArray *)selectedImageIndex{
    if (_selectedImageIndex == nil) {
        _selectedImageIndex = [[NSMutableArray alloc] init];
    }
    return _selectedImageIndex;
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
