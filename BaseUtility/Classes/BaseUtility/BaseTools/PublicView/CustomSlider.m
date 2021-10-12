//
//  CustomSlider.m
//  BaseTools
//
//  Created by Singularity on 2020/5/14.
//  Copyright © 2020 Singularity. All rights reserved.
//增加slider拖动范围

#import "CustomSlider.h"

#define thumbBound_x 40
#define thumbBound_y 40

@implementation CustomSlider {
    CGRect lastBounds;
}

/// 改变滑块的触摸范围
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    CGRect result = [super thumbRectForBounds:bounds trackRect:rect value:value];
    lastBounds = result;
    return result;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *result = [super hitTest:point withEvent:event];
    if (point.x < 0 || point.x > self.bounds.size.width){
        
        return result;
        
    }
    
    if ((point.y >= -thumbBound_y) && (point.y < lastBounds.size.height + thumbBound_y)) {
        float value = 0.0;
        value = point.x - self.bounds.origin.x;
        value = value/self.bounds.size.width;
        
        value = value < 0? 0 : value;
        value = value > 1? 1: value;
        
        value = value * (self.maximumValue - self.minimumValue) + self.minimumValue;
        [self setValue:value animated:YES];
    }
    return result;
    
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    BOOL result = [super pointInside:point withEvent:event];
    if (!result && point.y > -10) {
        if ((point.x >= lastBounds.origin.x - thumbBound_x) && (point.x <= (lastBounds.origin.x + lastBounds.size.width + thumbBound_x)) && (point.y < (lastBounds.size.height + thumbBound_y))) {
            result = YES;
        }
        
    }
    return result;
}

/// 更改滑动条尺寸
- (CGRect)trackRectForBounds:(CGRect)bounds{
    [super trackRectForBounds:bounds];
    
    return CGRectMake(bounds.origin.x, bounds.size.height/2-1, bounds.size.width, 2);
}

@end
