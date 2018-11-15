//
//  photoParams.h
//  photoUtils
//
//  Created by zhangjt on 2018/11/15.
//  Copyright © 2018 zdk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol photoFactoryDelegate <NSObject>
-(void) photoRet:(int)ret withImage:(UIImage*)image;
@end

@interface photoFactory : NSObject
@property (nonatomic, strong) UIImage* m_image;
@property (nonatomic, strong) UIColor* m_backgroundColor;
@property (nonatomic, assign) CGSize  m_size;
@property (nonatomic, weak) id<photoFactoryDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
