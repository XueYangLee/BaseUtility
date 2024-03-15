//
//  BaseWebViewController.m
//  PartScan
//
//  Created by 李雪阳 on 2018/2/26.
//  Copyright © 2018年 singularity. All rights reserved.
//

#import "BaseWebViewController.h"
#import "UtilityMacro.h"
#import "UtilityCategoryHeader.h"
#import "UtilityToolsHeader.h"

@implementation WeakBaseWebViewScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

#pragma mark - WKScriptMessageHandler
//遵循WKScriptMessageHandler协议，必须实现如下方法，然后把方法向外传递
//通过接收JS传出消息的name进行捕捉的回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if ([self.scriptDelegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}

@end



@interface BaseWebViewController ()

@property (nonatomic,strong) UIBarButtonItem *backItem;
@property (nonatomic,strong) UIBarButtonItem *closeItem;

@end


#define CUSTOM_UA @"custom_userAgent"

static CGFloat const progressViewHeight = 2;

@implementation BaseWebViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem=self.backItem;
    
    [self.view addSubview:self.wkWebView];
    [self.view addSubview:self.progressView];
    [self setWebViewUA];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(windowDidBecomeHidden) name:UIWindowDidBecomeHiddenNotification object:nil];
}

- (WKWebView *)wkWebView{
    if (_wkWebView==nil) {
        _config = [WKWebViewConfiguration new];
        //通过JS与webView内容交互
        _config.userContentController = [WKUserContentController new];
        //初始化偏好设置属性：preferences
        _config.preferences = [WKPreferences new];
        //字体大小 默认0;
        _config.preferences.minimumFontSize = 0;
        //是否支持JavaScript
        _config.preferences.javaScriptEnabled = YES;
        //不通过用户交互，是否可以打开窗口
        _config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        //默认是NO，这个值决定了用内嵌HTML5插放视频还是用本地的全屏控制
        _config.allowsInlineMediaPlayback = YES;
        //音视频的播放不需要用户手势触发、即为自动播放
        _config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
        
        _wkWebView=[[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WINDOW_HEIGHT) configuration:_config];
        _wkWebView.UIDelegate=self;
        _wkWebView.navigationDelegate=self;//WKNavigationDelegate, WKUIDelegate
        _wkWebView.allowsBackForwardNavigationGestures=YES;//webView中使用侧滑手势
        // KVO
        [self.wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:nil];
        [self.wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(title)) options:NSKeyValueObservingOptionNew context:nil];
        [self.wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(canGoBack)) options:NSKeyValueObservingOptionNew context:nil];
    }
    return _wkWebView;
}

/*
 if (@available(iOS 11.0, *)) {
 if ([self respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]){
 _wkWebView.scrollView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
 }
 } else {
 if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
 self.automaticallyAdjustsScrollViewInsets = NO;
 }
 }*/

- (void)wkWebViewFrame:(CGRect)frame{
    [_wkWebView removeFromSuperview];
    [_progressView removeFromSuperview];
    
    _config = [WKWebViewConfiguration new];
    //通过JS与webView内容交互
    _config.userContentController = [WKUserContentController new];
    //初始化偏好设置属性：preferences
    _config.preferences = [WKPreferences new];
    //字体大小 默认0;
    _config.preferences.minimumFontSize = 0;
    //是否支持JavaScript
    _config.preferences.javaScriptEnabled = YES;
    //不通过用户交互，是否可以打开窗口
    _config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    _wkWebView=[[WKWebView alloc]initWithFrame:frame configuration:_config];
    _wkWebView.UIDelegate=self;
    _wkWebView.navigationDelegate=self;//<WKNavigationDelegate, WKUIDelegate>
    _wkWebView.allowsBackForwardNavigationGestures=YES;
    // KVO
    [self.wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:nil];
    [self.wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(title)) options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:_wkWebView];
//    [self.view addSubview:self.progressView];
}

//添加自定义userAgent/需要时打开
- (void)setWebViewUA{
    
    if (@available(iOS 12.0, *)){
        //由于iOS12的UA改为异步，所以不管在js还是客户端第一次加载都获取不到，所以此时需要先设置好再去获取（1、如下设置；2、先在AppDelegate中设置到本地）
        NSString *userAgent = [self.wkWebView valueForKey:@"applicationNameForUserAgent"];
        NSString *newUserAgent = [NSString stringWithFormat:@"%@%@",userAgent,CUSTOM_UA];
        [self.wkWebView setValue:newUserAgent forKey:@"applicationNameForUserAgent"];
    }
    [self.wkWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSString *userAgent = result;
        
        if ([userAgent rangeOfString:CUSTOM_UA].location != NSNotFound) {
            return ;
        }
        NSString *newUserAgent = [userAgent stringByAppendingString:CUSTOM_UA];
        //                DLog(@"%@>>>%@>>>>>",userAgent,newUserAgent);
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent,@"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (@available(iOS 9.0, *)) {
            [self.wkWebView setCustomUserAgent:newUserAgent];
        } else {
            [self.wkWebView setValue:newUserAgent forKey:@"applicationNameForUserAgent"];
        }
    }]; //加载请求必须同步在设置UA的后面
}

