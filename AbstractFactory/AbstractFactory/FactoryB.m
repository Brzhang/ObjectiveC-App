//
//  FactoryB.m
//  AbstractFactory
//
//  Created by HowDo on 6/15/15.
//
//

#import "FactoryB.h"
#import "ProductB.h"

@implementation FactoryB

- (AbstractProduct* ) GetProduct
{
    return [[ProductB alloc] init];
}

@end
