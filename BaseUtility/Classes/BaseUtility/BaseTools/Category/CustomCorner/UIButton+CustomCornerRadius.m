//
//  UIButton+CustomCornerRadius.m
//  BaseTools
//
//  Created by Singularity on 2020/9/23.
//  Copyright © 2020 Singularity. All rights reserved.
//

#import "UIButton+CustomCornerRadius.h"
#import <objc/runtime.h>

@interface UIView ()
// 私有使用
@property(nonatomic, strong) CAShapeLayer *maskLayer;
/**圆角状态是否变化*/
@property(nonatomic, assign) BOOL radiusStatusChange;
@end



@implementation UIButton (CustomCornerRadius)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class targetClass = [self class];
        SEL originalSelector = @selector(layoutSubviews);
        SEL swizzledSelector = @selector(btnSwizzle_layoutSubviews);
        [self corner_swizzleMethod:targetClass orgSel:originalSelector swizzSel:swizzledSelector];
    });
}

+ (void)corner_swizzleMethod:(Class)class orgSel:(SEL)originalSelector swizzSel:(SEL)swizzledSelector {
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    IMP swizzledImp = method_getImplementation(swizzledMethod);
    char *swizzledTypes = (char *)method_getTypeEncoding(swizzledMethod);
    
    IMP originalImp = method_getImplementation(originalMethod);
    char *originalTypes = (char *)method_getTypeEncoding(originalMethod);
    
    BOOL success = class_addMethod(class, originalSelector, swizzledImp, swizzledTypes);
    if (success) {
        class_replaceMethod(class, swizzledSelector, originalImp, originalTypes);
    }else {
        // 添加失败，表明已经有这个方法，直接交换
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


- (void)corner_forceClip {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)btnSwizzle_layoutSubviews {
    [self btnSwizzle_layoutSubviews];
    if (self.corner_openClip) {
//        if (self.radiusStatusChange == NO) return;
        self.radiusStatusChange = NO;
        if (self.corner_clipType == BtnCornerClipTypeNone) {
            self.layer.mask = nil;
        } else {
            UIRectCorner rectCorner = [self getRectCorner];
            if (self.maskLayer == nil) {
                self.maskLayer = [[CAShapeLayer alloc] init];
            }
            
            UIBezierPath *maskPath;
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(self.corner_radius, self.corner_radius)];
            self.maskLayer.frame = self.bounds;
            self.maskLayer.path = maskPath.CGPath;
            self.layer.mask = self.maskLayer;
        }
    }
}

- (UIRectCorner)getRectCorner {
    UIRectCorner rectCorner = 0;
    if (self.corner_clipType & BtnCornerClipTypeAllCorners) {
        rectCorner = UIRectCornerAllCorners;
    } else {
        if (self.corner_clipType & BtnCornerClipTypeTopLeft) {
            rectCorner = rectCorner | UIRectCornerTopLeft;
        }
        if (self.corner_clipType & BtnCornerClipTypeTopRight) {
            rectCorner = rectCorner | UIRectCornerTopRight;
        }
        if (self.corner_clipType & BtnCornerClipTypeBottomLeft) {
            rectCorner = rectCorner | UIRectCornerBottomLeft;
        }
        if (self.corner_clipType & BtnCornerClipTypeBottomRight) {
            rectCorner = rectCorner | UIRectCornerBottomRight;
        }
    }
    return rectCorner;
}

#pragma mark - 添加属性
static const char *cornerRadius_openKey = "cornerRadius_openKey";
- (void)setCorner_openClip:(BOOL)corner_openClip {
    objc_setAssociatedObject(self, cornerRadius_openKey, @(corner_openClip), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)corner_openClip {
    return [objc_getAssociatedObject(self, cornerRadius_openKey) boolValue];
}

static const char *cornerRadius_radiusKey = "CornerRadius_radius";
- (void)setCorner_radius:(CGFloat)corner_radius {
    if (corner_radius == self.corner_radius) {
    } else {
        self.radiusStatusChange = YES;
    }
     objc_setAssociatedObject(self, cornerRadius_radiusKey, @(corner_radius), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)corner_radius {
      return [objc_getAssociatedObject(self, cornerRadius_radiusKey) floatValue];
}

static const char *cornerRadius_TypeKey = "cornerRadius_TypeKey";
- (void)setCorner_clipType:(BtnCornerClipType)corner_clipType {
    if (corner_clipType == self.corner_clipType) {
    } else {
        self.radiusStatusChange = YES;
    }
    objc_setAssociatedObject(self, cornerRadius_TypeKey, @(corner_clipType), OBJC_ASSOCIATION_RETAIN);
}

- (BtnCornerClipType)corner_clipType {
    return [objc_getAssociatedObject(self, cornerRadius_TypeKey) unsignedIntegerValue];
}

static const char *cornerRadius_maskLayerKey = "cornerRadius_maskLayerKey";
- (void)setMaskLayer:(CAShapeLayer *)maskLayer {
    objc_setAssociatedObject(self, cornerRadius_maskLayerKey, maskLayer, OBJC_ASSOCIATION_RETAIN);
}

- (CAShapeLayer *)maskLayer {
    return objc_getAssociatedObject(self, cornerRadius_maskLayerKey);
}

static const char *cornerRadius_StatusKey = "cornerRadius_StatusKey";
- (void)setRadiusStatusChange:(BOOL)radiusStatusChange {
    objc_setAssociatedObject(self, cornerRadius_StatusKey, @(radiusStatusChange), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)radiusStatusChange {
    return [objc_getAssociatedObject(self, cornerRadius_StatusKey) boolValue];
}

@end
