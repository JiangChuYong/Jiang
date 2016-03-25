//
//  AllOrderListViewController.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/8.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "AllOrderListViewController.h"
#import "AllOrderListViewCell.h"
#import <MJRefresh.h>
@interface AllOrderListViewController ()<UITableViewDelegate,UITableViewDataSource>

//设置字体大小和颜色
@property (weak, nonatomic) IBOutlet UILabel *labelEmptyNote;//"您还没有订单哦！"

@property (weak, nonatomic) IBOutlet UIButton *officeBtn;
@property (weak, nonatomic) IBOutlet UIButton *meettingRoomBtn;

@property (weak, nonatomic) IBOutlet UIView *nodataView; //当没有订单时显示View
@property (weak, nonatomic) IBOutlet UITableView *allOrderListTableView; //订单table
//@property (strong,nonatomic) OrderListInfoModel *orderListInfoModel;//订单列表实体对象

@property(assign, nonatomic)int pageCount;
@property (nonatomic, assign)BOOL hasOtherData;

@property (nonatomic, strong) AFRquest *GetOfficeOrdersList;
@property (nonatomic, strong) AFRquest *GetMeetingOrdersList;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIButton *selectButton;
@end

@implementation AllOrderListViewController
static NSString *orderListCell=@"orderListCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.nodataView.hidden = YES;
    //解决tableview留白
    self.automaticallyAdjustsScrollViewInsets = false;

    
//    self.orderListInfoModel=[[OrderListInfoModel alloc] init];
//    self.orderListInfoModel.OrderListArray = [NSMutableArray array];
    
  
    _dataArr=[NSMutableArray array];
    [self initUIComponent];
    [self setViewFontAndColor];//设置字体大小和颜色
    
    [self spaceTypeButtonSelected:_officeBtn];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UINavigationController *navi=(UINavigationController *)self.parentViewController;
    navi.tabBarController.tabBar.hidden=YES;
}

//页面已出现(系统方法)
-(void)viewDidAppear:(BOOL)animated{
    //让滑动条闪动一次，以提醒用户此页面可以滑动
    [self.allOrderListTableView flashScrollIndicators];
   
}
#pragma mark - 初始化
-(void)isShowEmptyTableWithArr:(NSMutableArray *)dataArr {
    //列表数据
    if (dataArr.count>0) {
        //当没有订单时显示的View
        self.nodataView.hidden = YES;
    }else{
        self.nodataView.hidden = NO;
    }
}

//初始化UI组件
-(void)initUIComponent{
    //注册Cell
    [self.allOrderListTableView registerNib:[UINib nibWithNibName:@"AllOrderListViewCell" bundle:nil] forCellReuseIdentifier:orderListCell];
    
}

#pragma mark - tableView的初始化
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllOrderListViewCell *cell=[tableView dequeueReusableCellWithIdentifier:orderListCell];
   
    NSString *orderInfo=[_dataArr objectAtIndex:indexPath.row];
    
    [cell initCellDataSourceWithOrder:orderInfo];//对cell中的元素赋值
    return cell;
}
//点击cell，跳转到提交订单
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_selectButton isEqual:_officeBtn]) {
        [self goOfficeOrderDetailView:(int)indexPath.row];
    }else{
       // [self goMeetingRoomOrderDetailView:(int)indexPath.row];
        NSLog(@"fads");
    }
}

#pragma mark - 按钮点击响应事件
/**
 *点击返回到”我的“页面
 */
