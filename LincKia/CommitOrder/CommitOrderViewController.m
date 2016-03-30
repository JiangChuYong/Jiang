//
//  CommitOrderViewController.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/25.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "CommitOrderViewController.h"
#import "MessageClassifyViewCell.h"
#import "OrderInformationViewCell.h"
#import "SwitchChoiseViewCell.h"
#import "CouponCodeViewCell.h"
#import "PaymentsChooseViewCell.h"
#import "TotalPriceAndPayButtonViewCell.h"
//#import "IsGroupButtonViewCell.h"
#import "AcceptContractViewCell.h"
#import "PayOrderModel.h"
@interface CommitOrderViewController ()<UITextFieldDelegate,UITableViewDataSource,UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnConfirmAndGoPay;//"确认信息，去支付"按钮

@property (weak, nonatomic) IBOutlet UIView *footerView;//底部view
@property (weak, nonatomic) IBOutlet UITableView *orderTableView;//中间tableview
@property (weak, nonatomic) IBOutlet UILabel *labelTotalPrice;//订单总额
@property (weak, nonatomic) IBOutlet UILabel *labelAccountPayable;//应付金额
@property(strong,nonatomic) NSArray *paymentImageNameArray;//存放支付方式（支付宝，微信，银联）的照片名
@property (assign,nonatomic) NSInteger cartItemListModeCount;//表示商品的条数
@property (assign,nonatomic) BOOL isAcceptTheContract;//用来判断是否勾选同意合同
//用户信息
@property (strong, nonatomic) NSDictionary *userInfo;
//订单显示信息
@property (strong, nonatomic) NSDictionary *orderInfo;
//支付方式
@property (assign,nonatomic) PayAccountIDStyle payAccountIDStyle;

@property (strong, nonatomic) PayOrderModel *payOrderInfo;

@property(nonatomic,strong)CouponCodeViewCell* couponCodecell;

@property (strong, nonatomic) AFRquest *OrdersGetOne;
@property (strong, nonatomic) AFRquest *AddMeetingOrder;
@property (strong, nonatomic) AFRquest *AddOrders;





@end

@implementation CommitOrderViewController
static NSString *messageClassifyCellIdentify=@"MessageClassifyViewCell";
static NSString *userInformationCellIdentify=@"UserInformationCell";
static NSString *orderInformationCellIdentify=@"OrderInformationViewCell";
static NSString *totalPriceAndPayButtonViewCellIdentify=@"TotalPriceAndPayButtonViewCell";

