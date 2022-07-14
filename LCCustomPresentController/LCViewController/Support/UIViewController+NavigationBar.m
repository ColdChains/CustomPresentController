//
//  UIViewController+NavigationBar.m
//  LCViewController
//
//  Created by lax on 2022/7/13.
//

#import "UIViewController+NavigationBar.h"
#import "objc/runtime.h"
#import "LCBaseHeader.h"

@implementation UIViewController (NavigationBar)

static char navigationBarKey = 'k';
static char showNavigationBarKey = 'k';
static char showSystemNavagationBarKey = 'k';
static char disablePopGestureRecognizerKey = 'k';

- (LCNavigationBar *)navigationBar {
    return objc_getAssociatedObject(self, &navigationBarKey);
}

- (void)setNavigationBar:(LCNavigationBar *)navigationBar {
    objc_setAssociatedObject(self, &navigationBarKey, navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)showNavigationBar {
    return objc_getAssociatedObject(self, &showNavigationBarKey);
}

- (void)setShowNavigationBar:(BOOL)showNavigationBar {
    objc_setAssociatedObject(self, &showNavigationBarKey, @(showNavigationBar), OBJC_ASSOCIATION_ASSIGN);
    if (showNavigationBar) {
        [self.navigationBar removeFromSuperview];
        self.navigationBar = [[LCNavigationBar alloc] init];
        self.navigationBar.delegate = self;
        [self.navigationBar addLeftItem];
        [self.view addSubview:self.navigationBar];
        [self.view bringSubviewToFront:self.navigationBar];
        [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self.view);
            make.height.mas_equalTo(LCBASE_STATUSBAR_HEIGHT + 44);
        }];
    } else if (self.navigationBar) {
        [self.navigationBar removeFromSuperview];
        self.navigationBar = nil;
    }
}

- (BOOL)showSystemNavagationBar {
    return objc_getAssociatedObject(self, &showSystemNavagationBarKey);
}

- (void)setShowSystemNavagationBar:(BOOL)showSystemNavagationBar {
    objc_setAssociatedObject(self, &showSystemNavagationBarKey, @(showSystemNavagationBar), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)disablePopGestureRecognizer {
    return objc_getAssociatedObject(self, &disablePopGestureRecognizerKey);
}

- (void)setDisablePopGestureRecognizer:(BOOL)disablePopGestureRecognizer {
    objc_setAssociatedObject(self, &disablePopGestureRecognizerKey, @(disablePopGestureRecognizer), OBJC_ASSOCIATION_ASSIGN);
}

// 返回/关闭事件
- (void)backAction {
    if ([self isPresent]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)isPresent {
    if(!self.presentingViewController) {
        return NO;
    }
    if(self.navigationController && self.navigationController.viewControllers.count > 1){
        return NO;
    }
    return YES;
}

// 点击返回按钮
- (void)didSelectLeftItem {
    [self backAction];
}

// 点击关闭按钮
- (void)didSelectCloseItem {
    [self backAction];
}

// 点击右侧按钮
- (void)didSelectRightItem {
    
}

+ (BOOL)swizzlingMethod:(Class)cls swizSel:(SEL)swizzlingSel originSel:(SEL)originSel {
    Method swizzlingMethod = class_getInstanceMethod(cls,swizzlingSel);
    Method originMethod = class_getInstanceMethod(cls, originSel);
    if (originMethod && swizzlingMethod) {
        //将 methodB的实现 添加到系统方法中 也就是说 将 methodA方法指针添加成 方法methodB的  返回值表示是否添加成功
        BOOL isAdd = class_addMethod(cls, swizzlingSel, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
        //添加成功了 说明 本类中不存在methodB 所以此时必须将方法b的实现指针换成方法A的，否则 b方法将没有实现。
        if (isAdd) {
            class_replaceMethod(cls, originSel, method_getImplementation(swizzlingMethod), method_getTypeEncoding(swizzlingMethod));
        }else{
            //添加失败了 说明本类中 有methodB的实现，此时只需要将 methodA和methodB的IMP互换一下即可。
            method_exchangeImplementations(swizzlingMethod, originMethod);
        }
        return YES;
    }
    return NO;
}

+ (void)load {
    [UIViewController swizzlingMethod:self swizSel:@selector(lcViewWillAppear:) originSel:@selector(viewWillAppear:)];
    [UIViewController swizzlingMethod:self swizSel:@selector(lcViewDidAppear:) originSel:@selector(viewDidAppear:)];
    [UIViewController swizzlingMethod:self swizSel:@selector(lcViewWillDisappear:) originSel:@selector(viewWillDisappear:)];
}

- (void)lcViewWillAppear:(BOOL)animated {
    [self lcViewWillAppear:animated];
    self.navigationController.navigationBar.hidden = !self.showSystemNavagationBar;
}

- (void)lcViewDidAppear:(BOOL)animated {
    [self lcViewDidAppear:animated];
    if (self.disablePopGestureRecognizer && [self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = !self.disablePopGestureRecognizer;
    }
}

- (void)lcViewWillDisappear:(BOOL)animated {
    [self lcViewWillDisappear:animated];
    if (self.disablePopGestureRecognizer && [self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

@end
