//
//  GCDTimer.m
//  NowMeditation
//
//  Created by 李雪阳 on 2020/11/6.
//

#import "GCDTimer.h"
#import "NSDate+Extension.h"

@implementation GCDTimer

//MARK: - 计时器
+ (dispatch_source_t)timeCountStartWithInterval:(float)interval handler:(dispatch_block_t)event_handle{
    /**
     *   GCD 计时器应用
     *   dispatch Queue :决定了将来回调的方法在哪里执行。
     *   dispatch_source_t timer  是一个OC对象
     *   DISPATCH_TIME_NOW  第二个参数：定时器开始时间,也可以使用如下的方法，在Now 的时间基础上再延时多长时间执行以下任务。

     dispatch_time(dispatch_time_t when, int64_t delta)
     
     *   intervalInSeconds  第三个参数:定时器开始后的间隔时间（纳秒 NSEC_PER_SEC）
     *  leewayInSeconds 第四个参数：间隔精准度，0代标最精准，传入一个大于0的数，代表多少秒的范围是可以接收的,主要为了提高程序性能，积攒一定的时间，Runloop执行完任务会睡觉，这个方法让他多睡一会，积攒时间，任务也就相应多了一点，而后一起执行
     */
    
    if (interval <= 0) {
        interval = 1.0;
    }

    /** 获取一个全局的线程来运行计时器*/
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    /** 创建一个计时器  （ DISPATCH_SOURCE_TYPE_TIMER）*/
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);

    /** 设置定时器的各种属性（何时开始，间隔多久执行）  GCD 的时间参数一般为纳秒 （1 秒 = 10 的 9 次方 纳秒）*/
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, interval * NSEC_PER_SEC, 0);

    // 任务回调
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (event_handle) {
                event_handle();
            }
        });
        
    });

    // 开始定时器任务（定时器默认开始是暂停的，需要复位开启）
    dispatch_resume(timer);
    
    return timer;
}

+ (void)resumeTimer:(dispatch_source_t)timer{
    if (!timer) {
        return;
    }
    dispatch_resume(timer);
}

+ (void)suspendTimer:(dispatch_source_t)timer{
    if (!timer) {
        return;
    }
    //挂起的时候注意，多次暂停的操作会导致线程锁的现象，即多少次暂停，,dispatch_resume和dispatch_suspend调用次数需要平衡，如果重复调用dispatch_resume则会崩溃,因为重复调用会让dispatch_resume代码里if分支不成立，从而执行了DISPATCH_CLIENT_CRASH("Over-resume of an object")导致崩溃
    dispatch_suspend(timer);
}

+ (void)cancelTimer:(dispatch_source_t)timer{
    if (!timer) {
        return;
    }
    //默认是重复执行的，可以在事件响应回调中通过dispatch_source_cancel方法来设置为只执行一次
    dispatch_source_set_event_handler(timer, ^{
        
        dispatch_source_cancel(timer);
    });
}



//MARK: - 秒数倒计时 验证码获取
+ (dispatch_source_t)countdownSecWithMaxSec:(NSInteger)maxSec completion:(void (^)(BOOL isReturnZero, NSInteger second))comp{
    
    __block NSInteger timeout=maxSec;//倒计时时间
    dispatch_queue_t queue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL,0),1.0*NSEC_PER_SEC,0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){//倒计时结束,关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (comp) {
                    comp(YES,0);
                }
            });
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (comp) {
                    comp(NO,timeout);
                }
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
    return _timer;
}


//MARK: - 时间倒计时 活动倒计时
+ (dispatch_source_t)countdownDHMSTimeWithStartTimeStamp:(NSString *)startTimeStamp endTimeStamp:(NSString *)endTimeStamp completion:(void (^)(BOOL isReturnZero, NSInteger day, NSInteger hour, NSInteger minute, NSInteger second))comp{
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[startTimeStamp doubleValue]/1000];
    NSDate* endDate = [NSDate date];
    if (endTimeStamp.length!=0) {
        endDate=[NSDate dateWithTimeIntervalSince1970:[endTimeStamp doubleValue]/1000];
    }
    
    NSInteger intervalTime=[NSDate secondIntervalSinceDate:startDate EndDate:endDate];
    
    
    __block NSInteger secTime=intervalTime;//倒计时时间
    dispatch_queue_t queue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL,0),1.0*NSEC_PER_SEC,0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(secTime <= 0){//倒计时结束,关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (comp) {
                    comp(YES,0,0,0,0);
                }
            });
        }else{
            NSInteger days = (NSInteger)(secTime/(3600*24));
            NSInteger hours = (NSInteger)((secTime-days*24*3600)/3600);
            NSInteger minute = (NSInteger)(secTime-days*24*3600-hours*3600)/60;
            NSInteger second = secTime-days*24*3600-hours*3600-minute*60;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (comp) {
                    comp(NO,days,hours,minute,second);
                }
            });
            secTime--;
        }
    });
    dispatch_resume(_timer);
    
    return _timer;
}


+ (dispatch_source_t)countdownTimeWithStartTimeStamp:(NSString *)startTimeStamp endTimeStamp:(NSString *)endTimeStamp completion:(void (^)(BOOL isReturnZero, NSInteger sec))comp{
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[startTimeStamp doubleValue]/1000];
    NSDate* endDate = [NSDate date];
    if (endTimeStamp.length!=0) {
        endDate=[NSDate dateWithTimeIntervalSince1970:[endTimeStamp doubleValue]/1000];
    }
    
    NSInteger intervalTime=[NSDate secondIntervalSinceDate:startDate EndDate:endDate];
    
    
    __block NSInteger secTime=intervalTime;//倒计时时间
    dispatch_queue_t queue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL,0),1.0*NSEC_PER_SEC,0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(secTime <= 0){//倒计时结束,关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (comp) {
                    comp(YES,0);
                }
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (comp) {
                    comp(NO,secTime);
                }
            });
            secTime--;
        }
    });
    dispatch_resume(_timer);
    
    return _timer;
}






@end
