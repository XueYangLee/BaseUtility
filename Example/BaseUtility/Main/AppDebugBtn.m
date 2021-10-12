//
//  AppDebugBtn.m
//  BaseTools
//
//  Created by Singularity on 2020/11/3.
//  Copyright © 2020 Singularity. All rights reserved.
//

#import "AppDebugBtn.h"
#import "NetURLManager.h"

@implementation AppDebugBtn

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.numberOfLines=2;
        [self setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [self setTitle:@"环境\n切换" forState:(UIControlStateNormal)];
        [self addTarget:self action:@selector(debugButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
        [self addGestureRecognizer:panGesture];
    }
    return self;
}


- (void)debugButtonClick{
    NSString *current=@"";
    if ([NetURLManager currentURLMode]==NetURLModeProduct) {
        current=@"当前环境【正式api~正式支付】";
    }else if ([NetURLManager currentURLMode]==NetURLModeDev){
        current=@"当前环境【测试api~测试沙盒】";
    }
    
    [CustomAlert showAlertWithBtnsAddTarget:[UIViewController currentViewController] title:@"切换环境并退出当前登录" message:current cancelBtnTitle:@"取消" otherBtnTitles:@[@"正式api~正式支付",@"测试api~测试沙盒"] actionHandle:^(NSInteger actionIndex, NSString * _Nonnull btnTitle) {
        
        if (actionIndex!=0) {
            
            [NetURLManager updateCurrentDebugURLMode:actionIndex-1];
            DLog(@"%@->buttonTitle\n%ld->actionIndex\n%ld->currentURLMode\n%@->currentHostURL",btnTitle,actionIndex,[NetURLManager currentURLMode],[NetURLManager currentHostURL])
            
            [SVProgressHUD showSuccessWithStatus:btnTitle];
//            [[UserCenter sharedCenter]logout];
        }
    }];
    
}



- (void)move:(UIPanGestureRecognizer *)panGesture {
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        UIView *subview = panGesture.view;
        CGPoint point = [panGesture translationInView:self.superview];
        CGFloat centerX = subview.centerX + point.x;
        CGFloat centerY = subview.centerY + point.y;
        
        CGFloat left = subview.width / 2.0;
        CGFloat right = self.superview.width - subview.width / 2.0;
        CGFloat top = STATUS_NAVI_HEIGHT + subview.height / 2.0;
        CGFloat bottom = self.superview.height - subview.height / 2.0;
        if (centerX < left) centerX = left;
        if (centerX > right) centerX = right;
        if (centerY < top) centerY = top;
        if (centerY > bottom) centerY = bottom;
        
        subview.center = CGPointMake(centerX, centerY);
        [panGesture setTranslation:CGPointZero inView:self.superview];
    }
}

@end
