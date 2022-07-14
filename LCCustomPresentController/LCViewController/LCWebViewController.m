//
//  LCWebViewController.m
//  LCViewController
//
//  Created by lax on 2022/5/18.
//

#import "LCWebViewController.h"
#import "LCBaseHeader.h"

@interface LCWebViewController ()

// Web请求
@property(nonatomic, strong) NSURLRequest *request;

@end

@implementation LCWebViewController

- (void)setWebViewTopMargin:(CGFloat)webViewTopMargin {
    _webViewTopMargin = webViewTopMargin;
    if (!self.isViewLoaded) { return; }
    if (self.webView && self.webView.superview) {
        [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(webViewTopMargin);
        }];
    }
    if (self.progressView && self.progressView.superview) {
        [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(webViewTopMargin);
        }];
    }
}

- (void)setAutoTitle:(BOOL)autoTitile {
    _autoTitle = autoTitile;
    if (!self.isViewLoaded) { return; }
    if (!self.showNavigationBar) { return; }
    if (_autoTitle) {
        [self.navigationBar addCloseItem];
    } else {
        self.navigationBar.closeItem = nil;
    }
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showNavigationBar = YES;
        self.webViewTopMargin = LCBASE_STATUSBAR_HEIGHT + 44;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
}

//
- (void)initData {
    // 添加监听
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    self.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    [self reloadData];
}

//
- (void)initUI {
    self.showNavigationBar = super.showNavigationBar;
    self.webViewTopMargin = _webViewTopMargin;
    self.autoTitle = _autoTitle;
    self.navigationBar.titleLabel.text = _titleString;
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(self.webViewTopMargin);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
    
    [self.view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(self.webViewTopMargin);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(2);
    }];
    
    if (self.scrollViewAdjustmentNever) {
        if (@available(iOS 11.0, *)) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
}

- (void)setScrollViewAdjustmentNever:(BOOL)scrollViewAdjustmentNever {
    if (scrollViewAdjustmentNever && _webView) {
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    _scrollViewAdjustmentNever = scrollViewAdjustmentNever;
}

// 转屏通知
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if (!self.navigationBar) {
        return;
    }
    if (UIDevice.currentDevice.orientation == UIInterfaceOrientationPortrait) {
        //竖屏
        [self.navigationBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(LCBASE_STATUSBAR_HEIGHT + 44);
        }];
    } else {
        //横屏
        [self.navigationBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(44);
        }];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat value = [[change objectForKey:@"new"] floatValue];
        if (value >= 1) {
            __weak typeof(self) weakSelf = self;
            [self.progressView setProgress:value animated:YES completion:^(BOOL finished) {
                [weakSelf.progressView setHidden:YES];
                [weakSelf.progressView setProgress:0 animated:NO];
            }];
        } else {
            [self.progressView setProgress:value animated:YES];
        }
    } else if ([keyPath isEqualToString:@"title"] && self.autoTitle == YES) {
        self.navigationBar.titleLabel.text = self.webView.title;
    } else if ([keyPath isEqualToString:@"canGoBack"] && self.autoTitle == YES) {
        self.disablePopGestureRecognizer = self.webView.canGoBack;
        [self.navigationBar.closeItem setHidden:self.webView.canGoBack == NO];
    }
}


// 开始请求
- (void)reloadData {
    NSString *encodeUrlStr = [_urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    encodeUrlStr = [encodeUrlStr stringByReplacingOccurrencesOfString:@"/%23" withString:@"/#"];
    self.request = [NSURLRequest requestWithURL:[NSURL URLWithString:encodeUrlStr] cachePolicy: self.cachePolicy timeoutInterval:20];
    if (self.request.URL.absoluteString.length > 0) {
        [self.webView loadRequest:self.request];
    }
}

- (void)didSelectLeftItem {
    if (_autoTitle == YES && _webView.canGoBack == YES) {
        [_webView goBack];
    } else {
        [self backAction];
    }
}

- (void)didSelectCloseItem {
    [self backAction];
}

#pragma mark - WKNavigationDelegate

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}

// 当内容开始到达时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

// 页面加载完成之后调用 自定义方法名 子类主动调用一下这个方法
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}

// 跳转的方法有三种
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}

// 加载https链接
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

//当webView的web内容进程被终止时调用。(iOS 9.0之后)
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0)) {
    
}

#pragma mark - WKUIDelegate

// 在js中调用alert函数时，会调用该方法。
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

// 在js中调用confirm函数时，会调用该方法
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"message:message?:@""preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确定"style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

// 在js中调用prompt函数时，会调用该方法
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成"style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
}

# pragma mark lazy load
- (WKWebView *)webView {
    if (_webView == nil) {
        WKWebViewConfiguration *config = self.webConfiguration;
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.opaque = NO;
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.customUserAgent = @"lightchain"; // 百度可能是处理了userAgent 自定义后无法打开百度
        // _webView.backgroundColor = BackgroundColor;
        // 设置没有弹性
        // _webView.scrollView.bounces = NO;
    }
    return _webView;
}

- (WKWebViewConfiguration *)webConfiguration {
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    config.userContentController = userContentController;
    config.allowsInlineMediaPlayback = YES;
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 12.0;
    config.preferences = preferences;
    
    return config;
}


- (LCProgressBar *)progressView {
    if (!_progressView) {
        _progressView = [[LCProgressBar alloc] init];
    }
    return _progressView;
}

- (void)dealloc {
    // 用到了weakProxy 不能用self
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"canGoBack"];
    [_webView removeObserver:self forKeyPath:@"title"];
}


@end
