//
//  MBProgressHUD+MBExtension.h
//  HUD_Test
//
//  Created by 李雪阳 on 2019/2/18.
//  Copyright © 2019 Singularity. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (MBExtension)

/** 指定视图显示文字信息  延迟消失 */
+ (void)showMessage:(NSString *_Nullable)message toView:(UIView *_Nullable)view;
/** 指定视图显示成功(图片)信息  延迟消失 */
+ (void)showSuccess:(NSString *_Nullable)success toView:(UIView *_Nullable)view;
/** 指定视图显示失败(图片)信息  延迟消失 */
+ (void)showError:(NSString *_Nullable)error toView:(UIView *_Nullable)view;
/** 指定视图显示提示警告(图片)信息  延迟消失 */
+ (void)showWarning:(NSString *_Nullable)Warning toView:(UIView *_Nullable)view;
/** 指定视图显示自定义图片信息  延迟消失  */
+ (void)showMessageWithImageName:(NSString *_Nullable)imageName message:(NSString *_Nullable)message toView:(UIView *_Nullable)view;

/** 显示文字信息  延迟消失 */
+ (void)showMessage:(NSString *_Nullable)message;
/** 显示成功(图片)信息  延迟消失 */
+ (void)showSuccess:(NSString *_Nullable)success;
/** 显示失败(图片)信息  延迟消失 */
+ (void)showError:(NSString *_Nullable)error;
/** 显示提示警告(图片)信息  延迟消失 */
+ (void)showWarning:(NSString *_Nullable)Warning;
/** 显示自定义图片信息  延迟消失 */
+ (void)showMessageWithImageName:(NSString *_Nullable)imageName message:(NSString *_Nullable)message;

/** 进度条加载 */
+ (MBProgressHUD *)showProgressBarToView:(UIView *_Nullable)view;

/** 指定视图显示加载中信息  常显 */
+ (MBProgressHUD *)showActivityMessage:(NSString*_Nullable)message view:(UIView *_Nullable)view;
/** 显示加载中信息  常显 */
+ (MBProgressHUD *)showActivityMessage:(NSString *_Nullable)message;
/** 显示加载中 */
+ (void)showHUD;
/** 从指定视图消失加载中 */
+ (void)hideHUDForView:(UIView *_Nullable)view;
/** 消失加载中 */
+ (void)hideHUD;



@end

NS_ASSUME_NONNULL_END
