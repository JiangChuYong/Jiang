//
//  RegisterInfoViewController.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/11.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "RegisterInfoViewController.h"

@interface RegisterInfoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnPhone;
@property (weak, nonatomic) IBOutlet UITextView *textProtocol;

@property (strong, nonatomic) AFRquest *GetProtocol;
@property (strong, nonatomic) NSDictionary *protocolDic;

@end

@implementation RegisterInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestFromServerGetProtocol];

    [self setViewFontAndColor];
    
    
}

#pragma mark -- 私有方法

/**
 *返回关于我们页面
 */

- (IBAction)goback:(id)sender {
[self dismissViewControllerAnimated:YES completion:nil];
    
}


/**
 * 打电话机制
 */

-(IBAction)callToPrivateCustom:(id)sender{
    NSLog(@"%@",self.btnPhone.currentTitle);
    
    NSMutableString *phoneNum=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_protocolDic[@"Tel"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNum]];
    
}


/**
 设置页面的字体以及颜色
 */
-(void)setViewFontAndColor{
    self.btnPhone.titleLabel.font=[UIFont systemFontOfSize:CommonFontSize_Large];
    [self.btnPhone setTitleColor:CommonColor_Black forState:UIControlStateNormal];
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
        [self dealResposeResult:_GetProtocol.resultDict[@"Data"]];
    }else{
        [[PBAlert sharedInstance] showText:_GetProtocol.resultDict[@"Description"] inView:self.view withTime:2.0];
    }
    NSLog(@"%@",_GetProtocol.resultDict);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",GetProtocol] object:nil];
}

//处理请求返回后的结果
-(void)dealResposeResult:(NSDictionary  *)response{
    _protocolDic=response;
    [self initItem];
    
}

-(void)initItem{
    self.textProtocol.text=_protocolDic[@"Content"];
    self.btnPhone.titleLabel.text=_protocolDic[@"Tel"];
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
