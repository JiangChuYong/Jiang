 //
//  FirstViewController.m
//  LincKia
//
//  Created by Phoebe on 16/2/15.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "HomePageViewController.h"

@interface HomePageViewController ()


@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    START_OBSERVE_CONNECTION
    AFRquest * af = [AFRquest sharedInstance];
    af.subURLString = @"api/Users/Login?deviceType=ios";
    af.parameters = @{@"Account":@"18602515155",@"Password":@"aaa111"};
    af.requestFlag = UsersLogin;
    af.style = POST;
    [af requestDataFromServer];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    STOP_OBSERVE_CONNECTION
}

-(void)dataReceived:(NSNotification *)notif{

    NSDictionary * dict = [notif object];
    if ([AFRquest sharedInstance].requestFlag == UsersLogin) {
        NSLog(@"flag == %i",[AFRquest sharedInstance].requestFlag);
        NSLog(@"%@",dict);
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
