//
//  ViewController.m
//  LCCustomModalPresent
//
//  Created by lax on 2022/7/7.
//

#import "ViewController.h"
#import <CustomPresentController/CustomPresentController.h>
#import "RootViewController.h"
#import "Root0ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

// 状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
}

// 通过pan手势实现
- (IBAction)button1Action:(id)sender {
    
    Root0ViewController *vc = [[Root0ViewController alloc] init];
    
    LCCustomModalPresentController *pvc = [[LCCustomModalPresentController alloc] initWithRootViewController:vc];
    pvc.topCornerRadius = 16;
    // 自定义高度
    pvc.minHeight = 111;
    pvc.middleHeight = 333;
    pvc.maxHeight = 555;
    pvc.defaultHeight = LCCustomModalPresentHeightMiddle;
    // 自定义topView
    UIView *top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    top.backgroundColor = [UIColor yellowColor];
    UIView *bar = [[UIView alloc] initWithFrame:CGRectMake((UIScreen.mainScreen.bounds.size.width - 30) / 2, 10, 30, 4)];
    bar.layer.cornerRadius = 2;
    bar.backgroundColor = [UIColor lightGrayColor];
    [top addSubview:bar];
    pvc.topView = top;
    
    // 接管状态栏样式
    pvc.modalPresentationCapturesStatusBarAppearance = YES;
    [self presentViewController:pvc animated:YES completion:nil];
    
}

// 通过pagecontroller手势实现
- (IBAction)button2Action:(id)sender {

    RootViewController *vc = [[RootViewController alloc] init];

    LCCustomPresentController *pvc = [[LCCustomPresentController alloc] init];

    // 自定义高度 也可通过协议修改
//    pvc.minHeight = 200;
//    pvc.middleHeight = 400;
//    pvc.maxHeight = 600;
//    pvc.defaultHeight = LCCustomPresentHeightMiddle;

    // 自定义topView
    UIView *top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 44)];
    top.backgroundColor = [UIColor yellowColor];
    UIView *bar = [[UIView alloc] initWithFrame:CGRectMake((UIScreen.mainScreen.bounds.size.width - 30) / 2, 10, 30, 4)];
    bar.layer.cornerRadius = 2;
    bar.backgroundColor = [UIColor lightGrayColor];
    [top addSubview:bar];

    pvc.menuBar = top;
    pvc.topCornerRadius = 16;
    pvc.viewControllers = @[vc];

    // 接管状态栏样式
    pvc.modalPresentationCapturesStatusBarAppearance = YES;
    [self presentViewController:pvc animated:YES completion:nil];

    // QLPageController的使用详见：https://github.com/ColdChains/MenuBarController.git
}

@end
