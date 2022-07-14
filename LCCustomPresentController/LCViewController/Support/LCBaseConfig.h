//
//  LCBaseConfig.h
//  LCViewController
//
//  Created by lax on 2022/5/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCBaseConfig : NSObject

// 页面背景色 默认whiteColor
@property (nonatomic, strong) UIColor *backgroundColor;

// 导航栏颜色 默认whiteColor
@property (nonatomic, strong) UIColor *navigationBarColor;

// 导航栏标题颜色 默认darkTextColor
@property (nonatomic, strong) UIColor *navigationTitleColor;

// 导航栏分割线颜色 默认F8F8F8
@property (nonatomic, strong) UIColor *dividerColor;

// 进度条颜色 默认blueColor
@property (nonatomic, strong) UIColor *progressColor;

// 导航栏标题字体 默认16
@property (nonatomic, strong) UIFont *navigationTitleFont;

// 导航栏按钮字体 默认14
@property (nonatomic, strong) UIFont *navigationButtonFont;

// 返回按钮图片
@property (nonatomic, copy) NSString *backButtonImageName;

// 关闭按钮图片
@property (nonatomic, copy) NSString *closeButtonImageName;

// 是否打印日志 默认NO release模式不起作用
@property (nonatomic) BOOL logEnabled;

+ (instancetype)shared;

@end

NS_ASSUME_NONNULL_END
