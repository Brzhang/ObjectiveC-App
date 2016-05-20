//
//  iCarouselContainer.h
//  iCarouselDemo
//
//  Created by Brook Zhang on 5/20/16.
//  Copyright © 2016 HowDo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol iCarouselContainerDelegate <NSObject>
@optional
- (void) selectImageArray:(NSArray*) array;

@end

@interface iCarouselContainer : UIView

@property (nonatomic, weak) id<iCarouselContainerDelegate> delegate;

- (void) loadImageArray:(NSArray*) array;
- (NSArray*) getSelectImageArray;

@end
