//
//  CustomBtn.m
//  LZY_HD
//
//  Created by 李雪阳 on 16/9/8.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "CustomBtn.h"

#define kImageRatio 0.5

@implementation CustomBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        [self.imageView setContentMode:UIViewContentModeCenter];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.titleLabel setFont:[UIFont systemFontOfSize:12]];
    }
    return self;
}


- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGFloat x = 0;
    CGFloat y = 15;
    CGFloat height = self.bounds.size.height * kImageRatio;
    CGFloat width = self.bounds.size.width;
    
    
    return CGRectMake(x, y, width, height);
    
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    CGFloat x = 0;
    CGFloat y = self.bounds.size.height * kImageRatio;
    CGFloat height = self.bounds.size.height * (1 - kImageRatio);
    CGFloat width = self.bounds.size.width;
    
    return CGRectMake(x, y, width, height);
}
@end
