//
//  MBProgressHUD+MBExtension.m
//  HUD_Test
//
//  Created by 李雪阳 on 2019/2/18.
//  Copyright © 2019 Singularity. All rights reserved.
//

#import "MBProgressHUD+MBExtension.h"

#define DelayHideTime 1.5

@implementation MBProgressHUD (MBExtension)

#pragma mark 显示带图片或者不带图片的信息
+ (void)show:(NSString *_Nullable)text icon:(NSString *_Nullable)icon view:(UIView *_Nullable)view{
    if (view == nil) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    // 判断是否显示图片
    if (icon == nil) {
        hud.mode = MBProgressHUDModeText;
    }else{
        // 设置图片
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]];
        img = img == nil ? [UIImage imageNamed:icon] : img;
        hud.customView = [[UIImageView alloc] initWithImage:img];
        // 自定义视图
        hud.mode = MBProgressHUDModeCustomView;
    }
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 指定时间之后再消失
    [hud hideAnimated:YES afterDelay:DelayHideTime];
}


#pragma mark 指定视图显示文字信息  延迟消失
+ (void)showMessage:(NSString *_Nullable)message toView:(UIView *_Nullable)view{
    [self show:message icon:nil view:view];
}

#pragma mark 指定视图显示成功(图片)信息  延迟消失
+ (void)showSuccess:(NSString *_Nullable)success toView:(UIView *_Nullable)view{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 指定视图显示失败(图片)信息  延迟消失
+ (void)showError:(NSString *_Nullable)error toView:(UIView *_Nullable)view{
    [self show:error icon:@"error.png" view:view];
}

#pragma mark 指定视图显示提示警告(图片)信息  延迟消失
+ (void)showWarning:(NSString *_Nullable)Warning toView:(UIView *_Nullable)view{
    [self show:Warning icon:@"warn" view:view];
}

#pragma mark 指定视图显示自定义图片信息  延迟消失
+ (void)showMessageWithImageName:(NSString *_Nullable)imageName message:(NSString *_Nullable)message toView:(UIView *_Nullable)view{
    [self show:message icon:imageName view:view];
}


#pragma mark 显示文字信息  延迟消失
+ (void)showMessage:(NSString *_Nullable)message{
    [self showMessage:message toView:nil];
}

#pragma mark 显示成功(图片)信息  延迟消失
+ (void)showSuccess:(NSString *_Nullable)success{
    [self showSuccess:success toView:nil];
}

#pragma mark 显示失败(图片)信息  延迟消失
+ (void)showError:(NSString *_Nullable)error{
    [self showError:error toView:nil];
}

#pragma mark 显示提示警告(图片)信息  延迟消失
+ (void)showWarning:(NSString *_Nullable)Warning{
    [self showWarning:Warning toView:nil];
}

#pragma mark 显示自定义图片信息  延迟消失
+ (void)showMessageWithImageName:(NSString *_Nullable)imageName message:(NSString *_Nullable)message{
    [self showMessageWithImageName:imageName message:message toView:nil];
}


#pragma mark 进度条加载
+ (MBProgressHUD *)showProgressBarToView:(UIView *_Nullable)view{
    if (view == nil) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;
    hud.label.text = @"加载中...";
    return hud;
}


#pragma mark 指定视图显示加载中信息  常显
+ (MBProgressHUD *)showActivityMessage:(NSString*_Nullable)message view:(UIView *_Nullable)view{
    if (view == nil) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 细节文字
    //    hud.detailsLabelText = @"请耐心等待";
    // 再设置模式
    hud.mode = MBProgressHUDModeIndeterminate;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    return hud;
}

#pragma mark 显示加载中信息  常显
+ (MBProgressHUD *)showActivityMessage:(NSString *_Nullable)message{
    return [self showActivityMessage:message view:nil];
}


#pragma mark 显示加载中
+ (void)showHUD{
    [self showActivityMessage:nil];
}

#pragma mark 从指定视图消失加载中
+ (void)hideHUDForView:(UIView *_Nullable)view{
    if (view == nil) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    [self hideHUDForView:view animated:YES];
}

#pragma mark 消失加载中
+ (void)hideHUD{
    [self hideHUDForView:nil];
}

@end
