//
//  SaveImageManager.m
//  WeiGuGlobal
//
//  Created by Singularity on 2019/4/3.
//  Copyright © 2019 com.chuang.global. All rights reserved.
//

#import "SaveImageManager.h"
#import <Photos/Photos.h>//相册权限
#import <SDWebImage/SDWebImageDownloader.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "CustomAlert.h"
#import "UtilityMacro.h"
#import "UtilityCategoryHeader.h"

@implementation SaveImageManager

static SaveImageCompletion _saveCompletion;


+ (void)saveImages:(NSArray <NSString *>*)imageUrlArray completion:(SaveImageCompletion)comp{
    _saveCompletion=comp;
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case PHAuthorizationStatusAuthorized: //已获取权限
                    [self downLoadImageArray:imageUrlArray];
                    break;
                case PHAuthorizationStatusDenied: //用户已经明确否认了这一照片数据的应用程序访问
                    [self authorizeRemind];
                    break;
                case PHAuthorizationStatusRestricted://此应用程序没有被授权访问的照片数据。可能是家长控制权限
                    [SVProgressHUD showErrorWithStatus:@"因为系统原因, 无法访问相册"];
                    break;
                default://其他。。。
                    break;
            }
        });
    }];
}


+ (void)saveImage:(NSString *)imageUrl completion:(SaveImageCompletion)comp{
    _saveCompletion=comp;
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case PHAuthorizationStatusAuthorized: //已获取权限
                    [self downLoadSingleImage:imageUrl];
                    break;
                case PHAuthorizationStatusDenied: //用户已经明确否认了这一照片数据的应用程序访问
                    [self authorizeRemind];
                    break;
                case PHAuthorizationStatusRestricted://此应用程序没有被授权访问的照片数据。可能是家长控制权限
                    [SVProgressHUD showErrorWithStatus:@"因为系统原因, 无法访问相册"];
                    break;
                default://其他。。。
                    break;
            }
        });
    }];
}


+ (void)saveLocalImage:(UIImage *)localImage completion:(SaveImageCompletion)comp{
    _saveCompletion=comp;
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case PHAuthorizationStatusAuthorized: //已获取权限
                    [self downLoadLocalImage:localImage];
                    break;
                case PHAuthorizationStatusDenied: //用户已经明确否认了这一照片数据的应用程序访问
                    [self authorizeRemind];
                    break;
                case PHAuthorizationStatusRestricted://此应用程序没有被授权访问的照片数据。可能是家长控制权限
                    [SVProgressHUD showErrorWithStatus:@"因为系统原因, 无法访问相册"];
                    break;
                default://其他。。。
                    break;
            }
        });
    }];
}


+ (void)authorizeRemind{
    [CustomAlert showAlertAddTarget:[UIViewController currentViewController] title:@"提示" message:[NSString stringWithFormat:@"请在%@的\"设置-隐私\"选项中，\r允许%@访问您照片的读取和写入以下载图片。",[UIDevice currentDevice].model,[[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"]] actionHandle:^(NSInteger actionIndex, NSString * _Nonnull btnTitle) {
        if (actionIndex==1) {
            
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }
    }];
}


+ (void)downLoadImageArray:(NSArray <NSString *>*)imageUrlArray{
    NSMutableArray *imgSaveArray=[NSMutableArray array];
    
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        for (NSInteger i=0; i<imageUrlArray.count; i++) {
            
            [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:imageUrlArray[i]] options:SDWebImageDownloaderAllowInvalidSSLCertificates progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                
                if (finished) {
                    [imgSaveArray addObject:image];
                }
                
                if (i==imageUrlArray.count-1) {
                    dispatch_semaphore_signal(sem);
                }
            }];
        }
        
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        
        [self downLoadImages:imgSaveArray completion:^(BOOL success) {
            
            if (_saveCompletion) {
                _saveCompletion(success);
            }
        }];
    });
    
    /* 某类https情况下会造成data获取为null
    for (NSInteger i=0; i<imageUrlArray.count; i++) {
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrlArray[i]]];
        UIImage *image = [UIImage imageWithData:data];
        [imgSaveArray addObject:image];
    }
    
    [SVProgressHUD showWithStatus:@"保存中"];
    [self downLoadImages:imgSaveArray completion:^(BOOL success) {
        if (success) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"保存失败"];
        }
    }];*/
    
}


//保存多张图片
+ (void)downLoadImages:(NSMutableArray *)images completion:(void (^__nullable)(BOOL success))comp {
    if ([images count] == 0) {
        if (comp) {
            comp(YES);
        }
        return;
    }
    
    UIImage* image = [images firstObject];
    [self writeImage:image completion:^(BOOL success) {
        if (success) {
            [images removeObjectAtIndex:0];
            [self downLoadImages:images completion:comp];
        }else{
            if (comp) {
                comp(NO);
            }
            return;
        }
    }];
    
}


