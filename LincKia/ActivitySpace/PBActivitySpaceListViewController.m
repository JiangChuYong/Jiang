//
//  ZZActivitySpaceListViewController.m
//  LincKia
//
//  Created by 董玲 on 11/12/15.
//  Copyright © 2015 ZZ. All rights reserved.
//

#import "PBActivitySpaceListViewController.h"
#import "ZZSpaceRecommendCellTableViewCell.h"
#import "SpaceIdModel.h"
#import "DeleteFocusIdModel.h"
#import "SpaceSearchModel.h"
#import "ResponseDataOfPagingResultOfIEnumerableOfActiveSpaceModel.h"
#import "MJRefresh.h"
#import "ResponseDataOfBoolean.h"
#import "PBSpaceViewController.h"
#import "PBActivtySpaceDetailViewController.h"
#import "ActiveSpaceModel.h"
#import "PBSearchViewController.h"

@interface PBActivitySpaceListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *spacesListTableview;
@property (weak, nonatomic) IBOutlet UIView *nodataView;
@property (strong,nonatomic) NSMutableArray * currentDataArray;
@property (assign,nonatomic) int currentTableViewPage;
@property (assign,nonatomic) int focusTag;

@end

@implementation PBActivitySpaceListViewController

static NSString *spaceListTableViewCell=@"spaceRecommendCellTableViewCell";

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    _currentTableViewPage = 1;
    [self requestDataFromServer];
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

- (IBAction)searchButtonPress:(UIButton *)sender {
    
    [ZZGlobalModel sharedInstance].orderSubmitFlag = FromActivitySpaceListPage;
    PBSearchViewController * searchVC =[[PBSearchViewController alloc] init];
    searchVC.isActiveSpace=YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma -- mark REQUEST PART

-(void)requestDataFromServer
{
    SpaceSearchModel * spaceSelectedModel = [[SpaceSearchModel alloc]init];
    spaceSelectedModel.Page =  _currentTableViewPage;
    spaceSelectedModel.Rows= 10;
    spaceSelectedModel.SortProperty=@"Name";
    spaceSelectedModel.SortDirection=@"asc";
     //发送请求
    [[ZZAllService sharedInstance] serviceQueryByObj:spaceSelectedModel delegate:self httpTag:HTTPHelperTag_ActiveSpace_GetActiveSpaceList];
}

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
    
    ActiveSpaceModel * space = _currentDataArray[indexPath.row];
    NSString *imageUrl=space.PicUrl;
    //主图
    UIImageView *imageViewRecommend =[spacesListTableViewCell valueForKey:@"spaceImageView"];
    [imageViewRecommend sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:Index_Recommond_Default_Image]];
    //读取空间名称
    NSString *spaceName = space.ActiveSpaceName;
    UILabel * spaceNameLabel = [spacesListTableViewCell valueForKey:@"spaceNameLabel"];
    spaceNameLabel.text = spaceName;
    //读取空间地址
    NSString *spaceAdress =space.Location;
    UILabel * spaceAdressLabel = [spacesListTableViewCell valueForKey:@"spaceAdressLabel"];
    spaceAdressLabel.text = spaceAdress;
    //添加用户交互图片
    UIButton *UITouchBtn =[spacesListTableViewCell valueForKey:@"UITouchBtn"];
    UITouchBtn.tag = 5000+indexPath.row;
    [UITouchBtn addTarget:self action:@selector(selectRecommond:) forControlEvents:UIControlEventTouchUpInside];
    return spacesListTableViewCell;
}
//选中空间
-(void)selectRecommond:(UIImageView *)sender
{
    ActiveSpaceModel * activeSpaceModel= _currentDataArray[sender.tag - 5000];
    [ZZGlobalModel sharedInstance].ActivitySpaceId = activeSpaceModel.ActiveSpaceId;
    PBActivtySpaceDetailViewController * spaceVC = [[PBActivtySpaceDetailViewController alloc] init];
    [self.navigationController pushViewController:spaceVC animated:YES];
}

#pragma -- REQUEST PART
/** *校验数据开始，如果没有通过校验，则返回校验提示*/
-(void)validateFailed:(int)tag validateInfo:(NSString *)validateInfo{
    NSLog(@"validateFailed");
}
/** *获取数据开始*/
-(void)gainDataStart:(int)tag{

}
//获取数据成功
-(void)gainDataSuccess:(int)tag responseObj:(id)responseObj{
    [[AlertUtils sharedInstance]stopHUD];
    
    NSLog(@"%@",responseObj);
    
    switch (tag) {
        
        case HTTPHelperTag_ActiveSpace_GetActiveSpaceList:
        {
            ResponseDataOfPagingResultOfIEnumerableOfActiveSpaceModel * response = [responseObj jsonToModel:ResponseDataOfPagingResultOfIEnumerableOfActiveSpaceModel.class];
            if(response.Code==SERVER_SUCCESS){
                [self dealResposeResult:response];
                return;
            }else{
                [[AlertUtils sharedInstance] showWithText:response.Description inView:self.view lastTime:2.0];
            }
        }
            
        default:
            break;
    }
    
}
-(void)gainDataFailed:(int)tag errorInfo:(NSString *)errorInfo{
    [[AlertUtils sharedInstance]stopHUD];
    [[AlertUtils sharedInstance] showWithText:errorInfo inView:self.view lastTime:2.0];
}
/** *处理请求返回后的结果*/
-(void)dealResposeResult:(ResponseDataOfPagingResultOfIEnumerableOfActiveSpaceModel *)response{
    //如果返回的数据小于10条则隐藏加载更多数据的提示条
    if(response.Data.Data.count<10){
        self.spacesListTableview.footer.hidden = YES;
    }else{
        //添加传统的上拉刷新
        [self.spacesListTableview addLegendFooterWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            [self requestDataFromServer];
        }];
    }
    if (_currentTableViewPage == 1) {
        _currentDataArray = [NSMutableArray array];
    }
    [_currentDataArray addObjectsFromArray:response.Data.Data];
   
    if (_currentDataArray.count > 0) {
        [self.view bringSubviewToFront:_spacesListTableview];
        [_spacesListTableview reloadData];
    }else{
        [self.view bringSubviewToFront:_nodataView];
    }
    _currentTableViewPage++;//拿到数据后页面数自加
    [self.spacesListTableview.footer endRefreshing];
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
