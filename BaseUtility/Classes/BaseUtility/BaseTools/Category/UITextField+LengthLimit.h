//
//  UITextField+LengthLimit.h
//  BaseTools
//
//  Created by Singularity on 2019/4/17.
//  Copyright © 2019 Singularity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (LengthLimit)



/**
 输入文字长度限制

 @param length 限制的长度
 */
- (void)setMaxLength:(int)length;

/**
 *  UITextField 抖动效果
 */
- (void)shake;

@end

NS_ASSUME_NONNULL_END
