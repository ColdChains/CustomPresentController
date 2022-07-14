//
//  LCCustomModalPresentController.m
//  LCCustomPresentController
//
//  Created by lax on 2022/7/11.
//

#import "LCCustomModalPresentController.h"
#import <Masonry/Masonry.h>

#define LCCustomModalPresent_SCREEN_BOUNDS           [UIScreen mainScreen].bounds

#define LCCustomModalPresent_SCREEN_HEIGHT           ([UIScreen mainScreen].bounds.size.height > [UIScreen mainScreen].bounds.size.width ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width)

#define LCCustomModalPresent_SCREEN_WIDTH            ([UIScreen mainScreen].bounds.size.height < [UIScreen mainScreen].bounds.size.width ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width)

#define LCCustomModalPresent_IS_IPHONEX              (LCCustomModalPresent_SCREEN_WIDTH >= 375.0f && LCCustomModalPresent_SCREEN_HEIGHT >= 812.0f)

#define LCCustomModalPresent_STATUSBAR_HEIGHT        (LCCustomModalPresent_IS_IPHONEX ? 44.0f : 20.0f)

@interface LCCustomModalPresentController () <UIGestureRecognizerDelegate>

// 根视图控制器
@property (nonatomic, strong) UIViewController *rootViewController;

// 蒙层
@property (nonatomic, strong) UIView *maskView;

// 点击页面消失
@property (nonatomic, strong) UIView *tapView;

// 根视图容器
@property (nonatomic, strong) UIView *contentView;

// 添加观察者记录
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *observerDictionary;

// 点击手势
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

// 滑动手势
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic) CGFloat originChildViewY;
@property (nonatomic) CGFloat originLocationPointY;
@property (nonatomic) BOOL isTouchScrollView;

@end

@implementation LCCustomModalPresentController

- (UIView *)tapView {
    if (!_tapView) {
        _tapView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    }
    return _tapView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    }
    return _contentView;
}

- (NSMutableDictionary<NSString *,NSNumber *> *)observerDictionary {
    if (!_observerDictionary) {
        _observerDictionary = [NSMutableDictionary dictionary];
    }
    return _observerDictionary;
}

- (void)setMinHeight:(CGFloat)minHeight {
    _minHeight = MAX(minHeight, 0);
    _middleHeight = MAX(minHeight, _middleHeight);
    _maxHeight = MAX(minHeight, _maxHeight);
}

- (void)setMiddleHeight:(CGFloat)middleHeight {
    _middleHeight = MAX(middleHeight, 0);
    _minHeight = MIN(middleHeight, _minHeight);
    _maxHeight = MAX(middleHeight, _maxHeight);
}

- (void)setMaxHeight:(CGFloat)maxHeight {
    _maxHeight = MAX(maxHeight, 0);
    _minHeight = MIN(maxHeight, _minHeight);
    _middleHeight = MIN(maxHeight, _middleHeight);
}

- (void)setMaskColor:(UIColor *)maskColor {
    _maskColor = maskColor;
    self.maskView.backgroundColor = maskColor;
}

- (void)setTopView:(UIView *)topView {
    _topView = topView;
    if (!self.isViewLoaded) { return; }
    [self.contentView addSubview:self.topView];
    [self layoutTopView];
    [self layoutChildView];
}

- (void)setRootViewController:(UIViewController *)rootViewController {
    [_rootViewController.view removeFromSuperview];
    [_rootViewController removeFromParentViewController];
    [self removeObserverWithViewController:_rootViewController];
    
    _rootViewController = rootViewController;
    
    if (!self.isViewLoaded) { return; }
    if (rootViewController) {
        [self addChildViewController:rootViewController];
        [self.contentView addSubview:rootViewController.view];
        [self addObserverWithViewController:rootViewController];
    }
    [self layoutTopView];
    [self layoutChildView];
}

- (void)layoutTopView {
    if (self.topView) {
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(self.topView.frame.size.height);
        }];
    }
}

- (void)layoutChildView {
    if (self.rootViewController.view.superview) {
        [self.rootViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.top.mas_equalTo(self.topView.mas_bottom ?: self.contentView);
        }];
    }
}

