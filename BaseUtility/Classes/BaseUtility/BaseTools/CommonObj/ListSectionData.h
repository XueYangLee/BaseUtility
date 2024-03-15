//
//  ListSectionData.h
//  BaseTools
//
//  Created by Singularity on 2020/10/29.
//  Copyright © 2020 Singularity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ListSectionCellData;

@interface ListSectionData : NSObject

/** 列表数据 */
@property (nonatomic,strong) NSArray <ListSectionCellData *>*cellDatas;

/** 组标题 */
@property (nonatomic,strong) NSString *sectionTitle;
/** 组标题字体大小 */
@property (nonatomic,strong) UIFont *sectionTitleFont;
/** 组标题字体颜色 */
@property (nonatomic,strong) UIColor *sectionTitleColor;

/** 组副标题 */
@property (nonatomic,strong) NSString *sectionSubTitle;
/** 组副标题字体大小 */
@property (nonatomic,strong) UIFont *sectionSubTitleFont;
/** 组副标题字体颜色 */
@property (nonatomic,strong) UIColor *sectionSubTitleColor;

/** 组按钮标题 */
@property (nonatomic,strong) NSString *sectionButtonTitle;
/** 组按钮标题字体大小 */
@property (nonatomic,strong) UIFont *sectionButtonTitleFont;
/** 组按钮标题字体颜色 */
@property (nonatomic,strong) UIColor *sectionButtonTitleColor;
/** 组按钮图片 */
@property (nonatomic,copy) NSString *sectionButtonImageName;
/** 组按钮焦点（选中）图片 */
@property (nonatomic,copy) NSString *sectionButtonFocusImageName;

/** 组必选显示  */
@property (nonatomic,assign) BOOL sectionRequired;

/** 组标题图片 */
@property (nonatomic,strong) UIImage *sectionTitleImage;
/** 组标题网络图片 */
@property (nonatomic,strong) NSString *sectionTitleImageURL;

/** 组类型 */
@property (nonatomic,strong) NSString *type;

/** 组数据 */
@property (nonatomic,strong) id sectionData;
/** 组头数据 */
@property (nonatomic,strong) id headerData;
/** 组尾数据 */
@property (nonatomic,strong) id footerData;

/** 组类名 作为整体计算时使用 */
@property (nonatomic,strong) NSString *sectionClassName;
/** 组头类名 */
@property (nonatomic,strong) NSString *headerClassName;
/** 组尾类名 */
@property (nonatomic,strong) NSString *footerClassName;

/** 组高度 作为整体计算时使用  tableView */
@property (nonatomic,assign) CGFloat sectionHeight;
/** 组头高度  tableView */
@property (nonatomic,assign) CGFloat headerHeight;
/** 组尾高度  tableView */
@property (nonatomic,assign) CGFloat footerHeight;

/** 组尺寸 作为整体计算时使用  collectionView */
@property (nonatomic,assign) CGSize sectionSize;
/** 组头尺寸  collectionView */
@property (nonatomic,assign) CGSize headerSize;
/** 组尾尺寸  collectionView */
@property (nonatomic,assign) CGSize footerSize;
/** 组行间距  collectionView */
@property (nonatomic,assign) CGFloat minimumLineSpacing;
/** 组控件间距  collectionView */
@property (nonatomic,assign) CGFloat minimumInteritemSpacing;
/** 组边距  collectionView */
@property (nonatomic,assign) UIEdgeInsets edgeInsets;

/// 是否展开组内数据
@property (nonatomic,assign) BOOL spread;
/// 是否折叠组内数据
@property (nonatomic,assign) BOOL fold;
/// 序列
@property (nonatomic,assign) NSInteger sort;
/// switch开关
@property (nonatomic,assign) BOOL switchOn;

@property (nonatomic,assign) BOOL enable;

@end




@interface ListSectionCellData : NSObject

/** 主数据源 */
@property (nonatomic,strong) id data;
/** 次级数据源 */
@property (nonatomic,strong) id subData;
/** 类名 */
@property (nonatomic,strong) NSString *className;
/** 标题名 */
@property (nonatomic,strong) NSString *titleName;
/** 类型 */
@property (nonatomic,strong) NSString *type;
/** 必选显示项  */
@property (nonatomic,assign) BOOL itemRequired;
/** 行高  tableView */
@property (nonatomic,assign) CGFloat cellHeight;
/** 控件尺寸 collectionView */
@property (nonatomic,assign) CGSize itemSize;

/// 类型id
@property (nonatomic,copy) NSString *itemId;
/// 序列
@property (nonatomic,assign) NSInteger sort;
/// switch开关
@property (nonatomic,assign) BOOL switchOn;

@property (nonatomic,assign) BOOL enable;

@end

NS_ASSUME_NONNULL_END
