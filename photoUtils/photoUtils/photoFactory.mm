//
//  photoParams.m
//  photoUtils
//
//  Created by zhangjt on 2018/11/15.
//  Copyright © 2018 zdk. All rights reserved.
//

#import "photoFactory.h"
#ifdef __cplusplus
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/imgcodecs/ios.h>
#endif

@implementation photoFactory

-(void) setM_size:(CGSize)size
{
    _m_size = size;
}

-(void) setM_backgroundColor:(UIColor *)color
{
    _m_backgroundColor = color;
    [self makingPhoto];
}

-(void) makingPhoto
{
    if (!_m_image)
    {
        return;
    }
    cv::Mat image;
    UIImageToMat(_m_image, image);
    if(!image.data)
    {
        return;
    }
    //转换hsv
    cv::Mat hsvImage;
    cv::cvtColor(image,hsvImage, cv::COLOR_BGR2HSV);
    cv::Mat grayImage;
    cv::cvtColor(image, grayImage, cv::COLOR_BGR2GRAY);
    
    std::vector<cv::Mat> hsv_channels, bgr_channels;
    cv::split(hsvImage, hsv_channels);
    cv::split(image, bgr_channels);
    cv::Mat hsv_hl, hsv_hh, hsv_s, hsv_v, color;
    cv::threshold(hsv_channels[0], hsv_hl, 100, 255, cv::THRESH_BINARY);
    cv::threshold(hsv_channels[0], hsv_hh, 119, 255, cv::THRESH_BINARY_INV);
    cv::threshold(hsv_channels[1], hsv_s, 43, 255, cv::THRESH_BINARY);
    cv::threshold(hsv_channels[2], hsv_v, 80, 255, cv::THRESH_BINARY);
    
    cv::Mat binImage;
    cv::threshold(grayImage, binImage, 100, 255, cv::THRESH_OTSU);
    color = hsv_hl & hsv_hh & hsv_s & binImage;
    
    cv::Mat closeImage;
    cv::Mat kernel = getStructuringElement(cv::MORPH_RECT, cv::Size(5, 5), cv::Point(-1, -1));
    cv::morphologyEx(color, closeImage, cv::MORPH_OPEN, kernel, cv::Point(-1, -1), 2);
    
    cv::add(bgr_channels[0], closeImage, bgr_channels[0]);
    cv::add(bgr_channels[1], closeImage, bgr_channels[1]);
    cv::add(bgr_channels[2], closeImage, bgr_channels[2]);
    
    cv::Mat retImage;
    cv::merge(bgr_channels, retImage);
    GaussianBlur(retImage, retImage, cv::Size(7, 7), 1);
    //resize(result, result, Size(295, 413));
    UIImage* finishImage = MatToUIImage(retImage);
    
    if(_delegate && [_delegate respondsToSelector:@selector(photoRet:withImage:)])
    {
        [_delegate photoRet:0 withImage:finishImage];
    }
    /*
     const cv::Scalar hsvBlackLo(  0,  0,  0);
     const cv::Scalar hsvBlackHi(185, 255, 46);
     
     const cv::Scalar hsvGreyLo(  0,  0,  46);
     const cv::Scalar hsvGreyHi(180, 43, 220);
     
     const cv::Scalar hsvWhiteLo(  0,  0,  221);
     const cv::Scalar hsvWhiteHi(180, 30, 255);
     
     const cv::Scalar hsvRedLo( 0,  43,  46);
     const cv::Scalar hsvRedHi(10, 255, 255);
     
     const cv::Scalar hsvOrangeLo(11,  43,  46);
     const cv::Scalar hsvOrangeHi(25, 255, 255);
     
     const cv::Scalar hsvYellowLo(26,  43,  46);
     const cv::Scalar hsvYellowHi(34, 255, 255);
     
     const cv::Scalar hsvGreenLo(35,  43,  46);
     const cv::Scalar hsvGreenHi(77, 255, 255);
     
     const cv::Scalar hsvCyanLo(78,  43,  46);
     const cv::Scalar hsvCyanHi(99, 255, 255);
     
     const cv::Scalar hsvBlueLo(100,  43,  46);
     const cv::Scalar hsvBlueHi(124, 255, 255);
     
     const cv::Scalar hsvPurpleLo(125,  43,  46);
     const cv::Scalar hsvPurpleHi(155, 255, 255);
     */
}

@end
