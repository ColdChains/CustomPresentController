//
//  LCCustomModalPresentProtocol.h
//  LCCustomPresentController
//
//  Created by lax on 2022/7/11.
//

#import <UIKit/UIKit.h>

@protocol LCCustomModalPresentProtocol <NSObject>

// 返回可以滚动的视图
- (UIScrollView *)customModalPresentScrollView;

@end
