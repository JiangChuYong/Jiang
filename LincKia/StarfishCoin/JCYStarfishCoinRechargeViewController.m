//
//  JCYStarfishCoinRechargeViewController.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/9.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "JCYStarfishCoinRechargeViewController.h"
#import "PBAlertViewController.h"
//cell
#import "JCYStarfishCoinRechargeCell.h"
#import "MessageClassifyViewCell.h"
#import "PaymentsChooseViewCell.h"
@interface JCYStarfishCoinRechargeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *rechargeTableView;
@property(strong,nonatomic) NSArray *paymentImageNameArray;//存放支付方式（支付宝，微信，银联）的照片名
@property (assign,nonatomic) PayAccountIDStyle payAccountIDStyle;
@property (strong, nonatomic) NSString *paymentMethod;
//@property (strong, nonatomic) PBAlertViewController *successAlertVC;
@property (strong, nonatomic) PBAlertViewController *cancelAlertVC;

@property (strong, nonatomic) NSString *tradeNo;
@property (strong, nonatomic) NSMutableDictionary *starFishDic;


@end

@implementation JCYStarfishCoinRechargeViewController
static NSString * rechargeCellIDKey = @"JCYStarfishCoinRechargeCell";
static NSString * messageCellIDkey = @"MessageClassifyViewCell";
static NSString * PaymentsChooseCellIDKey = @"PaymentsChooseViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.paymentImageNameArray=@[@"alipay@3x.png",@"wechat@3x.png",@"unionpay@3x.png"];
    //支付方式默认支付宝
    self.payAccountIDStyle=PayAccountID_AliPay;
    self.automaticallyAdjustsScrollViewInsets = false;
    [_rechargeTableView registerNib:[UINib nibWithNibName:@"JCYStarfishCoinRechargeCell" bundle:nil] forCellReuseIdentifier:rechargeCellIDKey];
    
    [_rechargeTableView registerNib:[UINib nibWithNibName:@"MessageClassifyViewCell" bundle:nil] forCellReuseIdentifier:messageCellIDkey];
    
    [_rechargeTableView registerNib:[UINib nibWithNibName:@"PaymentsChooseViewCell" bundle:nil] forCellReuseIdentifier:PaymentsChooseCellIDKey];
    _starFishDic=[JCYGlobalData sharedInstance].commonViewData;
    
}


//支付取消弹出提示框
- (IBAction)goBack:(UIBarButtonItem *)sender {
    _cancelAlertVC = [PBAlertViewController shareInstance];
    [self.view addSubview:[_cancelAlertVC creatBackgroundViewAndAlertView]];
    [_cancelAlertVC addLeftButtonTile:@"取消" andRightButtonTitle:@"确认" withMessage:@"是否退出充值？"];
    [_cancelAlertVC.smallerSureBtn addTarget:self action:@selector(alertSmallSureBtnBackPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_cancelAlertVC.cancelBtn addTarget:self action:@selector(alertCancelBtnBackPressed:) forControlEvents:UIControlEventTouchUpInside];
   // [self.navigationController popViewControllerAnimated:YES];
}

-(void)alertCancelBtnBackPressed:(UIButton *)sender
{
    
    [_cancelAlertVC.view removeFromSuperview];
}

-(void)alertSmallSureBtnBackPressed:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)instantRechargeButtonPressed:(UIButton *)sender {
    
    NSLog(@"海星币充值");
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0||indexPath.row==1) {
        JCYStarfishCoinRechargeCell *myRechargeCell=[_rechargeTableView dequeueReusableCellWithIdentifier:rechargeCellIDKey];
        return myRechargeCell.frame.size.height;
    }else if (indexPath.row==2){
        MessageClassifyViewCell *myMessageCell=[_rechargeTableView dequeueReusableCellWithIdentifier:messageCellIDkey];
        return myMessageCell.frame.size.height;
    }else{
        PaymentsChooseViewCell *myPaymentsChooseCell=[_rechargeTableView dequeueReusableCellWithIdentifier:PaymentsChooseCellIDKey];
        return myPaymentsChooseCell.frame.size.height;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row==0||indexPath.row==1) {
        JCYStarfishCoinRechargeCell *myRechargeCell=[_rechargeTableView dequeueReusableCellWithIdentifier:rechargeCellIDKey];
        switch (indexPath.row) {
            case 0:
                myRechargeCell.markLabel.text=@"海星币充值：";
                myRechargeCell.starfishCoinLabel.text=_starFishDic[@"StarfishCoin"];
                myRechargeCell.priceSymbolLabel.hidden=NO;
                break;
            case 1:
                myRechargeCell.markLabel.text=@"支付：";
                myRechargeCell.starfishCoinLabel.text=_starFishDic[@"StarfishPrice"];
                myRechargeCell.priceSymbolLabel.hidden=YES;
                break;
                
            default:
                break;
        }
        return myRechargeCell;
    }else if (indexPath.row==2){
        MessageClassifyViewCell *myMessageCell = [_rechargeTableView dequeueReusableCellWithIdentifier:messageCellIDkey];
        myMessageCell.lableClassifyName.text=@"请选择支付方式";
        return myMessageCell;
    }else{
        PaymentsChooseViewCell *myPaymentsChooseCell=[_rechargeTableView dequeueReusableCellWithIdentifier:PaymentsChooseCellIDKey];;
        switch (indexPath.row) {
            case 3:
                [myPaymentsChooseCell initUIComponentWithImage:[self.paymentImageNameArray objectAtIndex:0] paymentName:@"支付宝支付" declare:nil];
                myPaymentsChooseCell.btnPaymentCheckBox.tag=2000+PayAccountID_AliPay;
                if(self.payAccountIDStyle==PayAccountID_AliPay){
                    myPaymentsChooseCell.btnPaymentCheckBox.selected=YES;
                }
                break;
            case 4:
                [myPaymentsChooseCell initUIComponentWithImage:[self.paymentImageNameArray objectAtIndex:1] paymentName:@"微信支付" declare:nil];
                myPaymentsChooseCell.btnPaymentCheckBox.tag=2000+PayAccountID_WeiXin;
                if(self.payAccountIDStyle==PayAccountID_WeiXin){
                    myPaymentsChooseCell.btnPaymentCheckBox.selected=YES;
                }
                break;
                
            default:
                break;
        }
        [myPaymentsChooseCell.btnPaymentCheckBox addTarget:self action:@selector(paymentCheckBox:) forControlEvents:UIControlEventTouchUpInside];//按钮点击事件
        return myPaymentsChooseCell;
        
    }
    
}
//点击checkBox 选择支付方式
-(void)paymentCheckBox:(id)sender{
    UIButton *button=(UIButton *)sender;
    button.selected=!button.selected;
    if (button.selected) {
        self.payAccountIDStyle = (int)button.tag-2000;
    }else{
        self.payAccountIDStyle = 0;
    }
    [self.rechargeTableView reloadData];
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