- (IBAction)gobackToMineMainPage:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)spaceTypeButtonSelected:(UIButton *)sender {
    [self resetSelectedButtonUI:sender];
    if (![_selectButton isEqual:sender]) {
        _pageCount = 1;
    }
    _selectButton=sender;
    if ([sender isEqual:_officeBtn]) {
        
        _officeBtn.selected=YES;
        _meettingRoomBtn.selected=NO;
        //从服务器请求数据 订单列表数据
        [self requestOfficeListFromServer];
    }else{
        _officeBtn.selected=NO;
        _meettingRoomBtn.selected=YES;
        [self requestMeetingRoomListFromServer];
    }
    
}
-(void)resetSelectedButtonUI:(UIButton *)sender
{
    if ([sender isEqual:_officeBtn]) {
        sender.layer.borderWidth = 0;
        _meettingRoomBtn.layer.borderWidth = 1;
    }
    if ([sender isEqual:_meettingRoomBtn]) {
        sender.layer.borderWidth = 0;
        _officeBtn.layer.borderWidth = 1;
    }
}
-(void)goMeetingRoomOrderDetailView:(int)index
{
//    OrderListInfo *orderInfo=[self.orderListInfoModel.OrderListArray objectAtIndex:index];
//    if (orderInfo.Status==0||orderInfo.Status == 4) {
//        [self goImmediatelyPayWithIndex:index];
//    }else{
//        [ZZGlobalModel sharedInstance].orderID = orderInfo.OrderId;
//        PBMeetingRoomOrderDetailViewController * VC = [[PBMeetingRoomOrderDetailViewController alloc]init];
//        [self.navigationController pushViewController:VC animated:YES];
//    }
}
-(void)goOfficeOrderDetailView:(int)index
{
//    OrderListInfo *orderInfo=[self.orderListInfoModel.OrderListArray objectAtIndex:index];
//    if (orderInfo.Status==0||orderInfo.Status == 4) {
//        [self goImmediatelyPayWithIndex:index];
//    }else{
//        [self goImmediatelyOrderDetailPageWith:orderInfo.OrderId];
//    }
    
    
    NSDictionary *orderInfoDic=[_dataArr objectAtIndex:index];
    
    if ([orderInfoDic[@"Status"] integerValue]==0||[orderInfoDic[@"Status"] integerValue]==4) {
        [self goImmediatelyPayWithIndex:index];
    }else{
        [self goImmediatelyOrderDetailPageWith:orderInfoDic[@"OrderId"]];
    }
    
}
//点击立即支付
-(void)goImmediatelyPay:(UIButton *)button{
    //[self goImmediatelyPayWithIndex:(int)button.tag];
}
//点击跳转至办公预订订单详情页面
-(void)goImmediatelyOrderDetailPageWith:(NSString *)orderID{
//    [ZZGlobalModel sharedInstance].orderID = [NSString stringWithString:orderID];
//    ZZMyOrderDetailViewController * orderdetailVC= [[ZZMyOrderDetailViewController alloc]initWithNibName:@"ZZMyOrderDetailViewController" bundle:nil];
//    [self.navigationController pushViewController:orderdetailVC animated:YES];
    
    [JCYGlobalData sharedInstance].orderId=orderID;
    [self performSegueWithIdentifier:@"OnlineBookingToOfficeOrderDetail" sender:self];
    
}

#pragma mark --私有方法
//立即支付,跳转到提交订单页
-(void)goImmediatelyPayWithIndex:(int)index{
    NSLog(@"立即支付");
//    OrderListInfo *orderInfo=[self.orderListInfoModel.OrderListArray objectAtIndex:index];
//    //数据源处理
//    [ZZGlobalModel sharedInstance].orderSubmitFlag = OrderSubmitFlag_FromMyOrder;
//    [ZZGlobalModel sharedInstance].orderID=orderInfo.OrderId;
//    UserLoginViewModel *user=[ZZGlobalModel sharedInstance].userInfoViewModel;
//    //判断是公司还是个人
//    if (user.IsGroup) {//公司
//        SubmitOrderCompanyViewController *submitOrderCompanyViewController=[[SubmitOrderCompanyViewController alloc] initWithNibName:@"SubmitOrderCompanyViewController" bundle:nil];
//        [self.navigationController pushViewController:submitOrderCompanyViewController animated:YES];
//    }else{//个人
//        SubmitOrderPersonalViewController *submitOrderPersonalViewController=[[SubmitOrderPersonalViewController alloc] initWithNibName:@"SubmitOrderPersonalViewController" bundle:nil];
//        [self.navigationController pushViewController:submitOrderPersonalViewController animated:YES];
//    }
}



//设置文字的字号及颜色
-(void)setViewFontAndColor
{
    //当前列表选项按钮
    _officeBtn.layer.borderColor = CommonBackgroundColor_lightGray.CGColor;
    _officeBtn.layer.borderWidth = 1;
    _meettingRoomBtn.layer.borderWidth = 1;
    _meettingRoomBtn.layer.borderColor = CommonBackgroundColor_lightGray.CGColor;
}

