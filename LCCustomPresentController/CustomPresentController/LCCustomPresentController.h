//
//  LCCustomPresentController.h
//  LCCustomPresentController
//
//  Created by lax on 2022/7/11.
//

#import "LCMenuBarController.h"
#import "LCCustomPresentProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCCustomPresentController : LCMenuBarController

// 初始化高度 默认中
@property (nonatomic) LCCustomPresentHeight defaultHeight;

// 最小高度 默认0
@property (nonatomic) CGFloat minHeight;

// 中等高度 默认0
@property (nonatomic) CGFloat middleHeight;

// 最大高度 默认屏幕高度-状态栏高度
@property (nonatomic) CGFloat maxHeight;

// 顶部圆角 默认0
@property (nonatomic) CGFloat topCornerRadius;

// 惯性速度灵敏度 默认中
@property (nonatomic) LCCustomPresentVelocityRate velocityRate;

// 蒙层颜色
@property (nonatomic, strong) UIColor *maskColor;

@end

NS_ASSUME_NONNULL_END
