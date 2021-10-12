//
//  UserNotificationManager.h
//  NowMeditation
//
//  Created by Singularity on 2020/11/24.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@class UserNotifyContentModel;

typedef void(^NotifyContent)(UserNotifyContentModel *content);

@interface UserNotificationManager : NSObject

/** APPDelegate  中【注册】 代理   如果另存在远程推送时无需调用，调用远程推送相关的register方法即可  */
+ (void)registerNotificationWithDelegate:(id<UNUserNotificationCenterDelegate>)delegate application:(UIApplication *)application;


/** APPDelegate  中【-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler】使用    如果另存在远程推送时无需调用，调用远程推送相关方法即可 */
+ (void)willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler;
/** APPDelegate 中【- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler】使用    如果另存在远程推送时无需调用，调用远程推送相关方法即可  */
+ (void)didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler;




#pragma mark - 通知权限

/** 通知权限  */
+ (void)notificationAuthorizationEnabled:(void (^)(BOOL enabled))comp;

/** 通知权限操作提醒弹窗 */
+ (void)authorizeRemind;




#pragma mark - 本地通知推送

/**
 定时推送  发送一次
 @param delayTime 延迟的秒数
 @param content 内容模型数据
 @param identifier 推送标识！
 @param comp 完成回调
 */
+ (void)addLocalNotificationDelayTime:(CGFloat)delayTime content:(NotifyContent _Nonnull)content identifier:(NSString *_Nonnull)identifier completion:(void (^__nullable)(BOOL success))comp;


/**
 定期推送
 @param dateComponents 日期 (NSDateComponents *components = [[NSDateComponents alloc] init];\components.weekday = 2;//weekday默认是从周日开始\components.hour
 = 8;\components.minute = 20;)
 @param repeat 是否重复 即每到设定时间都提醒
 @param content 内容模型数据
 @param identifier 推送标识！
 @param comp 完成回调
 */
+ (void)addLocalNotificationDateComponents:(NSDateComponents *)dateComponents repeat:(BOOL)repeat content:(NotifyContent _Nonnull)content identifier:(NSString *_Nonnull)identifier completion:(void (^__nullable)(BOOL success))comp;




#pragma mark - 通知推送移除方法

/** 移除指定通知 */
+ (void)removeNotificationWithIdentifier:(NSString *_Nonnull)identifier;

/** 移除所有通知 */
+ (void)removeAllNotification;

@end




@interface UserNotifyContentModel : NSObject

/** 推送的标题 */
@property (nonatomic,copy) NSString *title;
/** 推送的副标题 */
@property (nonatomic,copy) NSString *subTitle;
/** 推送的内容 */
@property (nonatomic,copy) NSString *body;
/** 推送的用户信息 */
@property (nonatomic,strong) NSDictionary *userInfo;
/** 推送的角标 默认0 */
@property (nonatomic,assign) NSInteger badge;

@end

NS_ASSUME_NONNULL_END