- (UIBarButtonItem *)backItem{
    if (!_backItem) {
        _backItem=[[UIBarButtonItem alloc]initWithImage:[[UtilityModule imageNamed:@"navi_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popBackAction)];
    }
    return _backItem;
}

- (UIBarButtonItem *)closeItem{
    if (!_closeItem) {
        _closeItem=[[UIBarButtonItem alloc]initWithImage:[[UtilityModule imageNamed:@"navi_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popCloseAction)];
    }
    return _closeItem;
}

- (void)popBackAction{
    if ([self.wkWebView canGoBack]) {
        [self.wkWebView goBack];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)popCloseAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CustomProgressView *)progressView {
    if (!_progressView) {
//        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView = [[CustomProgressView alloc] init];
        // 高度默认有导航栏且有穿透效果
        _progressView.frame = CGRectMake(0, 0, SCREEN_WIDTH, progressViewHeight);
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.progressTintColor = [UIColor app_mainColor];
    }
    return _progressView;
}

- (void)setProgressColor:(UIColor *)progressColor{
    _progressView.progressTintColor = progressColor;
}



- (void)windowDidBecomeHidden{
    //在网页内打开视频或其他覆盖整个window的操作后状态栏消失问题的处理
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

/// KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.wkWebView) {
        self.progressView.alpha = 1.0;
        BOOL animated = self.wkWebView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:animated];
        if(self.wkWebView.estimatedProgress >= 0.99) {
            [UIView animateWithDuration:0.1 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.progressView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0 animated:NO];
            }];
        }
    } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(title))] && object == self.wkWebView){
        self.title = self.wkWebView.title;
    } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(canGoBack))] && object == self.wkWebView) {
        if (self.wkWebView.canGoBack){
            self.navigationItem.leftBarButtonItems = @[self.backItem,self.closeItem];
        }else{
            self.navigationItem.leftBarButtonItems = @[self.backItem];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
    // 加载完成
    if (!self.wkWebView.loading)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.progressView.alpha = 0.0;
        }];
    }
    [self baseWebViewObserveValueForKeyPath:keyPath ofObject:object change:change context:context];
}

/// KVO Public
- (void)baseWebViewObserveValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    //监听方法
}

/// 加载 web
- (void)setURLRequest:(NSURLRequest *)URLRequest{
    _URLRequest = URLRequest;
    [self.wkWebView loadRequest:URLRequest];
}

/// 加载 web
- (void)setURLString:(NSString *)URLString{
    _URLString = URLString;
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]]];
}

/// 加载 HTML
- (void)setHTMLString:(NSString *)HTMLString{
    _HTMLString = HTMLString;
    [self.wkWebView loadHTMLString:HTMLString baseURL:nil];
}



/// dealloc
- (void)dealloc {
    [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(title))];
    [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(canGoBack))];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//delegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
//    DLog(@"%@>>>>>>>>>>>>>开始导航时>.",webView.URL);
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    DLog(@"%@>>>>>>>>>>>>>结束导航时>.",webView.URL);
}


- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    [CustomAlert showAlertMessageConfirmAddTarget:[UIViewController currentViewController] message:message];
    
    if (completionHandler) {
        completionHandler();
    }
    
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
    [CustomAlert showAlertMessageConfirmAddTarget:[UIViewController currentViewController] message:message];
    
    if (completionHandler) {
        completionHandler(YES);
    }
}

//加载不受信任的https  https在某些情况下造成网页或者网页内的图片无法显示可使用  同时确保 NSAllowsArbitraryLoads设为YES
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
    }
}


//清除web缓存
- (void)removeWebCache {
    
    if (@available(iOS 9.0, *)) {
        //        NSSet *websiteDataTypes= [NSSet setWithArray:@[WKWebsiteDataTypeDiskCache,WKWebsiteDataTypeOfflineWebApplicationCache,WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeLocalStorage,WKWebsiteDataTypeCookies,WKWebsiteDataTypeSessionStorage,WKWebsiteDataTypeIndexedDBDatabases,WKWebsiteDataTypeWebSQLDatabases]];
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            DLog(@"清除缓存完成");
        }];
    } else {
        // Fallback on earlier versions
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
