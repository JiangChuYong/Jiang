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

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataReceived:) name:CONNECTED object:nil];
    
    _af = [AFRquest sharedInstance];
    _af.subURLString = @"api/Users/Login?deviceType=ios";
    _af.parameters = @{@"Account":@"18602515155",@"Password":@"aaa111"};
    _af.requestFlag = UsersLogin;
    _af.style = POST;
    [_af requestDataFromServer];
}
-(void)dataReceived:(NSNotification *)notif{

    NSDictionary * dict = [notif object];

    
    if (_af.requestFlag == UsersLogin) {
        NSDictionary * data = dict[@"Data"];
        NSString * userToken = data[@"UserToken"];
        NSLog(@"%@",userToken);
        if (userToken) {
            AFRquest * af = [AFRquest sharedInstance];
            af.subURLString = [NSString stringWithFormat:@"api/Users/GetUserInfo?deviceType=ios&usertoken=%@",userToken];
            af.style = GET;
            af.requestFlag = GetUserInfo;
            [af requestDataFromServer];
        }
    }
    
    if (_af.requestFlag == GetUserInfo) {
        NSLog(@"________\n%@\n__________",dict);
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
