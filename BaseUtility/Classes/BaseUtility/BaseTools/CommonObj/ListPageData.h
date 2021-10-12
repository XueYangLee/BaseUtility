//
//  ListPageData.h
//  BaseTools
//
//  Created by Singularity on 2020/10/29.
//  Copyright © 2020 Singularity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListPageData : NSObject

/** 每页数据个数  根据后台返回参数名而定 */
@property (nonatomic,assign) NSInteger pageSize;
/** 总数据数  根据后台返回参数名而定 */
@property (nonatomic,assign) NSInteger totalCount;
/** 页码  根据后台返回参数名而定 */
@property (nonatomic,assign) NSInteger currentPage;
/** 数据列表  根据后台返回参数名而定 */
@property (nonatomic,strong) NSArray *record;

@end

NS_ASSUME_NONNULL_END
