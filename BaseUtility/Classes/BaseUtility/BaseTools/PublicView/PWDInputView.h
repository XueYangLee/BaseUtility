//
//  PWDInputView.h
//  WeiGuGlobal
//
//  Created by 李雪阳 on 2019/3/25.
//  Copyright © 2019 com.chuang.global. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PWDInputView : UIView

@property (nonatomic,strong) UITextField *pwdTextField;

/**  输入回调  inputPWD 输入的密码   isFinish 输入是否完成  */
@property (nonatomic,copy) void (^affirmPWD)(NSString *inputPWD,BOOL isFinish);

/** 隐藏键盘 */
- (void)resignPWDTextResponder;

/** 重置输入 */
- (void)resetInput;

@end

NS_ASSUME_NONNULL_END
