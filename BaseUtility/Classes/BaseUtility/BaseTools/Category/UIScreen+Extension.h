//
//  UIScreen+Extension.h
//  textPod
//
//  Created by 李雪阳 on 2017/11/21.
//  Copyright © 2017年 singularity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (Extension)

/** 返回屏幕尺寸  [[UIScreen mainScreen]bounds]*/
+ (CGRect)scrnBounds;

/** 返回屏幕尺寸  [UIScreen mainScreen].bounds.size*/
+ (CGSize)scrnSize;

/** 判断是否是retina屏幕 */
+ (BOOL)isRetinaScrn;

/** 返回屏幕分辨率比例 */
+ (CGFloat)scrnScale;

@end
