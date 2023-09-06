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

@class WeakBaseWebViewScriptMessageDelegate;

// WKWebView 内存不释放的问题解决
@interface WeakBaseWebViewScriptMessageDelegate : NSObject<WKScriptMessageHandler>

//WKScriptMessageHandler 这个协议类专门用来处理JavaScript调用原生OC的方法
@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end

/**
 WeakBaseWebViewScriptMessageDelegate *weakScriptMessageDelegate = [[WeakBaseWebViewScriptMessageDelegate alloc] initWithDelegate:self];
 [self.config.userContentController addScriptMessageHandler:weakScriptMessageDelegate name:@"webConsult"];
 
 - (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
     DLog(@"name:%@\\\\n body:%@\\\\n frameInfo:%@\\\\n",message.name,message.body,message.frameInfo);
 }
 
 - (void)dealloc{
     [[self.wkWebView configuration].userContentController removeScriptMessageHandlerForName:@"webConsult"];
 }
 
 [self.wkWebView evaluateJavaScript:[NSString stringWithFormat:@"webToken('%@')",[UserCenter sharedCenter].token] completionHandler:^(id _Nullable data, NSError * _Nullable error) {}];//一定要加''
 */


@interface BaseWebViewController : BaseViewController<WKScriptMessageHandler,WKNavigationDelegate, WKUIDelegate>

/** webView */
@property (nonatomic, strong) WKWebView *wkWebView;
/** webConfig */
@property (nonatomic,strong) WKWebViewConfiguration *config;
/** 顶部进度条 */
@property (nonatomic, strong) CustomProgressView *progressView;


/** wkWeb自定义frame */
- (void)wkWebViewFrame:(CGRect)frame;

/** 进度条颜色(默认绿色) */
- (void)setProgressColor:(UIColor *)progressColor;

/// wkWebView监听方法
- (void)baseWebViewObserveValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context;


/** 网页加载方式 加载URLRequest */
@property (nonatomic, strong) NSURLRequest *URLRequest;
/** 网页加载方式 加载URLString */
@property (nonatomic, copy) NSString *URLString;
/** 网页加载方式 加载HTMLString */
@property (nonatomic, copy) NSString *HTMLString;


/** 清除web缓存 */
- (void)removeWebCache;

@end
