//
//  LCNavigationBar.m
//  LCViewController
//
//  Created by lax on 2022/5/18.
//

#import "LCProgressBar.h"
#import "LCBaseHeader.h"

@interface LCProgressBar ()

@property(nonatomic, strong) UIView *foreView;

@property(nonatomic) CGFloat progress;

@end

@implementation LCProgressBar

- (UIView *)foreView {
    if (!_foreView) {
        _foreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 2)];
    }
    return _foreView;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    CGFloat width = self.bounds.size.width * progress;
    self.foreView.frame = CGRectMake(0, 0, width, 2);
}

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, LCBASE_SCREEN_WIDTH, 2)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.foreView.backgroundColor = LCBaseConfig.shared.progressColor;
        self.progress = 0;
        
        [self addSubview:self.foreView];
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"frame"]) {
        self.progress = _progress;
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"frame"];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    [self setProgress:progress animated:animated completion:nil];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated completion:(void (^)(BOOL))completion {
    _progress = progress;
    CGFloat width = self.bounds.size.width * progress;
    [UIView animateWithDuration:animated ? 0.25 : 0 animations:^{
        self.foreView.frame = CGRectMake(0, 0, width, 2);
    } completion:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
    }];
}

@end