#pragma mark -- 请求服务端数据
//从服务器请求数据 空间搜索列表
-(void)requestOfficeListFromServer
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(officeOrderDataReceived:) name:[NSString stringWithFormat:@"%i",GetOfficeOrdersList] object:nil];
    
    NSUserDefaults * userInfo = [NSUserDefaults standardUserDefaults];
    NSString * userToken = [userInfo valueForKey:USERTOKEN];
    
    _GetOfficeOrdersList = [[AFRquest alloc]init];
    
    _GetOfficeOrdersList.subURLString =[NSString stringWithFormat:@"api/Orders/GetList?userToken=%@&deviceType=ios",userToken];
    
    _GetOfficeOrdersList.parameters = @{@"Status":@5,@"Page":[NSNumber numberWithInt:self.pageCount],@"Rows":@10,@"SortProperty":@"Name",@"SortDirection":@"asc"};
    
    _GetOfficeOrdersList.style = GET;
    
    [_GetOfficeOrdersList requestDataFromWithFlag:GetOfficeOrdersList];

}

-(void)officeOrderDataReceived:(NSNotification *)notif{
    
    int result = [_GetOfficeOrdersList.resultDict[@"Code"] intValue];
    if (result == SUCCESS) {
        
        NSLog(@"办公室");
       
        [self dealWithResponedDate:_GetOfficeOrdersList.resultDict[@"Data"][@"Data"]];
        
    }else{
        [[PBAlert sharedInstance] showText:_GetOfficeOrdersList.resultDict[@"Description"] inView:self.view withTime:2.0];
    }
    
    
    
    NSLog(@"%@",_GetOfficeOrdersList.resultDict);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",GetOfficeOrdersList] object:nil];
}


-(void)requestMeetingRoomListFromServer
{    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(meetingOrderDataReceived:) name:[NSString stringWithFormat:@"%i",GetMeetingOrdersList] object:nil];
    
    NSUserDefaults * userInfo = [NSUserDefaults standardUserDefaults];
    NSString * userToken = [userInfo valueForKey:USERTOKEN];
    
    _GetMeetingOrdersList = [[AFRquest alloc]init];
    
    _GetMeetingOrdersList.subURLString =[NSString stringWithFormat:@"api/Orders/GetMeetingList?userToken=%@&deviceType=ios",userToken];
    
    _GetMeetingOrdersList.parameters = @{@"Status":@5,@"Page":[NSNumber numberWithInt:self.pageCount],@"Rows":@10,@"SortProperty":@"Name",@"SortDirection":@"asc"};
    
    _GetMeetingOrdersList.style = GET;
    
    [_GetMeetingOrdersList requestDataFromWithFlag:GetMeetingOrdersList];

    
}

-(void)meetingOrderDataReceived:(NSNotification *)notif{
    
    int result = [_GetMeetingOrdersList.resultDict[@"Code"] intValue];
    if (result == SUCCESS) {
        
        NSLog(@"会议室");
        [self dealWithResponedDate:_GetMeetingOrdersList.resultDict[@"Data"][@"Data"] ];
        
    }else{
        [[PBAlert sharedInstance] showText:_GetMeetingOrdersList.resultDict[@"Description"] inView:self.view withTime:2.0];
    }
    
    
    
    NSLog(@"%@",_GetMeetingOrdersList.resultDict);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",GetMeetingOrdersList] object:nil];
}

#pragma mark -- 请求 代理

-(void)dealWithResponedDate:(NSMutableArray *)responseArr
{
    
    if(self.pageCount==1){
        [_dataArr removeAllObjects];
    }
    //说明返回的数据不止一页
    else{
        //状态取反
        self.hasOtherData = NO;
    }
    
    //底部的提示加载更多的view
    if(responseArr.count<10)
    {
        _allOrderListTableView.mj_footer.hidden = YES;
        _pageCount = 1;
    }else{
        
        // 添加传统的上拉刷新
        _allOrderListTableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            [self spaceTypeButtonSelected:_selectButton];
        }];
        
    }
    
    //说明更多数据也全部加载完成
    if(self.pageCount >1 && responseArr.count<10)
    {
        self.hasOtherData = YES;
    }
    
    [_dataArr addObjectsFromArray:responseArr];
    [self.allOrderListTableView reloadData];
    
    [self isShowEmptyTableWithArr:_dataArr];
				
    self.pageCount++;
}


-(void)stopMJRefreshing:(NSTimer *)timer
{
    [UIView animateWithDuration:1.0 animations:^{
        //[_allOrderListTableView removeFooter];
    }];
    if (timer) {
        [timer invalidate];
    }
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
