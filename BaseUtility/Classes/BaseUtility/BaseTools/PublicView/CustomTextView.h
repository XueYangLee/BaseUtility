//
//  CustomTextView.h
//  moneyhll
//
//  Created by 李雪阳 on 16/10/29.
//  Copyright © 2016年 浙江龙之游旅游开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomTextViewDelegate <NSObject>

- (void)customTextViewDidChange:(UITextView *)textView;

- (void)customTextViewShouldReturn:(UITextView *)textView;

- (BOOL)customTextView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

- (void)customTextViewDidBeginEditing:(UITextView *)textView;

- (void)customTextViewDidEndEditing:(UITextView *)textView;

@end


@interface CustomTextView : UITextView<UITextViewDelegate>

/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
/** 最大字数 默认200 */
@property (nonatomic,assign) NSInteger maxNumber;


@property (nonatomic,weak) id<CustomTextViewDelegate>textViewDelegate;

@property (nonatomic,copy) void(^textChanged)(NSString *text);

@end
