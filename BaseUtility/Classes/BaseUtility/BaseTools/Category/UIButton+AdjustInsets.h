//
//  UIButton+AdjustInsets.h
//  Now
//
//  Created by 李雪阳 on 2020/6/11.
//  Copyright © 2020 iMoblife. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    AdjustLeftImageRightTitle,//图片在左 文案在右
    AdjustLeftTitleRightImage,//文案在左 图片在右
    AdjustTopImageBottomTitle,//图片在上 文案在下
    AdjustTopTitleBottomImage,//文案在上 图片在下
} AdjustInsetsStyle;

@interface UIButton (AdjustInsets)


/** 增加图片文案间隔 */
- (void)addImageTitleInterval:(CGFloat)interval;

/** 调整为文案在左图片在右  */
- (void)adjustToLeftTitleRightImageWithInterval:(CGFloat)interval;

/** 调整为图片在上文案在下  */
- (void)adjustToTopImageBottomTitleWithInterval:(CGFloat)interval;

/** 图片文案均居中显示 */
- (void)adjustToImageTitleCenter;

/** 文案左对齐图片右对齐显示 */
- (void)adjustToEdgeLeftTitleEdgeRightImage;



/** 自定义调整图片及文案位置及间隔 */
- (void)adjustButtonInsetsWithAdjustStyle:(AdjustInsetsStyle)adjustStyle interval:(CGFloat)interval;

@end

NS_ASSUME_NONNULL_END
