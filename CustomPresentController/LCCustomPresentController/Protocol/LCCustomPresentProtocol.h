//
//  LCCustomPresentProtocol.h
//  LCCustomPresentController
//
//  Created by lax on 2022/7/12.
//

#import <MenuBarController/MenuBarController.h>

NS_ASSUME_NONNULL_BEGIN

@class LCCustomPresentController;

typedef NS_ENUM(NSUInteger, LCCustomPresentHeight) {
    LCCustomPresentHeightMin, // 低
    LCCustomPresentHeightMiddle, // 中
    LCCustomPresentHeightMax, // 高
};

typedef NS_ENUM(NSUInteger, LCCustomPresentVelocityRate) {
    LCCustomPresentVelocityRateLow = 20, // 低
    LCCustomPresentVelocityRateNormal = 15, // 中
    LCCustomPresentVelocityRateHigh = 10, // 高
};

@protocol LCCustomPresentDataSource <LCMenuBarProtocol>

@optional

// 初始化高度 默认中
- (LCCustomPresentHeight)customPresentDefaultHeight;

// 最小高度 默认0
- (CGFloat)customPresentMinHeight;

// 中等高度 默认0
- (CGFloat)customPresentMiddleHeight;

// 最大高度 默认屏幕高度-状态栏高度
- (CGFloat)customPresentMaxHeight;

// 顶部圆角 默认0
- (CGFloat)customPresentTopCornerRadius;

// 惯性速度灵敏度 默认中
- (LCCustomPresentVelocityRate)customPresentVelocityRate;

// 蒙层颜色
- (UIColor *)customPresentMaskColor;

@end

@protocol LCCustomPresentDelegate <LCMenuBarDelegate>

@optional

// 页面初始化完成
- (void)customPresentControllerViewDidLoad:(LCCustomPresentController *)vc;

@end

NS_ASSUME_NONNULL_END
