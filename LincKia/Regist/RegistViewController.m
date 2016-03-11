//
//  RegistViewController.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/11.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "RegistViewController.h"
#import "TimerView.h"
#import "UITextField+PlaceHolderSetting.h"
@interface RegistViewController ()<UITextFieldDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnSelectRead;
@property (weak, nonatomic) IBOutlet UIButton *btnGetCode;


@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@property (weak, nonatomic) IBOutlet UIImageView *phoneText_image;
@property (weak, nonatomic) IBOutlet UIImageView *codeText_Image;
@property (weak, nonatomic) IBOutlet UIImageView *passwdText_Image;
@property (weak, nonatomic) IBOutlet UIImageView *confirmPwdText_Image;

@property (strong, nonatomic) AFRquest *SendValidCode;
@property (strong, nonatomic) AFRquest *Register;
@property (strong, nonatomic) AFRquest *GetProtocol;
@property (strong, nonatomic) NSDictionary *protocolDic;

@property (weak, nonatomic) IBOutlet UILabel *readUserInfo;


@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setViewFontAndColor];
    _protocolDic =[NSDictionary dictionary];
    self.btnSelectRead.selected=YES;
    [self.btnSelectRead setImage:[UIImage imageNamed:@"choice_selected@3x.png"] forState:UIControlStateNormal];
    [_confirmPasswordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_passwdTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

/**
 设置页面的字体以及颜色
 */

-(void)setViewFontAndColor{
    //手机号
    [self.phoneTextField placeHolerFontColor:CommonColor_White];
    [self.phoneTextField placeHolerFontSize:CommonFontSize_Middle];
    self.phoneTextField.textColor=CommonColor_White;
    //验证码按钮
    self.btnGetCode.titleLabel.font=[UIFont boldSystemFontOfSize:CommonFontSize_Large];
    self.btnGetCode.titleLabel.textColor=CommonColor_White;
    //手机验证码
    [self.codeTextField placeHolerFontColor:CommonColor_White];
    [self.codeTextField placeHolerFontSize:CommonFontSize_Middle];
    self.codeTextField.textColor=CommonColor_White;
    //密码
    [self.passwdTextField placeHolerFontColor:CommonColor_White];
    [self.passwdTextField placeHolerFontSize:CommonFontSize_Middle];
    self.passwdTextField.textColor=CommonColor_White;
    //确认密码
    [self.confirmPasswordTextField placeHolerFontColor:CommonColor_White];
    [self.confirmPasswordTextField placeHolerFontSize:CommonFontSize_Middle];
    self.confirmPasswordTextField.textColor=CommonColor_White;
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:_readUserInfo.text];
    
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    [content
     addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:contentRange];
    
    _readUserInfo.attributedText = content;
    
    
}

#pragma mark--控制TextField键盘状态

//点击屏幕空白处去掉键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.phoneTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    [self.passwdTextField resignFirstResponder];
    [self.confirmPasswordTextField resignFirstResponder];
    
    [self keyboardWithHide:0.25];
    
};
- (void)textFieldDidChange:(UITextField *)sender
{
    if (sender.text.length > 16) {
        sender.text = [sender.text substringToIndex:16];
    }
}
//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //点击下一项，进入手机验证码输入框
    if (textField==self.phoneTextField) {
        [self.codeTextField becomeFirstResponder];
    }
    //点击下一项，进入密码输入框
    if (textField==self.codeTextField) {
        [self.passwdTextField becomeFirstResponder];
    }
    //点击下一项，进入确认密码输入框
    if (textField==self.passwdTextField) {
        [self.confirmPasswordTextField becomeFirstResponder];
    }
    
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
    if (textField==self.passwdTextField) {
        [self resetPasswdClick];
    }
    if (textField==self.confirmPasswordTextField) {
        [self resetConfirmPasswdClick];
        [self keyboardShow:0.25 heightDelta:-50];
    }
}

#pragma mark -- keyboardNotification
-(void)keyboardShow:(CGFloat)time heightDelta:(CGFloat)heightDelta
{
    CGFloat deltaY = -50;
    NSLog(@"%f",deltaY);
    if (deltaY<0) {
        [UIView animateWithDuration:time animations:^(void){
            CGRect rect = self.view.frame;
            rect.origin.y += deltaY;
            self.view.frame = rect;
        }];
    }
    
}

-(void)keyboardWithHide:(CGFloat)time
{
    [UIView animateWithDuration:time animations:^(void){
        CGRect rect = self.view.frame;
        rect.origin.y = 0;
        self.view.frame = rect;
    }completion:^(BOOL finish){
    }];
}
/**
 重置输入框的背景颜色
 */
