//
//  BaseWebViewController.h
//  PartScan
//
//  Created by 李雪阳 on 2018/2/26.
//  Copyright © 2018年 singularity. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>
#import "CustomProgressView.h"

@interface BaseWebViewController : BaseViewController<WKNavigationDelegate, WKUIDelegate>

/** webView */
@property (nonatomic, strong) WKWebView *wkWebView;
/** 顶部进度条 */
@property (nonatomic, strong) CustomProgressView *progressView;


/** wkWeb自定义frame */
- (void)wkWebViewFrame:(CGRect)frame;

/** 进度条颜色(默认绿色) */
- (void)setProgressColor:(UIColor *)progressColor;


/** 网页加载方式 加载URLRequest */
@property (nonatomic, strong) NSURLRequest *URLRequest;
/** 网页加载方式 加载URLString */
@property (nonatomic, copy) NSString *URLString;
/** 网页加载方式 加载HTMLString */
@property (nonatomic, copy) NSString *HTMLString;


/** 清除web缓存 */
- (void)removeWebCache;

@end
