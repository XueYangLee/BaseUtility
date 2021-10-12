//
//  SignInWithApple.m
//  NowMeditation
//
//  Created by Singularity on 2020/11/17.
//

#import "SignInWithApple.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import "KeyChainStore.h"
#import "UtilityMacro.h"

#define KEY_SIGNINAPPLE_IDENTIFIER_KEKCHAINSTORE  [NSString stringWithFormat:@"%@.SIGNINAPPLE.IDENTIFIER.KEY",APP_BUNDLE_ID]

@interface SignInWithApple ()<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>

@property (nonatomic,copy) SignInAppCompletion signInAppCompletion;

@end

@implementation SignInWithApple

+ (instancetype)sharedManager{
    static SignInWithApple *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[SignInWithApple alloc] init];
    });
    return shareManager;
}

- (void)signInWithAuthorizationAppleIDWithCompletion:(SignInAppCompletion)comp{
    if (@available(iOS 13.0, *)) {
        self.signInAppCompletion = comp;
        // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        // 创建新的AppleID 授权请求
        ASAuthorizationAppleIDRequest *appleIDRequest = [appleIDProvider createRequest];
        // 在用户授权期间请求的联系信息
        appleIDRequest.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
        ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[appleIDRequest]];
        // 设置授权控制器通知授权请求的成功与失败的代理
        authorizationController.delegate = self;
        // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
        authorizationController.presentationContextProvider = self;
        // 在控制器初始化期间启动授权流
        [authorizationController performRequests];
    }else{
        // 处理不支持系统版本
        DLog(@"该系统版本不可用Apple登录");
    }
}

// 如果存在iCloud Keychain 凭证或者AppleID 凭证提示用户//已经认证过的
- (void)signInWithExistAppleAccountWithCompletion:(SignInAppCompletion)comp{
    if (@available(iOS 13.0, *)) {
        self.signInAppCompletion = comp;
        // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        // 授权请求AppleID
        ASAuthorizationAppleIDRequest *appleIDRequest = [appleIDProvider createRequest];
        // 为了执行钥匙串凭证分享生成请求的一种机制
        ASAuthorizationPasswordProvider *passwordProvider = [[ASAuthorizationPasswordProvider alloc] init];
        ASAuthorizationPasswordRequest *passwordRequest = [passwordProvider createRequest];
        // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
        ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[appleIDRequest, passwordRequest]];
        // 设置授权控制器通知授权请求的成功与失败的代理
        authorizationController.delegate = self;
        // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
        authorizationController.presentationContextProvider = self;
        // 在控制器初始化期间启动授权流
        [authorizationController performRequests];
    }else{
        // 处理不支持系统版本
        DLog(@"该系统版本不可用Apple登录");
    }
}


//MARK: - delegate
//@optional 授权成功地回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)){
//    DLog(@"授权完成:::%@", authorization.credential);
//    DLog(@"%s", __FUNCTION__);
//    DLog(@"%@", controller);
//    DLog(@"%@", authorization);
    
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        // 用户登录使用ASAuthorizationAppleIDCredential
        ASAuthorizationAppleIDCredential *appleIDCredential = authorization.credential;
        
        // 使用过授权的，获取不到以下三个参数，因此不取
        /*
        NSString *familyName = appleIDCredential.fullName.familyName;
        NSString *givenName = appleIDCredential.fullName.givenName;
        NSString *email = appleIDCredential.email;*/
        //nickname隐藏邮箱时也拿不到
        NSString *nickName = appleIDCredential.fullName.nickname;
        
        NSString *userIdentifier = appleIDCredential.user;
        NSData *identityToken = appleIDCredential.identityToken;
        NSData *authorizationCode = appleIDCredential.authorizationCode;
        
        // 服务器验证需要使用的参数
        NSString *identityTokenStr = [[NSString alloc] initWithData:identityToken encoding:NSUTF8StringEncoding];
        NSString *authorizationCodeStr = [[NSString alloc] initWithData:authorizationCode encoding:NSUTF8StringEncoding];
//        DLog(@"%@-->identityToken\n\n%@-->authorizationCode\n\n%@-->userID", identityTokenStr, authorizationCodeStr, userIdentifier);
        
        SignInWithAppleModel *model=[SignInWithAppleModel new];
        model.identityToken = identityTokenStr;
        model.authorizationCode = authorizationCodeStr;
        model.userIdentifier = userIdentifier;
        
        NSString *userTrimString = @"";
        if (userIdentifier.length > 7) {
            userTrimString = [userIdentifier substringFromIndex:userIdentifier.length-7];
        }
        model.nickName = (nickName)? nickName : userTrimString;
        if (self.signInAppCompletion) {
            self.signInAppCompletion(model);
        }
        
        // Create an account in your system.
        // For the purpose of this demo app, store the userIdentifier in the keychain.
        //  需要使用钥匙串的方式保存用户的唯一信息
        [KeyChainStore save:KEY_SIGNINAPPLE_IDENTIFIER_KEKCHAINSTORE data:userIdentifier];
        
    }else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]){
        // 这个获取的是iCloud记录的账号密码，需要输入框支持iOS 12 记录账号密码的新特性，如果不支持，可以忽略
        // Sign in using an existing iCloud Keychain credential.
        // 用户登录使用现有的密码凭证
        ASPasswordCredential *passwordCredential = authorization.credential;
        // 密码凭证对象的用户标识 用户的唯一标识
        NSString *user = passwordCredential.user;
        // 密码凭证对象的密码
        NSString *password = passwordCredential.password;
        DLog(@"%@->user\n%@->pwd",user,password)
        
    }else{
        DLog(@"授权信息均不符");
        
    }
}

// 授权失败的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)){
    // Handle error.
    DLog(@"Handle error：%@", error);
    NSString *errorMsg = @"";
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
            
        default:
            break;
    }
    
    DLog(@"%@", errorMsg);
}

// 告诉代理应该在哪个window 展示内容给用户
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)){
    // 返回window
    return [UIApplication sharedApplication].windows.lastObject;
}



@end





@implementation SignInWithAppleModel

@end
