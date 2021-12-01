//
//  RouteCenter.h
//  BaseTools
//
//  Created by 李雪阳 on 2020/10/27.
//  Copyright © 2020 Singularity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RouteCenter : NSObject

+ (instancetype)sharedRouter;


- (BOOL)canOpenURL:(NSURL *)URL;

/** 网址路由调用页面   [[RouteCenter sharedRouter]openURL:[NSURL URLWithString:@"route://Module(Router_Module)/function(Func_function)#push"]] */
- (BOOL)openURL:(NSURL *)URL;
/** 网址路由调用页面   [[RouteCenter sharedRouter]openURL:[NSURL URLWithString:@"route://Module(Router_Module)/function(Func_function)"] params:@{@"key":@"value"}] */
- (BOOL)openURL:(NSURL *)URL params:(NSDictionary<NSString *, NSString *> *)params;

- (BOOL)openURL:(NSURL *)URL params:(NSDictionary<NSString *, NSString *> * __nullable)params handler:(void(^ __nullable)(NSString *pathComponentKey, id returnValue))handler;


/** 远程App调用入口 */
- (id)performActionWithUrl:(NSURL *)url completion:(void (^)(NSDictionary *))completion;


/**
 本地组件调用入口    执行 xx target 的 xx action 后，return
 @param routerName Router_XXX.h
 @param functionName Func_XXX 函数
 */
- (id)performRouter:(NSString *)routerName func:(NSString *)functionName params:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
