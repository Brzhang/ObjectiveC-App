//
//  ViewController.m
//  iCarouselDemo
//
//  Created by Brook Zhang on 5/18/16.
//  Copyright © 2016 HowDo. All rights reserved.
//

#import "ViewController.h"
#import "iCarouselContainer.h"

@interface ViewController () <iCarouselContainerDelegate>
@property (nonatomic, strong) iCarouselContainer* imageContainer;
@property (nonatomic, strong) NSArray *bigImages;
@property (nonatomic, strong) NSMutableArray *smallImages;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _imageContainer = [[iCarouselContainer alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 190)];
    _imageContainer.delegate = self;
    [self.view addSubview:_imageContainer];
    
    NSString* path = [NSString stringWithFormat:@"%@/%@",
                      [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                           NSUserDomainMask, YES) firstObject],
                      @"testPages"];
    _bigImages = [self allFilesAtPath:path];
    if ([_bigImages count] == 0) {
        return;
    }
    
    //[self createthumb:_bigImages filePath: path];
    [self.smallImages addObjectsFromArray:_bigImages];
    
    [_imageContainer loadImageArray:_smallImages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate
- (void) selectImageArray:(NSArray *)array
{
    NSLog(@"selected image count:%lu", (unsigned long)array.count);
}

#pragma mark - private methods
- (NSMutableArray *)allFilesAtPath:(NSString *)direString
{
    NSMutableArray *pathArray = [NSMutableArray array];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *tempArray = [fileManager contentsOfDirectoryAtPath:direString error:nil];
    for (NSString *fileName in tempArray) {
        BOOL flag = YES;
        NSString *fullPath = [direString stringByAppendingPathComponent:fileName];
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&flag]) {
            if (!flag) {
                // ignore .DS_Store
                if (![[fileName substringToIndex:1] isEqualToString:@"."]) {
                    [pathArray addObject:fullPath];
                }
            }
            else {
                [pathArray addObject:[self allFilesAtPath:fullPath]];
            }
        }
    }
    return pathArray;
}

- (void) createthumb:(NSArray*) array filePath:(NSString*) path
{
    //create thumb for big images
    for (int i = 0; i< array.count; ++i) {
        NSString* smallImage = [NSString stringWithFormat:@"%@/%d.png",path,i+1];
        [_smallImages addObject:smallImage];
        [self saveImageToFile:
         [self thumbnailWithImageWithoutScale:
          [UIImage imageNamed:array[i]] size:CGSizeMake(171,132)]
                     filePath:smallImage];
    }
}

- (void) saveImageToFile:(UIImage*) image filePath:path
{
    [UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
}

- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    
    if (image == nil)
    {
        newimage = nil;
    }
    else
    {
        CGSize oldsize = image.size;
        CGRect rect;
        rect.size = oldsize;
        
        float scaleY = asize.height/oldsize.height;
        float scaleX = asize.width/oldsize.width;
        float scale = scaleX < scaleY ? scaleX : scaleY;
        rect.size.width *= scale;
        rect.size.height *= scale;
        newimage = [self imageWithImage:image scaledToSize:rect.size];
    }
    
    return newimage;
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

#pragma mark - lazy init
-(NSMutableArray *)smallImages{
    if (_smallImages ==  nil) {
        _smallImages = [[NSMutableArray alloc] init];
    }
    return _smallImages;
}

@end
