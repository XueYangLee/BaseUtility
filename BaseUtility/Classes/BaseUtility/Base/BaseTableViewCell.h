//
//  BaseTableViewCell.h
//  BaseTools
//
//  Created by mac on 2020/5/11.
//  Copyright © 2020 Singularity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BaseTableViewCellPosition) {
    BaseTableViewCellPositionNone,
    BaseTableViewCellPositionFirstInSection,
    BaseTableViewCellPositionMiddleInSection,
    BaseTableViewCellPositionLastInSection,
    BaseTableViewCellPositionSingleInSection,
};

@interface BaseTableViewCell : UITableViewCell

/** tableViewDelegate 初始化Cell */
+ (instancetype)createCellWithTableView:(UITableView *)tableView;

/** 设置cell相关UI */
- (void)initUI;

/** cell在section中所处位置 */
@property (nonatomic,assign) BaseTableViewCellPosition base_cellPosition;


@end

NS_ASSUME_NONNULL_END
