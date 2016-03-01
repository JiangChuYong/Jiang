//
//  UITabBar+badge.h
//  LincKia
//
//  Created by Phoebe on 16/2/26.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)


- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end
