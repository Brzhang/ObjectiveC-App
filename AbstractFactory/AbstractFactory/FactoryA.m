//
//  FactoryA.m
//  AbstractFactory
//
//  Created by HowDo on 6/15/15.
//
//

#import "FactoryA.h"
#import "ProductA.h"

@implementation FactoryA

- (AbstractProduct* ) GetProduct
{
    return [[ProductA alloc] init];
}

@end