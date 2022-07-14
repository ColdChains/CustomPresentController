//
//  UIViewController+NavigationBar.h
//  LCViewController
//
//  Created by lax on 2022/7/13.
//

#import <UIKit/UIKit.h>
#import "LCNavigationBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (NavigationBar) <LCNavigationBarDelegate>

// 是否显示自定义导航栏 默认NO
@property (nonatomic, strong, nullable) LCNavigationBar *navigationBar;

// 是否显示导航栏 默认NO
@property (nonatomic) BOOL showNavigationBar;

// 是否显示系统导航栏 默认NO
@property (nonatomic) BOOL showSystemNavagationBar;

// 是否禁用侧滑返回 默认NO
@property (nonatomic) BOOL disablePopGestureRecognizer;

// 返回/关闭事件
- (void)backAction;

@end

NS_ASSUME_NONNULL_END
