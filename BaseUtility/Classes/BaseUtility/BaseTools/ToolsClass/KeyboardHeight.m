//
//  KeyboardHeight.m
//  Doctor
//
//  Created by 李雪阳 on 2022/7/29.
//

#import "KeyboardHeight.h"
#import "UtilityMacro.h"
#import <ReactiveObjC/ReactiveObjC.h>

@implementation KeyboardHeight

+ (void)keyboardHeightChanged:(void(^__nullable)(BOOL show, CGFloat height, CGFloat duration))comp{
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        
        NSDictionary *userInfo = [x userInfo];
        NSValue *value =  [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGSize keyboardSize = [value CGRectValue].size;
        CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        
        comp?comp(YES, keyboardSize.height, duration):nil;
    }];
    
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        
        CGFloat duration = [[[x userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        
        comp?comp(NO, 0, duration):nil;
    }];
}

@end
