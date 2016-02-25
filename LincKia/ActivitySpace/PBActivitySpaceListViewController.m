//
//  ZZActivitySpaceListViewController.m
//  LincKia
//
//  Created by 董玲 on 11/12/15.
//  Copyright © 2015 ZZ. All rights reserved.
//

#import "PBActivitySpaceListViewController.h"
#import "ZZSpaceRecommendCellTableViewCell.h"
#import "MJRefresh.h"
#import "PBActivtySpaceDetailViewController.h"

@interface PBActivitySpaceListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *spacesListTableview;
@property (weak, nonatomic) IBOutlet UIView *nodataView;
@property (strong,nonatomic) NSMutableArray * currentDataArray;
@property (assign,nonatomic) int currentTableViewPage;
@property (assign,nonatomic) int focusTag;
@property (strong,nonatomic) NSDictionary *responseDataOfIndexDict;

@property (strong,nonatomic) AFRquest *GetActiveSpaceList;

@end

@implementation PBActivitySpaceListViewController

static NSString *spaceListTableViewCell=@"spaceRecommendCellTableViewCell";

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    UINavigationController * navi = (UINavigationController *)self.parentViewController;
    navi.tabBarController.tabBar.hidden = YES;
    navi.navigationBar.hidden = YES;
    
    
    _currentTableViewPage = 1;
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonPressed:(UIButton *)sender {

    [self.navigationController popViewControllerAnimated:YES];

}

//- (IBAction)searchButtonPress:(UIButton *)sender {
//    
////    [ZZGlobalModel sharedInstance].orderSubmitFlag = FromActivitySpaceListPage;
////    PBSearchViewController * searchVC =[[PBSearchViewController alloc] init];
////    searchVC.isActiveSpace=YES;
////    [self.navigationController pushViewController:searchVC animated:YES];
//}
//
#pragma -- mark REQUEST PART
-(void)requestData
{
    _GetActiveSpaceList = [[AFRquest alloc]init];
    _GetActiveSpaceList.subURLString = @"api/ActiveSpace/GetActiveSpaceList?userToken=""&deviceType=ios";
     _GetActiveSpaceList.parameters = @{@"p.Page":[NSNumber numberWithInt:_currentTableViewPage],@"p.Rows":[NSNumber numberWithInt:10],@"p.SortProperty":@"Name",@"p.SortDirection":@"asc"};
    _GetActiveSpaceList.style = GET;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataReceived:) name:[NSString stringWithFormat:@"%i",GetActiveSpaceList] object:nil];
    [_GetActiveSpaceList requestDataFromWithFlag:GetActiveSpaceList];
}


-(void)dataReceived:(NSNotification *)notif{
    
    
    STOP_LOADING
    _responseDataOfIndexDict = _GetActiveSpaceList.resultDict;
    
    [self dealResposeResult:_responseDataOfIndexDict[@"Data"][@"Data"]];

    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",GetActiveSpaceList] object:nil];
}


//
#pragma -- mark TABLEVIEW DELEGATE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _currentDataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (Main_Screen_Height+20)*0.3f+60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.spacesListTableview registerNib:[UINib nibWithNibName:@"ZZSpaceRecommendCellTableViewCell" bundle:nil] forCellReuseIdentifier:spaceListTableViewCell];//表xib文件
    ZZSpaceRecommendCellTableViewCell *spacesListTableViewCell=[tableView dequeueReusableCellWithIdentifier:spaceListTableViewCell];
    
    NSDictionary * spaceDict = _currentDataArray[indexPath.row];
    NSString *imageUrl=spaceDict[@"PicUrl"];
    //主图
    UIImageView *imageViewRecommend =[spacesListTableViewCell valueForKey:@"spaceImageView"];
    [imageViewRecommend sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:Index_Recommond_Default_Image]];
    //读取空间名称
    NSString *spaceName = spaceDict[@"ActiveSpaceName"];
    UILabel * spaceNameLabel = [spacesListTableViewCell valueForKey:@"spaceNameLabel"];
    spaceNameLabel.text = spaceName;
    //读取空间地址
    NSString *spaceAdress =spaceDict[@"Location"];
    UILabel * spaceAdressLabel = [spacesListTableViewCell valueForKey:@"spaceAdressLabel"];
    spaceAdressLabel.text = spaceAdress;
    //添加用户交互图片
    UIButton *UITouchBtn =[spacesListTableViewCell valueForKey:@"UITouchBtn"];
    UITouchBtn.tag = 5000+indexPath.row;
    [UITouchBtn addTarget:self action:@selector(selectRecommond:) forControlEvents:UIControlEventTouchUpInside];
    return spacesListTableViewCell;
    return spacesListTableViewCell;
}
//选中空间
-(void)selectRecommond:(UIImageView *)sender
{
//    ActiveSpaceModel * activeSpaceModel= _currentDataArray[sender.tag - 5000];
    NSDictionary *tempDict=_currentDataArray[sender.tag-5000];
    [JCYGlobalData sharedInstance].ActivitySpaceId =tempDict[@"ActiveSpaceId"];

    
    [self performSegueWithIdentifier:@"ActivityToIntroduce" sender:self];
}


/** *处理请求返回后的结果*/
-(void)dealResposeResult:(NSMutableArray*)arr
{
    //如果返回的数据小于10条则隐藏加载更多数据的提示条
    if(arr.count<10){
        _spacesListTableview.mj_footer.hidden = YES;
    }else{
        _spacesListTableview.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            [self requestData];
        }];
        
    }
    if (_currentTableViewPage == 1) {
        _currentDataArray = [NSMutableArray array];
    }
    [_currentDataArray addObjectsFromArray:arr];
   
    if (_currentDataArray.count > 0) {
        [self.view bringSubviewToFront:_spacesListTableview];
        [_spacesListTableview reloadData];
    }else{
        [self.view bringSubviewToFront:_nodataView];
    }
    _currentTableViewPage++;//拿到数据后页面数自加
    [_spacesListTableview.mj_footer endRefreshing];
}

//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/

@end
