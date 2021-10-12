//
//  UITextField+LengthLimit.m
//  BaseTools
//
//  Created by Singularity on 2019/4/17.
//  Copyright © 2019 Singularity. All rights reserved.
//

#import "UITextField+LengthLimit.h"
#import <objc/objc.h>
#import <objc/runtime.h>

@implementation UITextField (LengthLimit)

static NSString *kLimitTextLengthKey = @"kLimitTextLengthKey";

- (void)setMaxLength:(int)length {
    objc_setAssociatedObject(self, (__bridge const void *)(kLimitTextLengthKey), [NSNumber numberWithInt:length], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addTarget:self action:@selector(textFieldMaxLengthLimit:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldMaxLengthLimit:(id)textField {
    NSNumber *lengthNumber = objc_getAssociatedObject(self, (__bridge const void *)(kLimitTextLengthKey));
    int maxLength = [lengthNumber intValue];
    
    
    if(textField == self) {
        if (maxLength > 0) {
            
            NSString *toBeString = self.text;
            
            //获取高亮部分
            UITextRange *selectedRange = [textField markedTextRange];
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            if (!position || !selectedRange)
            {
                if (toBeString.length > maxLength)
                {
                    NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLength];
                    if (rangeIndex.length == 1)
                    {
                        self.text = [toBeString substringToIndex:maxLength];
                    }
                    else
                    {
                        NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                        self.text = [toBeString substringWithRange:rangeRange];
                    }
                    //                [self shake];
                }
            }
            
        }
    }
    
}

//文字抖动
- (void)shake {
    CAKeyframeAnimation *keyAn = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [keyAn setDuration:0.5f];
    NSArray *array = [[NSArray alloc] initWithObjects:
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      nil];
    [keyAn setValues:array];
    
    NSArray *times = [[NSArray alloc] initWithObjects:
                      [NSNumber numberWithFloat:0.1f],
                      [NSNumber numberWithFloat:0.2f],
                      [NSNumber numberWithFloat:0.3f],
                      [NSNumber numberWithFloat:0.4f],
                      [NSNumber numberWithFloat:0.5f],
                      [NSNumber numberWithFloat:0.6f],
                      [NSNumber numberWithFloat:0.7f],
                      [NSNumber numberWithFloat:0.8f],
                      [NSNumber numberWithFloat:0.9f],
                      [NSNumber numberWithFloat:1.0f],
                      nil];
    [keyAn setKeyTimes:times];
    
    [self.layer addAnimation:keyAn forKey:@"TextAnim"];
}

@end