-(void)resetTextFeildImageUnclick{
    
    self.phoneText_image.image=[UIImage imageNamed:@"users_textfield_unclicked@3x"];
    self.codeText_Image.image=[UIImage imageNamed:@"users_textfield_unclicked@3x"];
    self.passwdText_Image.image=[UIImage imageNamed:@"users_textfield_unclicked@3x"];
    self.confirmPwdText_Image.image=[UIImage imageNamed:@"users_textfield_unclicked@3x"];
}
/**
 手机号 输入时输入框的背景颜色
 */
-(void)resetPhoneClick{
    
    self.phoneText_image.image=[UIImage imageNamed:@"users_textfield_clicked@3x"];
    self.codeText_Image.image=[UIImage imageNamed:@"users_textfield_unclicked@3x"];
    self.passwdText_Image.image=[UIImage imageNamed:@"users_textfield_unclicked@3x"];
    self.confirmPwdText_Image.image=[UIImage imageNamed:@"users_textfield_unclicked@3x"];
    
}
/**
 校验码 输入时输入框的背景颜色
 */
-(void)resetCodeClick{
    self.phoneText_image.image=[UIImage imageNamed:@"users_textfield_unclicked@3x"];
    self.codeText_Image.image=[UIImage imageNamed:@"users_textfield_clicked@3x"];
    self.passwdText_Image.image=[UIImage imageNamed:@"users_textfield_unclicked@3x"];
    self.confirmPwdText_Image.image=[UIImage imageNamed:@"users_textfield_unclicked@3x"];
}

/**
 密码 输入时输入框的背景颜色
 */
-(void)resetPasswdClick{
    self.phoneText_image.image=[UIImage imageNamed:@"users_textfield_unclicked@3x"];
    self.codeText_Image.image=[UIImage imageNamed:@"users_textfield_unclicked@3x"];
    self.passwdText_Image.image=[UIImage imageNamed:@"users_textfield_clicked@3x"];
    self.confirmPwdText_Image.image=[UIImage imageNamed:@"users_textfield_unclicked@3x"];
}
/**
 确认密码 输入时输入框的背景颜色
 */
-(void)resetConfirmPasswdClick{
    self.phoneText_image.image=[UIImage imageNamed:@"users_textfield_unclicked@3x"];
    self.codeText_Image.image=[UIImage imageNamed:@"users_textfield_unclicked@3x"];
    self.passwdText_Image.image=[UIImage imageNamed:@"users_textfield_unclicked@3x"];
    self.confirmPwdText_Image.image=[UIImage imageNamed:@"users_textfield_clicked@3x"];
}

-(void)requestFromServerRegister
{
    
    if ([self.phoneTextField.text isEqualToString:@""]) {
        [[PBAlert sharedInstance] showText:@"手机号不能为空" inView:self.view withTime:2.0];
        
        return;
    }else if (![CommonUtil isValidateMobile:self.phoneTextField.text]) {
        [[PBAlert sharedInstance] showText:@"请输入正确的手机号" inView:self.view withTime:2.0];
        return;
    }
    
    if ([self.codeTextField.text isEqualToString:@""]) {
        [[PBAlert sharedInstance] showText:@"验证码不能为空" inView:self.view withTime:2.0];
        return;
    }
    
    if ([self.passwdTextField.text isEqualToString:@""]) {
        
        [[PBAlert sharedInstance] showText:@"密码不能为空" inView:self.view withTime:2.0];
        return;
    }
    
    if (self.passwdTextField.text.length>16||self.passwdTextField.text.length<6) {
        [[PBAlert sharedInstance] showText:@"码长度为6到16位" inView:self.view withTime:2.0];
        return;
    }
    
    
    if(![_passwdTextField.text isEqualToString:_confirmPasswordTextField.text])
    {
        [[PBAlert sharedInstance] showText:@"请确认密码输入一致" inView:self.view withTime:2.0];
        return;
    }
    
    if (self.btnSelectRead.selected) {
        [self regist];
    }else{
        [[PBAlert sharedInstance] showText:@"请选择协议" inView:self.view withTime:2.0];
        
    }
    
    
}
//用户注册
-(void)regist
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(registDataReceived:) name:[NSString stringWithFormat:@"%i",Register] object:nil];
    _Register = [[AFRquest alloc]init];
    
    _Register.subURLString =@"api/Users/Register?deviceType=ios";
    
    _Register.parameters = @{@"Mobile":self.phoneTextField.text,@"Password":_passwdTextField.text,@"ConfirmPassword":_confirmPasswordTextField.text,@"ValidCode":_codeTextField.text};
    
    _Register.style = POST;
    
    [_Register requestDataFromWithFlag:Register];
    
}

