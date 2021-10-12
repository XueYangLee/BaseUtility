//
//  BaseViewController.h
//  textPod
//
//  Created by 李雪阳 on 2017/11/21.
//  Copyright © 2017年 singularity. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BaseViewController : UIViewController


/** CGRectZero是否从导航栏下开始计算 默认YES */
@property (assign,nonatomic) BOOL edgesExtendLayout;

/** 是否隐藏显示导航栏  默认显示 不隐藏 */
@property (nonatomic,assign) BOOL hideNavigationBar;

/** 是否隐藏导航栏下阴影线 默认隐藏 */
@property (nonatomic,assign) BOOL hideNaviShadow;



/**
 设置左侧导航栏按钮

 @param image 图片
 */
- (void)setNavigationLeftBarBtnItemWithImage:(UIImage *)image action:(SEL)selector;


/**
 设置右侧导航栏按钮

 @param title 标题（无传nil）
 @param image 图片（无传nil）
 */
- (void)setNavigationRightBarBtnItemWithTitle:(NSString *)title image:(UIImage *)image action:(SEL)selector;


/**
 状态栏类型及显示隐藏

 @param statusBarStyle 类型  UIStatusBarStyleDefault 黑色   UIStatusBarStyleLightContent 白色
 @param statusBarHidden 显示隐藏
 */
- (void)changeStatusBarStyle:(UIStatusBarStyle)statusBarStyle statusBarHidden:(BOOL)statusBarHidden;


/**
 更改statusBar颜色（离开页面需调用移除）
 */
- (void)changeStatusBarColor:(UIColor *)barColor;


/**
 移除statusbar颜色
 */
- (void)removeStatusBarColor;




/**
 初始化tableview（需添加代理）
 */
- (UITableView *)tableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style;




@end
