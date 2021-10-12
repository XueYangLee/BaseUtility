//
//  UtilityModule.m
//  BaseUtility
//
//  Created by 李雪阳 on 2021/10/12.
//

#import "UtilityModule.h"

@implementation UtilityModule

+ (NSBundle *)bundle{
    //TODO:注意Bundle名字需跟模块名称一致，否则会找不到path，直接Crash
    return [self.class bundleWithName:@"BaseUtility"];
}

@end
