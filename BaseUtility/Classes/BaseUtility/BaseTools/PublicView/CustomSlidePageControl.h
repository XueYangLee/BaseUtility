//
//  CustomSlidePageControl.h
//  Doctor
//
//  Created by 李雪阳 on 2021/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomSlidePageControl : UIView

/** scrollViewDidScroll: 调用scrollView */
@property (nonatomic,strong) UIScrollView *didScroll;

/** 当前焦点颜色 */
@property (nonatomic,strong) UIColor *currentPageIndicatorTintColor;
/** pageControl背景色 */
@property (nonatomic,strong) UIColor *pageIndicatorTintColor;

@end

NS_ASSUME_NONNULL_END
