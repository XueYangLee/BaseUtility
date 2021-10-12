//
//  UIColor+Extensions.h
//  BaseTools
//
//  Created by 李雪阳 on 2020/5/21.
//  Copyright © 2020 Singularity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Extensions)

/** 颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB) */
+ (UIColor *)colorWithHexString:(NSString *)color;

/** 适配暗黑及常规模式颜色 */
+ (UIColor *)colorWithDarkColor:(UIColor *)darkModeColor defaultColor:(UIColor *)defaultModeColor;

/** 根据color set中的colorName适配暗黑及常规模式颜色 */
+ (UIColor *)colorWithDarkAdaptColorName:(NSString *)colorName defaultColor:(UIColor *)defaultModeColor;

/** 根据图片获取图片的主色调 */
+ (UIColor *)imageMainColor:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
