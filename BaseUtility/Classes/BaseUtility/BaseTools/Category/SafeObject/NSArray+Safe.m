//
//  NSArray+Safe.m
//  BaseTools
//
//  Created by XueYangLee on 2020/6/29.
//  Copyright © 2020 Singularity. All rights reserved.
//

#import "NSArray+Safe.h"
#import "NSObject+SwizzleMethod.h"

@implementation NSArray (Safe)

+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{//保证方法替换只被执行一次
        
        /** objectAtIndex */
        [self swizzleInstanceMethodWithClass:NSClassFromString(@"__NSArray0") originalSEL:@selector(objectAtIndex:) swizzleNewSEL:@selector(safe_empty_objectAtIndex:)];//空数组情况
        [self swizzleInstanceMethodWithClass:NSClassFromString(@"__NSArrayI") originalSEL:@selector(objectAtIndex:) swizzleNewSEL:@selector(safe_objectAtIndex:)];//正常数组情况
        [self swizzleInstanceMethodWithClass:NSClassFromString(@"__NSSingleObjectArrayI") originalSEL:@selector(objectAtIndex:) swizzleNewSEL:@selector(safe_single_objectAtIndex:)];//数组只存在一个值的情况
        
        /** objectAtIndexedSubscript */
        [self swizzleInstanceMethodWithClass:NSClassFromString(@"__NSArrayI") originalSEL:@selector(objectAtIndexedSubscript:) swizzleNewSEL:@selector(safe_objectAtIndexedSubscript:)];
        
    });
}

- (id)safe_empty_objectAtIndex:(NSUInteger)index{
    if (index >= self.count || !self.count){
        return nil;
    }
    return [self safe_empty_objectAtIndex:index];
}

- (id)safe_objectAtIndex:(NSUInteger)index{
    if (index >= self.count || !self.count){
        return nil;
    }
    return [self safe_objectAtIndex:index];
}

- (id)safe_single_objectAtIndex:(NSUInteger)index{
    if (index >= self.count || !self.count){
        return nil;
    }
    return [self safe_single_objectAtIndex:index];
}

- (id)safe_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx >= self.count || !self.count){
        return nil;
    }
    return [self safe_objectAtIndexedSubscript:idx];
}

@end
