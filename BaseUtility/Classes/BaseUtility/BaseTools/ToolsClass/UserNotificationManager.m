//
//  UserNotificationManager.m
//  NowMeditation
//
//  Created by Singularity on 2020/11/24.
//

#import "UserNotificationManager.h"
#import "UtilityMacro.h"
#import "CustomAlert.h"
#import "UtilityCategoryHeader.h"

@interface UserNotificationManager ()

@end

@implementation UserNotificationManager

+ (void)registerNotificationWithDelegate:(id<UNUserNotificationCenterDelegate>)delegate application:(UIApplication *)application{
    application.applicationIconBadgeNumber = 0;
    UNAuthorizationOptions options = UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge;
    UNUserNotificationCenter * center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = delegate;
    [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error && granted) {
            // 允许授权
        } else {
            // 不允许授权
        }
    }];
    
    [application registerForRemoteNotifications];
    
}

//MARK: 通知权限判断
+ (void)notificationAuthorizationEnabled:(void (^)(BOOL enabled))comp{
    
    // 获取用户对通知的设置
    // 通过settings.authorizationStatus 来处理用户没有打开通知授权的情况
    [UNUserNotificationCenter.currentNotificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (settings.notificationCenterSetting == UNNotificationSettingEnabled) {
                if (comp) {
                    comp(YES);
                }
            }else {
                if (comp) {
                    comp(NO);
                }
            }
        });
        
    }];
}

//MARK: 权限提示
+ (void)authorizeRemind{
    
    [CustomAlert showAlertAddTarget:[UIViewController currentViewController] title:@"提示" message:[NSString stringWithFormat:@"请在%@的\"设置-通知\"选项中，\r允许%@通知",[UIDevice currentDevice].model,APP_NAME] actionHandle:^(NSInteger actionIndex, NSString * _Nonnull btnTitle) {
        if (actionIndex==1) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }
    }];
    
}


#pragma mark - 通知推送接收处理

+ (void)willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    //收到推送的请求
    UNNotificationRequest *request = notification.request;
    //收到推送的内容
    UNNotificationContent *content = request.content;
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    //收到推送消息的角标
    NSNumber *badge = content.badge;
    //收到推送消息body
    NSString *body = content.body;
    //推送消息的声音
    UNNotificationSound *sound = content.sound;
    // 推送消息的副标题
    NSString *subtitle = content.subtitle;
    // 推送消息的标题
    NSString *title = content.title;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {//应用处于前台时的远程推送接受
        DLog(@"iOS10 收到远程通知:%@",userInfo)
    } else {//应用处于前台时的本地推送接受
//        DLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo)
    }
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionBadge);
}


+ (void)didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    //收到推送的请求
    UNNotificationRequest *request = response.notification.request;
    //收到推送的内容
    UNNotificationContent *content = request.content;
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    //收到推送消息的角标
    NSNumber *badge = content.badge;
    //收到推送消息body
    NSString *body = content.body;
    //推送消息的声音
    UNNotificationSound *sound = content.sound;
    // 推送消息的副标题
    NSString *subtitle = content.subtitle;
    // 推送消息的标题
    NSString *title = content.title;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {//收到远程通知
        DLog(@"iOS10 点击远程通知:%@",userInfo)
    }else {//收到本地通知
        DLog(@"iOS10 点击本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo)
    }

    completionHandler();
}


#pragma mark - 本地通知推送

