//
//  JCYMyBookingListViewController.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/7.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "JCYMyBookingListViewController.h"
#import "PBMyBookingListTableViewCell.h"
#import "MJRefresh.h"

@interface JCYMyBookingListViewController ()
@property (strong, nonatomic) IBOutlet UIButton *workBookingButton;
@property (strong, nonatomic) IBOutlet UIButton *activeBookingButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *nodataPromptmessage;
@property (strong, nonatomic) IBOutlet UIView *noDataView;


@property (strong, nonatomic) AFRquest *GetCustomOfficeList;
@property (strong, nonatomic) AFRquest *GetMyVisitActiveSpace;
@property (strong,nonatomic) NSMutableArray * customOfficeListArray;
//发起请求参数
@property (assign,nonatomic) int currentPage;

@property (strong,nonatomic) NSMutableArray * activeSpaceListArray;
//发起请求参数
@property (assign,nonatomic) int activeSpaceCurrentPage;

@property (assign,nonatomic) BOOL isActiveBooking;




@end

@implementation JCYMyBookingListViewController
static NSString * identifier = @"PBMyBookingListTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _customOfficeListArray=[NSMutableArray array];
    _activeSpaceListArray=[NSMutableArray array];
    [_tableView registerNib:[UINib nibWithNibName:@"PBMyBookingListTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //选项控制
    _workBookingButton.selected = YES;
    _workBookingButton.layer.borderColor = CommonBackgroundColor_gray.CGColor;
    _activeBookingButton.layer.borderColor = CommonBackgroundColor_gray.CGColor;
    [self resetSelectedButtonUI:_workBookingButton];
    
    
    _isActiveBooking=NO;
    
    _currentPage  = 1;
    
    _activeSpaceCurrentPage  = 1;
    
    [self bookingButtonPress:_workBookingButton];
    UINavigationController *navi=(UINavigationController *)self.parentViewController;
    navi.tabBarController.tabBar.hidden=YES;
}

-(void)resetSelectedButtonUI:(UIButton *)sender
{
    if ([sender isEqual:_workBookingButton]) {
        sender.layer.borderWidth = 0;
        _activeBookingButton.layer.borderWidth = 1;
    }
    if ([sender isEqual:_activeBookingButton]) {
        sender.layer.borderWidth = 0;
        _workBookingButton.layer.borderWidth = 1;
    }
}


- (IBAction)bookingButtonPress:(UIButton *)sender {
    [self resetSelectedButtonUI:sender];
    if ([sender isEqual:_workBookingButton]) {
        _isActiveBooking=NO;

        [self requestDataFromServer];
        
    }else{
        _isActiveBooking=YES;

        [self requestDataFromServerforActiveSpaceBooking];
    }
}



-(void)requestDataFromServerforActiveSpaceBooking
{
    
//    [[ZZAllService sharedInstance] serviceQueryByObj:@{@"Page":[NSNumber numberWithInt:_activeSpaceCurrentPage],@"Rows":@10,@"SortProperty":@"Name",@"SortDirection":@"asc"}  delegate:self httpTag:HTTPHelperTag_MyVisitActiveSpace];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(visitActiveDataReceived:) name:[NSString stringWithFormat:@"%i",GetMyVisitActiveSpace] object:nil];
    
    NSUserDefaults * userInfo = [NSUserDefaults standardUserDefaults];
    NSString * userToken = [userInfo valueForKey:USERTOKEN];
    
    _GetMyVisitActiveSpace = [[AFRquest alloc]init];
    _GetMyVisitActiveSpace.subURLString =[NSString stringWithFormat:@"api/ActiveSpace/MyVisitActiveSpace?userToken=%@&deviceType=ios",userToken];
    _GetMyVisitActiveSpace.parameters = @{@"Page":[NSNumber numberWithInt:_activeSpaceCurrentPage],@"Rows":@10,@"SortProperty":@"Name",@"SortDirection":@"asc"};
    _GetMyVisitActiveSpace.style = GET;
    [_GetMyVisitActiveSpace requestDataFromWithFlag:GetMyVisitActiveSpace];
    
}

-(void)visitActiveDataReceived:(NSNotification *)notif{
    
    //_commentedListDic = _GetNotCommentedList.resultDict;
    //_activeSpaceListArray=_GetMyVisitActiveSpace.resultDict[@"Data"][@"Data"];
    
    
    int result = [_GetMyVisitActiveSpace.resultDict[@"Code"] intValue];
    if (result == SUCCESS) {
        
        
        [self dealResposeResultForActiveSpace:_GetMyVisitActiveSpace.resultDict[@"Data"][@"Data"] ];
        
    }else{
        [[PBAlert sharedInstance] showText:_GetMyVisitActiveSpace.resultDict[@"Description"] inView:self.view withTime:2.0];
    }
    
    
    
    NSLog(@"%@",_GetMyVisitActiveSpace.resultDict);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",GetMyVisitActiveSpace] object:nil];
}



//从服务器请求数据  待点评列表
-(void)requestDataFromServer{
    
    ////    [[ZZAllService sharedInstance] serviceQueryByObj:@{@"Page":[NSNumber numberWithInt:_currentPage],@"Rows":@10,@"SortProperty":@"Name",@"SortDirection":@"asc"}  delegate:self httpTag:HTTPHelperTag_GetCustomOfficeList];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(customOfficeDataReceived:) name:[NSString stringWithFormat:@"%i",GetCustomOfficeList] object:nil];
    
    NSUserDefaults * userInfo = [NSUserDefaults standardUserDefaults];
    NSString * userToken = [userInfo valueForKey:USERTOKEN];
    
    _GetCustomOfficeList = [[AFRquest alloc]init];
    _GetCustomOfficeList.subURLString =[NSString stringWithFormat:@"api/CustomOffice/GetCustomOfficeList?userToken=%@&deviceType=ios",userToken];
    _GetCustomOfficeList.parameters = @{@"Page":[NSNumber numberWithInt:_currentPage],@"Rows":@10,@"SortProperty":@"Name",@"SortDirection":@"asc"};
    _GetCustomOfficeList.style = GET;
    [_GetCustomOfficeList requestDataFromWithFlag:GetCustomOfficeList];
}




-(void)customOfficeDataReceived:(NSNotification *)notif{
    
    //_commentedListDic = _GetNotCommentedList.resultDict;
    //_customOfficeListArray=_GetCustomOfficeList.resultDict[@"Data"][@"Data"];
    
   
    int result = [_GetCustomOfficeList.resultDict[@"Code"] intValue];
    if (result == SUCCESS) {
        
   
        [self dealResposeResult:_GetCustomOfficeList.resultDict[@"Data"][@"Data"] ];
        
    }else{
        [[PBAlert sharedInstance] showText:_GetCustomOfficeList.resultDict[@"Description"] inView:self.view withTime:2.0];
    }
    
    
    
    NSLog(@"%@",_GetCustomOfficeList.resultDict);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",GetCustomOfficeList] object:nil];
}


- (IBAction)backButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PBMyBookingListTableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (_isActiveBooking) {
        
        NSDictionary * customOffice = _activeSpaceListArray[indexPath.row];
        
        NSLog(@"****%@",customOffice);
        
        cell.location.text = [NSString stringWithFormat:@"活动空间：%@",customOffice[@"activeSpaceName"]];
        
        NSString * bookingDate = [NSString stringWithFormat:@"%@ %@-%@",[customOffice[@"startTime"] substringToIndex:10],[[customOffice[@"startTime"] substringFromIndex:10] substringToIndex:6],[[customOffice[@"endTime"] substringFromIndex:10] substringToIndex:6]];
        
        cell.bookingTime.text = [NSString stringWithFormat:@"活动时间：%@",bookingDate];
        
        cell.name.text = [NSString stringWithFormat:@"预约姓名：%@",customOffice[@"name"]];
        
        cell.phone.text = [NSString stringWithFormat:@"预约手机：%@",customOffice[@"phoneNum"]];
        
        cell.numOfPerson.text = [NSString stringWithFormat:@"团队人数：%@",customOffice[@"peopleNum"]];
        
        cell.others.text = [NSString stringWithFormat:@"其他补充：%@",customOffice[@"content"]];
        
        NSString * creatTime = [customOffice[@"visitTime"] substringToIndex:10];
        
        cell.date.text = creatTime;
        
        
    }else
    {
        NSDictionary * customOffice = _customOfficeListArray[indexPath.row];
        
        cell.location.text = [NSString stringWithFormat:@"办公社区：%@",customOffice[@"officeAdress"]];
        
        NSString * bookingDate = [customOffice[@"appointmentTime"] substringToIndex:10];
        
        cell.bookingTime.text = [NSString stringWithFormat:@"入驻时间：%@",bookingDate];
        
        cell.name.text = [NSString stringWithFormat:@"预约姓名：%@",customOffice[@"name"]];
        
        cell.phone.text = [NSString stringWithFormat:@"预约手机：%@",customOffice[@"mobile"]];
        
        cell.numOfPerson.text = [NSString stringWithFormat:@"团队人数：%@",customOffice[@"teamNum"]];
        
        cell.others.text = [NSString stringWithFormat:@"其他补充：%@",customOffice[@"otherContent"]];
        
        NSString * creatTime = [customOffice[@"createTime"] substringToIndex:10];
        
        cell.date.text = creatTime;
        
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isActiveBooking) {
        
        return _activeSpaceListArray.count;
        
    }else{
        
        return _customOfficeListArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PBMyBookingListTableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    
    return cell.frame.size.height;
}
#pragma mark -- Data Request Part

/** *处理请求返回后的结果*/
-(void)dealResposeResult:(NSMutableArray * )dataArr{
    
    if (_currentPage == 1) {
        _customOfficeListArray = [NSMutableArray array];
    }
    //如果返回的数据小于10条则隐藏加载更多数据的提示条
    NSLog(@"****%@",dataArr);
    if(dataArr.count<10){
        _tableView.mj_footer.hidden = YES;
        _currentPage = 1;
    }else{
//        //添加传统的上拉刷新
//        [_tableView addLegendFooterWithRefreshingBlock:^{
//            // 进入刷新状态后会自动调用这个block
//            [self requestDataFromServer];
//        }];
        
        _tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            [self requestDataFromServer];
        }];
    }
    [_customOfficeListArray addObjectsFromArray:dataArr];
    
    NSLog(@"000000%@",_customOfficeListArray);
    
    if (_customOfficeListArray.count > 0) {
        [self.view bringSubviewToFront:_tableView];
        _noDataView.hidden=YES;
        [_tableView reloadData];
    }else{
        _noDataView.hidden=NO;
        _nodataPromptmessage.text=@"您没有办公预约信息！";
        [self.view bringSubviewToFront:_noDataView];
        [_tableView reloadData];
        
    }
    _currentPage++;//拿到数据后页面数自加
    // 拿到当前的上拉刷新控件，结束刷新状态
    [_tableView.mj_footer endRefreshing];
}


