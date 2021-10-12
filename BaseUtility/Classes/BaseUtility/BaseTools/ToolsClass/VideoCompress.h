//
//  VideoCompress.h
//  WeiGuGlobal
//
//  Created by Singularity on 2019/7/3.
//  Copyright © 2019 com.chuang.global. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 压缩成功Block

 @param resultPath 返回压缩成功的视频路径
 */
typedef void (^CompressionSuccessBlock)(NSString *resultPath,float memorySize);


@interface VideoCompress : NSObject



/**
 压缩视频, 该方法将压缩过的视频保存到沙盒文件, 如果压缩过的视频不需要再进行保留, 可调用 removeCompressedVideoFromDocuments 方法, 将其删除即可

 @param url 要压缩的视频路劲url
 @param compressionType 压缩可选类型
         AVAssetExportPresetLowQuality
         AVAssetExportPresetMediumQuality
         AVAssetExportPresetHighestQuality
         AVAssetExportPreset640x480
         AVAssetExportPreset960x540
         AVAssetExportPreset1280x720
         AVAssetExportPreset1920x1080
         AVAssetExportPreset3840x2160
 @param resultPathBlock 返回压缩后的视频路径及大小
 */
+ (void)compressVideoWithFileURL:(NSURL *)url compressionType:(NSString *)compressionType compressionResult:(CompressionSuccessBlock)resultPathBlock;



/**
 获取视频大小 单位MB

 @param url url路径
 */
+ (float)videoMemorySizeWithURL:(NSURL *)url;



/**
 清除沙盒文件中压缩后的视频
 */
+ (void)removeCompressedVideoFromDocuments;

@end

NS_ASSUME_NONNULL_END
