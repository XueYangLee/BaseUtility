//
//  CustomShare.h
//  NowMeditation
//
//  Created by 李雪阳 on 2020/11/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CustomShareModel;
@class CustomShareActivity;


/** 分享内容block */
typedef void(^ShareContent)(CustomShareModel *shareContent);
/** 自定义分享按钮配置block */
typedef NSArray <CustomShareActivity *>*_Nullable(^CustomActivityAction)(void);
/** 分享结果回调block */
typedef void(^ShareCompletion)(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems);


@interface CustomShare : NSObject

/**
 调用系统原生分享
 @param shareContent 分享内容 不能为空  shareImage或shareURL必须有一项存在
 @param customActivityAction 自定义底部按钮
 @param completion 分享回调
 */
+ (void)shareWithContent:(ShareContent _Nonnull)shareContent customActivityAction:(CustomActivityAction _Nullable)customActivityAction shareCompletion:(ShareCompletion _Nullable)completion;

@end




/** 分享的内容  不能为空  shareImage或shareURL必须有一项存在 */
@interface CustomShareModel : NSObject

/** 分享文案 */
@property (nonatomic,copy) NSString *shareText;
/** 分享图片 */
@property (nonatomic,strong) UIImage *shareImage;
/** 分享网址 */
@property (nonatomic,copy) NSString *shareURL;
/** 分享的视频或GIF文件路径  跟shareURL二选一即可 */
@property (nonatomic,copy) NSString *shareFilePath;

@end





@interface CustomShareActivity : UIActivity

/**
 自定义分享底部按钮
 @param title 按钮标题
 @param image 按钮图片
 @param type 按钮标识
 @param handleAction 按钮点击事件
 */
- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image type:(NSString *)type handleAction:(dispatch_block_t)handleAction;


@property (nonatomic,copy) dispatch_block_t handleAction;

@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
