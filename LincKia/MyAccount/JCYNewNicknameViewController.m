//
//  JCYNewNicknameViewController.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/11.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "JCYNewNicknameViewController.h"

@interface JCYNewNicknameViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UIView *saveBtnBackground;
//saveBtnBackground的底部约束
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *updateComstraint;

@property (strong, nonatomic) AFRquest *EditUserInfo;

@end

@implementation JCYNewNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [_nameTextField addTarget:self action:@selector(monitorTextField:) forControlEvents:UIControlEventEditingChanged];

    if ([JCYGlobalData sharedInstance].orderSubmitFlag==ModifyName) {
        self.title=@"修改姓名";
    }
    
    
}

-(void)monitorTextField:(UITextField *)sender
{
    if (sender.text.length > 200) {
        sender.text = [sender.text substringToIndex:200];
    }
}

- (IBAction)goBack:(id)sender {

    [self saveInfoSuccess];
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_nameTextField resignFirstResponder];
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardFrame ;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    NSNumber * duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    _updateComstraint.constant=keyboardFrame.size.height;

    [UIView animateWithDuration:[duration doubleValue] animations:^{
        
        [self.view layoutIfNeeded];
        
    }];
    
}
-(void)keyboardWillHide:(NSNotification *)notification
{
    NSNumber * duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    _updateComstraint.constant=0;

    [UIView animateWithDuration:[duration doubleValue] animations:^{
        
        [self.view layoutIfNeeded];
    }];
    
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



- (IBAction)saveInfo:(UIButton *)sender {
    [_nameTextField resignFirstResponder];
    if ([CommonUtil isBlankString:_nameTextField.text]||[CommonUtil stringContainsSpacing:_nameTextField.text]) {
        if ([JCYGlobalData sharedInstance].orderSubmitFlag==ModifyName) {
            [[PBAlert sharedInstance] showText:@"请输入有效的姓名" inView:self.view withTime:2.0];
        }else if ([JCYGlobalData sharedInstance].orderSubmitFlag==ModifyNickName)
        {
              [[PBAlert sharedInstance] showText:@"请输入有效的昵称" inView:self.view withTime:2.0];
        }
        
        return;
    }
    [self requestDataFromServer];
    
    
}

//  修改昵称或者姓名
-(void)requestDataFromServer
{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataReceived:) name:[NSString stringWithFormat:@"%i",EditUserInfo] object:nil];
    
    NSUserDefaults * userInfo = [NSUserDefaults standardUserDefaults];
    NSString * userToken = [userInfo valueForKey:USERTOKEN];
    
    _EditUserInfo = [[AFRquest alloc]init];
    
    _EditUserInfo.subURLString =[NSString stringWithFormat:@"api/Users/EditUserInfo?userToken=%@&deviceType=ios",userToken];
    if ([JCYGlobalData sharedInstance].orderSubmitFlag==ModifyNickName) {
        
        _EditUserInfo.parameters=@{@"DisplayName":_nameTextField.text,@"UserName":@""};
        
    }else if ([JCYGlobalData sharedInstance].orderSubmitFlag==ModifyName){
        _EditUserInfo.parameters=@{@"DisplayName":@"",@"UserName":_nameTextField.text};
        
    }
    _EditUserInfo.style = POST;
    
    [_EditUserInfo requestDataFromWithFlag:EditUserInfo];
}

-(void)dataReceived:(NSNotification *)notif{
    int result = [_EditUserInfo.resultDict[@"Code"] intValue];
    if (result == SUCCESS) {
        
         [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateName" object:_nameTextField.text];
        [[PBAlert sharedInstance] showText:@"修改成功" inView:self.view withTime:1.0];
        
        [self performSelector:@selector(saveInfoSuccess) withObject:nil afterDelay:1.0];
    }else{
        [[PBAlert sharedInstance] showText:_EditUserInfo.resultDict[@"Description"] inView:self.view withTime:2.0];
    }
    NSLog(@"%@",_EditUserInfo.resultDict);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",EditUserInfo] object:nil];
}
-(void)saveInfoSuccess{
    [self.navigationController popViewControllerAnimated:YES];
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
