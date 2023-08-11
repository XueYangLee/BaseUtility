//
//  CustomWaterLayout.h
//  Now
//
//  Created by Singularity on 2020/6/16.
//  Copyright © 2020 iMoblife. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CustomWaterLayoutDelegate <NSObject>

@required
/// section的数量
- (NSInteger)numberOfSection;
/// cell的大小
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
/// section的列数
- (NSInteger)numberOfColumnInSectionAtIndex:(NSInteger)section;

@optional
/// 行间距
- (CGFloat)minimumLineSpacingForSectionAtIndex:(NSInteger)section;
/// 列间距
- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
/// sectionInset
- (UIEdgeInsets)contentInsetOfSectionAtIndex:(NSInteger)section;

@end


@interface CustomWaterLayout : UICollectionViewLayout

@property (nonatomic, weak) id <CustomWaterLayoutDelegate> delegate;

/// 代替collectionView.contentInset  结果：组边距+contentInset   瀑布流下只实现代理
@property (nonatomic, assign) UIEdgeInsets contentInset;

@end

NS_ASSUME_NONNULL_END