//保存单张图片
+ (void)downLoadSingleImage:(NSString *)imageUrl{
    
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageDownloaderAllowInvalidSSLCertificates progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        
        [self writeImage:image completion:^(BOOL success) {
            
            if (_saveCompletion) {
                _saveCompletion(success);
            }
        }];
    }];
    
    /* 某类https情况下会造成data获取为null
    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    UIImage *image = [UIImage imageWithData:data];
    
    [SVProgressHUD showWithStatus:@"保存中"];
    [self writeImage:image completion:^(BOOL success) {
        if (success) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"保存失败"];
        }
    }];*/
}


//保存单张本地图片 UIImage
+ (void)downLoadLocalImage:(UIImage *)localImage{
    
    [self writeImage:localImage completion:^(BOOL success) {
        
        if (_saveCompletion) {
            _saveCompletion(success);
        }
    }];
}


#pragma mark -----保存单张图片并创建APP相册到本地-----
+ (void)writeImage:(UIImage *)image completion:(void (^__nullable)(BOOL success))comp{
    //修改系统相册用PHPhotoLibrary单粒,调用performChanges,否则苹果会报错,并提醒你使用
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 调用判断是否已有该名称相册
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        //以项目名字命名相册
        /** 如果发现获取到的appName为空，查看plist下以前默认创建的Bundle display name是否存在
        #info.plist文件下添加 Bundle display name   ${PRODUCT_NAME} */
        NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        PHAssetCollection *assetCollection = [self fetchAssetColletion:app_Name];
        //创建一个操作图库的对象
        
        PHAssetCollectionChangeRequest *assetCollectionChangeRequest;
        if (assetCollection) {
            // 已有相册
            assetCollectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
            
        } else {
            // 1.创建自定义相册
            assetCollectionChangeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:app_Name];
        }
        // 2.保存你需要保存的图片到系统相册(这里保存的是_imageView上的图片)
        PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        // 3.把创建好图片添加到自己相册(ps:想保存到系统相册，就注释掉下边一行代码就ok)
        //这里使用了占位图片,为什么使用占位图片呢
        //这个block是异步执行的,使用占位图片先为图片分配一个内存,等到有图片的时候,再对内存进行赋值
        PHObjectPlaceholder *placeholder = [assetChangeRequest placeholderForCreatedAsset];
        [assetCollectionChangeRequest addAssets:@[placeholder]];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        //弹出一个界面提醒用户是否保存成功
        if (success) {
            if (comp) {
                comp(YES);
            }
        } else {//如果保存失败优先检查appName是否存在，保存需要建立在以APP名字建立的相册上
            DLog(@"%@->图片保存失败",error);
            if (comp) {
                comp(NO);
            }
        }
        
    }];
}

//该方法获取在图库中是否已经创建该App的相册
//该方法的作用,获取系统中所有的相册,进行遍历,若是已有相册,返回该相册,若是没有返回nil,参数为需要创建  的相册名称
+ (PHAssetCollection *)fetchAssetColletion:(NSString *)albumTitle{
    // 获取所有的相册
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    //遍历相册数组,是否已创建该相册
    for (PHAssetCollection *assetCollection in result) {
        if ([assetCollection.localizedTitle isEqualToString:albumTitle]) {
            return assetCollection;
        }
    }
    return nil;
    
}







#pragma mark -----SDWebImage下载多张图片-----
+ (void)downloadWebImages:(NSArray<NSString *> *)imgsArray completion:(void(^)(NSArray *imageArray))comp {
    SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];//默认超时15秒
    __block NSMutableDictionary *resultDict = [NSMutableDictionary new];
    for(int i=0;i<imgsArray.count;i++) {
        NSString *imgUrl = [imgsArray objectAtIndex:i];
        [manager downloadImageWithURL:[NSURL URLWithString:imgUrl] options:SDWebImageDownloaderUseNSURLCache|SDWebImageDownloaderScaleDownLargeImages progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            if(finished){
                if(error){
                    //在对应的位置放一个error对象
                    [resultDict setObject:error forKey:@(i)];
                }else{
                    [resultDict setObject:image forKey:@(i)];
                }
                if(resultDict.count == imgsArray.count) {
                    //全部下载完成
                    NSArray *imageArray = [self createDownloadResultArray:resultDict count:imgsArray.count];
                    if(comp){
                        comp(imageArray);
                    }
                }
            }
            
        }];
    }
}

+ (NSArray *)createDownloadResultArray:(NSDictionary *)dict count:(NSInteger)count {
    NSMutableArray *resultArray = [NSMutableArray new];
    for(int i=0;i<count;i++) {
        NSObject *obj = [dict objectForKey:@(i)];
        [resultArray addObject:obj];
    }
    return resultArray;
}

@end
