//
//  LCBaseConfig.m
//  LCViewController
//
//  Created by lax on 2022/5/19.
//

#import "LCBaseConfig.h"

@implementation LCBaseConfig

+ (id)shared {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.navigationBarColor = [UIColor whiteColor];
        self.navigationTitleColor = [UIColor darkTextColor];
        self.dividerColor = [UIColor colorWithWhite:0.92 alpha:1];
        self.progressColor = [UIColor blueColor];
        self.navigationTitleFont = [UIFont boldSystemFontOfSize:16];
        self.navigationButtonFont = [UIFont systemFontOfSize:14];
        self.backButtonImageName = @"icon_navigation_back";
        self.closeButtonImageName = @"icon_navigation_close";
        _logEnabled = NO;
    }
    return self;
}

- (void)setLogEnabled:(BOOL)logEnabled {
    #ifdef DEBUG
    _logEnabled = logEnabled;
    #endif
}

@end
