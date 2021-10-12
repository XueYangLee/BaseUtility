//
//  BaseAlertView.m
//  BaseTools
//
//  Created by Singularity on 2020/8/20.
//  Copyright © 2020 Singularity. All rights reserved.
//

#import "BaseAlertView.h"
#import "UtilityMacro.h"
#import "UtilityCategoryHeader.h"

@implementation BaseAlertView

- (instancetype)init{
    self=[super init];
    if (self) {
        self.frame=[[UIScreen mainScreen]bounds];
        self.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.4];
        
        _bkView=[[UIView alloc]init];
        _bkView.size=CGSizeMake(SCREEN_WIDTH-90, 330);
        _bkView.center=self.center;
        _bkView.cornerRadius=6;
        _bkView.backgroundColor=[UIColor whiteColor];
        [self addSubview:_bkView];
        
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
}

- (void)show {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    _bkView.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
    _bkView.alpha = 0;
    
    [self showHandle];
    
    [UIView animateWithDuration:0.7f delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.bkView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        self.bkView.alpha = 1.0;
    } completion:nil];
}

- (void)showHandle{
    
}

- (void)dismiss {
    [self dismissHandle];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.bkView.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
        self.bkView.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.bkView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)dismissHandle{
    
}

@end
