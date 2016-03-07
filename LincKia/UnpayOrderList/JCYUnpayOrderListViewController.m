//
//  JCYUnpayOrderListViewController.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/7.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "JCYUnpayOrderListViewController.h"
#import "AllOrderListViewCell.h"
#import <MJRefresh.h>

@interface JCYUnpayOrderListViewController ()
//设置字体大小和颜色
@property (weak, nonatomic) IBOutlet UILabel *labelEmptyNote;//"您还没有未支付的订单"

@property (weak, nonatomic) IBOutlet UIView *emptyView;


@property (weak, nonatomic) IBOutlet UITableView *unpayOrderListTableView; //订单tableView
//@property (strong,nonatomic)OrderListInfoModel *orderListInfoModel;//订单列表对象
@property(assign,nonatomic)int pageCount;

@property (weak, nonatomic) IBOutlet UIButton *officeBtn;
@property (weak, nonatomic) IBOutlet UIButton *meetingRoomBtn;
@property (strong,nonatomic) UIButton * selectedBtn;
@property (strong,nonatomic) NSMutableArray *orderListArr;
@property (strong,nonatomic) NSMutableArray *meetingListArr;

@property (strong,nonatomic) NSDictionary *reciveOrderData;
@property (strong,nonatomic) NSDictionary *recivemeetingData;

@property (strong,nonatomic) AFRquest *GetOrderList;
@property (strong,nonatomic) AFRquest *GetMeetingList;

@end

@implementation JCYUnpayOrderListViewController
-(void)viewWillAppear:(BOOL)animated
{
    UINavigationController *navi=(UINavigationController *)self.parentViewController;
    navi.tabBarController.tabBar.hidden=YES;
}
//cell的identifier
static NSString *orderListCell=@"orderListCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.emptyView.hidden = YES;
    
    self.pageCount = 1;
    
    [self initUIComponent];
    [self spaceTypeSelected:_officeBtn];

}


- (IBAction)spaceTypeSelected:(UIButton *)sender {
    
    if (![_selectedBtn isEqual:sender]) {
        _pageCount = 1;
    }
    _selectedBtn =  sender;
    NSLog(@"============%@",_selectedBtn.titleLabel.text);
    _selectedBtn.layer.borderWidth = 0;
    sender.selected = !sender.selected;
    if ([sender isEqual:_officeBtn]) {
        _meetingRoomBtn.selected = NO;
        _meetingRoomBtn.layer.borderWidth = 1;
        [self requestDataFromServer];
    }else if([sender isEqual:_meetingRoomBtn]){
        _officeBtn.selected = NO;
        _officeBtn.layer.borderWidth = 1;
        [self requestMeetingRoomListFromServer];
    }
    
}

#pragma mark --初始化

-(void)isShowEmptyTable{
//    if (self.orderListInfoModel.OrderListArray.count) {
//        self.emptyView.hidden = YES;
//    }else{
//        self.emptyView.hidden = NO;
//    }
    
    
    if (_officeBtn.selected==YES&&_meetingRoomBtn.selected==NO) {
        
        if (_orderListArr.count) {
            _emptyView.hidden=YES;
        }else{
            _emptyView.hidden=NO;
        }
        
        
    }else{
        
        if (_meetingListArr.count) {
            _emptyView.hidden=YES;
        }else{
            _emptyView.hidden=NO;
        }
    }
}

//初始化UI组件
-(void)initUIComponent{
    
    _officeBtn.layer.borderWidth = 1;
    _officeBtn.layer.borderColor = CommonBackgroundColor_gray.CGColor;
    
    _meetingRoomBtn.layer.borderWidth = 1;
    _meetingRoomBtn.layer.borderColor = CommonBackgroundColor_gray.CGColor;
    
    [self.unpayOrderListTableView registerNib:[UINib nibWithNibName:@"AllOrderListViewCell" bundle:nil] forCellReuseIdentifier:orderListCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --UITableView的处理
//tableView初始处理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // return self.orderListInfoModel.OrderListArray.count;
    if (_officeBtn.selected==YES&&_meetingRoomBtn.selected==NO) {
        return _orderListArr.count;
    }else{
        return _meetingListArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AllOrderListViewCell *cell=[tableView dequeueReusableCellWithIdentifier:orderListCell];
//    OrderListInfo *orderInfo=[self.orderListInfoModel.OrderListArray objectAtIndex:indexPath.row];
//    [cell initCellDataSourceWithOrder:orderInfo];//对cell中的元素赋值
    
    
    if (_officeBtn.selected==YES&&_meetingRoomBtn.selected==NO) {

        [cell initCellDataSourceWithOrder:_orderListArr[indexPath.row]];
    }else{
        [cell initCellDataSourceWithOrder:_meetingListArr[indexPath.row]];
    }

    
    return cell;
    
}
//对被点击的cell操作
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self goPayWithIndex:(int)indexPath.row];
}

