//
//  CustomFlowLayout.h
//  BaseTools
//
//  Created by Singularity on 2019/4/18.
//  Copyright © 2019 Singularity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CalculateData;

typedef NS_ENUM(NSInteger, FlowLayoutAlignment) {
    FlowLayoutAlignmentJustify,
    FlowLayoutAlignmentLeft,
    FlowLayoutAlignmentCenter,
    FlowLayoutAlignmentRight
};


@protocol CustomFlowLayout <UICollectionViewDelegateFlowLayout>
// @interface ViewController ()<CustomFlowLayout>
@optional
/// 组背景色
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundColorForSection:(NSInteger)section;

//开启指定组头悬停功能
- (BOOL)openSectionHeaderHoverInCollectionView:(UICollectionView *)collectionView;
/// 那组开启那组返回yes
- (BOOL)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind hoverSectionAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface CustomFlowLayout : UICollectionViewFlowLayout

/** collectionViewCell 布局  居中、居左、居右 */
@property (assign, nonatomic) FlowLayoutAlignment alignment;

-(CalculateData *)collectionContentHeightDataWithItemWidths:(NSArray *)widths WithMaxWidth:(CGFloat)maxWidth WithOneItemHeight:(CGFloat)height WithMoreItemWidth:(CGFloat)moreItemWidth;

-(CGFloat )collectionContentTotalHeightDataWithItemWidths:(NSArray *)widths WithMaxWidth:(CGFloat)maxWidth WithOneItemHeight:(CGFloat)height;

@end





@interface CalculateData : NSObject

@property (nonatomic,assign) CGFloat expandHeight;
@property (nonatomic,assign) CGFloat notExpandHeight;
@property (nonatomic,assign) BOOL canExpand;
@property (nonatomic,assign) NSInteger noExpandIndex;

@end
NS_ASSUME_NONNULL_END
