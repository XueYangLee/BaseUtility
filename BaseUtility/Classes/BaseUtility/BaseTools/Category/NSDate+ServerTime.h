//
//  NSDate+ServerTime.h
//  BaseTools
//
//  Created by Singularity on 2020/10/27.
//  Copyright © 2020 Singularity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (ServerTime)

/** 重置 更新服务器时间戳 状态 */
+ (void)resetUpdateTimeState;

/** 更新服务器时间戳（网络请求成功时调用） */
+ (void)updateTimeFromServer:(long long)serverTiem;


/** 服务器校准的时间 返回时间戳 */
+ (long long)currentTimeInServer;

/** 服务器校准的时间 返回NSDate */
+ (NSDate *)currentDateInServer;

@end

NS_ASSUME_NONNULL_END
