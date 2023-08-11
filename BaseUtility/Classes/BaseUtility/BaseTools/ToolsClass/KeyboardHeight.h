//
//  KeyboardHeight.h
//  Doctor
//
//  Created by 李雪阳 on 2022/7/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyboardHeight : NSObject

/// 键盘弹出收起的高度变化
/// @param comp 键盘高度结果返回
+ (void)keyboardHeightChanged:(void(^__nullable)(BOOL show, CGFloat height, CGFloat duration))comp;

@end

NS_ASSUME_NONNULL_END
