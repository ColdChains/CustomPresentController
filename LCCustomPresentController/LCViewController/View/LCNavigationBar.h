//
//  LCNavigationBar.h
//  LCViewController
//
//  Created by lax on 2022/5/18.
//

#import <UIKit/UIKit.h>

@protocol LCNavigationBarDelegate <NSObject>

@optional

// 点击返回按钮
- (void)didSelectLeftItem;

// 点击关闭按钮
- (void)didSelectCloseItem;

// 点击右侧按钮
- (void)didSelectRightItem;

@end

@interface LCNavigationBar : UIView

// 代理
@property(nonatomic, weak) id<LCNavigationBarDelegate> delegate;

// 返回按钮 默认nil
@property(nonatomic, strong) UIButton *leftItem;

// 关闭按钮 默认nil
@property(nonatomic, strong) UIButton *closeItem;

// 右侧按钮 默认nil
@property(nonatomic, strong) UIButton *rightItem;

// 标题 默认显示
@property(nonatomic, strong) UILabel *titleLabel;

// 自定义标题视图 默认nil
@property(nonatomic, strong) UIView *titleView;

// 分割线 默认显示
@property(nonatomic, strong) UIView *dividerView;

// 右侧按钮右侧的间距
@property(nonatomic) CGFloat rightItemMargin;

// 设置返回按钮
- (void)addLeftItem;

// 设置关闭按钮
- (void)addCloseItem;

@end
