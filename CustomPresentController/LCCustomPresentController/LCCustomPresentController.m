//
//  LCCustomPresentController.m
//  LCCustomPresentController
//
//  Created by lax on 2022/7/11.
//

#import "LCCustomPresentController.h"

#define LCCustomPresent_SCREEN_BOUNDS           [UIScreen mainScreen].bounds

#define LCCustomPresent_SCREEN_HEIGHT           ([UIScreen mainScreen].bounds.size.height > [UIScreen mainScreen].bounds.size.width ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width)

#define LCCustomPresent_SCREEN_WIDTH            ([UIScreen mainScreen].bounds.size.height < [UIScreen mainScreen].bounds.size.width ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width)

#define LCCustomPresent_IS_IPHONEX              (LCCustomPresent_SCREEN_WIDTH >= 375.0f && LCCustomPresent_SCREEN_HEIGHT >= 812.0f)

#define LCCustomPresent_STATUSBAR_HEIGHT        (LCCustomPresent_IS_IPHONEX ? 44.0f : 20.0f)

@interface LCCustomPresentController ()

// 蒙层
@property (nonatomic, strong) UIView *maskView;

// 是否拖拽子视图
@property (nonatomic) BOOL pointInSubView;

@end

@implementation LCCustomPresentController

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

- (void)setVelocityRate:(LCCustomPresentVelocityRate)velocityRate {
    velocityRate = MAX(velocityRate, 1);
    velocityRate = MIN(velocityRate, 100);
    _velocityRate = velocityRate;
}

- (void)setMaskColor:(UIColor *)maskColor {
    _maskColor = maskColor;
    self.maskView.backgroundColor = maskColor;
}

- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationCustom;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.defaultHeight = LCCustomPresentHeightMax;
        self.minHeight = 0;
        self.middleHeight = 0;
        self.maxHeight = LCCustomPresent_SCREEN_HEIGHT - LCCustomPresent_STATUSBAR_HEIGHT;
        self.velocityRate = LCCustomPresentVelocityRateNormal;
        self.maskColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return self;
}

- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers
{
    self = [super initWithViewControllers:viewControllers];
    if (self) {
        self.defaultHeight = LCCustomPresentHeightMax;
        self.minHeight = 0;
        self.middleHeight = 0;
        self.maxHeight = LCCustomPresent_SCREEN_HEIGHT - LCCustomPresent_STATUSBAR_HEIGHT;
        self.velocityRate = LCCustomPresentVelocityRateNormal;
        self.maskColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, LCCustomPresent_SCREEN_HEIGHT)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [headerView addGestureRecognizer:tapGesture];
    self.headerView = headerView;
    
    // todo: 切换控制器需要刷新
    [self updateDataSource];
}

- (void)updateDataSource {
    if ([self.currentViewController respondsToSelector:@selector(customPresentDefaultHeight)]) {
        self.defaultHeight = [(id<LCCustomPresentDataSource>)self.currentViewController customPresentDefaultHeight];
    }
    if ([self.currentViewController respondsToSelector:@selector(customPresentMinHeight)]) {
        self.minHeight = [(id<LCCustomPresentDataSource>)self.currentViewController customPresentMinHeight];
    }
    if ([self.currentViewController respondsToSelector:@selector(customPresentMiddleHeight)]) {
        self.middleHeight = [(id<LCCustomPresentDataSource>)self.currentViewController customPresentMiddleHeight];
    }
    if ([self.currentViewController respondsToSelector:@selector(customPresentMaxHeight)]) {
        self.maxHeight = [(id<LCCustomPresentDataSource>)self.currentViewController customPresentMaxHeight];
    }
    if ([self.currentViewController respondsToSelector:@selector(customPresentTopCornerRadius)]) {
        self.topCornerRadius = [(id<LCCustomPresentDataSource>)self.currentViewController customPresentTopCornerRadius];
    }
    if ([self.currentViewController respondsToSelector:@selector(customPresentVelocityRate)]) {
        self.velocityRate = [(id<LCCustomPresentDataSource>)self.currentViewController customPresentVelocityRate];
    }
    if ([self.currentViewController respondsToSelector:@selector(customPresentMaskColor)]) {
        self.maskColor = [(id<LCCustomPresentDataSource>)self.currentViewController customPresentMaskColor];
    }
    CGFloat h = self.defaultHeight == LCCustomPresentHeightMin ? self.minHeight : self.defaultHeight == LCCustomPresentHeightMax ? self.maxHeight : self.middleHeight;
    [self.verticalScrollView setContentOffset:CGPointMake(0, h) animated:YES];
    self.headerScrollTopMargin = LCCustomPresent_SCREEN_HEIGHT - self.maxHeight;
}

