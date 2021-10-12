//
//  CALayer+XibBorderColor.m
//  Moneyhll
//
//  Created by 李雪阳 on 16/5/30.
//  Copyright © 2016年 浙江龙之游旅游开发有限公司. All rights reserved.
//

#import "CALayer+XibBorderColor.h"
#import <UIKit/UIKit.h>

@implementation CALayer (XibBorderColor)

- (void)setBorderColorWithUIColor:(UIColor *)color{
    
    self.borderColor = color.CGColor;
}

@end
