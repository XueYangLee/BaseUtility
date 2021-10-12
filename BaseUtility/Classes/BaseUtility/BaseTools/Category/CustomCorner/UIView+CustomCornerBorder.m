//
//  UIView+CustomCornerBorder.m
//  BaseTools
//
//  Created by Singularity on 2020/4/28.
//  Copyright © 2020 Singularity. All rights reserved.
//

#import "UIView+CustomCornerBorder.h"
#import <objc/runtime.h>

@interface UIView ()
// 私有使用
@property(nonatomic, strong) CAShapeLayer *subBorderLayer;
/**边框状态是否变化*/
@property(nonatomic, assign) BOOL borderStatusChange;
@end


@implementation UIView (CustomCornerBorder)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class targetClass = [self class];
        SEL originalSelector = @selector(layoutSubviews);
        SEL swizzledSelector = @selector(swizzle_borderlayoutSubviews);
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

- (void)corner_forceReLayout {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)swizzle_borderlayoutSubviews {
    [self swizzle_borderlayoutSubviews];
    if (self.corner_openBorder) {
//        if (self.borderStatusChange == NO) return;
        self.borderStatusChange = NO;
        if (self.corner_openBorder == BorderTypeNone) {
            [self.subBorderLayer removeFromSuperlayer];
        } else {
            UIRectCorner rectCorner = [self getRectCornerForBorder];
            if (self.subBorderLayer == nil) {
                self.subBorderLayer = [[CAShapeLayer alloc] init];
            }
            UIBezierPath *maskPath;
            maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width -  self.corner_borderWidth, self.frame.size.height - self.corner_borderWidth) byRoundingCorners:rectCorner cornerRadii:CGSizeMake(self.corner_borderRadius, self.corner_borderRadius)];
            self.subBorderLayer.frame = CGRectMake(self.corner_borderWidth / 2, self.corner_borderWidth / 2,self.frame.size.width - self.corner_borderWidth,self.frame.size.height - self.corner_borderWidth);
            self.subBorderLayer.path = maskPath.CGPath;
            self.subBorderLayer.fillColor = self.corner_borderFillColor.CGColor;
            self.subBorderLayer.strokeColor = self.corner_borderColor.CGColor;
            self.subBorderLayer.lineWidth = self.corner_borderWidth;
            
            if (!self.subBorderLayer.superlayer) {
                [self.layer addSublayer:self.subBorderLayer];
            }
        }
    }
}

- (UIRectCorner)getRectCornerForBorder {
    UIRectCorner rectCorner = 0;
    if (self.corner_borderType & BorderTypeAllCorners) {
        rectCorner = UIRectCornerAllCorners;
    } else {
        if (self.corner_borderType & BorderTypeTopLeft) {
            rectCorner = rectCorner | UIRectCornerTopLeft;
        }
        if (self.corner_borderType & BorderTypeTopRight) {
            rectCorner = rectCorner | UIRectCornerTopRight;
        }
        if (self.corner_borderType & BorderTypeBottomLeft) {
            rectCorner = rectCorner | UIRectCornerBottomLeft;
        }
        if (self.corner_borderType & BorderTypeBottomRight) {
            rectCorner = rectCorner | UIRectCornerBottomRight;
        }
    }
    return rectCorner;
}

#pragma mark - 添加属性
static const char *cornerRadius_openKey_border = "cornerRadius_openKey_border";
- (void)setCorner_openBorder:(BOOL)corner_openBorder {
    objc_setAssociatedObject(self, cornerRadius_openKey_border, @(corner_openBorder), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)corner_openBorder {
    return [objc_getAssociatedObject(self, cornerRadius_openKey_border) boolValue];
}

static const char *cornerRadius_radiusKey_border = "cornerRadius_radiusKey_border";
- (void)setCorner_borderRadius:(CGFloat)corner_borderRadius {
    if (corner_borderRadius == self.corner_borderRadius) {
    } else {
        self.borderStatusChange = YES;
    }
    objc_setAssociatedObject(self, cornerRadius_radiusKey_border, @(corner_borderRadius), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)corner_borderRadius {
    return [objc_getAssociatedObject(self, cornerRadius_radiusKey_border) floatValue];
}

static const char *cornerRadiusWidth_radiusKey_border = "cornerRadiusWidth_radiusKey_border";
- (void)setCorner_borderWidth:(CGFloat)corner_borderWidth{
    if (corner_borderWidth == self.corner_borderWidth) {
    } else {
        self.borderStatusChange = YES;
    }
    objc_setAssociatedObject(self, cornerRadiusWidth_radiusKey_border, @(corner_borderWidth), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)corner_borderWidth {
    return [objc_getAssociatedObject(self, cornerRadiusWidth_radiusKey_border) floatValue];
}

static const char *cornerRadius_TypeKey_b = "cornerRadius_TypeKey_b";
- (void)setCorner_borderType:(CornerBorderType)corner_borderType {
    if (corner_borderType == self.corner_borderType) {
    } else {
        self.borderStatusChange = YES;
    }
    objc_setAssociatedObject(self, cornerRadius_TypeKey_b, @(corner_borderType), OBJC_ASSOCIATION_RETAIN);
}

- (CornerBorderType)corner_borderType {
    return [objc_getAssociatedObject(self, cornerRadius_TypeKey_b) unsignedIntegerValue];
}

static const char *cornerRadiusColor_LayerKey_border = "cornerRadiusColor_LayerKey_border";
- (void)setCorner_borderColor:(UIColor *)corner_borderColor {
    if ([corner_borderColor isEqual:self.corner_borderColor]) {
    } else {
        self.borderStatusChange = YES;
    }
    objc_setAssociatedObject(self, cornerRadiusColor_LayerKey_border, corner_borderColor, OBJC_ASSOCIATION_RETAIN);
}

- (UIColor *)corner_borderColor {
    return objc_getAssociatedObject(self, cornerRadiusColor_LayerKey_border);
}

static const char *cornerRadiusColor_LayerKey_borderfill = "cornerRadius_ColColor";
- (void)setCorner_borderFillColor:(UIColor *)corner_borderfillColor {
    if ([corner_borderfillColor isEqual:self.corner_borderFillColor]) {
    } else {
        self.borderStatusChange = YES;
    }
    objc_setAssociatedObject(self, cornerRadiusColor_LayerKey_borderfill, corner_borderfillColor, OBJC_ASSOCIATION_RETAIN);
}

- (UIColor *)corner_borderFillColor {
    return objc_getAssociatedObject(self, cornerRadiusColor_LayerKey_borderfill);
}


static const char *cornerRadius_LayerKey_border = "cornerRadius_LayerKey_border";
- (void)setSubBorderLayer:(CAShapeLayer *)subBorderLayer {
    objc_setAssociatedObject(self, cornerRadius_LayerKey_border, subBorderLayer, OBJC_ASSOCIATION_RETAIN);
}

- (CAShapeLayer *)subBorderLayer {
    return objc_getAssociatedObject(self, cornerRadius_LayerKey_border);
}

static const char *cornerRadius_StatusKey_border = "cornerRadius_StatusKey_border";
- (void)setBorderStatusChange:(BOOL)borderStatusChange {
    objc_setAssociatedObject(self, cornerRadius_StatusKey_border, @(borderStatusChange), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)borderStatusChange {
    return [objc_getAssociatedObject(self, cornerRadius_StatusKey_border) boolValue];
}


@end
