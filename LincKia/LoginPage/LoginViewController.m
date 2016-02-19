//
//  LoginViewController.m
//  LincKia
//
//  Created by Phoebe on 16/2/17.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "LoginViewController.h"


@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end


@implementation LoginViewController
#pragma -- mark Private Methods
-(BOOL)isRightPhoneNum{
    if ([CommonUtil isValidateMobile:_phone.text]) {
        return YES;
    }else{
        return NO;
    }
}

-(BOOL)isRightPassword{
    
    if (_password.text.length < 6) {
        return NO;
    }
    
    return YES;
}
-(void)requestData{
    START_OBSERVE_CONNECTION
    AFRquest * af = [AFRquest sharedInstance];
    af.subURLString = @"api/Users/Login?deviceType=ios";
    af.parameters = @{@"Account":_phone.text,@"Password":_password.text};
    af.requestFlag = UsersLogin;
    af.style = POST;
    [af requestDataFromServer];

}

-(void)dataReceived:(NSNotification *)notif{
    NSLog(@"%@",[notif object]);
    NSDictionary * userInfo = [notif object];
    NSDictionary * data = userInfo[@"Data"];
    if ([AFRquest sharedInstance].requestFlag == UsersLogin) {
        NSNumber * code = userInfo[@"Code"];
        if ([code intValue] == 0) {
            [self dismissViewControllerAnimated:YES completion:^{}];
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            [user setValue:_phone.text forKey:USERNAME];
            [user setValue:_password.text forKey:PASSWORD];
            [user setValue:data[@"UserToken"] forKey:USERTOKEN];
            [user synchronize];
        }else{
            NSString * errorInfo = userInfo[@"Description"];
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:errorInfo delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }
}
#pragma -- mark Button Action

- (IBAction)backToLastPage:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    
    if ([self isRightPassword]) {
        if ([self isRightPhoneNum]) {
            [self requestData];
        }else{
            NSLog(@"手机号有误");
        }
    }else{
        NSLog(@"密码输入有误");
    }
    

}

- (IBAction)toRegisterPage:(UIButton *)sender {
}

- (IBAction)toFindPasswordPage:(UIButton *)sender {
}

#pragma -- mark TextField Delegate

- (IBAction)textFieldChanged:(UITextField *)sender {
    
    //输入字符数控制
    if ([sender isEqual:_phone]) {
        if (sender.text.length > 11) {
            sender.text = [sender.text substringToIndex:11];
        }
    }
    
    if ([sender isEqual:_password]) {
        if (sender.text.length > 16) {
            sender.text = [sender.text substringToIndex:16];
        }
    }
    
}



@end