//
//  RouteCenter.m
//  BaseTools
//
//  Created by 李雪阳 on 2020/10/27.
//  Copyright © 2020 Singularity. All rights reserved.
//

#import "RouteCenter.h"
#import <objc/runtime.h>
#import "UtilityBaseHeader.h"
#import "UtilityCategoryHeader.h"

typedef NS_ENUM(NSUInteger, RouteEnterIntoMode) {
    RouteEnterIntoModePush,
    RouteEnterIntoModeModal,
    RouteEnterIntoModePresent,
};

static NSString *const RouteFragmentEnterIntoModePushKey = @"push";
static NSString *const RouteFragmentEnterIntoModeModalKey = @"modal";
static NSString *const RouteFragmentEnterIntoModePresentKey = @"present";


@implementation RouteCenter

+ (instancetype)sharedRouter {
    static RouteCenter *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[RouteCenter alloc] init];
    });
    return shareManager;
}

#pragma mark - Public Method - OpenURL
- (BOOL)canOpenURL:(NSURL *)URL {
    if (!URL) {
        return NO;
    }
    
    NSString *scheme = URL.scheme;
    if (!scheme.length) {
        return NO;
    }
    
    NSString *host = URL.host;
    if (!host.length) {
        return NO;
    }
    
    __block BOOL flag = YES;
    
    //优先查找Class
    NSString *reflectStr = [NSString stringWithFormat:@"Router_%@",host];
    
    Class mClass = NSClassFromString(reflectStr);
    
    //selector
    NSArray<NSString *> *pathComponents = URL.pathComponents;
    
    __block NSString *selectorStr;
    
    [pathComponents enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqualToString:@"/"]) {
            selectorStr = obj;
        }
    }];
    
    if (mClass) {
        if (selectorStr) {
            selectorStr = [NSString stringWithFormat:@"Func_%@:",selectorStr];
            
            SEL selector = NSSelectorFromString(selectorStr);
            
            id instance = [[mClass alloc] init];
            
            if (![instance respondsToSelector:selector]) {
                flag = NO;
            }else{
                flag = YES;
            }
        }else{
            flag = NO;
        }
    }
    
    return flag;
}


- (BOOL)openURL:(NSURL *)URL {
    return [self openURL:URL params:nil handler:nil];
}

- (BOOL)openURL:(NSURL *)URL params:(NSDictionary<NSString *, NSString *> *)params {
    return [self openURL:URL params:params handler:nil];
}

- (BOOL)openURL:(NSURL *)URL params:(NSDictionary<NSString *, NSString *> * __nullable)params handler:(void(^ __nullable)(NSString *pathComponentKey, id returnValue))customHandler {
    if (![self canOpenURL:URL]) {
        NSString *errMsg = [NSString stringWithFormat:@"RouterError:[%@]未能正常打开,请检查target服务类在项目中是否存在并可以正常响应action事件.",URL.absoluteString];
        NSAssert(NO, errMsg);
        return NO;
    }
    NSString *host = URL.host;
    
    RouteEnterIntoMode enterMode = RouteEnterIntoModePush;
    if (URL.fragment.length) {
        NSString *fragmentEnterMode = URL.fragment.lowercaseString;
        if ([fragmentEnterMode isEqualToString:RouteFragmentEnterIntoModePresentKey]) {
            enterMode = RouteEnterIntoModePresent;
        }else if ([fragmentEnterMode isEqualToString:RouteFragmentEnterIntoModeModalKey]) {
            enterMode == RouteEnterIntoModeModal;
        }else{
            enterMode = RouteEnterIntoModePush;
        }
    }
    
    //parameters
    NSDictionary<NSString *, NSString *> *queryDic = [self queryParameterFromURL:URL];
    
    //selectorStr
    __block NSString *selectorStr;
    
    NSArray<NSString *> *pathComponents = URL.pathComponents;
    
    [pathComponents enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqualToString:@"/"]) {
            selectorStr = obj;
        }
    }];
    
    //通过Target-Action调用
    NSString *reflectStr = [NSString stringWithFormat:@"Router_%@", host];
    Class mClass = NSClassFromString(reflectStr);;
    selectorStr = [NSString stringWithFormat:@"Func_%@:", selectorStr];
    SEL selector = NSSelectorFromString(selectorStr);
    id instance = [[mClass alloc] init];
    
    NSDictionary<NSString *, id> *finalParams = [self solveURLParams:queryDic withFuncParams:params forClass:mClass];
    
    id returnValue = [self safePerformAction:selector target:instance params:finalParams];
    if (!returnValue) {
        return NO;
    }
    NSString *pathComponentKey = [NSString stringWithFormat:@"%@.%@",reflectStr,selectorStr];
    
    if (enterMode == RouteEnterIntoModePresent) {
        [[UIViewController currentViewController] presentViewController:(UIViewController *)returnValue animated:YES completion:nil];
    }else if (enterMode == RouteEnterIntoModeModal){
        NaviRoutePresentToVC((UIViewController *)returnValue);
    }else{
        NaviRoutePushToVC((UIViewController *)returnValue, YES);
    }
    
    !customHandler?:customHandler(pathComponentKey, returnValue);
    
    return YES;

}

