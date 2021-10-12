//
//  UIScreen+Extension.m
//  textPod
//
//  Created by 李雪阳 on 2017/11/21.
//  Copyright © 2017年 singularity. All rights reserved.
//

#import "UIScreen+Extension.h"

@implementation UIScreen (Extension)

+ (CGRect)scrnBounds{
    return [[UIScreen mainScreen]bounds];
}

+ (CGSize)scrnSize {
    //在个别页面从横屏切换到竖屏的时候会出现[UIScreen mainScreen].bounds的高宽颠倒问题
    static CGSize size;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size = [UIScreen mainScreen].bounds.size;
        if (size.height < size.width) {
            CGFloat tmp = size.height;
            size.height = size.width;
            size.width = tmp;
        }
    });
    return size;
}

+ (BOOL)isRetinaScrn {
    return [UIScreen scrnScale] >= 2;
}

+ (CGFloat)scrnScale {//屏幕分辨率
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [UIScreen mainScreen].scale;
    });
    return scale;
}

@end
