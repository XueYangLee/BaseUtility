//
//  UUID.h
//  BaseTools
//
//  Created by 李雪阳 on 2020/6/9.
//  Copyright © 2020 Singularity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUID : NSObject

/** 获取设备UUID */
+ (NSString *)getUUID;

@end

NS_ASSUME_NONNULL_END