//MARK: - Params Method
///根据URL分解出参数
- (NSDictionary<NSString *, id> *)queryParameterFromURL:(NSURL *)URL {
    if (!URL) {
        return nil;
    }
    
    NSURLComponents *components = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    
    NSArray <NSURLQueryItem *> *queryItems = [components queryItems] ?: @[];
    
    NSMutableDictionary *queryParams = @{}.mutableCopy;
    
    for (NSURLQueryItem *item in queryItems) {
        if (item.value == nil) {
            continue;
        }
        
        if (queryParams[item.name] == nil) {
            queryParams[item.name] = item.value;
        } else if ([queryParams[item.name] isKindOfClass:[NSArray class]]) {
            NSArray *values = (NSArray *)(queryParams[item.name]);
            queryParams[item.name] = [values arrayByAddingObject:item.value];
        } else {
            id existingValue = queryParams[item.name];
            queryParams[item.name] = @[existingValue, item.value];
        }
    }
    
    return queryParams.copy;
}


- (NSDictionary<NSString *, id> *)solveURLParams:(NSDictionary<NSString *, id> *)URLParams withFuncParams:(NSDictionary<NSString *, id> *)funcParams forClass:(Class)mClass {
    if (!URLParams) {
        URLParams = @{};
    }
    NSMutableDictionary<NSString *, id> *params = URLParams.mutableCopy;
    NSArray<NSString *> *funcParamKeys = funcParams.allKeys;
    [funcParamKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [params setObject:funcParams[obj] forKey:obj];
    }];
    
    return params;
}

//MARK: - 远程App调用入口
/*
 scheme://[target]/[action]?[params]
 
 url sample:
 aaa://targetA/actionB?id=1234
 */

- (id)performActionWithUrl:(NSURL *)url completion:(void (^)(NSDictionary *))completion
{
    if (url == nil||![url isKindOfClass:[NSURL class]]) {
        return nil;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url.absoluteString];
    // 遍历所有参数
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.value&&obj.name) {
            [params setObject:obj.value forKey:obj.name];
        }
    }];
    
    // 这里这么写主要是出于安全考虑，防止黑客通过远程方式调用本地模块。这里的做法足以应对绝大多数场景，如果要求更加严苛，也可以做更加复杂的安全逻辑。
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([actionName hasPrefix:@"native"]) {
        return @(NO);
    }
    
    // 这个demo针对URL的路由处理非常简单，就只是取对应的target名字和method名字，但这已经足以应对绝大部份需求。如果需要拓展，可以在这个方法调用之前加入完整的路由逻辑
    id result = [self performRouter:url.host func:actionName params:params];
    if (completion) {
        if (result) {
            completion(@{@"result":result});
        } else {
            completion(nil);
        }
    }
    return result;
}

//MARK: - 本地组件调用入口
- (id)performRouter:(NSString *)routerName func:(NSString *)functionName params:(NSDictionary *)params
{
    if (routerName == nil || functionName == nil) {
        return nil;
    }
    
    // generate target
    NSString *targetClassString = nil;
    targetClassString = [NSString stringWithFormat:@"Router_%@", routerName];
    
    Class targetClass = NSClassFromString(targetClassString);
    NSObject *target = [[targetClass alloc] init];

    // generate action
    NSString *actionString = [NSString stringWithFormat:@"Func_%@:", functionName];
    SEL action = NSSelectorFromString(actionString);
    
    if (target == nil) {
        // 这里是处理无响应请求的地方之一，这个demo做得比较简单，如果没有可以响应的target，就直接return了。实际开发过程中是可以事先给一个固定的target专门用于在这个时候顶上，然后处理这种请求的
        [self NoTargetActionResponseWithTargetString:targetClassString selectorString:actionString originParams:params];
        return nil;
    }
    
    if ([target respondsToSelector:action]) {
        return [self safePerformAction:action target:target params:params];
    } else {
        // 这里是处理无响应请求的地方，如果无响应，则尝试调用对应target的notFound方法统一处理
        SEL action = NSSelectorFromString(@"notFound:");
        if ([target respondsToSelector:action]) {
            return [self safePerformAction:action target:target params:params];
        } else {
            // 这里也是处理无响应请求的地方，在notFound都没有的时候，这个demo是直接return了。实际开发过程中，可以用前面提到的固定的target顶上的。
            [self NoTargetActionResponseWithTargetString:targetClassString selectorString:actionString originParams:params];
            return nil;
        }
    }
}


#pragma mark - private methods
- (void)NoTargetActionResponseWithTargetString:(NSString *)targetString selectorString:(NSString *)selectorString originParams:(NSDictionary *)originParams
{
    
    NSString *errMsg = [NSString stringWithFormat:@"RouterError:项目中未发现%@.", targetString];
    NSAssert(NO, errMsg);
    /*
    SEL action = NSSelectorFromString(@"Action_response:");
    NSObject *target = [[NSClassFromString(@"Target_NoTargetAction") alloc] init];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"originParams"] = originParams;
    params[@"targetString"] = targetString;
    params[@"selectorString"] = selectorString;
    
    [self safePerformAction:action target:target params:params];*/
}

- (id)safePerformAction:(SEL)action target:(NSObject *)target params:(NSDictionary *)params
{
    NSMethodSignature* methodSig = [target methodSignatureForSelector:action];
    if(methodSig == nil) {
        return nil;
    }
    const char* retType = [methodSig methodReturnType];

    if (strcmp(retType, @encode(void)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        return nil;
    }

    if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

    if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

    if (strcmp(retType, @encode(CGFloat)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
}



@end
