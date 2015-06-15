//
//  AbstractFactory.h
//  AbstractFactory
//
//  Created by HowDo on 6/15/15.
//
//

#ifndef AbstractFactory_AbstractFactory_h
#define AbstractFactory_AbstractFactory_h

#import <Foundation/Foundation.h>
#import "AbstractProduct.h"

typedef NS_ENUM(NSInteger, EnumProductType)
{
    EPT_A = 0,
    EPT_B,
};

@interface AbstractFactory : NSObject
+ (AbstractFactory* ) CreateFactory : (EnumProductType) type;
- (AbstractProduct* ) GetProduct;
@end

#endif
