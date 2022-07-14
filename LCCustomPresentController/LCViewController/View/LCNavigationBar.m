//
//  LCNavigationBar.m
//  LCViewController
//
//  Created by lax on 2022/5/18.
//

#import "LCNavigationBar.h"
#import "LCBaseHeader.h"

@interface LCNavigationBar ()

@property (nonatomic) CGFloat buttonHeight;

@end

@implementation LCNavigationBar

- (UIView *)dividerView {
    if (!_dividerView) {
        _dividerView = [[UIView alloc] init];
        _dividerView.backgroundColor = LCBaseConfig.shared.dividerColor;
    }
    return _dividerView;
}

- (void)setLeftItem:(UIButton *)leftItem {
    [_leftItem removeFromSuperview];
    _leftItem = leftItem;
    if (leftItem) {
        [self addSubview:leftItem];
        [leftItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.bottom.mas_equalTo(self).offset(-(self.buttonHeight - (leftItem.bounds.size.height ?: self.buttonHeight)) / 2);
            make.width.mas_equalTo(leftItem.bounds.size.width ?: self.buttonHeight);
            make.height.mas_equalTo(leftItem.bounds.size.height ?: self.buttonHeight);
        }];
    }
    self.closeItem = _closeItem;
}

- (void)setCloseItem:(UIButton *)closeItem {
    [_closeItem removeFromSuperview];
    _closeItem = closeItem;
    if (closeItem) {
        [self addSubview:closeItem];
        [closeItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_leftItem.mas_right ?: self);
            make.bottom.mas_equalTo(self).offset(-(self.buttonHeight - (closeItem.bounds.size.height ?: self.buttonHeight)) / 2);
            make.width.mas_equalTo(closeItem.bounds.size.width ?: self.buttonHeight);
            make.height.mas_equalTo(closeItem.bounds.size.height ?: self.buttonHeight);
        }];
    }
}

- (void)setRightItem:(UIButton *)rightItem {
    [_rightItem removeFromSuperview];
    _rightItem = rightItem;
    if (rightItem) {
        [self addSubview:rightItem];
        [rightItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-self.rightItemMargin);
            make.bottom.mas_equalTo(self).offset(-(self.buttonHeight - (rightItem.bounds.size.height ?: self.buttonHeight)) / 2);
            make.width.mas_equalTo(rightItem.bounds.size.width ?: self.buttonHeight);
            make.height.mas_equalTo(rightItem.bounds.size.height ?: self.buttonHeight);
        }];
    }
    self.titleView = _titleView;
}

- (void)setTitleView:(UIView *)titleView {
    [_titleView removeFromSuperview];
    _titleView = titleView;
    if (titleView) {
        [self addSubview:titleView];
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self);
            make.height.mas_equalTo(self.buttonHeight);
            make.left.mas_greaterThanOrEqualTo(_closeItem.mas_right ?: _leftItem.mas_right ?: self);
            make.right.mas_lessThanOrEqualTo(_rightItem.mas_left ?: self);
            make.centerX.mas_equalTo(self);
        }];
    }
}

- (void)setRightItemMargin:(CGFloat)rightItemMargin {
    _rightItemMargin = rightItemMargin;
    [_rightItem mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-rightItemMargin);
    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, LCBASE_SCREEN_WIDTH, LCBASE_STATUSBAR_HEIGHT + 44)];
    if (self) {
        self.buttonHeight = self.frame.size.height - LCBASE_STATUSBAR_HEIGHT;
        self.backgroundColor = LCBaseConfig.shared.navigationBarColor;
        [self initView];
    }
    return self;
}

- (void)initView {
    [self addSubview:self.dividerView];
    [self.dividerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.font = LCBaseConfig.shared.navigationTitleFont;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = LCBaseConfig.shared.navigationTitleColor;
    self.titleView = _titleLabel;
    
}

// 设置返回按钮
- (void)addLeftItem {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    button.titleLabel.font = LCBaseConfig.shared.navigationTitleFont;
    [button setTitleColor:LCBaseConfig.shared.navigationTitleColor forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:LCBaseConfig.shared.backButtonImageName] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.leftItem = button;
}

// 设置关闭按钮 默认隐藏
- (void)addCloseItem {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    button.titleLabel.font = LCBaseConfig.shared.navigationTitleFont;
    [button setImage:[UIImage imageNamed:LCBaseConfig.shared.closeButtonImageName] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeItemAction) forControlEvents:UIControlEventTouchUpInside];
    button.hidden = YES;
    self.closeItem = button;
}

- (void)leftItemAction {
    if ([self.delegate respondsToSelector:@selector(didSelectLeftItem)]) {
        [self.delegate didSelectLeftItem];
    }
}

- (void)closeItemAction {
    if ([self.delegate respondsToSelector:@selector(didSelectCloseItem)]) {
        [self.delegate didSelectCloseItem];
    }
}

- (void)rightItemAction {
    if ([self.delegate respondsToSelector:@selector(didSelectRightItem)]) {
        [self.delegate didSelectRightItem];
    }
}

@end
