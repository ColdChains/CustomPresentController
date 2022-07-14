//
//  LCNavigationBar.h
//  LCViewController
//
//  Created by lax on 2022/5/18.
//

#import <UIKit/UIKit.h>

@interface LCProgressBar : UIView

@property(nonatomic, assign, readonly) CGFloat progress;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated  completion:(void (^)(BOOL finished))completion;

@end
