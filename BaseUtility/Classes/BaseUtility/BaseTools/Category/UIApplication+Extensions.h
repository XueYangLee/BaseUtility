//
//  UIApplication+Extensions.h
//  Weibo11
//
//  Created by JYJ on 15/12/8.
//  Copyright © 2015年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Extensions)

/**
* 返回应用程序代理
*/
+ (id)appDelegate;


/**
 *  返回当前设备对应的启动图片
 */
+ (UIImage *)launchImage;

@end
