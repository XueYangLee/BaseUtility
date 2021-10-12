//
//  BaseAlertView.h
//  BaseTools
//
//  Created by Singularity on 2020/8/20.
//  Copyright © 2020 Singularity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseAlertView : UIView

/** 底视图  原始尺寸 CGSizeMake(SCREEN_WIDTH-90, 330) */
@property (nonatomic,strong) UIView *bkView;

/** UI设置 */
- (void)initUI;

/** 显示时的处理 */
- (void)showHandle;
/** 消失时的处理 */
- (void)dismissHandle;

/** 视图显示 */
- (void)show;
/** 视图消失 */
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
