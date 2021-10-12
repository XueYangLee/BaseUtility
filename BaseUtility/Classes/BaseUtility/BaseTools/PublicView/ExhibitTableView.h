//
//  ExhibitTableView.h
//  Doctor
//
//  Created by 李雪阳 on 2021/9/2.
//

#import <UIKit/UIKit.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

NS_ASSUME_NONNULL_BEGIN

/** 列表嵌套用tableview，scrollEnable已被禁止 */
@interface ExhibitTableView : UITableView<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

/** 无数据空页面是否显示  默认显示 */
@property (nonatomic, assign) BOOL empty_showData;

- (void)initUI;

- (void)reloadEmptyDataSet;

@end

NS_ASSUME_NONNULL_END
