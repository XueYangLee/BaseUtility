//
//  UIImage+Extension.h
//  CarSteward
//
//  Created by 李雪阳 on 2018/3/26.
//  Copyright © 2018年 singularity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/** 返回拉伸图片 */
+ (UIImage *)resizedImage:(NSString *)name;

/** 用颜色返回一张图片 */
+ (UIImage *)imageWithColor:(UIColor*)color Alpha:(CGFloat)alpha;

/** 带边框的图片 */
+ (instancetype)circleImageWithImageName:(NSString *)imageName borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/** 获取bundle中的图片 */
+ (UIImage *)imageNamed:(NSString *)name bundleNamed:(NSString *)bundleName;


/** 圆形图片 */
- (UIImage *)circleImage;

/** 根据View转成UIImage */
+ (UIImage *)imageCreateFromView:(UIView *)view;

/** 获取屏幕截图 */
+ (UIImage *)screenShot;

/** 获取对应view截图 */
+ (UIImage *)screenShotFrowView:(UIView *)view;

/** 获取启动图 */
+ (UIImage *)getLaunchImage;

/** 获取视频首帧图 */
+ (UIImage*)getVideoFirstFPSImage:(NSURL *)videoUrl;

/** 压缩图片到指定大小 */
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize;

/** 图片合成 */
+ (UIImage *)compositeImage:(UIImage *)originalImage toImage:(UIImage *)targetImage;

/** 改变图片的透明度 */
+ (UIImage *)imageAlphaWithImage:(UIImage*)image alpha:(CGFloat)alpha;

/** 为图片添加高斯模糊效果   blur值 0-1 */
+ (UIImage *)blurryImage:(UIImage *)image blurValue:(CGFloat)blur;


/** 压缩图片到指定大小   maxLength  字节   100kb = 100000 length */
+ (NSData *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength;


@end
