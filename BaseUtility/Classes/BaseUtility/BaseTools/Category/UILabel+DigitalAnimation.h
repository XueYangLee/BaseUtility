//
//  UILabel+DigitalAnimation.h
//  NowMeditation
//
//  Created by Singularity on 2020/11/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (DigitalAnimation)

@property (nonatomic,assign) BOOL isRunning;

- (void)digitalAnimationFromNum:(float)fromNum toNum:(float)toNum duration:(float)duration prefix:(NSString *_Nullable)prefix suffix:(NSString *_Nullable)suffix;

@end

NS_ASSUME_NONNULL_END
