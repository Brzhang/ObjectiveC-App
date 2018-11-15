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
    cv::cvtColor(image,hsvImage,cv::COLOR_BGR2HSV);
    
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
    
    std::vector<cv::Scalar> hsvLo{hsvBlackLo,hsvGreyLo,hsvWhiteLo,hsvRedLo,
                        hsvOrangeLo,hsvYellowLo,hsvGreenLo,hsvCyanLo,
                        hsvBlueLo,hsvPurpleLo};
    std::vector<cv::Scalar> hsvHi{hsvBlackHi,hsvGreyHi,hsvWhiteHi,hsvRedHi,
                        hsvOrangeHi,hsvYellowHi,hsvGreenHi,hsvCyanHi,
                        hsvBlueHi,hsvPurpleHi};
    cv::Mat imgThresholded;
    cv::inRange(hsvImage, hsvLo[1], hsvHi[1],imgThresholded);
    
    int erosion_type;
    int erosion_elem = 0;
    int erosion_size = 0;
    if( erosion_elem == 0 ){ erosion_type = cv::MORPH_RECT; }
    else if( erosion_elem == 1 ){ erosion_type = cv::MORPH_CROSS; }
    else if( erosion_elem == 2) { erosion_type = cv::MORPH_ELLIPSE; }
    
    cv::Mat erosionElement = getStructuringElement( erosion_type,
                                            cv::Size( 2*erosion_size + 1, 2*erosion_size+1 ),
                                            cv::Point( erosion_size, erosion_size ) );
    
    // 腐蚀操作
    cv::Mat imgEroded;
    cv::erode(imgThresholded, imgEroded, erosionElement);
    
    int dilation_type;
    int dilation_elem = 0;
    int dilation_size = 0;
    if( dilation_elem == 0 ){ dilation_type = cv::MORPH_RECT; }
    else if( dilation_elem == 1 ){ dilation_type = cv::MORPH_CROSS; }
    else if( dilation_elem == 2) { dilation_type = cv::MORPH_ELLIPSE; }
    
    cv::Mat dilationElement = getStructuringElement( dilation_type,
                                        cv::Size( 2*dilation_size + 1, 2*dilation_size+1 ),
                                        cv::Point( dilation_size, dilation_size ) );
    //膨胀操作
    cv::Mat imgdilated;
    dilate(imgEroded, imgdilated, dilationElement);
    
    
    std::vector<cv::Mat> v;
    cv::split(imgdilated,v);

    //遍历替换
    int nl = imgdilated.rows;
    int nc = imgdilated.cols;
    int step = 10;
    for(int j = 0; j < nl; j++)
    {
        for(int i = 0; i < nc; i++)
        {
            //以H.S两个通道做阈值分割，把灰替换成蓝色
            if((v[0].at<uchar>(j,i))<=(0) && v[0].at<uchar>(j,i)>=(180)
               &&(v[1].at<uchar>(j,i))<=(46) && v[1].at<uchar>(j,i)>=(250))
            {
                //cout<<int(v[0].at<uchar>(j,i))<<endl;
                //红色底
                //v[0].at<uchar>(j,i)=0;
                //白色底
                //v[0].at<uchar>(j,i)=0;
                //v[1].at<uchar>(j,i)=0;  //V[0]和V[1]全调成0就是变成白色
                //绿色底
                //v[0].at<uchar>(j,i)=60;
                //蓝色底
                v[0].at<uchar>(j,i)=120;
                /*cout<<int(v[0].at<uchar>(j,i))<<endl;*/
            }
        }
    }
    cv::Mat finImg;
    cv::merge(v,finImg);
    cv::Mat rgbImg;
    cv::cvtColor(finImg,rgbImg, cv::COLOR_HSV2BGR); //将图像转换回RGB空间
    //加个滤波把边缘部分的值滤掉（此处应该用低通滤波器，但感觉不太好，还是不用了。）
    cv::Mat result;
    GaussianBlur(rgbImg,result,cv::Size(3,3),0.5);
    cv::waitKey(0);
    UIImage* finishImage = MatToUIImage(result);
    
    if(_delegate && [_delegate respondsToSelector:@selector(photoRet:withImage:)])
    {
        [_delegate photoRet:0 withImage:finishImage];
    }
}

@end
