//
//  ViewController.m
//  photoUtils
//
//  Created by zhangjt on 2018/11/15.
//  Copyright © 2018 zdk. All rights reserved.
//

#import "ViewController.h"
#import "PhotoViewController.h"

#define G_Width self.view.frame.size.width
#define G_Height self.view.frame.size.height

@interface ViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton* btnSelectPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSelectPhoto.frame = CGRectMake(20, G_Height/2-30, G_Width-40, 40);
    btnSelectPhoto.layer.borderWidth = 1.f;
    [btnSelectPhoto setTitle:@"从相册中选择图片" forState:UIControlStateNormal];
    [btnSelectPhoto setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnSelectPhoto addTarget:self action:@selector(btnSelectPhotoClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSelectPhoto];
}

-(void) btnSelectPhotoClicked:(UIButton*)btn
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    PhotoViewController* pvc = [[PhotoViewController alloc] init];
    [self.navigationController pushViewController:pvc animated:NO];
    [pvc setPhoto:image];
}

@end
