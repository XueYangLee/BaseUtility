//
//  UUID.m
//  BaseTools
//
//  Created by 李雪阳 on 2020/6/9.
//  Copyright © 2020 Singularity. All rights reserved.
//

#import "UUID.h"
#import <AdSupport/AdSupport.h>
//#import "KeyChainStore.h"
#import <SAMKeychain/SAMKeychain.h>
#import "UtilityMacro.h"

#define KEY_UUID_KEKCHAINSTORE  [NSString stringWithFormat:@"%@.UUID.KEY",APP_BUNDLE_ID]
#define SERVICE_UUID_KEKCHAINSTORE  [NSString stringWithFormat:@"%@.UUID",APP_BUNDLE_ID]

@implementation UUID

+ (NSString *)getUUID {
//    NSString * UUIDString = (NSString *)[KeyChainStore load:KEY_UUID_KEKCHAINSTORE];
    NSString * UUIDString = [SAMKeychain passwordForService:SERVICE_UUID_KEKCHAINSTORE account:KEY_UUID_KEKCHAINSTORE];
    
    //首次执行该方法时，uuid为空
    if ([UUIDString isEqualToString:@""] || !UUIDString || [UUIDString isKindOfClass:[NSNull class]]) {
        
        UUIDString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        
        if (UUIDString.length == 0 || [UUIDString isEqualToString:@"00000000-0000-0000-0000-000000000000"] || ![[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]){
            //生成一个uuid的方法
            CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
            
            UUIDString = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        }
        
        //将该uuid保存到keychain
//        [KeyChainStore save:KEY_UUID_KEKCHAINSTORE data:UUIDString];
        [SAMKeychain setPassword:UUIDString forService:SERVICE_UUID_KEKCHAINSTORE account:KEY_UUID_KEKCHAINSTORE];
        
    }
    return UUIDString;
}


@end
