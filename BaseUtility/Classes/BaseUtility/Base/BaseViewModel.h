//
//  BaseViewModel.h
//  BaseTools
//
//  Created by 李雪阳 on 2019/3/29.
//  Copyright © 2019 Singularity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/** 数据结果 */
typedef void(^__nullable VMCompletion)(BOOL success);

/** 数据结果  数据data */
typedef void(^__nullable VMDataCompletion)(BOOL success, id data);

/** 数据结果  数据data及信息文案 */
typedef void(^__nullable VMDataMsgCompletion)(BOOL success, id data, NSString *msg);

/** 数据结果  信息文案 */
typedef void(^__nullable VMMsgCompletion)(BOOL success, NSString *msg);

/** 数据结果  刷新数据结果（有无更多数据） */
typedef void(^VMRefreshCompletion)(BOOL success, BOOL noMoreData);

/** 数据结果  数据data  信息文案及刷新数据结果（有无更多数据） */
typedef void(^VMDataMsgRefreshCompletion)(BOOL success, id data, NSString *msg, BOOL noMoreData);

/** 数据结果  信息文案及刷新数据结果（有无更多数据） */
typedef void(^VMMsgRefreshCompletion)(BOOL success, NSString *msg, BOOL noMoreData);




@interface BaseViewModel : NSObject

@end

NS_ASSUME_NONNULL_END
