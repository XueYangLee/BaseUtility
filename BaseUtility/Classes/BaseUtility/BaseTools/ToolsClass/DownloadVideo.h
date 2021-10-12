//
//  DownloadVideo.h
//  WeiGuGlobal
//
//  Created by Singularity on 2019/5/9.
//  Copyright © 2019 com.chuang.global. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DownloadVideoCompletion)(BOOL success);


@interface DownloadVideo : NSObject

/**
 下载网络视频

 @param videoUrl 视频网络地址
 */
+ (void)videoDownloadWithUrl:(NSString *)videoUrl progress:(void(^__nullable)(NSProgress *progress, double downloadProgress))progress completion:(DownloadVideoCompletion)comp;

@end

NS_ASSUME_NONNULL_END
