//
//  LCCustomModalPresentController.h
//  LCCustomPresentController
//
//  Created by lax on 2022/7/11.
//

#import <UIKit/UIKit.h>
#import "LCCustomModalPresentProtocol.h"

typedef NS_ENUM(NSUInteger, LCCustomModalPresentHeight) {
    LCCustomModalPresentHeightMin,
    LCCustomModalPresentHeightMiddle,
    LCCustomModalPresentHeightMax,
};

NS_ASSUME_NONNULL_BEGIN

@interface LCCustomModalPresentController : UIViewController

// 根视图控制器
@property (nonatomic, strong, readonly) UIViewController *rootViewController;

// 根视图容器
@property (nonatomic, strong, readonly) UIView *contentView;

// 点击手势
@property (nonatomic, strong, readonly) UITapGestureRecognizer *tapGesture;

// 滑动手势
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGesture;

// 默认展示高度
@property (nonatomic) LCCustomModalPresentHeight defaultHeight;

// 最小高度 默认0
@property (nonatomic) CGFloat minHeight;

// 中等高度 默认0
@property (nonatomic) CGFloat middleHeight;

// 最大高度 默认屏幕高度-状态栏高度
@property (nonatomic) CGFloat maxHeight;

// 顶部圆角 默认0
@property (nonatomic) CGFloat topCornerRadius;

// 蒙层颜色
@property (nonatomic, strong) UIColor *maskColor;

// 顶部视图
@property (nonatomic, strong) UIView *topView;

/// 初始化
/// @param rootViewController 根视图控制器
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController;

@end

NS_ASSUME_NONNULL_END
