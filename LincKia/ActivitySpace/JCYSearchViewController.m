//
//  JCYSearchViewController.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/9.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "JCYSearchViewController.h"
#import "ZZSpaceRecommendCellTableViewCell.h"
#import <MJRefresh.h>
@interface JCYSearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *noDataLable;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIView *nodataView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
//@property (strong,nonatomic) SpaceSearchModel * searchModel;

@property (assign, nonatomic) int currentPage;

//办公社区空间搜索请求
@property (strong, nonatomic) AFRquest *GetAllSpaceList;
//活动空间搜索请求
@property (strong, nonatomic) AFRquest *GetActiveSpaceList;

//当前表格需要显示的内容
@property (strong, nonatomic)  NSMutableArray * currentDataArray;
@end

@implementation JCYSearchViewController
static NSString *spaceListTableViewCell=@"spaceRecommendCellTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _currentPage = 1;
    _currentDataArray = [NSMutableArray array];
    [_tableView registerNib:[UINib nibWithNibName:@"ZZSpaceRecommendCellTableViewCell" bundle:nil ] forCellReuseIdentifier:spaceListTableViewCell];
    
    if ([JCYGlobalData sharedInstance].orderSubmitFlag==FromActivitySpaceListPage) {
        _searchTextField.placeholder=@"输入活动地点/空间名称";
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UINavigationController *navi=(UINavigationController *)self.parentViewController;
    navi.tabBarController.tabBar.hidden=YES;
    
}

#pragma -- mark ACTION PART
- (IBAction)backButtonPressed:(UIButton *)sender {
    UINavigationController *navi=(UINavigationController *)self.parentViewController;
    [navi popViewControllerAnimated:YES];

}
- (IBAction)searchButtonPressed:(UIButton *)sender {
    [_searchTextField resignFirstResponder];
    
    //活动空间搜索
    if ([JCYGlobalData sharedInstance].orderSubmitFlag == FromActivitySpaceListPage) {
        [self requestActiveSpaceListFromServer:_searchTextField.text];
    }
    
    //办公社区空间搜索
    if ([JCYGlobalData sharedInstance].orderSubmitFlag == FromOfficeListPage) {
        [self requestLinckiaSpaceListFromServer:_searchTextField.text];
    }
    
}
#pragma -- mark TEXTFIELD DELEGATE
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_searchTextField resignFirstResponder];
    [self searchButtonPressed:_searchBtn];
    return YES;
}
#pragma -- mark TABLEVIEW DELEGATE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _currentDataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ADVIEW_HEIGHT+60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZZSpaceRecommendCellTableViewCell *spacesListTableViewCell=[tableView dequeueReusableCellWithIdentifier:spaceListTableViewCell];
    if ([JCYGlobalData sharedInstance].orderSubmitFlag == FromOfficeListPage) {
        [self loadOfficeDataWithIndex:indexPath andCell:spacesListTableViewCell];
    }
    
    if ([JCYGlobalData sharedInstance].orderSubmitFlag == FromActivitySpaceListPage) {
        [self loadActicitySpaceDataWithIndex:indexPath andCell:spacesListTableViewCell];
    }
    
    return spacesListTableViewCell;
    
}

-(void)loadActicitySpaceDataWithIndex:(NSIndexPath *)indexPath andCell:(ZZSpaceRecommendCellTableViewCell *)cell{
    NSDictionary *activeSpaceInfo = _currentDataArray[indexPath.row];
    NSString * imageURL = activeSpaceInfo[@"PicUrl"];
    //主图
    UIImageView *imageViewRecommend =[cell valueForKey:@"spaceImageView"];
    [imageViewRecommend sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:Index_Recommond_Default_Image]];
    //读取空间名称
    cell.spaceNameLabel.text = activeSpaceInfo[@"ActiveSpaceName"];
    //读取空间地址
    cell.spaceAdressLabel.text =activeSpaceInfo[@"Location"];
    //添加用户交互图片
    cell.UITouchBtn.tag = 5000+indexPath.row;
    [cell.UITouchBtn addTarget:self action:@selector(selectRecommond:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)loadOfficeDataWithIndex:(NSIndexPath *)indexPath andCell:(ZZSpaceRecommendCellTableViewCell *)spacesListTableViewCell
{
    NSDictionary * spaceInfo = _currentDataArray[indexPath.row];
    NSString *imageUrl=spaceInfo[@"PicUrl"];
    //主图
    UIImageView *imageViewRecommend =[spacesListTableViewCell valueForKey:@"spaceImageView"];
    [imageViewRecommend sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:Index_Recommond_Default_Image]];
    //读取空间名称
    spacesListTableViewCell.spaceNameLabel.text = spaceInfo[@"Name"];
    //读取空间地址
    spacesListTableViewCell.spaceAdressLabel.text =spaceInfo[@"Location"];
    //添加用户交互图片
    spacesListTableViewCell.UITouchBtn.tag = 5000+indexPath.row;
    [spacesListTableViewCell.UITouchBtn addTarget:self action:@selector(selectRecommond:) forControlEvents:UIControlEventTouchUpInside];
}
//选中空间
-(void)selectRecommond:(UIButton *)sender
{
    if ([JCYGlobalData sharedInstance].orderSubmitFlag == FromOfficeListPage) {

        NSDictionary *spaceSummaryDic=_currentDataArray[sender.tag-5000];
        [JCYGlobalData sharedInstance].SpaceId=spaceSummaryDic[@"SpaceId"];
        
        [self performSegueWithIdentifier:@"SearchToLinckiaSpaceInfo" sender:self];
    }
    if ([JCYGlobalData sharedInstance].orderSubmitFlag == FromActivitySpaceListPage) {

        NSDictionary *activeSpaceInfo=_currentDataArray[sender.tag-5000];
        [JCYGlobalData sharedInstance].ActivitySpaceId=activeSpaceInfo[@"ActiveSpaceId"];
        
        [self performSegueWithIdentifier:@"SearchToActiveSpaceInfo" sender:self];
        
    }
    
    
    NSLog(@"Info");
    
}