static NSString *paymentsChooseViewCellIdentify=@"PaymentsChooseViewCell";
static NSString *switchChoiseViewCellIdentify=@"SwitchChoiseViewCell";
static NSString *couponCodeViewCellIdentify=@"CouponCodeViewCell";
static NSString *acceptContractViewCellIdentify=@"AcceptContractViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = false;
    [self tableViewregisterNib];
    [self addToOrders];//订单添加请求
    [self initDateSource];
    [self initUIComponent];
    [self setViewFontAndColor];//用于设置字体的大小和颜色
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.orderTableView addGestureRecognizer:tapGestureRecognizer];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([JCYGlobalData sharedInstance].hasNavi) {
        UINavigationController *navi=(UINavigationController *)self.parentViewController;
        [navi.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        navi.navigationBar.hidden = NO;

    }

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if ([JCYGlobalData sharedInstance].hasNavi){
        UINavigationController *navi=(UINavigationController *)self.parentViewController;
        navi.navigationBar.hidden = YES;
        [JCYGlobalData sharedInstance].hasNavi=NO;
    }
   
    
}
-(void)tableViewregisterNib
{
    [_orderTableView registerNib:[UINib nibWithNibName:@"MessageClassifyViewCell" bundle:nil] forCellReuseIdentifier:messageClassifyCellIdentify];
    
    [_orderTableView registerNib:[UINib nibWithNibName:@"PaymentsChooseViewCell" bundle:nil] forCellReuseIdentifier:paymentsChooseViewCellIdentify];
    
    [_orderTableView registerNib:[UINib nibWithNibName:@"OrderInformationViewCell" bundle:nil] forCellReuseIdentifier:orderInformationCellIdentify];
    
    [_orderTableView registerNib:[UINib nibWithNibName:@"SwitchChoiseViewCell" bundle:nil] forCellReuseIdentifier:switchChoiseViewCellIdentify];
    
    [_orderTableView registerNib:[UINib nibWithNibName:@"CouponCodeViewCell" bundle:nil] forCellReuseIdentifier:couponCodeViewCellIdentify];
    
    [_orderTableView registerNib:[UINib nibWithNibName:@"TotalPriceAndPayButtonViewCell" bundle:nil] forCellReuseIdentifier:totalPriceAndPayButtonViewCellIdentify];
    
    [_orderTableView registerNib:[UINib nibWithNibName:@"AcceptContractViewCell" bundle:nil] forCellReuseIdentifier:acceptContractViewCellIdentify];
}
//初始化数据源
-(void)initDateSource{
    self.userInfo=[JCYGlobalData sharedInstance].userInfo;//用户信息
    //存放支付方式（支付宝，微信，银联）的照片名
    self.paymentImageNameArray=@[@"alipay@3x.png",@"wechat@3x.png",@"unionpay@3x.png"];
    
    
    //给PayOrderModel赋初值
    self.payOrderInfo=[[PayOrderModel alloc] init];
    self.payOrderInfo.DiscountAmount=0;//不考虑优惠券
    self.payOrderInfo.DiscountCode=nil;
    self.payOrderInfo.BeedInvoice=NO;
    self.payOrderInfo.IsPayOffline=NO;
    self.payAccountIDStyle=PayAccountID_AliPay;
    self.isAcceptTheContract=YES;//给是否同意合同标识赋初值
   // self.isPaySucceed=NO;
}
//初始化UI组件
-(void)initUIComponent{
    //设置隐藏tableview的分割线
    self.orderTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.orderTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}
#pragma mark --私有方法
//将手机号处理为 134****3265样式
-(NSString *)mobileNumberHideMiddle:(NSString *)mobile{
    NSString *result=[[mobile substringToIndex:3] stringByAppendingString:@"****"];
    result=[result stringByAppendingString:[mobile substringFromIndex:7]];
    return result;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //优惠券textfield
    if ((textField.tag-3000)==2) {
        [self couponTextBorderChange:textField isFocused:YES];
        self.btnConfirmAndGoPay.enabled=NO;
        [self.orderTableView setContentOffset:CGPointMake(0,self.couponCodecell.frame.origin.y-118) animated:YES];
    }
}

//优惠券输入边框变换
-(void)couponTextBorderChange:(UITextField *)textField isFocused:(BOOL)isFocuse{
    UIImageView *couponImageView=(UIImageView *)[self.view viewWithTag:4000];
    if (isFocuse) {
        couponImageView.image=[UIImage imageNamed:@"coupons_textfield_focused@3x.png"];
    }else{
        couponImageView.image=[UIImage imageNamed:@"coupons_textfield_unfocused@3x.png"];
    }
}
//设置文字的字号及颜色
-(void)setViewFontAndColor{
    self.btnConfirmAndGoPay.layer.cornerRadius = 5;
    [self.btnConfirmAndGoPay.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.btnConfirmAndGoPay clipsToBounds];
}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.couponCodecell.textFieldCouponCode resignFirstResponder];
}

#pragma mark --代理方法
//设置tableview的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //self.cartItemListModeCount是不定的
    return 9 + self.cartItemListModeCount;
}

