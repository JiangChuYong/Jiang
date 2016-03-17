//
//  JCYChangedPhoneNumViewController.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/14.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "JCYChangedPhoneNumViewController.h"
#import "TimerView.h"

@interface JCYChangedPhoneNumViewController ()
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;

@property (strong, nonatomic) AFRquest *SendValidCode;
@property (strong, nonatomic) AFRquest *CheckUserByValidCode;

@end

@implementation JCYChangedPhoneNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self setUI];
    [self resetUI];
}


-(void)resetUI
{
    //填入用户手机号
    NSString * mobile = [JCYGlobalData sharedInstance].userInfo[@"Mobile"];
    _phone.placeholder = [mobile stringByReplacingCharactersInRange:NSMakeRange(4, 4) withString:@"****"];
    _phone.userInteractionEnabled = NO;
}

#pragma -- mark UI PART
-(void)setUI
{
    _getCodeButton.layer.cornerRadius = 5;
    _getCodeButton.clipsToBounds = YES;
    
    _confirmButton.layer.cornerRadius = 5;
    _confirmButton.clipsToBounds = YES;
    [_code addTarget:self action:@selector(textFiedDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
}

-(void)textFiedDidChanged:(UITextField *)textField
{
        
    if(textField.text.length > 6 && [textField isEqual:_code]){
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
    [_code resignFirstResponder];
}


- (IBAction)getCodeButtonPressed:(id)sender {
    NSLog(@"%@",_phone.text);
    //短信修改请求验证码
    [self requestFromServerSendValidCode:[JCYGlobalData sharedInstance].userInfo[@"Mobile"] Type:@"1"];
    [[TimerView shareTimerView] currentTime:sender endTime:^{
        NSLog(@"倒计时结束");
    }];
    
}
- (IBAction)confirmButtonPressed:(id)sender {
    [self requestFromServerCheckUserByValidCode];
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

//手机短信验证码验证用户
-(void)requestFromServerCheckUserByValidCode
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkUserByValidCodeDataReceived:) name:[NSString stringWithFormat:@"%i",CheckUserByValidCode] object:nil];
    _CheckUserByValidCode = [[AFRquest alloc]init];
    
    _CheckUserByValidCode.subURLString =@"api/Users/CheckUserByValidCode?deviceType=ios";
    
    _CheckUserByValidCode.parameters = @{@"phoneNum":[JCYGlobalData sharedInstance].userInfo[@"Mobile"],@"validCode":_code.text};
    
    _CheckUserByValidCode.style = GET;
    
    [_CheckUserByValidCode requestDataFromWithFlag:CheckUserByValidCode];
    
}

-(void)checkUserByValidCodeDataReceived:(NSNotification *)notif{
    int result = [_CheckUserByValidCode.resultDict[@"Code"] intValue];
    if (result == SUCCESS) {
        
        [self performSegueWithIdentifier:@"VerificationToSetNewPhoneNum" sender:self];
        
    }else{
        [[PBAlert sharedInstance] showText:_CheckUserByValidCode.resultDict[@"Description"] inView:self.view withTime:2.0];
    }
    NSLog(@"%@",_CheckUserByValidCode.resultDict);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",CheckUserByValidCode] object:nil];
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
