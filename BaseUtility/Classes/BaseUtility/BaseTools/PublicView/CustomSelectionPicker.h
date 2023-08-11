//
//  CustomSelectionPicker.h
//  Doctor
//
//  Created by 李雪阳 on 2022/8/18.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^selectionCompletion)(NSArray * __nullable indexArray, NSArray * __nullable titleArray);

@interface CustomSelectionPicker : UIView

- (instancetype)initWithMultiple:(BOOL)multiple;
- (instancetype)initWithMultiple:(BOOL)multiple completion:(selectionCompletion)comp;
- (instancetype)initWithMultiple:(BOOL)multiple data:(NSArray *)dataArray completion:(selectionCompletion)comp;

/// 内容数据源  
@property (nonatomic,strong) NSArray *dataArray;

/// 已选中过的数据  在dataArray之后
@property (nonatomic,strong) NSArray *selectedArray;

@property (nonatomic,copy) selectionCompletion selectionComp;

@property (nonatomic,copy) NSString *title;

/// 多选结果是否可为空
@property (nonatomic,assign) BOOL canMultipleEmpty;

- (void)show;

@end



@interface CustomSelectionPickerTableCell : BaseTableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *selectBtn;

@property (nonatomic,copy) NSString *content;

@property (nonatomic,assign) BOOL itemSelected;
@property (nonatomic,copy) void(^selectClick)(BOOL selected, NSString *title);

@end

NS_ASSUME_NONNULL_END