//实例化各个cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //订单信息
    if (indexPath.row == 0) {
        //第一行标头
        MessageClassifyViewCell *cell=[_orderTableView dequeueReusableCellWithIdentifier:messageClassifyCellIdentify];
        cell.lableClassifyName.text=@"订单信息";
        [cell.lableClassifyName setFont:[UIFont systemFontOfSize:15]];
        
        return cell;
    }else if (indexPath.row>0&&indexPath.row<self.cartItemListModeCount+1){
        OrderInformationViewCell *cell=[_orderTableView dequeueReusableCellWithIdentifier:orderInformationCellIdentify];
        [cell initDataSourceWithOrderDetailModel:[self.orderInfo[@"OrderDetailInfo"] objectAtIndex:indexPath.row-1] withOrderViewInfo:self.orderInfo];
        
        return cell;
    }
    //发票的选择
    else if (indexPath.row == self.cartItemListModeCount+1){
        SwitchChoiseViewCell *cell=[_orderTableView dequeueReusableCellWithIdentifier:switchChoiseViewCellIdentify];
        
        [cell initDateSourceWithSelectName:@"发票" describe:@"(请到预定门店领取发票)"];
        cell.btnSwitch.tag=1000;
        cell.btnSwitch.selected=self.payOrderInfo.BeedInvoice;
        [cell.btnSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    //标签（选择支付方式）
    else if (indexPath.row == self.cartItemListModeCount + 2){
        MessageClassifyViewCell *cell=[_orderTableView dequeueReusableCellWithIdentifier:messageClassifyCellIdentify];
        
        cell.lableClassifyName.text=@"请选择支付方式";
        return cell;
    }
    //支付方式
    else if (indexPath.row>2+self.cartItemListModeCount&&indexPath.row<5+self.cartItemListModeCount){
        //支付方式
        PaymentsChooseViewCell *cell=[[PaymentsChooseViewCell alloc]init];
        switch (indexPath.row-self.cartItemListModeCount) {
            case 3:
                [cell initUIComponentWithImage:[self.paymentImageNameArray objectAtIndex:0] paymentName:@"支付宝付款" declare:nil];
                cell.btnPaymentCheckBox.tag=2000+PayAccountID_AliPay;
                if(self.payAccountIDStyle==PayAccountID_AliPay){
                    cell.btnPaymentCheckBox.selected=YES;
                }
                break;
            case 4:
                [cell initUIComponentWithImage:[self.paymentImageNameArray objectAtIndex:1] paymentName:@"微信付款" declare:nil];
                cell.btnPaymentCheckBox.tag=2000+PayAccountID_WeiXin;
                if(self.payAccountIDStyle==PayAccountID_WeiXin){
                    cell.btnPaymentCheckBox.selected=YES;
                }
                break;
            default:
                break;
        }
        if (indexPath.row == self.cartItemListModeCount +4) {
            cell.blueLineImageView.hidden = YES;
        }
        [cell.btnPaymentCheckBox addTarget:self action:@selector(paymentCheckBox:) forControlEvents:UIControlEventTouchUpInside];//按钮点击事件
        return cell;
    }
    //优惠券
    else if (indexPath.row==5+self.cartItemListModeCount){
        self.couponCodecell=[_orderTableView dequeueReusableCellWithIdentifier:couponCodeViewCellIdentify];
        [self.couponCodecell.btnSure addTarget:self action:@selector(couponCodeSure:) forControlEvents:UIControlEventTouchUpInside];
        self.couponCodecell.textFieldCouponCode.text=self.payOrderInfo.DiscountCode;
        self.couponCodecell.textFieldCouponCode.delegate=self;
        self.couponCodecell.textFieldCouponCode.tag=3000+2;
        return self.couponCodecell;
    }else if (indexPath.row == self.cartItemListModeCount + 6){
        SwitchChoiseViewCell *cell=[_orderTableView dequeueReusableCellWithIdentifier:switchChoiseViewCellIdentify];
        [cell initDateSourceWithSelectName:@"门店支付" describe:@""];
        if (self.payOrderInfo.IsPayOffline) {
            cell.btnSwitch.selected = YES;
        }else{
            cell.btnSwitch.selected = NO;
        }
        cell.btnSwitch.tag=1001;
        cell.btnSwitch.selected=self.payOrderInfo.IsPayOffline;
        [cell.btnSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else if (indexPath.row==7+self.cartItemListModeCount){//底部部分
        
        TotalPriceAndPayButtonViewCell *cell=[_orderTableView dequeueReusableCellWithIdentifier:totalPriceAndPayButtonViewCellIdentify];
        NSString *mobile=[self mobileNumberHideMiddle:self.userInfo[@"Mobile"]];//将手机号处理
        cell.labelMbileNote.text = [NSString stringWithFormat:@"订单成功后，订单序列号将发送到  %@",mobile];
        return cell;
    }
    else if(indexPath.row==8+self.cartItemListModeCount){//同意合同
        AcceptContractViewCell *cell=[_orderTableView dequeueReusableCellWithIdentifier:acceptContractViewCellIdentify];
        cell.btnCheckBox.selected=self.isAcceptTheContract;
        //给复选框添加事件
        [cell.btnCheckBox addTarget:self action:@selector(acceptTheContract:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnRentContract addTarget:self action:@selector(showTheContract:) forControlEvents:UIControlEventTouchUpInside];
        return  cell;
    }else{
        return nil;
    }
}

//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 33;
    }else if (indexPath.row>0&&indexPath.row<self.cartItemListModeCount+1) {
        return 155;
    }else if(indexPath.row==self.cartItemListModeCount+1) {
        return 48;
    }else if (indexPath.row==self.cartItemListModeCount+2){
        return 33;
    }else if (indexPath.row>self.cartItemListModeCount+2&&indexPath.row<self.cartItemListModeCount+5){
        return 60;
    }else if (indexPath.row == self.cartItemListModeCount+5){
        return 58;
    }else if (indexPath.row == self.cartItemListModeCount+6){
        return 60;
    }else if (indexPath.row == self.cartItemListModeCount+7){
        return 58;
    }else{
        return 37;
    }
}

//cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - 按钮点击跳转方法

//点击switch按钮事件 发票&&门店支付
-(void)switchAction:(id)sender{
    UIButton *button=(UIButton *)sender;
    button.selected=!button.selected;
    if (button.tag==1000) {
        self.payOrderInfo.BeedInvoice=button.selected; //发票
    }else{
        self.payOrderInfo.IsPayOffline=button.selected;//门店支付
        if(self.payOrderInfo.IsPayOffline){//门店支付
            self.payAccountIDStyle=PayAccountID_NO;
            [_btnConfirmAndGoPay setTitle:@"确认订单" forState:UIControlStateNormal];
        }else{
            [_btnConfirmAndGoPay setTitle:@"确认信息，去支付" forState:UIControlStateNormal];
        }
    }
    [self.orderTableView reloadData];
    
    NSLog(@"Switch－－－－门店支付");
}

//点击checkbox同意合同
-(void)acceptTheContract:(id)sender{
    UIButton *button=(UIButton *)sender;
    button.selected=!button.selected;
    self.isAcceptTheContract=button.selected;
}

//点击查看租赁合同
-(void)showTheContract:(id)sender{
//    if(!self.protocolViewModel)
//    {
//        [self requestDataFromServer_Protocol];
//    }
//    else
//    {
//        ContractInfoViewController * contractInfoViewController = [[ContractInfoViewController alloc]initWithNibName:@"ContractInfoViewController" bundle:nil];
//        contractInfoViewController.protocolViewModel = self.protocolViewModel;
//        
//        [self.navigationController pushViewController:contractInfoViewController animated:YES];
//    }
    NSLog(@"－－－－查看租赁合同");

}

//优惠券编码确定
-(void)couponCodeSure:(id)sender{
//    [self.couponCodecell.textFieldCouponCode resignFirstResponder];
//    if (self.couponCodecell.textFieldCouponCode.text.length>1)
//    {
//        CheckDiscountModel * checkDiscountModel = [[CheckDiscountModel alloc]init];
//        checkDiscountModel.DiscountCode = self.couponCodecell.textFieldCouponCode.text;
//        checkDiscountModel.OrderId = self.orderInfo.OrderId;
//        
//        NSLog(@"%@",[checkDiscountModel jsonString]);
//        [self requestFromServerCheckDiscount:checkDiscountModel];//检查优惠券
//    }else{
//        
//        NSString *amount=[NSString stringWithFormat:@"%.0f",self.orderInfo.Amount];//订单总额
//        self.labelTotalPrice.text = amount;//订单总额
//        //显示应付金额
//        self.labelAccountPayable.text = amount;
//        [[AlertUtils sharedInstance] showWithText:@"请输入优惠券编码" inView:self.view lastTime:2.0];
//    }
    
    NSLog(@"－－－－优惠卷");

    
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//点击checkBox 选择支付方式
-(void)paymentCheckBox:(id)sender{
    self.payOrderInfo.IsPayOffline = NO;
    UIButton *button=(UIButton *)sender;
    button.selected=!button.selected;
    //选中支付方式后自动关掉线下支付的选择
    if (button.selected) {
        self.payOrderInfo.IsPayOffline = NO;
    }else{
        self.payOrderInfo.IsPayOffline = YES;
    }
    if (button.selected) {
        self.payAccountIDStyle = (int)button.tag-2000;
    }else{
        self.payAccountIDStyle = 0;
    }
    [_btnConfirmAndGoPay setTitle:@"确认信息，去支付" forState:UIControlStateNormal];
    [self.orderTableView reloadData];
    
    NSLog(@"－－－－选择支付方式");

}




//申请预定订单
-(void)addToOrders
{
    switch ([JCYGlobalData sharedInstance].orderSubmitFlag) {
        case FromUnpayPage:
        case OrderSubmitFlag_FromMyOrder:
        {
            NSLog(@"从我的订单进入");
            [self requestFromServer];
        }
            break;
            
        case OrderSubmitFlag_OrdersAdd:
        {
            NSLog(@"点击立即预定进入");
            
          //  [[ZZAllService sharedInstance] serviceQueryByObj:[ZZGlobalModel sharedInstance].cartModel  delegate:self httpTag:HTTPHelperTag_Orders_Add];//申请预定订单
            [self requestFromServerForLinckiaSpace];
        }
            break;
            
        case OrderSubmitFlag_OrdersAddMeetingRoom:
        {
            //[[ZZAllService sharedInstance]serviceQueryByObj:[ZZGlobalModel sharedInstance].meetingCarModel delegate:self httpTag:HTTPHelperTag_Orders_AddMeeting];
            [self requestFromServerForMeeting];
        }
            
        default:
            break;
    }
}


//从服务器请求数据 获取订单列表
-(void)requestFromServer
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataReceived:) name:[NSString stringWithFormat:@"%i",OrdersGetOne] object:nil];
    
    NSUserDefaults * userInfo = [NSUserDefaults standardUserDefaults];
    NSString * userToken = [userInfo valueForKey:USERTOKEN];
    
    _OrdersGetOne = [[AFRquest alloc]init];
    
    _OrdersGetOne.subURLString =[NSString stringWithFormat:@"api/Orders/GetOne?userToken=%@&deviceType=ios",userToken];
    
    _OrdersGetOne.parameters = @{@"orderID":[JCYGlobalData sharedInstance].orderId};
    
    _OrdersGetOne.style = GET;
    
    [_OrdersGetOne requestDataFromWithFlag:OrdersGetOne];
    
}

