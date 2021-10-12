//
//  CustomShare.m
//  NowMeditation
//
//  Created by 李雪阳 on 2020/11/19.
//

#import "CustomShare.h"
#import "UtilityMacro.h"

@implementation CustomShare

+ (void)shareWithContent:(ShareContent)shareContent customActivityAction:(CustomActivityAction)customActivityAction shareCompletion:(ShareCompletion)completion{
    
    NSArray *contentArray = [self disposeShareContent:shareContent];
    if (!contentArray.count) {
        DLog(@"分享内容不能为空，图片或URL必须存在一项")
        return;
    }
    
    NSArray *activities = [NSArray new];
    if (customActivityAction) {
        activities = customActivityAction();
    }
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:contentArray applicationActivities:activities];
    
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completion) {
            completion(activityType, completed, returnedItems);
        }
    };
    
    activityVC.excludedActivityTypes = @[UIActivityTypePrint,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypeAirDrop,UIActivityTypeOpenInIBooks];
    
    [[UIViewController currentViewController] presentViewController:activityVC animated:YES completion:nil];
}

+ (NSArray *)disposeShareContent:(ShareContent)shareContent{
    CustomShareModel *contentModel = [CustomShareModel new];
    if (shareContent) {
        shareContent(contentModel);
    }
    
    if (!contentModel.shareImage && !contentModel.shareURL && !contentModel.shareFilePath) {
        return nil;
    }
    
    NSMutableArray *contentArray = [NSMutableArray array];
    if (contentModel.shareText) {
        [contentArray addObject:contentModel.shareText];
    }
    if (contentModel.shareImage) {
        [contentArray addObject:contentModel.shareImage];
    }
    if (contentModel.shareURL || contentModel.shareFilePath) {
        if (contentModel.shareURL) {
            [contentArray addObject:[NSURL URLWithString:contentModel.shareURL]];
        }else{
            [contentArray addObject:[NSURL fileURLWithPath:contentModel.shareFilePath]];
        }
    }
    
    return contentArray;
}

@end




@implementation CustomShareModel

@end




@implementation CustomShareActivity

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image type:(NSString *)type handleAction:(dispatch_block_t)handleAction{
    self = [super init];
    if (self) {
        self.title = title;
        self.image = image;
        self.type = type;
        
        self.handleAction = handleAction;
    }
    return self;
}


+ (UIActivityCategory)activityCategory{
    //UIActivityViewController中显示的位置 UIActivityCategoryShare 上部分 UIActivityCategoryAction 下部分
    return UIActivityCategoryAction;
}

- (NSString *)activityTitle{
    return self.title;
}

- (UIImage *)activityImage{
    return self.image;
}

- (UIActivityType)activityType{
    return self.type;
}

- (void)performActivity {
    
    if (self.handleAction) {
        self.handleAction();
    }
    //操作结束必须通知操作结束
    [self activityDidFinish:YES];
}




- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    if (activityItems.count > 0) {
        return YES;
    }
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    //准备分享
}

@end