-(void)registDataReceived:(NSNotification *)notif{
    int result = [_Register.resultDict[@"Code"] intValue];
    
    if (result == SUCCESS) {
        [[PBAlert sharedInstance] showText:@"注册成功" inView:self.view withTime:2.0];
        [self performSelector:@selector(goBack:) withObject:nil afterDelay:2.0];
    }else{
        [[PBAlert sharedInstance] showText:_Register.resultDict[@"Description"] inView:self.view withTime:2.0];
    }
    NSLog(@"%@",_Register.resultDict);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",Register] object:nil];
}


//获取短信验证码请求
-(void)requestFromServerSendValidCode
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(validCodeDataReceived:) name:[NSString stringWithFormat:@"%i",SendValidCode] object:nil];
    _SendValidCode = [[AFRquest alloc]init];
    
    _SendValidCode.subURLString =@"api/Users/SendValidCode?deviceType=ios";
    
    _SendValidCode.parameters = @{@"Mobile":self.phoneTextField.text,@"type":@"0"};
    
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

//获取协议信息
-(void)requestFromServerGetProtocol
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getProtocolDataReceived:) name:[NSString stringWithFormat:@"%i",GetProtocol] object:nil];
    _GetProtocol = [[AFRquest alloc]init];
    
    _GetProtocol.subURLString =@"api/Sys/GetProtocol?deviceType=ios";
    
    _GetProtocol.parameters = @{@"protocolType":@1};
    
    _GetProtocol.style = GET;
    
    [_GetProtocol requestDataFromWithFlag:GetProtocol];
    
}

-(void)getProtocolDataReceived:(NSNotification *)notif{
    int result = [_GetProtocol.resultDict[@"Code"] intValue];
    if (result == SUCCESS) {
        [self dealResposeResultProtocol:_GetProtocol.resultDict[@"Data"]];
    }else{
        [[PBAlert sharedInstance] showText:_GetProtocol.resultDict[@"Description"] inView:self.view withTime:2.0];
    }
    NSLog(@"%@",_GetProtocol.resultDict);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",GetProtocol] object:nil];
}

//处理请求返回后的结果 注册协议

-(void)dealResposeResultProtocol:(NSDictionary  *)response{
    [JCYGlobalData sharedInstance].protocolDic=response;
    _protocolDic=response;
    //    RegisterInfoViewController * contractInfoViewController = [[RegisterInfoViewController alloc]initWithNibName:@"RegisterInfoViewController" bundle:nil];
    //    [self.navigationController pushViewController:contractInfoViewController animated:YES];
    //    contractInfoViewController.protocolViewModel = self.protocolViewModel;
}


//注册action
- (IBAction)registPressed:(id)sender {
    [self requestFromServerRegister];
}
//协议action
- (IBAction)registProtocol:(id)sender {
    
    if(!_protocolDic)
    {
        [self requestFromServerGetProtocol];
    }
    else
    {
        [JCYGlobalData sharedInstance].protocolDic=_protocolDic;
        
        //        RegisterInfoViewController * contractInfoViewController = [[RegisterInfoViewController alloc]initWithNibName:@"RegisterInfoViewController" bundle:nil];
        //        [self.navigationController pushViewController:contractInfoViewController animated:YES];
        //        contractInfoViewController.protocolViewModel = self.protocolViewModel;
        
    }
    
    
}
//勾选协议
- (IBAction)selectReadDelegate:(id)sender {
    self.btnSelectRead.selected=!self.btnSelectRead.selected;
    if (self.btnSelectRead.selected) {
        [self.btnSelectRead setImage:[UIImage imageNamed:@"choice_selected@3x.png"] forState:UIControlStateNormal];
    }else{
        [self.btnSelectRead setImage:[UIImage imageNamed:@"choice_unselected@3x.png"] forState:UIControlStateNormal];
    }
    
}
//验证码action
- (IBAction)clickGetCode:(id)sender {
    NSLog(@"点击获取验证码");
    if ([self.phoneTextField.text isEqualToString:@""]) {
        
        [[PBAlert sharedInstance] showText:@"手机号不能为空" inView:self.view withTime:2.0];
        return;
    }else if (![CommonUtil isValidateMobile:self.phoneTextField.text]) {
        [[PBAlert sharedInstance] showText:@"请输入正确的手机号" inView:self.view withTime:2.0];
        return;
    }
    
    [[TimerView shareTimerView] currentTime:sender endTime:^{
        NSLog(@"倒计时结束");
    }];
    //获取验证码
    [self requestFromServerSendValidCode];
}
//返回
- (IBAction)goBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
