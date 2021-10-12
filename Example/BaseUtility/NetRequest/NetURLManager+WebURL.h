//
//  NetURLManager+WebURL.h
//  BaseTools
//
//  Created by Singularity on 2020/11/4.
//  Copyright © 2020 Singularity. All rights reserved.
//

#import "NetURLManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetURLManager (WebURL)

/** 用户隐私政策 */
+ (NSString *)WebURLForUserPrivacy;

/** 政策协议 */
+ (NSString *)WebURLForPolicyAgreement;


@end

NS_ASSUME_NONNULL_END
