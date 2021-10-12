//
//  UIViewController+CurrentViewController.h
//  BaseTools
//
//  Created by 李雪阳 on 2019/3/29.
//  Copyright © 2019 Singularity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (CurrentViewController)

/** 获取当前屏幕显示的viewcontroller */
+ (UIViewController *)currentViewController;


@end

NS_ASSUME_NONNULL_END
