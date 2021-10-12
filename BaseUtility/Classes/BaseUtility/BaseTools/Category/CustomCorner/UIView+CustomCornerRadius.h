//
//  UIView+CustomCornerRadius.h
//  BaseTools
//
//  Created by Singularity on 2020/4/28.
//  Copyright © 2020 Singularity. All rights reserved.
//
/** 切圆角工具 mask */

#import <UIKit/UIKit.h>

#define CornerClipTypeTopBoth (CornerClipTypeTopLeft | CornerClipTypeTopRight)
#define CornerClipTypeBottomBoth (CornerClipTypeBottomLeft | CornerClipTypeBottomRight)
#define CornerClipTypeLeftBoth (CornerClipTypeTopLeft | CornerClipTypeBottomLeft)
#define CornerClipTypeRightBoth (CornerClipTypeTopRight | CornerClipTypeBottomRight)

typedef NS_OPTIONS (NSUInteger, CornerClipType) {
    CornerClipTypeNone = 0,  //不切
    CornerClipTypeTopLeft     = 1 << 0,
    CornerClipTypeTopRight    = 1 << 1,
    CornerClipTypeBottomLeft  = 1 << 2,
    CornerClipTypeBottomRight = 1 << 3,
    CornerClipTypeAllCorners  = 1 << 4
};

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CustomCornerRadius)

/**针对这个view 切圆角工具是否可用  defualt NO  tip：开启后后清除圆角使用 corner_clipType =CornerClipTypeNone */
@property(nonatomic, assign) BOOL corner_openClip;
/**圆角大小 -- tip：切圆角 CornerClipType*/
@property(nonatomic, assign) CGFloat corner_radius;
/**圆角类型 -- tip：切圆角 CornerClipType*/
@property(nonatomic, assign) CornerClipType corner_clipType;

/**此分类重写view的layoutsubviews，进行切割圆角
    当视图显示出来后，如果视图frame没有变化或者没有添加子视图等，不触发layoutsubviews方法，
    所以后续再进行的圆角设置会不起作用（复用cell除外，复用时会再次调用layoutsubviews），
    此时为了圆角生效可调用forceClip;
 */
- (void)corner_forceClip;

@end

NS_ASSUME_NONNULL_END