/**
 *返回到“我的”页面
 */
- (IBAction)gobackToMineBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --私有方法
//付款，跳转到提交订单
-(void)goPayWithIndex:(int)index{
//    
//    OrderListInfo *orderInfo=[self.orderListInfoModel.OrderListArray objectAtIndex:index];
//    [ZZGlobalModel sharedInstance].orderID=orderInfo.OrderId;
//    
//    if ([_selectedBtn isEqual:_officeBtn]) {
//        [ZZGlobalModel sharedInstance].orderSubmitFlag = OrderSubmitFlag_FromMyOrder;
//    }
//    if ([_selectedBtn isEqual:_meetingRoomBtn]) {
//        [ZZGlobalModel sharedInstance].orderSubmitFlag = FromUnpayPage;
//    }
//    
//    UserLoginViewModel *user=[ZZGlobalModel sharedInstance].userInfoViewModel;
//    //判断是公司还是个人
//    if (user.IsGroup) {//公司
//        SubmitOrderCompanyViewController *submitOrderCompanyViewController=[[SubmitOrderCompanyViewController alloc] initWithNibName:@"SubmitOrderCompanyViewController" bundle:nil];
//        [self.navigationController pushViewController:submitOrderCompanyViewController animated:YES];
//    }else{//个人
//        SubmitOrderPersonalViewController *submitOrderPersonalViewController=[[SubmitOrderPersonalViewController alloc] initWithNibName:@"SubmitOrderPersonalViewController" bundle:nil];
//        [self.navigationController pushViewController:submitOrderPersonalViewController animated:YES];
//    }
//
    
    if (_officeBtn.selected==YES&&_meetingRoomBtn.selected==NO) {
        
        NSLog(@"办公室");
    }else{
        NSLog(@"会议室");
    }

}

#pragma mark -- 请求服务端数据
//从服务器请求数据 空间搜索列表
-(void)requestDataFromServer{
    
//    [[ZZAllService sharedInstance] serviceQueryByObj:@{@"Status":@0,@"Page":[NSNumber numberWithInt:self.pageCount],@"Rows":@10,@"SortProperty":@"Name",@"SortDirection":@"asc"}  delegate:self httpTag:HTTPHelperTag_Orders_GetList];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orderListDataReceived:) name:[NSString stringWithFormat:@"%i",GetUnpayOrderList] object:nil];
    NSUserDefaults * userInfo = [NSUserDefaults standardUserDefaults];
    NSString * userToken = [userInfo valueForKey:USERTOKEN];
    _GetOrderList = [[AFRquest alloc]init];
    _GetOrderList.subURLString =[NSString stringWithFormat:@"api/Orders/GetList?userToken=%@&deviceType=ios",userToken];
     _GetOrderList.parameters = @{@"Status":@0,@"Page":[NSNumber numberWithInt:self.pageCount],@"Rows":@10,@"SortProperty":@"Name",@"SortDirection":@"asc"};
    _GetOrderList.style = GET;
    [_GetOrderList requestDataFromWithFlag:GetUnpayOrderList];



    
}

