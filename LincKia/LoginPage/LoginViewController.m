//
//  LoginViewController.m
//  LincKia
//
//  Created by Phoebe on 16/2/17.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "LoginViewController.h"
#import "HomePageViewController.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *password;

@property (strong,nonatomic) AFRquest * Login;

@end


@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UINavigationController * navi = (UINavigationController *)self.navigationController;
    navi.tabBarController.tabBar.hidden = YES;
    navi.navigationBar.hidden = YES;
}

-(void)viewDidLoad{
    [super viewDidLoad];
}

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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataReceived:) name:[NSString stringWithFormat:@"%i",UsersLogin] object:nil];
    SHOW_LOADING
    _Login = [[AFRquest alloc]init];
    _Login.subURLString = @"api/Users/Login?deviceType=ios";
    _Login.parameters = @{@"Account":_phone.text,@"Password":_password.text};
    _Login.style = POST;
    [_Login requestDataFromWithFlag:UsersLogin];
}

-(void)dataReceived:(NSNotification *)notif{
    
    STOP_LOADING
    NSDictionary * userInfo = _Login.resultDict;
    NSDictionary * data = userInfo[@"Data"];
    NSNumber * code = userInfo[@"Code"];
    if ([code intValue] == 0) {
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        [user setValue:_phone.text forKey:USERNAME];
        [user setValue:_password.text forKey:PASSWORD];
        [user setValue:data[@"UserToken"] forKey:USERTOKEN];
        [user synchronize];
        [JCYGlobalData sharedInstance].LoginStatus = YES;
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        NSString * errorInfo = userInfo[@"Description"];
        [[PBAlert sharedInstance]showText:errorInfo inView:self.view withTime:2.0];
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",UsersLogin] object:nil];
}
#pragma -- mark Button Action
- (IBAction)backButtonPressed:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    
    if ([self isRightPassword]) {
        if ([self isRightPhoneNum]) {
            [self requestData];
        }else{
            [[PBAlert sharedInstance]showText:@"您输入的手机号有误" inView:self.view withTime:2];
        }
    }else{
        [[PBAlert sharedInstance]showText:@"密码输入有误" inView:self.view withTime:2];
    }
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_phone resignFirstResponder];
    [_password resignFirstResponder];
}
- (IBAction)toRegisterPage:(UIButton *)sender {
}

- (IBAction)toFindPasswordPage:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"LoginToFindPassword" sender:self];
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