//MARK: 本地定时推送
+ (void)addLocalNotificationDelayTime:(CGFloat)delayTime content:(NotifyContent _Nonnull)content identifier:(NSString *_Nonnull)identifier completion:(void (^__nullable)(BOOL success))comp{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent *notifyContent = [[UNMutableNotificationContent alloc] init];
    
    UserNotifyContentModel *contentModel = [self disposeNotifyContent:content];
    if (!contentModel) {
        DLog(@"推送内容缺失")
        return;
    }
    if (contentModel.title) {
        notifyContent.title = contentModel.title;
    }
    if (contentModel.subTitle) {
        notifyContent.subtitle = contentModel.subTitle;
    }
    if (contentModel.body) {
        notifyContent.body = contentModel.body;
    }
    if (contentModel.userInfo) {
        notifyContent.userInfo = contentModel.userInfo;
    }
    notifyContent.badge = [NSNumber numberWithInteger:contentModel.badge];// 角标
    notifyContent.sound = [UNNotificationSound defaultSound];
    if (delayTime <= 0.1) {
        delayTime = 0.1;
    }
    // 多少秒后发送,可以将固定的日期转化为时间
    NSTimeInterval time = [[NSDate dateWithTimeIntervalSinceNow:delayTime] timeIntervalSinceNow];
    // repeats，是否重复，如果重复的话时间必须大于60s，要不会报错
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:time repeats:NO];
    
    // 添加通知的标识符，可以用于移除，更新等操作
    if (!identifier || [identifier isEqualToString:@""]) {
        identifier = @"notifyIdentifier";
    }
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:notifyContent trigger:trigger];
    
    [center addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
        if (!error) {
            DLog(@"成功添加推送");
        }
        if (comp) {
            comp((error)?NO:YES);
        }
    }];
}

//MARK: 本地定期推送
+ (void)addLocalNotificationDateComponents:(NSDateComponents *)dateComponents repeat:(BOOL)repeat content:(NotifyContent _Nonnull)content identifier:(NSString *_Nonnull)identifier completion:(void (^__nullable)(BOOL success))comp{
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent *notifyContent = [[UNMutableNotificationContent alloc] init];
    
    UserNotifyContentModel *contentModel = [self disposeNotifyContent:content];
    if (!contentModel) {
        DLog(@"推送内容缺失")
        return;
    }
    if (contentModel.title) {
        notifyContent.title = contentModel.title;
    }
    if (contentModel.subTitle) {
        notifyContent.subtitle = contentModel.subTitle;
    }
    if (contentModel.body) {
        notifyContent.body = contentModel.body;
    }
    if (contentModel.userInfo) {
        notifyContent.userInfo = contentModel.userInfo;
    }
    notifyContent.badge = [NSNumber numberWithInteger:contentModel.badge];// 角标
    notifyContent.sound = [UNNotificationSound defaultSound];
    
    /*
    NSDateComponents *components = [[NSDateComponents alloc] init];//重复,按日期
    components.weekday = 2;//weekday默认是从周日开始
    components.hour = 8;
    components.minute = 20;*/
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents repeats:repeat];
    
    // 添加通知的标识符，可以用于移除，更新等操作
    if (!identifier || [identifier isEqualToString:@""]) {
        identifier = @"notifyIdentifier";
    }
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:notifyContent trigger:trigger];
    
    [center addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
        if (!error) {
            DLog(@"成功添加推送");
        }
        if (comp) {
            comp((error)?NO:YES);
        }
    }];
}


+ (UserNotifyContentModel *)disposeNotifyContent:(NotifyContent)content{
    UserNotifyContentModel *contentModel = [UserNotifyContentModel new];
    if (content) {
        content(contentModel);
    }
    
    if (!contentModel.title && !contentModel.subTitle && !contentModel.body) {
        return nil;
    }
    return contentModel;
}


#pragma mark - 通知推送移除方法

//MARK: 移除指定通知
+ (void)removeNotificationWithIdentifier:(NSString *_Nonnull)identifier{
    UNUserNotificationCenter * center = [UNUserNotificationCenter currentNotificationCenter];
    // 判断noticeID是否存在
    [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
    
        for (UNNotificationRequest * request in requests) {
            if([identifier isEqualToString:request.identifier]){
                [center removePendingNotificationRequestsWithIdentifiers:@[identifier]];
            }
        }
        
    }];
}

//MARK: 移除所有通知
+ (void)removeAllNotification{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllPendingNotificationRequests];//所有未送达的
    [center removeAllDeliveredNotifications];//所有已送达的
}

@end




@implementation UserNotifyContentModel

@end