-(void)orderListDataReceived:(NSNotification *)notif{
    
    _reciveOrderData = _GetOrderList.resultDict;
   // _orderListArr=_GetMeetingList.resultDict[@"Data"][@"Data"];
    
    
    int result = [_GetOrderList.resultDict[@"Code"] intValue];;
    if (result == SUCCESS) {
        
        //[self dealDataWithResponse:_spaceInfoDict[@"Data"]];
        [self dealOrderReciveData:_GetOrderList.resultDict[@"Data"][@"Data"]];
        
    }else{
        [[PBAlert sharedInstance] showText:_GetOrderList.resultDict[@"Description"] inView:self.view withTime:2.0];
    }

    
    
    NSLog(@"%@",_reciveOrderData);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",GetUnpayOrderList] object:nil];
}


-(void)requestMeetingRoomListFromServer
{
//    [[ZZAllService sharedInstance] serviceQueryByObj:@{@"Status":@0,@"Page":[NSNumber numberWithInt:self.pageCount],@"Rows":@10,@"SortProperty":@"Name",@"SortDirection":@"asc"}  delegate:self httpTag:HTTPHelperTag_Orders_GetMeetingList];
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(meetingListDataReceived:) name:[NSString stringWithFormat:@"%i",GetMeetingList] object:nil];
    NSUserDefaults * userInfo = [NSUserDefaults standardUserDefaults];
    NSString * userToken = [userInfo valueForKey:USERTOKEN];
    _GetMeetingList = [[AFRquest alloc]init];
    _GetMeetingList.subURLString =[NSString stringWithFormat:@"api/Orders/GetMeetingList?userToken=%@&deviceType=ios",userToken];
    _GetMeetingList.parameters = @{@"Status":@0,@"Page":[NSNumber numberWithInt:self.pageCount],@"Rows":@10,@"SortProperty":@"Name",@"SortDirection":@"asc"};
    _GetMeetingList.style = GET;
    [_GetMeetingList requestDataFromWithFlag:GetMeetingList];
}

-(void)meetingListDataReceived:(NSNotification *)notif{
    
    _recivemeetingData = _GetMeetingList.resultDict;
    
   // _meetingListArr=_GetMeetingList.resultDict[@"Data"][@"Data"];
    
    NSLog(@"%@",_recivemeetingData);
    
    
    int result = [_GetMeetingList.resultDict[@"Code"] intValue];;
    if (result == SUCCESS) {
        
        //[self dealDataWithResponse:_spaceInfoDict[@"Data"]];
        [self dealMeetingReciveData:_GetMeetingList.resultDict[@"Data"][@"Data"]];
        
    }else{
        [[PBAlert sharedInstance] showText:_GetMeetingList.resultDict[@"Description"] inView:self.view withTime:2.0];
    }

    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",GetMeetingList] object:nil];
}


#pragma mark -- 请求
-(void)dealOrderReciveData:(NSMutableArray *)dataArr
{
    if(dataArr.count<10){
        _unpayOrderListTableView.mj_footer.hidden = YES;
    }else{
        _unpayOrderListTableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            [self requestDataFromServer];
        }];
        
    }
    if (_pageCount == 1) {
        _orderListArr = [NSMutableArray array];
    }
    [_orderListArr addObjectsFromArray:dataArr];
   

    
    [self isShowEmptyTable];
    [self.unpayOrderListTableView reloadData];
    
    // 拿到当前的上拉刷新控件，结束刷新状态
    [self.unpayOrderListTableView.mj_footer endRefreshing];
    
    self.pageCount++;
    

}

-(void)dealMeetingReciveData:(NSMutableArray *)dataArr
{
    if(dataArr.count<10){
        _unpayOrderListTableView.mj_footer.hidden = YES;
    }else{
        _unpayOrderListTableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            [self requestMeetingRoomListFromServer];
        }];
        
    }
    if (_pageCount == 1) {
        _meetingListArr = [NSMutableArray array];
    }
    [_meetingListArr addObjectsFromArray:dataArr];
    
    
    
    [self isShowEmptyTable];
    [self.unpayOrderListTableView reloadData];
    
    // 拿到当前的上拉刷新控件，结束刷新状态
    [self.unpayOrderListTableView.mj_footer endRefreshing];
    
    self.pageCount++;
    
    
}





-(void)stopMJRefreshing:(NSTimer *)timer
{
    [UIView animateWithDuration:1.0 animations:^{
        //[_unpayOrderListTableView removeFooter];
    }];
    if (timer) {
        [timer invalidate];
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
