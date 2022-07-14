//
//  LCWebViewController.h
//  LCViewController
//
//  Created by lax on 2022/5/18.
//

#import "LCViewController.h"
#import "UIViewController+NavigationBar.h"
#import <WebKit/WebKit.h>

#import "LCNavigationBar.h"
#import "LCProgressBar.h"

@interface LCWebViewController : LCViewController <WKNavigationDelegate, WKUIDelegate>

// 链接地址
@property(nonatomic, copy) NSString *urlString;

// 标题
@property(nonatomic, copy) NSString *titleString;

// 是否取Web页面内的标题 默认NO
@property(nonatomic) BOOL autoTitle;

// webView/progressView相对于self.view顶部间距 默认导航栏的高度 默认展示导航栏
@property(nonatomic) CGFloat webViewTopMargin;

//
@property (nonatomic) NSURLRequestCachePolicy cachePolicy;


// 自动计算滚动视图的内容边距 默认NO
@property(nonatomic) BOOL scrollViewAdjustmentNever;
// 网页加载进度条
@property(nonatomic, strong) LCProgressBar *progressView;

@property(nonatomic, strong) WKWebView *webView;

// 埋点数据 key： 埋点key  value：埋点value
@property (nonatomic, strong) NSDictionary *trackDict;

//
@property (nonatomic, strong) WKWebViewConfiguration *webConfiguration;

// 刷新数据
- (void)reloadData;

@end
