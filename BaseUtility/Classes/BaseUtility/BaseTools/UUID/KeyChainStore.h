//
//  KeyChainStore.h
//  moneyhll
//
//  Created by 李雪阳 on 16/12/18.
//  Copyright © 2016年 浙江龙之游旅游开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainStore : NSObject


/**
 保存信息到keychain中

 @param service 标识
 @param data 保存的数据
 */
+ (void)save:(NSString *)service data:(id)data;


/**
 读取保存标识的信息

 @param service 标识
 */
+ (id)load:(NSString *)service;


/**
 删除标识的信息

 @param service 标识
 */
+ (void)deleteKeyData:(NSString *)service;

@end
