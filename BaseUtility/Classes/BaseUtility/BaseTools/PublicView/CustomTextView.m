//
//  CustomTextView.m
//  moneyhll
//
//  Created by 李雪阳 on 16/10/29.
//  Copyright © 2016年 浙江龙之游旅游开发有限公司. All rights reserved.
//

#import "CustomTextView.h"

@interface CustomTextView ()

@property (nonatomic,copy) NSString *textStr;

@end


@implementation CustomTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self=[super initWithFrame:frame];
    if (self) {
        [self baseSetup];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self baseSetup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self baseSetup];
}

- (void)baseSetup{
    _maxNumber=200;
    self.layoutManager.allowsNonContiguousLayout=NO;//追加文字上下跳动问题
    
//    self.textContainerInset = UIEdgeInsetsMake(12, 12, 12, 12);//内边距默认12
    self.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.font = [UIFont systemFontOfSize:15];// 设置默认字体
    self.placeholderColor = [UIColor grayColor];// 设置默认颜色
    self.delegate=self;
    // 使用通知监听文字改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    if ([textView.text length] > _maxNumber) {//字数限制
        textView.text = [textView.text substringWithRange:NSMakeRange(0, _maxNumber)];
        [textView.undoManager removeAllActions];/** 为了实现输入的字数限制效果，会通过delegate监听输入框的UIControlEventEditingChanged事件，截取字符串，手动给输入框的text属性赋值。正常情况下输入框自己默认执行setText：，默认不会注册到自己的undoManager上，并且会清空undoManager的undo、redo栈，这样并没有问题。问题是在于监听UIControlEventEditingChanged事件所执行的方法里是先程序代码对输入框的text做截取然后执行setText：，并没有清空undoManager的undo、redo栈。 */
        [textView becomeFirstResponder];
        return;
    }
    
    if (self.textChanged) {
        self.textChanged(textView.text);
    }
    
    if ([self.textViewDelegate respondsToSelector:@selector(customTextViewDidChange:)]) {
        [self.textViewDelegate customTextViewDidChange:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    
    if ([self.textViewDelegate respondsToSelector:@selector(customTextViewShouldReturn:)]) {
        //text为输入中的内容的最后一个字符
        ////判断输入的字是否是回车，即按下【Return】
        if ([text isEqualToString:@"\n"]){
            
            //一般通常也会收键盘，即取消textView的第一响应者
            [self resignFirstResponder];
            [self.textViewDelegate customTextViewShouldReturn:textView];
            /**这里返回NO，就代表【Return】键值失效，即在页面上按下
          【Return】键，不会出现换行，如果为YES，则输入页面会换行*/
            return NO;
        }
    }
    
    if ([self.textViewDelegate respondsToSelector:@selector(customTextView:shouldChangeTextInRange:replacementText:)]) {
        return [self.textViewDelegate customTextView:textView shouldChangeTextInRange:range replacementText:text];
    }

    return YES;
}


- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([self.textViewDelegate respondsToSelector:@selector(customTextViewDidBeginEditing:)]) {
        [self.textViewDelegate customTextViewDidBeginEditing:textView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([self.textViewDelegate respondsToSelector:@selector(customTextViewDidEndEditing:)]) {
        [self.textViewDelegate customTextViewDidEndEditing:textView];
    }
}

- (void)textDidChange:(NSNotification *)note {
    // 会重新调用drawRect:方法
    [self setNeedsDisplay];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 * 每次调用drawRect:方法，都会将以前画的东西清除掉
 */
- (void)drawRect:(CGRect)rect {
    // 如果有文字，就直接返回，不需要画占位文字
    if (self.hasText) return;
    
    // 属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placeholderColor;
    
    /*// 画文字  内边距12
    rect.origin.x = 5 + 12;
    rect.origin.y = 8 + 4;
    rect.size.width -= 2 * (rect.origin.x + 12);*/
    //无内边距12的原始尺寸
     rect.origin.x = 5;
     rect.origin.y = 0;
     rect.size.width -= 2 * rect.origin.x;
    [self.placeholder drawInRect:rect withAttributes:attrs];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setNeedsDisplay];
}

#pragma mark - setter
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = [placeholder copy];
    
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    
    [self setNeedsDisplay];
}

- (void)setMaxNumber:(NSInteger)maxNumber{
    _maxNumber=maxNumber;
    
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    
    [self setNeedsDisplay];
}

@end
