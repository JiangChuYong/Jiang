//
//  JCYChangePhoneNumForLoginViewController.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/21.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "JCYChangePhoneNumForLoginViewController.h"

@interface JCYChangePhoneNumForLoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *loginPassword;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (strong, nonatomic) AFRquest *Login;

@end

@implementation JCYChangePhoneNumForLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _confirmButton.layer.cornerRadius = 5;
    _confirmButton.clipsToBounds = YES;
    //监听键盘控制确认按钮的动画
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //控制输入字数
    [_loginPassword addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];

}

-(void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardFrame ;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    NSNumber * duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    _bottomConstraint.constant=keyboardFrame.size.height;
    
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        
        [self.view layoutIfNeeded];
        
    }];
    
}
-(void)keyboardWillHide:(NSNotification *)notification
{
    NSNumber * duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    _bottomConstraint.constant=0;
    
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        
        [self.view layoutIfNeeded];
    }];
    
}

-(void)textFieldDidChanged:(UITextField *)textField
{
    if (textField.text.length > 16) {
        textField.text =  [textField.text substringToIndex:16];
    }
}


- (IBAction)goBack:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)confirmButtonPressed:(UIButton *)sender {
    if (_loginPassword.text.length<6) {
        [[PBAlert sharedInstance] showText:@"密码输入有误" inView:self.view withTime:2.0];
    }else{
        [self requestFromServer];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_loginPassword resignFirstResponder];
}

//获取短信验证码请求
-(void)requestFromServer;
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataReceived:) name:[NSString stringWithFormat:@"%i",UsersLogin] object:nil];
    _Login = [[AFRquest alloc]init];
    
    _Login.subURLString = @"api/Users/Login?deviceType=ios";
    _Login.parameters = @{@"Account":[JCYGlobalData sharedInstance].userInfo[@"Mobile"],@"Password":_loginPassword.text};
    _Login.style = POST;
    [_Login requestDataFromWithFlag:UsersLogin];
}

-(void)dataReceived:(NSNotification *)notif{
    int result = [_Login.resultDict[@"Code"] intValue];
    if (result == SUCCESS) {
        [[PBAlert sharedInstance] showText:@"验证通过" inView:self.view withTime:2.0];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pushToNextPage:) userInfo:nil repeats:YES];
    }else{
        [[PBAlert sharedInstance] showText:_Login.resultDict[@"Description"] inView:self.view withTime:2.0];
    }
    NSLog(@"%@",_Login.resultDict);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",UsersLogin] object:nil];
}

-(void)pushToNextPage:(NSTimer *)timer
{
    //密码正确跳转更换手机号码页面
//    PBChangedPhoneNumViewController * VC = [[PBChangedPhoneNumViewController alloc]init];
//    [self.navigationController pushViewController:VC animated:YES];
    
    [self performSegueWithIdentifier:@"LoginVerificationToSetNewPhoneNum" sender:self];
    
    if (timer) {
        [timer invalidate];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
