//
//  FindPasswdViewController.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/10.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "FindPasswdViewController.h"
#import "UITextField+PlaceHolderSetting.h"
#import "TimerView.h"
@interface FindPasswdViewController ()<UITextFieldDelegate>{
    UITextView *returnTextView;
}

@property (weak, nonatomic) IBOutlet UIButton *btnGetCode;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
//@property(strong,nonatomic)SetPasswordBindingModel *setPasswordBindingModel;


@property (weak, nonatomic) IBOutlet UIImageView *phoneText_image;
@property (weak, nonatomic) IBOutlet UIImageView *codeText_Image;

@property (strong, nonatomic) AFRquest *SendValidCode;
@property (strong, nonatomic) AFRquest *ResetPassword;


@end

@implementation FindPasswdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setViewFontAndColor];

}


#pragma mark--控制TextField键盘状态

//点击屏幕空白处去掉键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.phoneTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    
    
};

//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField==self.phoneTextField) {
        [self resetPhoneClick];
    }
    if (textField==self.codeTextField) {
        [self resetCodeClick];
    }
    
}

#pragma mark--UITextDelegete

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    returnTextView = textView;
    return YES;
}



#pragma mark--私有方法

/**
 重置输入框的背景颜色
 */
-(void)resetTextFeildImageUnclick{
    
    self.phoneText_image.image=[UIImage imageNamed:@"users_textfield_unclicked@3x"];
    self.codeText_Image.image=[UIImage imageNamed:@"users_textfield_unclicked@3x"];
}


/**
 手机号 输入时输入框的背景颜色
 */
-(void)resetPhoneClick{
    
    self.phoneText_image.image=[UIImage imageNamed:@"users_textfield_clicked@3x"];
    self.codeText_Image.image=[UIImage imageNamed:@"users_textfield_unclicked@3x"];
    
    
}
/**
 校验码 输入时输入框的背景颜色
 */
-(void)resetCodeClick{
    self.phoneText_image.image=[UIImage imageNamed:@"users_textfield_unclicked@3x"];
    self.codeText_Image.image=[UIImage imageNamed:@"users_textfield_clicked@3x"];
}


/**
 设置页面的字体以及颜色
 */

-(void)setViewFontAndColor{
    [self.phoneTextField placeHolerFontColor:CommonColor_White];
    
    

    
    [self.phoneTextField placeHolerFontSize:CommonFontSize_Middle];
    self.phoneTextField.textColor=CommonColor_White;
    
    [self.codeTextField placeHolerFontColor:CommonColor_White];
    [self.codeTextField placeHolerFontSize:CommonFontSize_Middle];
    self.codeTextField.textColor=CommonColor_White;
    
    self.btnGetCode.titleLabel.font=[UIFont boldSystemFontOfSize:CommonFontSize_Large];
    self.btnGetCode.titleLabel.textColor=CommonColor_White;
    
    
}



- (IBAction)goBack:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


/**
 获取验证码
 */
- (IBAction)clickGetCode:(id)sender {
    NSLog(@"获取验证码");
    
    if (![CommonUtil isValidateMobile:self.phoneTextField.text]) {

        [[PBAlert sharedInstance] showText:@"请输入正确的手机号" inView:self.view withTime:2.0];
        
        return;
    }
    
    [[TimerView shareTimerView] currentTime:sender endTime:^{
        NSLog(@"倒计时结束");
        
    }];
    
    [_phoneTextField resignFirstResponder];
    [_codeTextField resignFirstResponder];
    [self requestFromServerSendValidCode];
}



/**
 点击提交
 */
- (IBAction)submitPressed:(id)sender {
    NSLog(@"点击提交");
    [_phoneTextField resignFirstResponder];
    [_codeTextField resignFirstResponder];
    [self requestFromServerResetPassword];
    
}




//获取短信验证码请求
-(void)requestFromServerSendValidCode
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(validCodeDataReceived:) name:[NSString stringWithFormat:@"%i",SendValidCode] object:nil];
    _SendValidCode = [[AFRquest alloc]init];
    
    _SendValidCode.subURLString =@"api/Users/SendValidCode?deviceType=ios";
    
    _SendValidCode.parameters = @{@"Mobile":self.phoneTextField.text,@"type":@"1"};
    
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


//密码重置
-(void)requestFromServerResetPassword
{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetPasswordDataReceived:) name:[NSString stringWithFormat:@"%i",ResetPassword] object:nil];
    _ResetPassword = [[AFRquest alloc]init];
    
    _ResetPassword.subURLString =@"api/Users/ResetPassword?deviceType=ios";
    
    _ResetPassword.parameters = @{@"Mobile":_phoneTextField.text,@"ValidCode":_codeTextField.text};
    
    _ResetPassword.style = POST;
    
    [_ResetPassword requestDataFromWithFlag:ResetPassword];
    
}



-(void)resetPasswordDataReceived:(NSNotification *)notif{
    
    int result = [_ResetPassword.resultDict[@"Code"] intValue];
    if (result == SUCCESS) {
        [[PBAlert sharedInstance] showText:@"新密码已发送请稍候" inView:self.view withTime:2.0];
        [self performSelector:@selector(goBack:) withObject:nil afterDelay:2.0];
    }else{
        [[PBAlert sharedInstance] showText:_ResetPassword.resultDict[@"Description"] inView:self.view withTime:2.0];
    }
    NSLog(@"%@",_ResetPassword.resultDict);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",ResetPassword] object:nil];
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
