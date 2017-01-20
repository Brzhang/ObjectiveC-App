//
//  ViewController.m
//  DySimpleApp
//
//  Created by zhangjt on 1/20/17.
//  Copyright © 2017 zhangjt. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGRect rect = [[UIScreen mainScreen]bounds];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"load FW" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    btn.layer.borderColor = [UIColor blueColor].CGColor;
    btn.layer.borderWidth = 1.0f;
    btn.layer.cornerRadius = 2.0;
    btn.frame = CGRectMake(20, (rect.size.height-40)/4, 80, 30);
    [btn addTarget:self action:@selector(loadFW) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UILabel* label = [[UILabel alloc] init];
    label.text = @"The Dynamic Framework Simple App";
    label.font = [UIFont systemFontOfSize:22.f];
    label.textColor = [UIColor darkGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(0, (rect.size.height-80), rect.size.width, 40);
    [self.view addSubview:label];
}

- (void) loadFW
{
    //we stored the framework in the document folder.
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentDirectory = nil;
    if ([paths count] != 0)
        documentDirectory = [paths objectAtIndex:0];
    
    NSString *libName = @"DyFrameworkTest.framework";
    NSString *destLibPath = [documentDirectory stringByAppendingPathComponent:libName];
    
    //check if the file exist
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:destLibPath]) {
        return;
    }
    
    //load lib way 1：use dlopen to load the lib, must include the header before use it
    //    void* lib_handle = dlopen([destLibPath cStringUsingEncoding:NSUTF8StringEncoding], RTLD_LOCAL);
    //    if (!lib_handle) {
    //        return;
    //    }
    // how to unload the library.
    //    if (dlclose(lib_handle) != 0) {
    //        NSLog(@"Unable to close library.\n");
    //    }
    
    //load lib way 2:
    NSBundle *frameworkBundle = [NSBundle bundleWithPath:destLibPath];
    if (frameworkBundle && [frameworkBundle load]) {
        NSLog(@"bundle load framework success.");
    }else {
        NSLog(@"bundle load framework err");
        return;
    }
    
    Class interfaceCalss = NSClassFromString(@"MathClass");
    if (!interfaceCalss) {
        NSLog(@"Unable to get TestDylib class");
        return;
    }
    
    //call the mothod of framework
    NSObject *dylib = [interfaceCalss new];
    id ret = [dylib performSelector:@selector(add:other:) withObject:[[NSNumber alloc] initWithInt:1] withObject:[[NSNumber alloc] initWithInt:2]];
    
    CGRect rect = [[UIScreen mainScreen]bounds];
    
    UILabel* retlab = [[UILabel alloc] init];
    retlab.text = [NSString stringWithFormat:@"Result is：%@",ret];
    retlab.font = [UIFont systemFontOfSize:15.f];
    retlab.textColor = [UIColor redColor];
    retlab.textAlignment = NSTextAlignmentCenter;
    retlab.frame = CGRectMake(0, (rect.size.height)/2, rect.size.width, 30);
    [self.view addSubview:retlab];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