/** *处理请求返回后的结果*/
-(void)dealResposeResultForActiveSpace:(NSMutableArray * )dataArr{
    
    if (_activeSpaceCurrentPage == 1) {
        _activeSpaceListArray = [NSMutableArray array];
    }
    //如果返回的数据小于10条则隐藏加载更多数据的提示条
    NSLog(@"****%@",dataArr);
    if(dataArr.count<10){
        _tableView.mj_footer.hidden = YES;
        _activeSpaceCurrentPage = 1;
    }else{
        //添加传统的上拉刷新
        _tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            [self requestDataFromServerforActiveSpaceBooking];
        }];
    }
    [_activeSpaceListArray addObjectsFromArray:dataArr];
    
    NSLog(@"000000%@",_activeSpaceListArray);
    
    if (_activeSpaceListArray.count > 0) {
        [self.view bringSubviewToFront:_tableView];
        NSLog(@"^^^^^^^^^^%lu",(unsigned long)_activeSpaceListArray.count);
        [_tableView reloadData];
        _noDataView.hidden=YES;
    }else{
        _noDataView.hidden=NO;
        _nodataPromptmessage.text=@"您没有活动预约信息！";
        [self.view bringSubviewToFront:_noDataView];
        
        [_tableView reloadData];
        
    }
    _activeSpaceCurrentPage++;//拿到数据后页面数自加
    // 拿到当前的上拉刷新控件，结束刷新状态
    [_tableView.mj_footer endRefreshing];
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
