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
/** 组副标题 */
@property (nonatomic,strong) NSString *sectionSubTitle;
/** 组按钮标题 */
@property (nonatomic,strong) NSString *sectionButtonTitle;

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
/** 行高  tableView */
@property (nonatomic,assign) CGFloat cellHeight;
/** 控件尺寸 collectionView */
@property (nonatomic,assign) CGSize itemSize;

@end

NS_ASSUME_NONNULL_END
