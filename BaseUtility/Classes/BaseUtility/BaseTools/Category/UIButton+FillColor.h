//
//  UIButton+FillColor.h
//  WeiGuGlobal
//
//  Created by 李雪阳 on 2018/10/27.
//  Copyright © 2018年 com.chuang.global. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (FillColor)

/** 按钮背景色 可根据state更换 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@end

NS_ASSUME_NONNULL_END
