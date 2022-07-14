//
//  LCTabBarController.m
//  LCViewController
//
//  Created by lax on 2022/5/18.
//

#import "LCTabBarController.h"
#import "LCBaseHeader.h"

@interface LCTabBarController ()

@end

@implementation LCTabBarController

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.selectedViewController ?: super.childViewControllerForStatusBarStyle;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.selectedViewController ?: super.childViewControllerForStatusBarStyle;
}

- (UIViewController *)childViewControllerForHomeIndicatorAutoHidden {
    return self.selectedViewController ?: super.childViewControllerForStatusBarStyle;
}

- (UIModalPresentationStyle)modalPresentationStyle {
    return self.selectedViewController.modalPresentationStyle;
}

- (BOOL)shouldAutorotate {
    return self.selectedViewController ? self.selectedViewController.shouldAutorotate : super.shouldAutorotate;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.selectedViewController ? self.selectedViewController.preferredInterfaceOrientationForPresentation : super.preferredInterfaceOrientationForPresentation;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.selectedViewController ? self.selectedViewController.supportedInterfaceOrientations : super.supportedInterfaceOrientations;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (LCBaseConfig.shared.logEnabled) {
        NSLog(@"%p%s", self, __func__);
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (LCBaseConfig.shared.logEnabled) {
        NSLog(@"%p%s", self, __func__);
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (LCBaseConfig.shared.logEnabled) {
        NSLog(@"%p%s", self, __func__);
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (LCBaseConfig.shared.logEnabled) {
        NSLog(@"%p%s", self, __func__);
    }
}

- (void)dealloc {
    if (LCBaseConfig.shared.logEnabled) {
        NSLog(@"%p%s", self, __func__);
    }
}

@end