//从服务器请求数据 空间搜索列表
-(void)requestLinckiaSpaceListFromServer:(NSString *)tag
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(linckiaSpaceDataReceived:) name:[NSString stringWithFormat:@"%i",GetAllSpaceList] object:nil];
    _GetAllSpaceList = [[AFRquest alloc]init];
    
    _GetAllSpaceList.subURLString =@"api/Spaces/GetAllSpaceList?userToken=""&deviceType=ios";
    
    
    _GetAllSpaceList.parameters = @{@"Page":[NSNumber numberWithInt:_currentPage],@"Rows":@10,@"SortProperty":@"Name",@"SortDirection":@"asc",@"Tag":tag};
    
    _GetAllSpaceList.style = GET;
    
    [_GetAllSpaceList requestDataFromWithFlag:GetAllSpaceList];
    [[PBAlert sharedInstance] showProgressDialogText:@"搜索中..." inView:self.view];
    
    
}

-(void)linckiaSpaceDataReceived:(NSNotification *)notif{
    int result = [_GetAllSpaceList.resultDict[@"Code"] intValue];
    [[PBAlert sharedInstance] stopHud];
    if (result == SUCCESS) {
        NSLog(@"办公空间搜索");
        [self dealResposeResult:_GetAllSpaceList.resultDict[@"Data"][@"Data"]];
        
    }else{
        [[PBAlert sharedInstance] showText:_GetAllSpaceList.resultDict[@"Description"] inView:self.view withTime:2.0];
    }
    NSLog(@"%@",_GetAllSpaceList.resultDict);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",GetAllSpaceList] object:nil];
}


//从服务器请求数据 活动空间搜索列表
-(void)requestActiveSpaceListFromServer:(NSString *)keyword
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(activeSpaceDataReceived:) name:[NSString stringWithFormat:@"%i",GetActiveSpaceList] object:nil];
    
    _GetActiveSpaceList = [[AFRquest alloc]init];
    
    _GetActiveSpaceList.subURLString =@"api/ActiveSpace/GetActiveSpaceList?userToken=""&deviceType=ios";
    
    _GetActiveSpaceList.parameters = @{@"SortProperty":@"Name",@"SortDirection":@"asc",@"Rows":@10,@"Page":[NSNumber numberWithInt:_currentPage],@"activeSpaceName":keyword,@"address":keyword};
    
    _GetActiveSpaceList.style = GET;
    
    [_GetActiveSpaceList requestDataFromWithFlag:GetActiveSpaceList];
    [[PBAlert sharedInstance] showProgressDialogText:@"搜索中..." inView:self.view];
    
}

-(void)activeSpaceDataReceived:(NSNotification *)notif{
    int result = [_GetActiveSpaceList.resultDict[@"Code"] intValue];
    [[PBAlert sharedInstance] stopHud];

    if (result == SUCCESS) {
        NSLog(@"活动空间搜索");
        [self dealResposeResult:_GetActiveSpaceList.resultDict[@"Data"][@"Data"]];
        
    }else{
        [[PBAlert sharedInstance] showText:_GetActiveSpaceList.resultDict[@"Description"] inView:self.view withTime:2.0];
    }
    NSLog(@"%@",_GetActiveSpaceList.resultDict);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",GetActiveSpaceList] object:nil];
}


/** *处理请求返回后的结果*/
-(void)dealResposeResult:(NSMutableArray *)responseArr{
    
    if (_currentPage == 1) {
        [_currentDataArray removeAllObjects];
    }
    
    [_currentDataArray addObjectsFromArray:responseArr];
    
    if (_currentDataArray.count > 0) {
        [self.view bringSubviewToFront:_tableView];
        [_tableView reloadData];
    }else{
        [self.view bringSubviewToFront:_nodataView];
    }
    
    //如果返回的数据小于10条则隐藏加载更多数据的提示条
    if(responseArr.count<10){
        _currentPage = 1;
        _tableView.mj_footer.hidden = YES;
    }else{
        _currentPage++;
        // 添加传统的上拉刷新
        _tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            
            if ([JCYGlobalData sharedInstance].orderSubmitFlag==FromActivitySpaceListPage) {
                [self requestActiveSpaceListFromServer:_searchTextField.text];
            }
            
            if ([JCYGlobalData sharedInstance].orderSubmitFlag==FromOfficeListPage){
                [self requestLinckiaSpaceListFromServer:_searchTextField.text];
            }
            
        }];
        
    }
    [_tableView.mj_footer endRefreshing];
    
}

-(void)stopMJRefreshing:(NSTimer *)timer
{
    [UIView animateWithDuration:1.0 animations:^{
        //[_tableView removeFooter];
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
