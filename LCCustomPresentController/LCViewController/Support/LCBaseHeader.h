//
//  LCBaseHeader.h
//  LCViewController
//
//  Created by lax on 2022/5/19.
//

#ifndef LCBaseHeader_h
#define LCBaseHeader_h

#import "Masonry.h"

#import "LCBaseConfig.h"

#define LCBASE_SCREEN_HEIGHT           ([UIScreen mainScreen].bounds.size.height > [UIScreen mainScreen].bounds.size.width ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width)

#define LCBASE_SCREEN_WIDTH            ([UIScreen mainScreen].bounds.size.height < [UIScreen mainScreen].bounds.size.width ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width)

#define LCBASE_IS_IPHONEX              (LCBASE_SCREEN_WIDTH >= 375.0f && LCBASE_SCREEN_HEIGHT >= 812.0f)

#define LCBASE_STATUSBAR_HEIGHT        (LCBASE_IS_IPHONEX ? 44.0f : 20.0f)


#endif /* LCBaseHeader_h */
