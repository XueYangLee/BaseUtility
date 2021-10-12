//
//  UILabel+DigitalAnimation.m
//  NowMeditation
//
//  Created by Singularity on 2020/11/12.
//

#import "UILabel+DigitalAnimation.h"
#import <objc/runtime.h>

@implementation UILabel (DigitalAnimation)

@dynamic isRunning;

- (void)digitalAnimationFromNum:(float)fromNum toNum:(float)toNum duration:(float)duration prefix:(NSString * _Nullable)prefix suffix:(NSString * _Nullable)suffix{
    self.isRunning = YES;  //如果再次进来，就停止运行
    if (!prefix) {
        prefix=@"";
    }
    if (!suffix) {
        suffix=@"";
    }
    self.text = [NSString stringWithFormat:@"%@%0.f%@",prefix,fromNum,suffix];
    
    NSInteger totalCount = [self getCountFromNum:fabs(toNum-fromNum) ];
    
    CGFloat delayTime = duration / totalCount;
    
//    DLog(@"数字：%.2f,时长：%f,时间间隔：%f,分割个数：%ld",toNum,duration,delayTime,(long)totalCount);
    NSMutableArray *mediumNumArr = [[NSMutableArray alloc] initWithCapacity:totalCount];
    
    for (CGFloat i = 0; i<= totalCount; i++) {
        if (toNum-fromNum>0) {   //如果结束的数字比开始的数字大
            [mediumNumArr addObject:[NSString stringWithFormat:@"%@%.f%@",prefix,i*((toNum-fromNum)/totalCount)+fromNum,suffix]];
        }else {
            [mediumNumArr addObject:[NSString stringWithFormat:@"%@%.f%@",prefix,fromNum - i*((fromNum-toNum)/totalCount),suffix]];
        }
        //     [mediumNumArr addObject:[NSString stringWithFormat:@"%.2f",i*(toNum/totalCount)]];
    }
    [self changeLabelTitleWithDelayTime:delayTime andMediumArr:mediumNumArr];
}

//得到分割数目
- (NSInteger)getCountFromNum:(CGFloat)num {
    if (num<=0) {
        return 1;
    }else if(num<1000){
        return 100;
    }else {
        return num/20;
    }
}

- (void)changeLabelTitleWithDelayTime:(CGFloat)delayTime andMediumArr:(NSMutableArray *)mediumArr {
    if (!self.isRunning) {
        return;
    }
    if ([mediumArr count]<=0) {
        self.isRunning = NO;
    }else {
        self.text = mediumArr[0];
        [mediumArr removeObjectAtIndex:0];
//        self.isRunning = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self changeLabelTitleWithDelayTime:delayTime andMediumArr:mediumArr];
        });
    }
}


- (BOOL)isRunning{
    return objc_getAssociatedObject(self,@selector(isRunning));
}

- (void)setIsRunning:(BOOL)isRunning{
    objc_setAssociatedObject(self, @selector(isRunning),@(isRunning), OBJC_ASSOCIATION_ASSIGN);
}

@end
