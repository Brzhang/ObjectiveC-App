//
//  SizeView.m
//  photoUtils
//
//  Created by zhangjt on 2018/11/15.
//  Copyright © 2018 zdk. All rights reserved.
//

#import "SizeView.h"
#import <Masonry.h>

@interface SizeView()
@property (nonatomic, strong) UISegmentedControl *m_segment;
@property (nonatomic, assign) CGSize m_size;
@end

@implementation SizeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype) init
{
    self = [super init];
    if (self)
    {
        [self createUI];
    }
    return self;
}

-(void) createUI
{
    NSArray *items = [NSArray arrayWithObjects: @"原始尺寸", @"1寸", @"2寸", nil];
    self.m_segment = [[UISegmentedControl alloc] initWithItems:items];
    self.m_segment.selectedSegmentIndex = 0;
    self.m_size = CGSizeZero;
    [self.m_segment addTarget:self action:@selector(segmentDidChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.m_segment];
}

-(void) layoutSubviews
{
    [self.m_segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(self.mas_width).offset(-40);
        make.height.mas_equalTo(30.f);
    }];
}

-(void) segmentDidChange:(UISegmentedControl*) seg
{
    switch (seg.selectedSegmentIndex) {
        case 0:
            self.m_size = CGSizeZero;
            break;
        case 1:
            self.m_size = CGSizeMake(400, 400);
            break;
        case 2:
            self.m_size = CGSizeMake(800, 800);
        default:
            break;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(sizeChanged:)])
    {
        [_delegate sizeChanged:self.m_size];
    }
}

-(CGSize) getSize
{
    return self.m_size;
}

@end
