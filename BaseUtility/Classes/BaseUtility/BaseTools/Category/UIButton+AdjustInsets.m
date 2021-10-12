//
//  UIButton+AdjustInsets.m
//  Now
//
//  Created by 李雪阳 on 2020/6/11.
//  Copyright © 2020 iMoblife. All rights reserved.
//

#import "UIButton+AdjustInsets.h"

@implementation UIButton (AdjustInsets)


- (void)addImageTitleInterval:(CGFloat)interval{
    self.imageEdgeInsets = UIEdgeInsetsMake(0, -interval/2.0, 0, interval/2.0);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, interval/2.0, 0, -interval/2.0);
}

- (void)adjustToLeftTitleRightImageWithInterval:(CGFloat)interval{
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.image.size.width-interval, 0, self.imageView.image.size.width)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.frame.size.width, 0, -self.titleLabel.frame.size.width-interval)];
}


- (void)adjustToTopImageBottomTitleWithInterval:(CGFloat)interval{
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.frame.size.width, -self.imageView.frame.size.height-interval, 0);
    self.imageEdgeInsets = UIEdgeInsetsMake(-self.titleLabel.frame.size.height-interval, 0, 0, -self.titleLabel.frame.size.width);
}


- (void)adjustToImageTitleCenter{
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.frame.size.width, 0, 0);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -self.titleLabel.frame.size.width);
}


- (void)adjustToEdgeLeftTitleEdgeRightImage{
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.frame.size.width-self.frame.size.width+self.titleLabel.frame.size.width, 0, 0);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -self.titleLabel.frame.size.width-self.frame.size.width+self.imageView.frame.size.width);
}



/**
 *  知识点：titleEdgeInsets是title相对于其上下左右的inset，跟tableView的contentInset是类似的，
 *  如果只有title，那它上下左右都是相对于button的，image也是一样；
 *  如果同时有image和label，那这时候image的上左下是相对于button，右边是相对于label的；title的上右下是相对于button，左边是相对于image的。
 */

- (void)adjustButtonInsetsWithAdjustStyle:(AdjustInsetsStyle)style interval:(CGFloat)interval {
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
    // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    switch (style) {
        case AdjustLeftImageRightTitle://图片在左 文案在右
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -interval/2.0, 0, interval/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, interval/2.0, 0, -interval/2.0);
        }
            break;
        case AdjustLeftTitleRightImage://文案在左 图片在右
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+interval/2.0, 0, -labelWidth-interval/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-interval/2.0, 0, imageWith+interval/2.0);
        }
            break;
        case AdjustTopImageBottomTitle://图片在上 文案在下
        {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-interval/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-interval/2.0, 0);
        }
            break;
        case AdjustTopTitleBottomImage://文案在上 图片在下
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-interval/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-interval/2.0, -imageWith, 0, 0);
        }
            break;
        
        default:
            break;
    }
    
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}



@end
