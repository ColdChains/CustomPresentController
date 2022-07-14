//
//  LCViewController.m
//  LCViewController
//
//  Created by lax on 2022/5/18.
//

#import "LCViewController.h"
#import "LCBaseHeader.h"

@interface LCViewController ()

@end

@implementation LCViewController

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationFullScreen;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = LCBaseConfig.shared.backgroundColor;
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
