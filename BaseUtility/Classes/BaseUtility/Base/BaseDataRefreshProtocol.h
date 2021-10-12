//
//  BaseDataRefreshProtocol.h
//  BaseTools
//
//  Created by 李雪阳 on 2020/6/15.
//  Copyright © 2020 Singularity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BaseDataRefreshProtocol <NSObject>

@optional

/** 刷新数据源处理 */
- (void)loadRefreshData;

/** 结束下拉刷新 下拉加载动作 */
- (void)endRefreshing;

/** 结束下拉刷新动作（刷新头） */
- (void)endRefreshInHeader;

/** 结束上拉加载动作（刷新尾）*/
- (void)endRefreshInFooter;

/** 重置刷新尾状态  一般下拉刷新后重置，可以再次进行上拉加载 */
- (void)resetFooterState;

/** 没有更多数据  MJRefreshStateNoMoreData */
- (void)noMoreData;

/** 无数据 隐藏刷新尾部 */
- (void)noneData;

/** 触动刷新 开始刷新动作 */
- (void)beginRefreshing;

@end

NS_ASSUME_NONNULL_END
