//
//  NSMutableDictionary+Safe.m
//  BaseTools
//
//  Created by XueYangLee on 2020/6/29.
//  Copyright © 2020 Singularity. All rights reserved.
//

#import "NSMutableDictionary+Safe.h"
#import "NSObject+SwizzleMethod.h"

@implementation NSMutableDictionary (Safe)

+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{//保证方法替换只被执行一次

        /** removeObjectForKey */
        [self swizzleInstanceMethodWithClass:NSClassFromString(@"__NSDictionaryM") originalSEL:@selector(removeObjectForKey:) swizzleNewSEL:@selector(safe_removeObjectForKey:)];
        
        /** setObject:forKey: */
        [self swizzleInstanceMethodWithClass:NSClassFromString(@"__NSDictionaryM") originalSEL:@selector(setObject:forKey:) swizzleNewSEL:@selector(safe_setObject:forKey:)];
    });
}

- (void)safe_removeObjectForKey:(id<NSCopying>)aKey {
    if (!aKey) {
        return;
    }
    [self safe_removeObjectForKey:aKey];
}

- (void)safe_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!anObject) {
        return;
    }
    if (!aKey) {
        return;
    }
    return [self safe_setObject:anObject forKey:aKey];
}

@end
