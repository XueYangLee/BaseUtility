//
//  SendMailManager.h
//  NowMeditation
//
//  Created by Singularity on 2020/11/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SendMailCompletion)(BOOL success, NSString *resultMsg);

@class SendMailContentModel;

@interface SendMailManager : NSObject

+ (instancetype)sharedManager;

- (void)sendEmailWithContent:(SendMailContentModel *)contentModel completion:(SendMailCompletion)comp;


@end


@interface SendMailContentModel : NSObject

/** 主题 */
@property (nonatomic,copy) NSString *subject;
/** 收件人地址数组 */
@property (nonatomic,strong) NSArray *recipients;
/** 抄送收件人地址数组 */
@property (nonatomic,strong) NSArray *ccRecipients;
/** 密送收件人地址数组 */
@property (nonatomic,strong) NSArray *secretRecipients;
/** 邮件内容 */
@property (nonatomic,copy) NSString *content;
/** 附加图片 */
@property (nonatomic,strong) UIImage *addImage;



@end

NS_ASSUME_NONNULL_END
