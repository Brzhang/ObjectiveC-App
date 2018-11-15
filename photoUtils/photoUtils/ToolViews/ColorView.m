//
//  ColorView.m
//  photoUtils
//
//  Created by zhangjt on 2018/11/15.
//  Copyright © 2018 zdk. All rights reserved.
//

#import "ColorView.h"
#import <Masonry.h>

@interface ColorView()
@property (nonatomic, strong) UISegmentedControl *m_segment;
@property (nonatomic, strong) UIColor* m_color;
@end
@implementation ColorView

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
    NSArray *items = [NSArray arrayWithObjects: @"无色", @"蓝色", @"红色", nil];
    self.m_segment = [[UISegmentedControl alloc] initWithItems:items];
    self.m_segment.selectedSegmentIndex = 0;
    self.m_color = [UIColor clearColor];
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
            self.m_color = [UIColor clearColor];
            break;
        case 1:
            self.m_color = [UIColor blueColor];
            break;
        case 2:
            self.m_color = [UIColor redColor];
        default:
            break;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(colorChanged:)])
    {
        [_delegate colorChanged:self.m_color];
    }
}

-(UIColor*) getBackgroundColor;
{
    return self.m_color;
}

@end
