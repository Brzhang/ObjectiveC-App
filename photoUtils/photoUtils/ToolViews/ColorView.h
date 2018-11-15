//
//  ColorView.h
//  photoUtils
//
//  Created by zhangjt on 2018/11/15.
//  Copyright © 2018 zdk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ColorViewDelegate <NSObject>
-(void) colorChanged:(UIColor*) color;
@end

@interface ColorView : UIView
@property (nonatomic, weak) id<ColorViewDelegate> delegate;
-(UIColor*) getBackgroundColor;
@end

NS_ASSUME_NONNULL_END
