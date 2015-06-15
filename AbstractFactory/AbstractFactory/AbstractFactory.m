//
//  AbstractFactory.m
//  AbstractFactory
//
//  Created by HowDo on 6/15/15.
//
//

#import "AbstractFactory.h"
#import "FactoryA.h"
#import "FactoryB.h"
#import "ProductA.h"
#import "ProductB.h"

@implementation AbstractFactory

+ (AbstractFactory* ) CreateFactory : (EnumProductType) type
{
    switch (type) {
        case EPT_A:
            return [[FactoryA alloc] init];
        case EPT_B:
            return [[FactoryB alloc] init];
        default:
            break;
    }
}

- (AbstractProduct* ) GetProduct
{
    return nil;
}
@end