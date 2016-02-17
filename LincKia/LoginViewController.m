//
//  LoginViewController.m
//  LincKia
//
//  Created by Phoebe on 16/2/17.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController
- (IBAction)backToLastPage:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
