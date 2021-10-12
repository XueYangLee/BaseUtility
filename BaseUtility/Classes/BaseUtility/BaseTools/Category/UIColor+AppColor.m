//
//  UIColor+AppColor.m
//  BaseTools
//
//  Created by Singularity on 2020/10/27.
//  Copyright © 2020 Singularity. All rights reserved.
//

#import "UIColor+AppColor.h"
#import "UIColor+Extensions.h"

@implementation UIColor (AppColor)

+ (UIColor *)app_mainColor{
    return [UIColor colorWithHexString:@"#1825AA"];
}

+ (UIColor *)app_subMainColor{
    return [UIColor colorWithHexString:@"#F7BC32"];
}

+ (UIColor *)app_titleColor{
    return [UIColor colorWithHexString:@"#1D1D1F"];
}

+ (UIColor *)app_subTitleColor{
    return [UIColor colorWithHexString:@"#86868B"];
}

+ (UIColor *)app_backgroundColor{
    return [UIColor colorWithHexString:@"#F7F8FA"];
}

+ (UIColor *)app_lightBackgroundColor{
    return [UIColor colorWithHexString:@"#FAFAFA"];
}

+ (UIColor *)app_lineColor{
    return [UIColor colorWithHexString:@"#EDEDED"];
}

+ (UIColor *)app_redColor{
    return [UIColor colorWithHexString:@"#FF3B30"];
}

@end
