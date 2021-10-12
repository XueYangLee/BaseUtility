//
//  XHStarRateView.h
//  XHStarRateView
//
//  Created by 江欣华 on 16/4/1.
//  Copyright © 2016年 jxh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHStarRateView;

typedef void(^finishBlock)(CGFloat currentScore);

typedef NS_ENUM(NSInteger, StarRateStyle)
{
    WholeStar = 0, //只能整星评论
    HalfStar = 1,  //允许半星评论
    IncompleteStar = 2  //允许不完整星评论
};

@protocol XHStarRateViewDelegate <NSObject>

-(void)starRateView:(XHStarRateView *)starRateView currentScore:(CGFloat)currentScore;

@end

@interface XHStarRateView : UIView

/** 是否动画显示，默认NO */
@property (nonatomic,assign) BOOL isAnimation;
/** 评分样式    默认是WholeStar */
@property (nonatomic,assign) StarRateStyle rateStyle;
/** 当前评分：0-5  默认0 */
@property (nonatomic,assign) CGFloat currentScore;

/** 是否允许评分  默认不允许 */
@property (nonatomic,assign) BOOL canScore;

@property (nonatomic, weak) id<XHStarRateViewDelegate>delegate;


-(instancetype)initWithFrame:(CGRect)frame;
-(instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(StarRateStyle)rateStyle isAnination:(BOOL)isAnimation delegate:(id)delegate;


-(instancetype)initWithFrame:(CGRect)frame finish:(finishBlock)finish;
-(instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(StarRateStyle)rateStyle isAnination:(BOOL)isAnimation finish:(finishBlock)finish;

@end
