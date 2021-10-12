//
//  SendMailManager.m
//  NowMeditation
//
//  Created by Singularity on 2020/11/18.
//

#import "SendMailManager.h"
#import <MessageUI/MessageUI.h>
#import "CustomAlert.h"
#import "UtilityMacro.h"

@interface SendMailManager () <MFMailComposeViewControllerDelegate>

@property (nonatomic,copy) SendMailCompletion sendMailCompletion;

@end

@implementation SendMailManager

+ (instancetype)sharedManager
{
    static SendMailManager *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[SendMailManager alloc] init];
    });
    return shareManager;
}


- (void)sendEmailWithContent:(SendMailContentModel *)contentModel completion:(SendMailCompletion)comp{
    BOOL canSend = [MFMailComposeViewController canSendMail];
    
    if (!canSend) {
        [CustomAlert showAlertAddTarget:[UIViewController currentViewController] title:@"请开通您的邮箱账号" message:@"设置->密码与账户->添加账户" cancelBtnTitle:nil defaultBtnTitle:@"确认" actionHandle:^(NSInteger actionIndex, NSString * _Nonnull btnTitle) {
            NSURL *url = [NSURL URLWithString:@"mailto:yourEmail"];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }
        }];
        return;
    }
    
    self.sendMailCompletion=comp;

    // 邮件服务器
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    
    if (contentModel.subject) {
        [mailCompose setSubject:contentModel.subject];// 设置邮件主题
    }
    if (contentModel.recipients.count) {
        [mailCompose setToRecipients:contentModel.recipients];// 设置收件人
    }
    if (contentModel.ccRecipients.count) {
        [mailCompose setCcRecipients:contentModel.ccRecipients];// 设置抄送人
    }
    if (contentModel.secretRecipients.count) {
        [mailCompose setBccRecipients:contentModel.secretRecipients];// 设置密抄送
    }
    
    if (contentModel.content) {
        [mailCompose setMessageBody:contentModel.content isHTML:NO];//设置邮件的正文内容
    }
    
    if (contentModel.addImage) {
        NSData *imageData = UIImagePNGRepresentation(contentModel.addImage);//添加图片附件
        [mailCompose addAttachmentData:imageData mimeType:@"image/png" fileName:@"image.png"];
    }

    // 弹出邮件发送视图
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIViewController currentViewController] presentViewController:mailCompose animated:YES completion:nil];
    });

}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    BOOL success = NO;
    NSString *resultMsg = @"";
    switch (result)
    {
        case MFMailComposeResultCancelled: //用户取消编辑邮件
          DLog(@"Mail send canceled...");
            resultMsg = @"Mail send canceled...";
          break;
        case MFMailComposeResultSaved: //用户成功保存邮件
          DLog(@"Mail saved...");
            success = YES;
            resultMsg = @"Mail saved...";
          break;
        case MFMailComposeResultSent: //用户点击发送，将邮件放到队列中，还没发送
          DLog(@"Mail sent...");
            resultMsg = @"Mail sent...";
          break;
        case MFMailComposeResultFailed: //用户试图保存或者发送邮件失败
          DLog(@"Mail send errored: %@...", [error localizedDescription]);
            resultMsg = [NSString stringWithFormat:@"Mail send errored: %@...",[error localizedDescription]];
          break;
    }
    
    if (self.sendMailCompletion) {
        self.sendMailCompletion(success, resultMsg);
    }
    // 关闭邮件发送视图
    dispatch_async(dispatch_get_main_queue(), ^{
        [controller dismissViewControllerAnimated:YES completion:nil];
    });
    
}

@end







@implementation SendMailContentModel

@end

