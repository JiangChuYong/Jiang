//
//  JCYSetNewPhoneNumViewController.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/14.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "JCYSetNewPhoneNumViewController.h"
#import "TimerView.h"
@interface JCYSetNewPhoneNumViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (strong, nonatomic) AFRquest *SendValidCode;
@property (strong, nonatomic) AFRquest *SetPhoneNum;

@end

@implementation JCYSetNewPhoneNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self setUI];
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
-(void)setUI
{
    _getCodeButton.layer.cornerRadius = 5;
    _getCodeButton.clipsToBounds = YES;
    
    _confirmButton.layer.cornerRadius = 5;
    _confirmButton.clipsToBounds = YES;
    
    [_phone addTarget:self action:@selector(textFiedDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [_code addTarget:self action:@selector(textFiedDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
}

-(void)textFiedDidChanged:(UITextField *)textField
{
    if (textField.text.length > 11&&[textField isEqual:_phone]) {
        textField.text = [textField.text substringToIndex:11];
    }else if(textField.text.length > 6 && [textField isEqual:_code]){
        textField.text = [textField.text substringToIndex:6];
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_phone resignFirstResponder];
    [_code resignFirstResponder];
}


- (IBAction)getCodeButtonPressed:(id)sender {
    if ([_phone.text isEqualToString:@""]) {
        [[PBAlert sharedInstance] showText:@"手机号不能为空" inView:self.view withTime:2.0];
        return;
    }
    if ([CommonUtil isValidateMobile: _phone.text]) {
        //更换号码请求验证码
        [self requestFromServerSendValidCode:_phone.text Type:@"0"];
        [[TimerView shareTimerView] currentTime:sender endTime:^{
            NSLog(@"倒计时结束");
        }];
        
    }else{
        [[PBAlert sharedInstance] showText:@"手机号格式有误" inView:self.view withTime:1.0];
    }

}
- (IBAction)confirmButtonPressed:(id)sender {
    
    if ([_phone.text isEqualToString:@""]) {
        [[PBAlert sharedInstance] showText:@"手机号不能为空" inView:self.view withTime:2.0];
        return;
    }
    
    if ([_code.text isEqualToString:@""]) {
        [[PBAlert sharedInstance] showText:@"验证码不能为空" inView:self.view withTime:2.0];
        return;
    }
    
    
    //更换手机号
    if ([CommonUtil isValidateMobile: _phone.text]) {

        [self requestFromServerSetPhoneNum];
        
    }else{
        
        [[PBAlert sharedInstance] showText:@"手机号输入有误" inView:self.view withTime:2.0];
    }
}
- (IBAction)goBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

//更换手机号
-(void)requestFromServerSetPhoneNum;
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setPhoneNumDataReceived:) name:[NSString stringWithFormat:@"%i",SetPhoneNum] object:nil];
    NSUserDefaults * userInfo = [NSUserDefaults standardUserDefaults];
    NSString * userToken = [userInfo valueForKey:USERTOKEN];
    _SetPhoneNum = [[AFRquest alloc]init];
    _SetPhoneNum.subURLString =[NSString stringWithFormat:@"api/Users/SetPhoneNum?userToken=%@&deviceType=ios",userToken];
    _SetPhoneNum.parameters =@{@"phoneNum":_phone.text,@"ValidCode":_code.text};
    
    _SetPhoneNum.style = POST;
    [_SetPhoneNum requestDataFromWithFlag:SetPhoneNum];
}

-(void)setPhoneNumDataReceived:(NSNotification *)notif{
    int result = [_SetPhoneNum.resultDict[@"Code"] intValue];
    if (result == SUCCESS) {

        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号更换成功，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
        
        
    }else{
        [[PBAlert sharedInstance] showText:_SetPhoneNum.resultDict[@"Description"] inView:self.view withTime:2.0];
    }
    NSLog(@"%@",_SetPhoneNum.resultDict);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",SetPhoneNum] object:nil];
}

-(void)clearLoginCache
{
    [JCYGlobalData sharedInstance].userInfo = nil;
    [JCYGlobalData sharedInstance].LoginStatus=NO;
    NSLog(@"userInfo=%@",[JCYGlobalData sharedInstance].userInfo);
    //清空登录缓存
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:nil forKey:USERNAME];
    [user setObject:nil forKey:PASSWORD];
    [user synchronize];
    

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self clearLoginCache];
        [JCYGlobalData sharedInstance].isBackHome=YES;
        [self performSegueWithIdentifier:@"SetPhoneNumToLogin" sender:self];

    }
}
//获取短信验证码请求
-(void)requestFromServerSendValidCode:(NSString *)code Type:(NSString *)type;
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(validCodeDataReceived:) name:[NSString stringWithFormat:@"%i",SendValidCode] object:nil];
    _SendValidCode = [[AFRquest alloc]init];
    
    _SendValidCode.subURLString =@"api/Users/SendValidCode?deviceType=ios";
    
    _SendValidCode.parameters = @{@"Mobile":code,@"type":type};
    _SendValidCode.style = POST;
    
    [_SendValidCode requestDataFromWithFlag:SendValidCode];
    
}

-(void)validCodeDataReceived:(NSNotification *)notif{
    int result = [_SendValidCode.resultDict[@"Code"] intValue];
    if (result == SUCCESS) {
        [[PBAlert sharedInstance] showText:@"验证码已发送" inView:self.view withTime:2.0];
    }else{
        [[PBAlert sharedInstance] showText:_SendValidCode.resultDict[@"Description"] inView:self.view withTime:2.0];
    }
    NSLog(@"%@",_SendValidCode.resultDict);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",SendValidCode] object:nil];
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