- (void)pageControllerDidLoadViewController:(UIViewController *)vc {
    if ([vc respondsToSelector:@selector(customPresentControllerViewDidLoad:)]) {
        [(id<LCCustomPresentDelegate>)vc customPresentControllerViewDidLoad:self];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.menuBar) {
        [self clipsView:self.menuBar topCornerRadius:self.topCornerRadius];
    } else {
        [self clipsView:self.horizontalScrollView topCornerRadius:self.topCornerRadius];
    }
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

- (void)tapAction:(UITapGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clipsView:(UIView *)view topCornerRadius:(CGFloat)topCornerRadius {
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(topCornerRadius, topCornerRadius)];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    view.layer.mask = layer;
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [UIView animateWithDuration:.25 animations:^{
        self.maskView.backgroundColor = [UIColor clearColor];
    }];
    [super dismissViewControllerAnimated:flag completion:completion];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    if (scrollView == self.verticalScrollView) {
        // 向上拖拽顶部有弹性效果
//        if (self.pointInSubView && scrollView.contentOffset.y > self.maxHeight) {
        // 解决惯性过大时上滑会超过最大高度
        if (scrollView.contentOffset.y >= self.maxHeight) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, self.maxHeight);
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [super scrollViewWillBeginDragging:scrollView];
    if (scrollView == self.verticalScrollView) {
        self.pointInSubView = NO;
        UIScrollView *subScrollView = self.currentScrollView;
        if (subScrollView) {
            CGPoint point = [scrollView.panGestureRecognizer locationInView:subScrollView.superview];
            if (point.y > CGRectGetMinY(subScrollView.frame) && point.y < CGRectGetMaxY(subScrollView.frame)) {
                self.pointInSubView = YES;
            }
        }
        self.menuCanDrag = !self.pointInSubView;
        // 向上拖拽顶部有弹性效果
        // 避免set方法导致layout子视图
//        if ([self respondsToSelector:@selector(updateHeaderScrollTopMargin:)]) {
//            [self performSelector:@selector(updateHeaderScrollTopMargin:) withObject:@(self.pointInSubView ? LCCustomPresent_SCREEN_HEIGHT - self.maxHeight : 0)];
//        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    
    if (scrollView != self.verticalScrollView) {
        return;
    }
    
    CGPoint velocityPoint = [scrollView.panGestureRecognizer velocityInView:scrollView.panGestureRecognizer.view.superview];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (decelerate) {
            [scrollView setContentOffset:scrollView.contentOffset animated:NO];
        }
        
        CGFloat h = scrollView.contentOffset.y;
        if (scrollView.contentOffset.y < self.maxHeight) {
            h -= velocityPoint.y / self.velocityRate;
        }
        
        if (h > self.middleHeight + (self.maxHeight - self.middleHeight) / 2) {
            h = self.maxHeight;
        } else if (h > self.minHeight + (self.middleHeight - self.minHeight) / 2) {
            h = self.middleHeight;
        } else if (h > self.minHeight / 2) {
            h = self.minHeight;
        } else {
            h = 0;
        }
        
        if (h > 0) {
            [UIView animateWithDuration:0.35 delay:0.0 usingSpringWithDamping:0.75 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                // 子视图有偏移量时 先拖拽顶部调整高度 再滑动子视图 高度会卡在半路
                if (scrollView.contentOffset.y < self.maxHeight && [scrollView.panGestureRecognizer velocityInView:scrollView.panGestureRecognizer.view.superview].y < 0) {
                    self.notHandleVerticalScrollView = YES;
                }
                scrollView.contentOffset = CGPointMake(0, h);
            } completion:^(BOOL finished) {
                self.notHandleVerticalScrollView = NO;
            }];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    });
    
}

@end
