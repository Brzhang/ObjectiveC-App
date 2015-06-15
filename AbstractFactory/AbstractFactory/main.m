//
//  main.m
//  AbstractFactory
//
//  Created by HowDo on 6/15/15.
//  Copyright (c) 2015 HowDo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AbstractFactory.h"
#import "AbstractProduct.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
    }
    
    AbstractFactory *factoryA = [AbstractFactory CreateFactory:EPT_A];
    AbstractProduct *productA = [factoryA GetProduct];
    NSLog(@"Print the product's name: %@", [productA GetProductName]);
    
    AbstractFactory *factoryB = [AbstractFactory CreateFactory:EPT_B];
    AbstractProduct *productB = [factoryB GetProduct];
    NSLog(@"Print the product's name: %@", [productB GetProductName]);
    
    return 0;
}