-(void)dataReceived:(NSNotification *)notif{
    int result = [_OrdersGetOne.resultDict[@"Code"] intValue];
    if (result == SUCCESS) {
        NSLog(@"办公室");
        
        [self dealResposeResult_OrderDtail:_OrdersGetOne.resultDict[@"Data"]];
    }else{
        [[PBAlert sharedInstance] showText:_OrdersGetOne.resultDict[@"Description"] inView:self.view withTime:2.0];
    }
    
    NSLog(@"%@",_OrdersGetOne.resultDict);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",OrdersGetOne] object:nil];
}

//增加会议室订单
-(void)requestFromServerForMeeting
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(meetingDataReceived:) name:[NSString stringWithFormat:@"%i",AddMeetingOrder] object:nil];
    
    NSUserDefaults * userInfo = [NSUserDefaults standardUserDefaults];
    NSString * userToken = [userInfo valueForKey:USERTOKEN];
    
    _AddMeetingOrder = [[AFRquest alloc]init];
    
    _AddMeetingOrder.subURLString =[NSString stringWithFormat:@"api/Orders/AddMeeting?userToken=%@&deviceType=ios",userToken];
    
    _AddMeetingOrder.parameters = @{@"cart":[JCYGlobalData sharedInstance].meetingCarArr};

    _AddMeetingOrder.style = POST;
    
    [_AddMeetingOrder requestDataFromWithFlag:AddMeetingOrder];
}


