//
//  NSDate+ServerTime.m
//  BaseTools
//
//  Created by Singularity on 2020/10/27.
//  Copyright © 2020 Singularity. All rights reserved.
//

#import "NSDate+ServerTime.h"

/// 本地和服务器的时间差
static NSString *APPSystemTimeDifferenceKey = @"APPSystemTimeDifference";

///是否已经更新过时间戳
static BOOL hasUpdatedTime = NO;

@implementation NSDate (ServerTime)


+ (void)resetUpdateTimeState {
    hasUpdatedTime = NO;
}

+ (void)updateTimeFromServer:(long long)serverTiem {
    
    if (hasUpdatedTime) {
        return;
    }
    
    if (serverTiem == 0) {
        //错误数据
        return;
    }

    long long localTime = [[NSDate date] timeIntervalSince1970] * 1000;
    long long tmsDistence = serverTiem - localTime;
    
    [[NSUserDefaults standardUserDefaults]setObject:@(tmsDistence) forKey:APPSystemTimeDifferenceKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
//    hasUpdatedTime = YES;
}


+ (long long)currentTimeInServer {

    long long localTms = [[NSDate date] timeIntervalSince1970] * 1000;
    long long distenceTms = [[[NSUserDefaults standardUserDefaults]objectForKey:APPSystemTimeDifferenceKey]longLongValue];
    return localTms + distenceTms;
}

+ (NSDate *)currentDateInServer {

    return [NSDate dateWithTimeIntervalSince1970:[NSDate currentTimeInServer]/1000];
}

@end
