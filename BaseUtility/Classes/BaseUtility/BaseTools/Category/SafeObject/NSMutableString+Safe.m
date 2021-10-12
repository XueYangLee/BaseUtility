//
//  NSMutableString+Safe.m
//  BaseTools
//
//  Created by XueYangLee on 2020/6/29.
//  Copyright © 2020 Singularity. All rights reserved.
//

#import "NSMutableString+Safe.h"
#import "NSObject+SwizzleMethod.h"

@implementation NSMutableString (Safe)

+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{//保证方法替换只被执行一次

        /** substringFromIndex */
        [self swizzleInstanceMethodWithClass:NSClassFromString(@"__NSCFString") originalSEL:@selector(substringFromIndex:) swizzleNewSEL:@selector(safe_substringFromIndex:)];
        
        /** substringToIndex */
        [self swizzleInstanceMethodWithClass:NSClassFromString(@"__NSCFString") originalSEL:@selector(substringToIndex:) swizzleNewSEL:@selector(safe_substringToIndex:)];
        
        /** substringWithRange */
        [self swizzleInstanceMethodWithClass:NSClassFromString(@"__NSCFString") originalSEL:@selector(substringWithRange:) swizzleNewSEL:@selector(safe_substringWithRange:)];
        
        /** rangeOfString: options:range: locale: */
        [self swizzleInstanceMethodWithClass:NSClassFromString(@"__NSCFString") originalSEL:@selector(rangeOfString:options:range:locale:) swizzleNewSEL:@selector(safe_rangeOfString:options:range:locale:)];
        
        /** appendString */
        [self swizzleInstanceMethodWithClass:NSClassFromString(@"__NSCFString") originalSEL:@selector(appendString:) swizzleNewSEL:@selector(safe_appendString:)];
        
        /** stringByReplacingCharactersInRange:withString: */
        [self swizzleInstanceMethodWithClass:NSClassFromString(@"__NSCFString") originalSEL:@selector(stringByReplacingCharactersInRange:withString:) swizzleNewSEL:@selector(safe_stringByReplacingCharactersInRange:withString:)];
        
        /** replaceCharactersInRange:withString: */
        [self swizzleInstanceMethodWithClass:NSClassFromString(@"__NSCFString") originalSEL:@selector(replaceCharactersInRange:withString:) swizzleNewSEL:@selector(safe_replaceCharactersInRange:withString:)];
        
        /** insertString:atIndex: */
        [self swizzleInstanceMethodWithClass:NSClassFromString(@"__NSCFString") originalSEL:@selector(insertString:atIndex:) swizzleNewSEL:@selector(safe_insertString:atIndex:)];
        
        /** deleteCharactersInRange: */
        [self swizzleInstanceMethodWithClass:NSClassFromString(@"__NSCFString") originalSEL:@selector(deleteCharactersInRange:) swizzleNewSEL:@selector(safe_deleteCharactersInRange:)];
    });
}


/** 从from位置开始截取字符串  */
- (NSString *)safe_substringFromIndex:(NSUInteger)from {
    if (from > self.length ) {
        return nil;
    }
    return [self safe_substringFromIndex:from];
}

/** 从开始截取到to位置的字符串 */
- (NSString *)safe_substringToIndex:(NSUInteger)to {
    if (to > self.length ) {
        return nil;
    }
    return [self safe_substringToIndex:to];
}

/** 截取指定范围的字符串 */
- (NSString *)safe_substringWithRange:(NSRange)range {
    if (range.location > self.length) {
        return nil;
    }
    
    if (range.length > self.length) {
        return nil;
    }
    
    if ((range.location + range.length) > self.length) {
        return nil;
    }
    return [self safe_substringWithRange:range];
}

/// 搜索指定 字符串
/// @param searchString 指定 字符串
/// @param mask 比较模式
/// @param rangeOfReceiverToSearch 搜索 范围
/// @param locale 本地化
- (NSRange)safe_rangeOfString:(NSString *)searchString options:(NSStringCompareOptions)mask range:(NSRange)rangeOfReceiverToSearch locale:(nullable NSLocale *)locale {
    if (!searchString) {
        searchString = self;
    }
    
    if (rangeOfReceiverToSearch.location > self.length) {
        rangeOfReceiverToSearch = NSMakeRange(0, self.length);
    }
    
    if (rangeOfReceiverToSearch.length > self.length) {
        rangeOfReceiverToSearch = NSMakeRange(0, self.length);
    }
    
    if ((rangeOfReceiverToSearch.location + rangeOfReceiverToSearch.length) > self.length) {
        rangeOfReceiverToSearch = NSMakeRange(0, self.length);
    }
    
    
    return [self safe_rangeOfString:searchString options:mask range:rangeOfReceiverToSearch locale:locale];
}

/** 追加字符串 */
- (void)safe_appendString:(NSString *)aString {
    if (!aString) {
        return;
    }
    return [self safe_appendString:aString];
}

/** 字符串替换 */
- (NSString *)safe_stringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement{
    if (range.location > self.length) {
        return nil;
    }
    
    if (range.length > self.length) {
        return nil;
    }
    
    if ((range.location + range.length) > self.length) {
        return nil;
    }
    
    if (!replacement) {
        return nil;
    }
    return [self safe_stringByReplacingCharactersInRange:range withString:replacement];
}


- (void)safe_replaceCharactersInRange:(NSRange)range withString:(NSString *)aString{
    if (range.location > self.length) {
        return;
    }
    
    if (range.length > self.length) {
        return;
    }
    
    if ((range.location + range.length) > self.length) {
        return;
    }
    
    if (!aString) {
        return;
    }
    
    return [self safe_replaceCharactersInRange:range withString:aString];
}


- (void)safe_insertString:(NSString *)aString atIndex:(NSUInteger)loc{
    if (loc > self.length) {
        return;
    }
    
    if (!aString) {
        return;
    }
    return [self safe_insertString:aString atIndex:loc];
}


- (void)safe_deleteCharactersInRange:(NSRange)range{
    if (range.location > self.length) {
        return;
    }
    
    if (range.length > self.length) {
        return;
    }
    
    if ((range.location + range.length) > self.length) {
        return;
    }
    return [self safe_deleteCharactersInRange:range];
}

@end