- (void)addObserverWithViewController:(UIViewController *)vc {
    UIScrollView *scrollView = [self scrollViewWithViewController:self.rootViewController];
    if (scrollView) {
        if (scrollView && ![self.observerDictionary objectForKey:[NSString stringWithFormat:@"%p", scrollView]]) {
            [self.observerDictionary setValue:@(1) forKey:[NSString stringWithFormat:@"%p", scrollView]];
            [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        }
    }
}

- (void)removeObserverWithViewController:(UIViewController *)vc {
    UIScrollView *scrollView = [self scrollViewWithViewController:self.rootViewController];
    if (scrollView) {
        if ([self.observerDictionary objectForKey:[NSString stringWithFormat:@"%p", scrollView]]) {
            [self.observerDictionary removeObjectForKey:[NSString stringWithFormat:@"%p", scrollView]];
            [scrollView removeObserver:self forKeyPath:@"contentOffset"];
        }
    }
}

// MARK: - 系统属性管理

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.rootViewController ?: super.childViewControllerForStatusBarStyle;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.rootViewController ?: super.childViewControllerForStatusBarStyle;
}

- (UIViewController *)childViewControllerForHomeIndicatorAutoHidden {
    return self.rootViewController ?: super.childViewControllerForStatusBarStyle;
}

- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationCustom;
}

- (BOOL)shouldAutorotate {
    return self.rootViewController ? self.rootViewController.shouldAutorotate : super.shouldAutorotate;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.rootViewController ? self.rootViewController.preferredInterfaceOrientationForPresentation : super.preferredInterfaceOrientationForPresentation;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.rootViewController ? self.rootViewController.supportedInterfaceOrientations : super.supportedInterfaceOrientations;
}

// MARK: - 系统方法

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super init];
    if (self) {
        self.rootViewController = rootViewController;
        
        self.defaultHeight = LCCustomModalPresentHeightMax;
        self.minHeight = 0;
        self.middleHeight = 0;
        self.maxHeight = LCCustomModalPresent_SCREEN_HEIGHT - LCCustomModalPresent_STATUSBAR_HEIGHT;
        
        self.maskColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return self;
}

- (void)dealloc {
    [self removeObserverWithViewController:self.rootViewController];
}

- (UIScrollView *)scrollViewWithViewController:(UIViewController *)vc {
    if ([vc conformsToProtocol:@protocol(LCCustomModalPresentProtocol)]) {
        if ([vc respondsToSelector:@selector(customModalPresentScrollView)]) {
            return [(id<LCCustomModalPresentProtocol>)vc customModalPresentScrollView];
        }
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tapView];
    [self.tapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(LCCustomModalPresent_SCREEN_HEIGHT);
    }];
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.tapView addGestureRecognizer:self.tapGesture];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    self.panGesture.delegate = self;
    [self.contentView addGestureRecognizer:self.panGesture];
    
    self.topView = _topView;
    
    self.rootViewController = _rootViewController;
    
    CGFloat h = self.defaultHeight == LCCustomModalPresentHeightMin ? self.minHeight : self.defaultHeight == LCCustomModalPresentHeightMax ? self.maxHeight : self.middleHeight;
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(h);
    }];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(self.topCornerRadius, self.topCornerRadius)];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    self.contentView.layer.mask = layer;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.maskView) {
        self.maskView = UIApplication.sharedApplication.keyWindow.subviews.lastObject;
        [UIView animateWithDuration:.25 animations:^{
            self.maskView.backgroundColor = self.maskColor;
        }];
    }
}

