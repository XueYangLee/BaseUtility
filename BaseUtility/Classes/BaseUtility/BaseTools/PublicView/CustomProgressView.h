//
//  CustomProgressView.h
//  WeiGuGlobal
//
//  Created by Singularity on 2019/6/11.
//  Copyright © 2019 com.chuang.global. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomProgressView : UIView

/** 进度  区间  0-1  默认0 */
@property (nonatomic, assign) float progress;

/** 已加载部分颜色 */
@property (nonatomic, strong, nullable) UIColor *progressTintColor;

/** 未加载部分的颜色 */
@property (nonatomic, strong, nullable) UIColor *trackTintColor;

/// An image to use for the portion of the progress bar that is filled. If you provide a custom image, the progressTintColor property is ignored.
@property (nonatomic, strong, nullable) UIImage *progressImage;

/// An image to use for the portion of the track that is not filled. If you provide a custom image, the trackTintColor property is ignored.
@property (nonatomic, strong, nullable) UIImage *trackImage;

@property (nonatomic, strong, nullable) NSString *text; // default is nil.
@property (nonatomic, strong, nullable) UIColor *textColor; // default is white color.
@property (nonatomic, strong, nullable) UIFont  *font; // default is system font 17.0.
@property (nonatomic, assign) NSTextAlignment textAlignment; // default is left.

/** 是否带有圆弧角 */
@property (nonatomic, assign) BOOL roundedCorner;

/// The animation duration when call `setProgress:animated:` method and set animated parameter value to YES. Default value is 1/4s.
@property (nonatomic, assign) CFTimeInterval animationDuration;

/// Adjusts the current progress shown by the receiver, optionally animating the change.
- (void)setProgress:(float)progress animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
