//
//  UITableViewCell+ContentViewDispose.m
//  Now
//
//  Created by Singularity on 2020/10/9.
//  Copyright © 2020 iMoblife. All rights reserved.
//

#import "UITableViewCell+ContentViewDispose.h"
#import "NSObject+SwizzleMethod.h"

@implementation UITableViewCell (ContentViewDispose)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{//保证方法替换只被执行一次

        [self swizzleInstanceMethodWithOriginalSEL:@selector(addSubview:) swizzleNewSEL:@selector(swizzle_addSubview:)];
    });
}

- (void)swizzle_addSubview:(UIView *)view{
    if ([view isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]) {
        [self swizzle_addSubview:view];
    }else{
        [self.contentView addSubview:view];
    }
}

@end
