//
//  UIView+CustomCornerBorder.h
//  BaseTools
//
//  Created by Singularity on 2020/4/28.
//  Copyright © 2020 Singularity. All rights reserved.
//
/**  加边框模式  addSubLayer */

#import <UIKit/UIKit.h>

typedef NS_OPTIONS (NSUInteger, CornerBorderType) {
    BorderTypeNone = 0,
    BorderTypeTopLeft     = 1 << 0,
    BorderTypeTopRight    = 1 << 1,
    BorderTypeBottomLeft  = 1 << 2,
    BorderTypeBottomRight = 1 << 3,
    BorderTypeAllCorners  = 1 << 4
};

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CustomCornerBorder)


/**是否启动加边框  defualt NO  -- tip：加边框 CornerBorder*/
@property(nonatomic, assign) BOOL corner_openBorder;
/**边框圆角大小 -- tip：加边框 CornerBorder*/
@property(nonatomic, assign) CGFloat corner_borderRadius;
/**边框圆角颜色  -- tip：加边框 CornerBorder*/
@property(nonatomic, strong) UIColor *corner_borderColor;
/**填充颜色  -- tip：加边框 CornerBorder*/
@property(nonatomic, strong) UIColor *corner_borderFillColor;
/**边框宽度  -- tip：加边框 CornerBorder*/
@property(nonatomic, assign) CGFloat corner_borderWidth;
/**边框圆角类型  -- tip：加边框 CornerBorder*/
@property(nonatomic, assign) CornerBorderType corner_borderType;

/**此分类重写view的layoutsubviews，进行切割圆角
 当视图显示出来后，如果视图frame没有变化或者没有添加子视图等，不触发layoutsubviews方法，
 所以后续再进行的圆角设置会不起作用（复用cell除外，复用时会再次调用layoutsubviews），
 此时为了生效可调用forceClip;
 */
- (void)corner_forceReLayout;

@end

NS_ASSUME_NONNULL_END
