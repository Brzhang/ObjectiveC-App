//
//  MagnifierView.h
//  MagnifyingGlassDemo
//
//  Created by Brook on 25/07/15.
//  Copyright (c) 2015 Brook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MagnifierView : UIView

@property (nonatomic, strong) UIView *viewToMagnify;
@property (assign) CGRect enlargedRect;

@end
