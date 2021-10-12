//
//  SaveImageManager.h
//  WeiGuGlobal
//
//  Created by Singularity on 2019/4/3.
//  Copyright © 2019 com.chuang.global. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SaveImageCompletion)(BOOL success);


@interface SaveImageManager : NSObject


/**
 保存多张图片并创建APP相册到本地

 @param imageArray 图片数组
 @param comp 保存结果 进行后续操作
 */
+ (void)saveImages:(NSArray <NSString *>*)imageArray completion:(nullable SaveImageCompletion)comp;



/**
 保存单张图片并创建APP相册到本地

 @param imageUrl 图片Url
 @param comp 保存结果 进行后续操作
 */
+ (void)saveImage:(NSString *)imageUrl completion:(nullable SaveImageCompletion)comp;



/**
 保存单张UIImage图片并创建APP相册到本地
 
 @param localImage  需要保存的UIimage
 @param comp 保存结果 进行后续操作
 */
+ (void)saveLocalImage:(UIImage *)localImage completion:(SaveImageCompletion)comp;


/** 相册读写权限弹框 */
+ (void)authorizeRemind;





/**
 保存单张图片并创建APP相册到本地 **通用方法**
 
 @param image 图片
 @param comp 回调
 */
+ (void)writeImage:(UIImage *)image completion:(void (^__nullable)(BOOL success))comp;


/**
 SDWebImage下载多张图片
 
 @param imgsArray 图片数组Url
 @param comp 回调 返回image数组
 */
+ (void)downloadWebImages:(NSArray<NSString *> *)imgsArray completion:(void(^)(NSArray *imageArray))comp;

@end

NS_ASSUME_NONNULL_END
