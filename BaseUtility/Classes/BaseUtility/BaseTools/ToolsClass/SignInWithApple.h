//
//  SignInWithApple.h
//  NowMeditation
//
//  Created by Singularity on 2020/11/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SignInWithAppleModel;

typedef void(^SignInAppCompletion)(SignInWithAppleModel *appleInfo);

/** 苹果登录    在Signing & Capability -> +Capability中开启 SignInWithApple*/
@interface SignInWithApple : NSObject

+ (instancetype)sharedManager;

/** 苹果登录  授权登录 */
- (void)signInWithAuthorizationAppleIDWithCompletion:(SignInAppCompletion)comp;

/** 存在iCloud Keychain 凭证或者AppleID  已认证过的登录方式 */
- (void)signInWithExistAppleAccountWithCompletion:(SignInAppCompletion)comp;

@end



@interface SignInWithAppleModel : NSObject

// 验证数据，用于传给开发者后台服务器，然后开发者服务器再向苹果的身份验证服务端验证，本次授权登录请求数据的有效性和真实性
@property (nonatomic,copy) NSString *identityToken;
@property (nonatomic,copy) NSString *authorizationCode;

// UserID:Unique, stable, team-scoped user ID，苹果用户唯一标识符，该值在同一个开发者账号下的所有App下是一样的，开发者可以用该唯一标识符与自己后台系统的账号体系绑定起
@property (nonatomic,copy) NSString *userIdentifier;

@property (nonatomic,copy) NSString *nickName;

@end

NS_ASSUME_NONNULL_END
