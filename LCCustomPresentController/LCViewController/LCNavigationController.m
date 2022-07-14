//
//  LCNavigationController.m
//  LCViewController
//
//  Created by lax on 2022/5/18.
//

#import "LCNavigationController.h"

@interface LCNavigationController ()

@end

@implementation LCNavigationController

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController ?: super.childViewControllerForStatusBarStyle;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController ?: super.childViewControllerForStatusBarStyle;
}

- (UIViewController *)childViewControllerForHomeIndicatorAutoHidden {
    return self.topViewController ?: super.childViewControllerForStatusBarStyle;
}

- (UIModalPresentationStyle)modalPresentationStyle {
    return self.topViewController.modalPresentationStyle;
}

- (BOOL)shouldAutorotate {
    return self.topViewController ? self.topViewController.shouldAutorotate : super.shouldAutorotate;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController ? self.topViewController.preferredInterfaceOrientationForPresentation : super.preferredInterfaceOrientationForPresentation;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController ? self.topViewController.supportedInterfaceOrientations : super.supportedInterfaceOrientations;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
