//
//  BaseCollectionViewController+EmptyData.h
//  BaseTools
//
//  Created by 李雪阳 on 2020/10/30.
//  Copyright © 2020 Singularity. All rights reserved.
//
//  pod 'DZNEmptyDataSet'   或导入UIScrollView+EmptyDataSet文件

#import "BaseCollectionViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseCollectionViewController (EmptyData)<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

- (void)initEmptyData;

@end

NS_ASSUME_NONNULL_END
