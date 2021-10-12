//
//  UIButton+FillColor.m
//  WeiGuGlobal
//
//  Created by 李雪阳 on 2018/10/27.
//  Copyright © 2018年 com.chuang.global. All rights reserved.
//

#import "UIButton+FillColor.h"

@implementation UIButton (FillColor)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    CGRect rect = self.bounds;
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        rect.size = CGSizeMake(10, 10);
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    [self setBackgroundImage:image forState:state];
}



@end
