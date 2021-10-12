//
//  UIApplication+Extensions.m
//  Weibo11
//
//  Created by JYJ on 15/12/8.
//  Copyright © 2015年 itheima. All rights reserved.
//

#import "UIApplication+Extensions.h"
#import "UIScreen+Extension.h"

@implementation UIApplication (Extensions)

+ (id)appDelegate {
    return [UIApplication sharedApplication].delegate;
}


+ (UIImage *)launchImage {
    UIImage *image = nil;
    NSArray *launchImages = [NSBundle mainBundle].infoDictionary[@"UILaunchImages"];
    
    for (NSDictionary *dict in launchImages) {
        // 1. 将字符串转换成尺寸
        CGSize size = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        // 2. 与当前屏幕进行比较
        if (CGSizeEqualToSize(size, [UIScreen scrnSize])) {
            NSString *filename = dict[@"UILaunchImageName"];
            image = [UIImage imageNamed:filename];
            
            break;
        }
    }
    return image;
}

@end