-(void)meetingDataReceived:(NSNotification *)notif{
    int result = [_AddMeetingOrder.resultDict[@"Code"] intValue];
    if (result == SUCCESS) {
        NSLog(@"MeetingRoom");
        
        [self dealResposeResult_OrderDtail:_AddMeetingOrder.resultDict[@"Data"]];
    }else{
        [[PBAlert sharedInstance] showText:_AddMeetingOrder.resultDict[@"Description"] inView:self.view withTime:2.0];
        
    }
    
    NSLog(@"%@",_AddMeetingOrder.resultDict);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",AddMeetingOrder] object:nil];
}

//增加Linckiaspace订单
-(void)requestFromServerForLinckiaSpace
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(spaceDataReceived:) name:[NSString stringWithFormat:@"%i",AddOrders] object:nil];
    
    NSUserDefaults * userInfo = [NSUserDefaults standardUserDefaults];
    NSString * userToken = [userInfo valueForKey:USERTOKEN];
    
    _AddOrders = [[AFRquest alloc]init];
    
    _AddOrders.subURLString =[NSString stringWithFormat:@"api/Orders/Add?userToken=%@&deviceType=ios",userToken];
    
    _AddOrders.parameters = @{@"cart":[JCYGlobalData sharedInstance].meetingCarArr};
    
    _AddOrders.style = POST;
    
    [_AddOrders requestDataFromWithFlag:AddOrders];
}


