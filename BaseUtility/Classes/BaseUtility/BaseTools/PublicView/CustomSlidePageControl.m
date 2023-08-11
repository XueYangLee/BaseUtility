//
//  CustomSlidePageControl.m
//  Doctor
//
//  Created by 李雪阳 on 2021/12/9.
//

#import "CustomSlidePageControl.h"
#import "UtilityMacro.h"
#import "UtilityCategoryHeader.h"
#import <FuncControl/FuncChains.h>
#import <Masonry/Masonry.h>

@interface CustomSlidePageControl ()

@property (nonatomic,strong) UIView *slidePageView;

@end

@implementation CustomSlidePageControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.cornerRadius=self.height/2;
        self.backgroundColor=UIColor.app_backgroundColor;
        
        _slidePageView=[UIView new].func_frame(CGRectMake(0, 0, self.width/2, self.height)).func_backgroundColor(UIColor.app_mainColor);
        _slidePageView.cornerRadius=self.height/2;
        [self addSubview:_slidePageView];
    }
    return self;
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor{
    _slidePageView.func_backgroundColor(currentPageIndicatorTintColor);
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor{
    self.backgroundColor=pageIndicatorTintColor;
}


- (void)setDidScroll:(UIScrollView *)didScroll{
    @weakify(self)
    [UIView animateWithDuration:0.25 animations:^{
        @strongify(self)
        CGPoint offset =  didScroll.contentOffset;
        
        // scrollView的当前位移/scrollView的总位移=滑块的当前位移/滑块的总位移
        //        offset/(scrollView.contentSize.width-scrollView.frame.size.width)=滑块的位移/(slideBackView.frame.size.width-sliderView.frame.size.width)
        //        滑块距离屏幕左边的距离加上滑块的当前位移，即为滑块当前的x
        
        CGRect frame=self.slidePageView.frame;
        
        frame.origin.x=offset.x*(self.frame.size.width-self.slidePageView.frame.size.width)/(didScroll.contentSize.width-didScroll.frame.size.width);
        
        self.slidePageView.frame = frame;
    }];
}

@end
