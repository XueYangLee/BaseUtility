//
//  CustomWaterLayout.h
//  Now
//
//  Created by Singularity on 2020/6/16.
//  Copyright © 2020 iMoblife. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef CGFloat(^ItemHeightBlock)(NSIndexPath *indexPath, CGFloat width);

@interface CustomWaterLayout : UICollectionViewLayout

/** 列数 */
@property (nonatomic, assign) NSInteger lineNumber;

/** 行间距 */
@property (nonatomic, assign) CGFloat lineSpacing;

/** 列间距 */
@property (nonatomic, assign) CGFloat interItemSpacing;

/** 内边距 */
@property (nonatomic, assign) UIEdgeInsets sectionInset;


/** collectionView计算高度方法  block中计算cell高度 */
- (void)heightForItemAtIndexPath:(CGFloat(^)(NSIndexPath *indexPath, CGFloat width))block;

@end

NS_ASSUME_NONNULL_END
