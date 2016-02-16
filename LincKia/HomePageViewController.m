 //
//  FirstViewController.m
//  LincKia
//
//  Created by Phoebe on 16/2/15.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "HomePageViewController.h"

@interface HomePageViewController ()

@property (nonatomic,strong) AFRquest * af;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    START_OBSERVE_CONNECTION
    _af = [AFRquest sharedInstance];
    _af.subURLString = @"api/Users/Login?deviceType=ios";
    _af.parameters = @{@"Account":@"18602515155",@"Password":@"aaa111"};
    _af.requestFlag = UsersLogin;
    _af.style = POST;
    [_af requestDataFromServer];
}
-(void)dataReceived:(NSNotification *)notif{

    NSDictionary * dict = [notif object];
    if (dict) {
        STOP_OBSERVE_CONNECTION
    }
    
    if (_af.requestFlag == UsersLogin) {
        
        NSLog(@"_YI_______\n%@\n__________",dict);

        NSDictionary * data = dict[@"Data"];
        NSString * userToken = data[@"UserToken"];
        if (userToken) {
            START_OBSERVE_CONNECTION
            _af = [AFRquest sharedInstance];
            _af.subURLString = [NSString stringWithFormat:@"api/Users/GetUserInfo?deviceType=ios&usertoken=%@",userToken];
            _af.style = GET;
            _af.requestFlag = GetUserInfo;
            [_af requestDataFromServer];
        }
    }
    
    if (_af.requestFlag == GetUserInfo) {
        NSLog(@"__ER______\n%@\n__________",dict);
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
