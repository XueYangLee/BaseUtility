//
//  AppInitializeSetting.h
//  BaseTools
//
//  Created by 李雪阳 on 2021/4/19.
//  Copyright © 2021 Singularity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppInitializeSetting : NSObject

/** 键盘 */
+ (void)initKeyboard;

/** 导航栏统一设置 */
+ (void)initNaviConfig;

/** hud */
+ (void)initSVProgress;

/** mmkv  */
+ (void)initMMapKeyValue;

/** 初始化网络请求 */
+ (void)initNetWork;

/** injectionIII */
+ (void)initDebugCompileInject;

@end

NS_ASSUME_NONNULL_END
