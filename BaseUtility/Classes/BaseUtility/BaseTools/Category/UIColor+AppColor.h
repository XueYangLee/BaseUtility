//
//  UIColor+AppColor.h
//  BaseTools
//
//  Created by Singularity on 2020/10/27.
//  Copyright © 2020 Singularity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (AppColor)

/** app主色调  #1825AA */
+ (UIColor *)app_mainColor;
/** 辅色 #F7BC32 */
+ (UIColor *)app_subMainColor;
/** 主文字颜色  #1D1D1F*/
+ (UIColor *)app_titleColor;
/** 辅文字颜色  #86868B*/
+ (UIColor *)app_subTitleColor;
/** 背景色  #F7F8FA*/
+ (UIColor *)app_backgroundColor;
/** 背景色  #FAFAFA */
+ (UIColor *)app_lightBackgroundColor;
/** 线条色 #EDEDED */
+ (UIColor *)app_lineColor;
/** 红色  #FF3B30 */
+ (UIColor *)app_redColor;

@end

NS_ASSUME_NONNULL_END
