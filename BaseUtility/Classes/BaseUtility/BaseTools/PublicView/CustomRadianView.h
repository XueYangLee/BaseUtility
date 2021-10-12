//
//  CustomRadianView.h
//  WeiGuGlobal
//
//  Created by 李雪阳 on 2019/7/25.
//  Copyright © 2019 com.chuang.global. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CustomRadianDirection) {
    CustomRadianDirectionBottom     = 0,
    CustomRadianDirectionTop        = 1,
    CustomRadianDirectionLeft       = 2,
    CustomRadianDirectionRight      = 3,
};

@interface CustomRadianView : UIView

/** 圆弧方向, 默认在下方 */
@property (nonatomic) CustomRadianDirection direction;

/** 圆弧高/宽, 可为负值。 正值凸, 负值凹 */
@property (nonatomic) CGFloat radian;

@end

NS_ASSUME_NONNULL_END
