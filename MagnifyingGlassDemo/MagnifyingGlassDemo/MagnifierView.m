//
//  MagnifierView.h
//  MagnifyingGlassDemo
//
//  Created by Brook on 25/07/15.
//  Copyright (c) 2015 Brook. All rights reserved.
//

#import "MagnifierView.h"

@implementation MagnifierView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.layer.borderWidth = 2;
        self.backgroundColor = [UIColor clearColor];
    }
	return self;
}
- (void)drawRect:(CGRect)rect {
	// here we're just doing some transforms on the view we're magnifying,
	// and rendering that view directly into this view,
	// rather than the previous method of copying an image.
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context,0,0);
	CGContextScaleCTM(context, 2, 2);
	CGContextTranslateCTM(context,-1*(self.enlargedRect.origin.x),-1*(self.enlargedRect.origin.y));
	[self.viewToMagnify.layer renderInContext:context];
}

@end
