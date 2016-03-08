//
//  JCYOpinionFeedbackViewController.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/8.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "JCYOpinionFeedbackViewController.h"

@interface JCYOpinionFeedbackViewController ()<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *opinionTextView;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumLable;
@property (nonatomic,strong) NSString *phoneNum;
@property (strong, nonatomic) AFRquest *CommitFeedback;


@end

@implementation JCYOpinionFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    
    _phoneNum=[JCYGlobalData sharedInstance].userInfo[@"Mobile"];
    
    _phoneNumLable.text=[NSString stringWithFormat:@"%@****%@",[_phoneNum substringToIndex:3],[_phoneNum substringFromIndex:7]];
    
}

-(void)setUI
{
    _opinionTextView.layer.borderWidth=1;
    _opinionTextView.layer.borderColor=CommonBackgroundColor_gray.CGColor;
    
    _phoneNumLable.layer.borderWidth=1;
    _phoneNumLable.layer.borderColor=CommonBackgroundColor_gray.CGColor;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPress:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)submitButtonPress:(UIButton *)sender {
    
    if ([_opinionTextView.text isEqualToString:@""]||[_opinionTextView.text isEqualToString:@"  请留下您宝贵的意见"]) {
        
        [[PBAlert sharedInstance] showText:@"请输入有效的反馈内容" inView:self.view withTime:2.0];
        
        return;
    }

    [self requestDataFromServer];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_opinionTextView resignFirstResponder];
}
#pragma mark -- 请求服务端数据
//从服务器请求数据
-(void)requestDataFromServer
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataReceived:) name:[NSString stringWithFormat:@"%i",CommitFeedback] object:nil];
    
    NSUserDefaults * userInfo = [NSUserDefaults standardUserDefaults];
    NSString * userToken = [userInfo valueForKey:USERTOKEN];
    
    _CommitFeedback = [[AFRquest alloc]init];
    
    _CommitFeedback.subURLString =[NSString stringWithFormat:@"api/Feedback/Add?userToken=%@&deviceType=ios",userToken];
    
    _CommitFeedback.parameters = @{@"Content":_opinionTextView.text,@"Phone":_phoneNum};
    
    _CommitFeedback.style = POST;
    
    [_CommitFeedback requestDataFromWithFlag:CommitFeedback];
    
}

-(void)dataReceived:(NSNotification *)notif{
    
    
    
    
    int result = [_CommitFeedback.resultDict[@"Code"] intValue];
    if (result == SUCCESS) {
        
        
        //提交意见时的弹出框
        UIAlertView *prompt = [[UIAlertView alloc] initWithTitle:@"" message:@"提交成功" delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [prompt show];
        
    }else{
        [[PBAlert sharedInstance] showText:_CommitFeedback.resultDict[@"Description"] inView:self.view withTime:2.0];
    }
    
    
    
    NSLog(@"%@",_CommitFeedback.resultDict);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",CommitFeedback] object:nil];
}


#pragma mark -- TextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"  请留下您宝贵的意见"
         ]) {
        textView.text = @"";
        textView.textColor = CommonColor_Black;
        
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"  请留下您宝贵的意见";
        textView.textColor = CommonColor_Gray;
    }
    
}

//打印点击的alert按钮
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        //提交完成后 跳转回设置页面
        [self.navigationController popViewControllerAnimated:YES];
    }
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
