//
//  NetURLManager+WebURL.m
//  BaseTools
//
//  Created by Singularity on 2020/11/4.
//  Copyright © 2020 Singularity. All rights reserved.
//

#import "NetURLManager+WebURL.h"

@implementation NetURLManager (WebURL)

+ (NSString *)WebURLForUserPrivacy{
    return [NetURLManager URLForPath:@"/h5/privacy.html"];
}

+ (NSString *)WebURLForPolicyAgreement{
    return [NetURLManager URLForPath:@"/h5/policyAgreement.html"];
}

@end
