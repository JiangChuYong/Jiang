//
//  PBAlert.m
//  LincKia
//
//  Created by Phoebe on 16/2/19.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "PBAlert.h"

@implementation PBAlert
SingletonM(PBAlert);

- (void)showText:(NSString *)message inView:(UIView *)view withTime:(int)time{
    
    _HUD = [[MBProgressHUD alloc]initWithView:view];
    [view addSubview:_HUD];
    _HUD.labelText = message;
    _HUD.mode = MBProgressHUDModeText;
    
    [_HUD showAnimated:YES whileExecutingBlock:^{
        sleep(time);
    } completionBlock:^{
        [_HUD removeFromSuperview];
        _HUD = nil;
    }];
    
}
- (void)showProgressDialogText:(NSString *)message inView:(UIView *)view{
    _HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:_HUD];
    _HUD.labelText = message;
    _HUD.mode = MBProgressHUDModeIndeterminate;
    
    [_HUD showAnimated:YES whileExecutingBlock:^{
        float progress = 0.0f;
        while (progress < 1.0f) {
            progress += 0.01f;
            _HUD.progress = progress;
            usleep(MAXFLOAT);
        }
    } completionBlock:^{
        [_HUD removeFromSuperview];
        _HUD = nil;
    }];
}

-(void)stopHud{
    [_HUD removeFromSuperview];
    _HUD = nil;
}

@end
