//
//  JCYSetNewPasswordViewController.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/17.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "JCYSetNewPasswordViewController.h"

@interface JCYSetNewPasswordViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *oldPassword;
@property (strong, nonatomic) IBOutlet UITextField *changePassword;
@property (strong, nonatomic) IBOutlet UITextField *renewPassword;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (strong, nonatomic) AFRquest *ModifyPassword;

@end

@implementation JCYSetNewPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //监听键盘控制确认按钮的动画
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self oberserverTextfieldsStatus:_changePassword];
    [self oberserverTextfieldsStatus:_oldPassword];
    [self oberserverTextfieldsStatus:_renewPassword];
}

-(void)oberserverTextfieldsStatus:(UITextField *)textField
{
    [textField addTarget:self action:@selector(monitorTextField:) forControlEvents:UIControlEventEditingChanged];
}
#pragma mark--控制TextField输入长度

-(void)monitorTextField:(UITextField *)sender
{
    if (sender.text.length > 16) {
        sender.text = [sender.text substringToIndex:16];
    }
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



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)goBack:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)confirmButtonPressed:(UIButton *)sender {
    
    
    if ([_oldPassword.text isEqualToString:@""]) {
        
        
        [[PBAlert sharedInstance] showText:@"请输入原密码" inView:self.view withTime:2.0];
        
        return;
    }
    if ([_changePassword.text isEqualToString:@""]){
        
        [[PBAlert sharedInstance] showText:@"请输入新密码" inView:self.view withTime:2.0];
        
        return;
    }
    if ([_renewPassword.text isEqualToString:@""]){
        
        [[PBAlert sharedInstance] showText:@"请输入确认密码" inView:self.view withTime:2.0];
        
        return;
        
    }
    if(![_changePassword.text isEqualToString:_renewPassword.text]){
        
        [[PBAlert sharedInstance] showText:@"两次输入密码不一致" inView:self.view withTime:2.0];
        
        return;
    }else{
        if ([self compareNullStr:_changePassword.text]||[self compareNullStr:_renewPassword.text]) {
            
            [[PBAlert sharedInstance] showText:@"密码不能含有空格" inView:self.view withTime:2.0];
            
            return;
        }
    }
    

    [self requestFromServer];
}

//遍历字符串，判断是否有空字符串
- (BOOL)compareNullStr:(NSString *)string
{
    for(int i =0; i < [string length]; i++)
    {
        NSString *temp = [string substringWithRange:NSMakeRange(i, 1)];
        if ([temp isEqualToString:@" "]) {
            
            return YES;
        }
    }
    return NO;
}



//从服务器请求数据 空间搜索列表
-(void)requestFromServer
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataReceived:) name:[NSString stringWithFormat:@"%i",ChangePassword] object:nil];
    
    NSUserDefaults * userInfo = [NSUserDefaults standardUserDefaults];
    NSString * userToken = [userInfo valueForKey:USERTOKEN];
    
    _ModifyPassword = [[AFRquest alloc]init];
    
   _ModifyPassword.subURLString =[NSString stringWithFormat:@"api/Users/ChangePassword?userToken=%@&deviceType=ios",userToken];
    
    _ModifyPassword.parameters = @{@"OldPassword":_oldPassword.text,@"NewPassword":_changePassword.text,@"ConfirmPassword":_renewPassword.text};
    
    _ModifyPassword.style = POST;
    
    [_ModifyPassword requestDataFromWithFlag:ChangePassword];
    [[PBAlert sharedInstance] showProgressDialogText:@"保存中..." inView:self.view];
    
}

-(void)dataReceived:(NSNotification *)notif{
    
    [[PBAlert sharedInstance] stopHud];
    int result = [_ModifyPassword.resultDict[@"Code"] intValue];
    if (result == SUCCESS) {
        
        UIAlertView *alter=[[UIAlertView alloc]initWithTitle:@"提示" message:@"密码已修改成功，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alter show];
        
        
    }else{
        [[PBAlert sharedInstance] showText:_ModifyPassword.resultDict[@"Description"] inView:self.view withTime:2.0];
    }
    
    
    
    NSLog(@"%@",_ModifyPassword.resultDict);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",ChangePassword] object:nil];
}


#pragma -- mark UIAlterViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [JCYGlobalData sharedInstance].isBackHome=YES;
        [self saveInfoSuccess];
        [self performSegueWithIdentifier:@"ModifyPasswordToLogin" sender:self];
    }
}

-(void)saveInfoSuccess{
    [JCYGlobalData sharedInstance].userInfo = nil;
    [JCYGlobalData sharedInstance].LoginStatus=NO;

    NSLog(@"userInfo=%@",[JCYGlobalData sharedInstance].userInfo);
    //清空登录缓存
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:nil forKey:USERNAME];
    [user setObject:nil forKey:PASSWORD];
    [user synchronize];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_oldPassword resignFirstResponder];
    [_changePassword resignFirstResponder];
    [_renewPassword resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //监听退出登录的消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recivecCancleLoginInfo:) name:@"cancelLogin" object:nil];
    
    
}
-(void)recivecCancleLoginInfo:(NSNotification *)notifi;
{
    UINavigationController *navi=(UINavigationController *)self.parentViewController;
    [navi popToRootViewControllerAnimated:YES];
    navi.tabBarController.selectedIndex=0;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"cancelLogin" object:nil];
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
