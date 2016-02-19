//
//  PBAlert.h
//  LincKia
//
//  Created by Phoebe on 16/2/19.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface PBAlert : UIView

SingletonH(PBAlert);

@property (nonatomic,strong) MBProgressHUD *HUD;

//文字提示
- (void)showText:(NSString *)message inView:(UIView *)view withTime:(int)time;
//旋转动画提示
- (void)showProgressDialogText:(NSString *)message inView:(UIView *)view;

-(void)stopHud;

@end
