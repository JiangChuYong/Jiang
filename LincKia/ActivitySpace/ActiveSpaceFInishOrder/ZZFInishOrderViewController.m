//
//  ZZFInishOrderViewController.m
//  LincKia
//
// 完成订单

#import "ZZFInishOrderViewController.h"

@interface ZZFInishOrderViewController ()

@end

@implementation ZZFInishOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setUI];//设置文字的字号及颜色

}
-(void)viewWillAppear:(BOOL)animated
{
    UINavigationController *navi=(UINavigationController *)self.parentViewController;
    //导航隐藏的页面跳转至导航显示的页面
    if (!navi.navigationBar.hidden) {
        navi.navigationBar.hidden = YES;
        
    }
}
//返回首页
- (IBAction)backToHome:(id)sender {

//    [((ZZAppDelegate *)[[UIApplication sharedApplication] delegate]).viewController viewDidLoad];
    UINavigationController *navi=(UINavigationController *)self.parentViewController;
    [navi popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//设置文字的字号及颜色
-(void)setUI{
    
    //myOrderDetailBtn圆角效果
    self.myOrderDetailBtn.layer.cornerRadius = 5;
    [self.myOrderDetailBtn clipsToBounds];
    
    if ([JCYGlobalData sharedInstance].sucessFromPage==MyOnlineBooking||[JCYGlobalData sharedInstance].sucessFromPage==ActiveSpaceOrderDetail) {
        self.labelTitle.text=@"预约成功";
        self.labelPaySuccessNote.text=@"您的预约已经成功";
        self.labelMobileNote.text=@"根据您的预约我们会将预约参观的的详细信息通过短信发送到您的手机：";
        
        [self.myOrderDetailBtn setTitle:@"查看我的预约" forState:UIControlStateNormal];
        
        if (![JCYGlobalData sharedInstance].isActiveSpace) {
            NSLog(@"%@",[JCYGlobalData sharedInstance].spaceVisitDict);
            self.mobile.text=[JCYGlobalData sharedInstance].spaceVisitDict[@"TelPhone"];
            
            
        }else{
            self.mobile.text=[JCYGlobalData sharedInstance].activeSpaceBookingInfo[@"phoneNum"];
        }
    }else if ([JCYGlobalData sharedInstance].sucessFromPage==MyOrderDetail){
        //self.mobile.text=[JCYGlobalData sharedInstance].userInfo;
    }
    
}

- (IBAction)pushToMyOrderDetailPage:(UIButton *)sender {
    
//    if ([ZZGlobalModel sharedInstance].orderSubmitFlag == OrderSubmitFlag_OrdersAddMeetingRoom || [ZZGlobalModel sharedInstance].orderSubmitFlag == FromUnpayPage) {
//        PBMeetingRoomOrderDetailViewController * VC = [[PBMeetingRoomOrderDetailViewController alloc]init];
//        [self.navigationController pushViewController:VC animated:YES];
//        return;
//    }
//
    
     //推向订单详情页面
    if ([JCYGlobalData sharedInstance].sucessFromPage==MyOnlineBooking||[JCYGlobalData sharedInstance].sucessFromPage==ActiveSpaceOrderDetail){
        [self performSegueWithIdentifier:@"FinishToOrderDetail" sender:self];
        
    }//else if ([ZZGlobalModel sharedInstance].sucessFromPage==MyOrderDetail){
//        ZZMyOrderDetailViewController *myOrderDetailVc=[[ZZMyOrderDetailViewController alloc]init];
//        [self.navigationController pushViewController:myOrderDetailVc animated:YES];
//    }
}

   
@end