// MARK: -

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [UIView animateWithDuration:.25 animations:^{
        UIApplication.sharedApplication.keyWindow.subviews.lastObject.backgroundColor = [UIColor clearColor];
    }];
    [super dismissViewControllerAnimated:flag completion:completion];
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)panAction:(UIPanGestureRecognizer *)sender {
    if (!self.rootViewController) {
        return;
    }
    
    UIView *childView = self.contentView;
    CGFloat childViewY = childView.frame.origin.y;
    CGFloat locationPointY = [sender locationInView:self.view].y;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        self.originChildViewY = childViewY;
        self.originLocationPointY = locationPointY;
        
        UIScrollView *subScrollView = [self scrollViewWithViewController:self.rootViewController];
        CGPoint point = [subScrollView.panGestureRecognizer locationInView:subScrollView.superview];
        self.isTouchScrollView = NO;
        if (point.y > CGRectGetMinY(subScrollView.frame) && point.y < CGRectGetMaxY(subScrollView.frame)) {
            self.isTouchScrollView = YES;
        }
        
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        
        // 拖拽滚动视图时不处理
        if ([self scrollViewWithViewController:self.rootViewController] && self.isTouchScrollView) {
            return;
        }
        
        CGFloat y = self.originChildViewY + locationPointY - self.originLocationPointY;
        // todo:
        y = MAX(y, LCCustomModalPresent_SCREEN_HEIGHT - self.maxHeight);
        y = MIN(y, LCCustomModalPresent_SCREEN_HEIGHT - self.minHeight / 2);
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(LCCustomModalPresent_SCREEN_HEIGHT - y);
        }];
        
    } else {
        
        self.isTouchScrollView = NO;
        
        UIScrollView *scrollView = [self scrollViewWithViewController:self.rootViewController];
        // 滚动视图有偏移量时不处理
        if (scrollView && scrollView.contentOffset.y > 0) {
            return;
        }
        
        CGPoint velocityPoint = [sender velocityInView:sender.view.superview];
        
        childViewY += velocityPoint.y / 12;
        CGFloat topLine = LCCustomModalPresent_SCREEN_HEIGHT - self.maxHeight + (self.maxHeight - self.middleHeight) / 2;
        CGFloat bottomLine = LCCustomModalPresent_SCREEN_HEIGHT - self.middleHeight + (self.middleHeight - self.minHeight) / 2;
        CGFloat y = -1;
        
        if (childViewY < topLine) {
            y = LCCustomModalPresent_SCREEN_HEIGHT - self.maxHeight;
        } else if (childViewY < bottomLine) {
            y = LCCustomModalPresent_SCREEN_HEIGHT - self.middleHeight;
        } else if (childViewY < LCCustomModalPresent_SCREEN_HEIGHT - self.minHeight / 2) {
            y = LCCustomModalPresent_SCREEN_HEIGHT - self.minHeight;
        }
        
        if (y >= 0 && y < LCCustomModalPresent_SCREEN_HEIGHT) {
            UIView *childView = self.contentView;
            if (childView.frame.size.height > LCCustomModalPresent_SCREEN_HEIGHT - y) { // 向下滑
                [UIView animateWithDuration:0.35 delay:0.0 usingSpringWithDamping:0.75 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(LCCustomModalPresent_SCREEN_HEIGHT - y);
                    }];
                    [self.view layoutIfNeeded];
                } completion:^(BOOL finished) {}];
            } else { // 向上滑
                [UIView animateWithDuration:0.35 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(LCCustomModalPresent_SCREEN_HEIGHT - y);
                    }];
                    [self.view layoutIfNeeded];
                } completion:^(BOOL finished) {}];
            }
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"] && [object isKindOfClass:UIScrollView.class]) {

        CGPoint newPoint = [change[@"new"] CGPointValue];
        CGPoint oldPoint = [change[@"old"] CGPointValue];
        UIView *childView = self.contentView;
        UIScrollView *scrollView = (UIScrollView *)object;
        
        if (newPoint.y == oldPoint.y ) {
            return;
        }
        
        if (childView.layer.animationKeys.count > 0) {
            [scrollView setContentOffset:CGPointZero animated:NO];
            return;
        }
        
        if (self.panGesture.state != UIGestureRecognizerStateChanged) {
            return;
        }
        
        CGFloat y = childView.frame.origin.y - newPoint.y;
        if (newPoint.y > 0) { // 向上滑
            if (y > LCCustomModalPresent_SCREEN_HEIGHT - self.maxHeight && (scrollView.contentOffset.y - newPoint.y <= 0)) {
                scrollView.contentOffset = CGPointZero;
                y = MAX(LCCustomModalPresent_SCREEN_HEIGHT - self.maxHeight, y);
                [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(LCCustomModalPresent_SCREEN_HEIGHT - y);
                }];
            }
        } else if (newPoint.y < 0) { // 向下滑
            scrollView.contentOffset = CGPointMake(0, 0);
            y = MAX(LCCustomModalPresent_SCREEN_HEIGHT - self.maxHeight, y);
            [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(LCCustomModalPresent_SCREEN_HEIGHT - y);
            }];
        }
        
    }
}

// MARK: - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
