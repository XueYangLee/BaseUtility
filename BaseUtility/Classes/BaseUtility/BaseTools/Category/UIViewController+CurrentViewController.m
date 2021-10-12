//
//  UIViewController+CurrentViewController.m
//  BaseTools
//
//  Created by 李雪阳 on 2019/3/29.
//  Copyright © 2019 Singularity. All rights reserved.
//

#import "UIViewController+CurrentViewController.h"

@implementation UIViewController (CurrentViewController)

+ (UIViewController*)getCurrentViewController:(UIViewController*)VC {
    
    if (VC.presentedViewController) {
        
        // Return presented view controller
        return [self getCurrentViewController:VC.presentedViewController];
        
    } else if ([VC isKindOfClass:[UISplitViewController class]]) {
        
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) VC;
        if (svc.viewControllers.count > 0){
            return [self getCurrentViewController:svc.viewControllers.lastObject];
        }else{
            return VC;
        }
        
    } else if ([VC isKindOfClass:[UINavigationController class]]) {
        
        // Return top view
        UINavigationController* svc = (UINavigationController*) VC;
        if (svc.viewControllers.count > 0){
            return [self getCurrentViewController:svc.topViewController];
        }else{
            return VC;
        }
        
    } else if ([VC isKindOfClass:[UITabBarController class]]) {
        
        // Return visible view
        UITabBarController* svc = (UITabBarController*) VC;
        if (svc.viewControllers.count > 0){
            return [self getCurrentViewController:svc.selectedViewController];
        }else{
            return VC;
        }
        
    } else {
        
        // Unknown view controller type, return last child view controller
        return VC;
        
    }
    
}

+ (UIViewController *)currentViewController {
    
    // Find best view controller
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self getCurrentViewController:viewController];
}

@end
