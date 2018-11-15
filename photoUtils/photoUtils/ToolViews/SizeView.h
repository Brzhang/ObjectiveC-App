//
//  SizeView.h
//  photoUtils
//
//  Created by zhangjt on 2018/11/15.
//  Copyright © 2018 zdk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SizeViewDelegate <NSObject>
-(void) sizeChanged:(CGSize) size;
@end


@interface SizeView : UIView
@property (nonatomic, weak) id<SizeViewDelegate> delegate;
-(CGSize) getSize;
@end

NS_ASSUME_NONNULL_END
