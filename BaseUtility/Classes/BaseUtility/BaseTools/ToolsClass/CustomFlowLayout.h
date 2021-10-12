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
//section背景色   @interface ViewController ()<CustomFlowLayout>
@optional
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundColorForSection:(NSInteger)section;

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
