//
//  AppInitializeSetting.m
//  BaseTools
//
//  Created by 李雪阳 on 2021/4/19.
//  Copyright © 2021 Singularity. All rights reserved.
//

#import "AppInitializeSetting.h"
#import "NetRequestConfig.h"

@implementation AppInitializeSetting

+ (void)initKeyboard{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    manager.toolbarDoneBarButtonItemText = @"完成";
}

+ (void)initNaviConfig{
//    [WRNavigationBar wr_setDefaultNavBarBarTintColor:[UIColor app_mainColor]];
//    [WRNavigationBar wr_setDefaultNavBarTintColor:[UIColor whiteColor]];
//    [WRNavigationBar wr_setDefaultNavBarTitleColor:[UIColor whiteColor]];
//    [WRNavigationBar wr_setDefaultStatusBarStyle:UIStatusBarStyleLightContent];
//    [WRNavigationBar wr_setDefaultNavBarShadowImageHidden:YES];
}

+ (void)initMMapKeyValue{
    [MMKV initializeMMKV:nil logLevel:MMKVLogError];
}

+ (void)initSVProgress {
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
//    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

+ (void)initNetWork{
    [CustomNetWorkManager sharedManager].config=[NetRequestConfig new];
}

+ (void)initDebugCompileInject{
#if DEBUG
    [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle"] load];
#endif
}

@end
