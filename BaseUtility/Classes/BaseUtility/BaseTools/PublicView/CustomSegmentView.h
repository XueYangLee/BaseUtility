//
//  CustomSegmentView.h
//  XH_Tenant
//
//  Created by 李雪阳 on 2021/4/28.
//

#import <UIKit/UIKit.h>
#import "BaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^segmentSelect)(NSInteger selectIndex,NSString *selectContent);

@interface CustomSegmentView : UIView

- (instancetype)initWithSegmentSelected:(segmentSelect)comp;

/** 显示的数据  重新调用会刷新  index重置为0 */
@property (nonatomic,strong) NSArray *items;

/** 默认选择条数 */
@property (nonatomic,assign) NSInteger defaultSelect;

@end



@interface CustomSegmentCell : BaseCollectionViewCell

@property (nonatomic,strong) UIButton *itemBtn;
@property (nonatomic,strong) UILabel *itemSeg;


@property (nonatomic,copy) NSString *content;

@property (nonatomic,copy) dispatch_block_t contentClick;

@property (nonatomic,assign) BOOL itemSelected;

@end

NS_ASSUME_NONNULL_END
