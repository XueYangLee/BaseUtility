//
//  UIImage+ImageSize.h
//  BaseTools
//
//  Created by Singularity on 2019/4/23.
//  Copyright © 2019 Singularity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ImageSize)

/** 获取网络图片尺寸并缓存（SDWebImage方式下载缓存）首次加载图片会在block中返回尺寸 */
+ (CGSize)imageSizeInCacheWithImageUrl:(id)imageURL completion:(void (^__nullable)(CGSize imageSize))completion;


/** 获取网络图片尺寸 */
+ (CGSize)imageSizeWithImageUrl:(id)imageURL;

@end

NS_ASSUME_NONNULL_END
