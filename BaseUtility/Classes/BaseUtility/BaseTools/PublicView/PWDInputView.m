//
//  PWDInputView.m
//  WeiGuGlobal
//
//  Created by 李雪阳 on 2019/3/25.
//  Copyright © 2019 com.chuang.global. All rights reserved.
//

#import "PWDInputView.h"
#import "UtilityCategoryHeader.h"

@interface PWDInputView ()<UITextFieldDelegate>

@property (nonatomic,strong) NSMutableArray *pwdDotArray;

@end

#define PWD_COUNT  6

@implementation PWDInputView

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.borderColor=[UIColor colorWithHexString:@"9b9b9b"];
        self.borderWidth=0.5;
        
        [self setUI];
        [_pwdTextField becomeFirstResponder];
    }
    return self;
}

- (void)setUI{
    _pwdTextField=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _pwdTextField.hidden = YES;
    _pwdTextField.secureTextEntry = YES;//密码模式
    _pwdTextField.delegate = self;
    _pwdTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_pwdTextField];
    
    
    CGFloat width = self.width/PWD_COUNT;
    for (int i = 0; i < PWD_COUNT; i ++)
    {
        UILabel *dot = [[UILabel alloc]initWithFrame:CGRectMake((width-10)/2 + i*width, (self.height-10)/2, 10, 10)];//中心点位置
        dot.backgroundColor = [UIColor colorWithHexString:@"666666"];
        dot.layer.cornerRadius = 5;
        dot.layer.masksToBounds=YES;
        dot.clipsToBounds = YES;//超出部分隐藏
        dot.hidden = YES;
        [self addSubview:dot];
        [self.pwdDotArray addObject:dot];
        
        if (i == PWD_COUNT-1){
            continue;
        }
        
        UILabel *segLine = [[UILabel alloc]initWithFrame:CGRectMake((i+1)*width, 0, 0.5, self.height)];
        segLine.backgroundColor = [UIColor colorWithHexString:@"9b9b9b"];
        [self addSubview:segLine];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.text.length >= 6 && string.length) {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        return NO;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]*$"];
    if (![predicate evaluateWithObject:string]) {
        return NO;
    }
    NSString *pwdTotalStr;
    if (string.length <= 0) {
        pwdTotalStr = [textField.text substringToIndex:textField.text.length-1];
    }
    else {
        pwdTotalStr = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    [self setDotWithCount:pwdTotalStr.length];
    
    
//        DLog(@"_____total %@",pwdTotalStr);
    
    if (pwdTotalStr.length == 6) {//输入完成
        
        if (self.affirmPWD) {
            self.affirmPWD(pwdTotalStr, YES);
        }
        
    }else{
        if (self.affirmPWD) {
            self.affirmPWD(@"", NO);
        }
    }
    
    return YES;
}

- (void)setDotWithCount:(NSInteger)count {
    for (UILabel *dot in _pwdDotArray) {
        dot.hidden = YES;
    }
    
    for (int i = 0; i< count; i++) {
        ((UILabel*)[_pwdDotArray objectAtIndex:i]).hidden = NO;
    }
}



- (NSMutableArray *)pwdDotArray{
    if (_pwdDotArray==nil){
        _pwdDotArray=[NSMutableArray array];
    }
    return _pwdDotArray;
}

- (void)resetInput{
    [self.pwdDotArray removeAllObjects];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setUI];
    [_pwdTextField becomeFirstResponder];
    if (self.affirmPWD) {
        self.affirmPWD(@"", NO);
    }
}

- (void)resignPWDTextResponder{
    [_pwdTextField resignFirstResponder];
}


@end
