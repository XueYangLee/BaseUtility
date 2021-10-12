//
//  UIButton+CustomCornerRadius.h
//  BaseTools
//
//  Created by Singularity on 2020/9/23.
//  Copyright © 2020 Singularity. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BtnCornerClipTypeTopBoth (BtnCornerClipTypeTopLeft | BtnCornerClipTypeTopRight)
#define BtnCornerClipTypeBottomBoth (BtnCornerClipTypeBottomLeft | BtnCornerClipTypeBottomRight)
#define BtnCornerClipTypeLeftBoth (BtnCornerClipTypeTopLeft | BtnCornerClipTypeBottomLeft)
#define BtnCornerClipTypeRightBoth (BtnCornerClipTypeTopRight | BtnCornerClipTypeBottomRight)

typedef NS_OPTIONS (NSUInteger, BtnCornerClipType) {
    BtnCornerClipTypeNone = 0,  //不切
    BtnCornerClipTypeTopLeft     = 1 << 0,
    BtnCornerClipTypeTopRight    = 1 << 1,
    BtnCornerClipTypeBottomLeft  = 1 << 2,
    BtnCornerClipTypeBottomRight = 1 << 3,
    BtnCornerClipTypeAllCorners  = 1 << 4
};

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (CustomCornerRadius)

/**针对这个view 切圆角工具是否可用  defualt NO  tip：开启后后清除圆角使用 corner_clipType =BtnCornerClipTypeNone */
@property(nonatomic, assign) BOOL corner_openClip;
/**圆角大小 -- tip：切圆角 BtnCornerClipType*/
@property(nonatomic, assign) CGFloat corner_radius;
/**圆角类型 -- tip：切圆角 BtnCornerClipType*/
@property(nonatomic, assign) BtnCornerClipType corner_clipType;

/**此分类重写view的layoutsubviews，进行切割圆角
    当视图显示出来后，如果视图frame没有变化或者没有添加子视图等，不触发layoutsubviews方法，
    所以后续再进行的圆角设置会不起作用（复用cell除外，复用时会再次调用layoutsubviews），
    此时为了圆角生效可调用forceClip;
 */
- (void)corner_forceClip;

@end

NS_ASSUME_NONNULL_END