-(void)spaceDataReceived:(NSNotification *)notif{
    int result = [_AddOrders.resultDict[@"Code"] intValue];
    if (result == SUCCESS) {
        
        [self dealResposeResult_OrderDtail:_AddOrders.resultDict[@"Data"]];
    }else{
        [[PBAlert sharedInstance] showText:_AddOrders.resultDict[@"Description"] inView:self.view withTime:2.0];
        
    }
    
    NSLog(@"%@",_AddOrders.resultDict);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",AddOrders] object:nil];
}


//处理空间单元返回后的结果
-(void)dealResposeResult_OrderDtail:(NSDictionary *)response{
    
    self.orderInfo=response;
    self.cartItemListModeCount=[self.orderInfo[@"OrderDetailInfo"] count];
    [self.orderTableView reloadData];
    NSString *amount=[NSString stringWithFormat:@"%.0f",[self.orderInfo[@"Amount"] floatValue]];//订单总额
    NSMutableString * totalPrice = [NSMutableString stringWithFormat:@"￥"];
    self.labelTotalPrice.text=[totalPrice stringByAppendingString:amount];//订单总额
    //显示应付金额
    NSString *payAmount=[NSString stringWithFormat:@"%.0f",[self.orderInfo[@"Amount"] floatValue]-self.payOrderInfo.DiscountAmount];
    NSMutableString * needPay = [NSMutableString stringWithFormat:@"￥"];
    self.labelAccountPayable.text=[needPay stringByAppendingString:payAmount];//应付金额

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
