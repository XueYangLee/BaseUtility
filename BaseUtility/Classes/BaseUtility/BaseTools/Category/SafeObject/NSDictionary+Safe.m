//
//  NSDictionary+Safe.m
//  BaseTools
//
//  Created by XueYangLee on 2020/6/29.
//  Copyright © 2020 Singularity. All rights reserved.
//

#import "NSDictionary+Safe.h"
#import "NSObject+SwizzleMethod.h"

@implementation NSDictionary (Safe)

+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{//保证方法替换只被执行一次

        /** initWithObjects:forKeys:count: */
        [self swizzleInstanceMethodWithClass:NSClassFromString(@"__NSPlaceholderDictionary") originalSEL:@selector(initWithObjects:forKeys:count:) swizzleNewSEL:@selector(initWithSafeObjects:forKeys:count:)];
    });
}

-(instancetype)initWithSafeObjects:(id *)objects forKeys:(id<NSCopying> *)keys count:(NSUInteger)count {
    NSUInteger safeCount = 0;
    for (NSUInteger i = 0; i < count; i++) {
        if (!(keys[i] && objects[i])) {
            break;
        }else{
            safeCount++;
        }
    }
    self = [self initWithSafeObjects:objects forKeys:keys count:safeCount];
    return self;
}

@end
