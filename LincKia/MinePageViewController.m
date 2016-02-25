//
//  MinePageViewController.m
//  LincKia
//
//  Created by Phoebe on 16/2/15.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "MinePageViewController.h"
#import "PBMineTableViewHeadCellTableViewCell.h"
#import "PBMineTableViewSecondCell.h"
#import "PBDoubleTableViewCell.h"
#import "PBMineTableViewSingleLineCell.h"

@interface MinePageViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong,nonatomic) NSMutableArray * dataSource;
@property (strong,nonatomic) NSDictionary * userInfoDic;

@property (assign,nonatomic) BOOL HasUnpayOrder;
@property (strong,nonatomic) AFRquest * CheckUnpaidOrder;
@property (strong,nonatomic) AFRquest * GetUserInfo;

@end

@implementation MinePageViewController

static NSString * headCellIDKey = @"PBMineTableViewHeadCellTableViewCell";
static NSString * secondCellIDKey = @"PBMineTableViewSecondCell";
static NSString * doubleLineCellIDKey = @"PBDoubleTableViewCell";
static NSString * singleLineCellIDKey = @"PBMineTableViewSingleLineCell";


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UINavigationController * navi = (UINavigationController *)self.navigationController;
    navi.tabBarController.tabBar.hidden = NO;
    navi.navigationBar.hidden = NO;
    
    if (![JCYGlobalData sharedInstance].LoginStatus) {
        [self performSegueWithIdentifier:@"MineToLogin" sender:self];
    }else{
        _HasUnpayOrder = NO;
        [self checkUnpayOrder];
        [self getUserInfoData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerTableViewCells];
    [self initMineViewDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)registerTableViewCells
{
    [_table registerNib:[UINib nibWithNibName:@"PBMineTableViewHeadCellTableViewCell" bundle:nil] forCellReuseIdentifier:headCellIDKey];
    [_table registerNib:[UINib nibWithNibName:@"PBMineTableViewSecondCell" bundle:nil] forCellReuseIdentifier:secondCellIDKey];
    [_table registerNib:[UINib nibWithNibName:@"PBDoubleTableViewCell" bundle:nil] forCellReuseIdentifier:doubleLineCellIDKey];
    [_table registerNib:[UINib nibWithNibName:@"PBMineTableViewSingleLineCell" bundle:nil] forCellReuseIdentifier:singleLineCellIDKey];
}
-(void)initMineViewDataSource
{
    // NSArray * row_01 = [NSArray arrayWithObjects:@"mine_resume.png",@"海星客专业资历", nil];
    // NSArray * row_02 = [NSArray arrayWithObjects:@"mine_service.png", @"社区服务",nil];
    // NSArray * row_03 = [NSArray arrayWithObjects:@"mine_coffice.png",@"我的咖啡客",nil];
    NSArray * row_04 = [NSArray arrayWithObjects:@"mine_appointment_visit.png",@"我的预约参观",nil];
    NSArray * row_05 = [NSArray arrayWithObjects:@"mine_online_orientation.png",@"我的在线订位",nil];
    NSArray * row_06 = [NSArray arrayWithObjects:@"mine_help.png",@"帮助与反馈",nil];
    NSArray * row_07 = [NSArray arrayWithObjects:@"mine_set_up.png",@"设置",nil];
    _dataSource = [NSMutableArray arrayWithObjects:row_04,row_05,row_06,row_07,nil];
    [_table reloadData];
}
#pragma -- mark TableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count+2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        PBMineTableViewHeadCellTableViewCell * headCell = [_table dequeueReusableCellWithIdentifier:headCellIDKey];
        return [headCell getCellHeight];;
    }
    else if(indexPath.row == 1){
        PBMineTableViewSecondCell * secondCell = [_table dequeueReusableCellWithIdentifier:secondCellIDKey];
        if (_userInfoDic) {
        }
        return secondCell.frame.size.height;
    }
    else{
        PBMineTableViewSingleLineCell * singleLineCell = [_table dequeueReusableCellWithIdentifier:singleLineCellIDKey];
        return singleLineCell.frame.size.height;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 0) {
        
        PBMineTableViewHeadCellTableViewCell * headCell = [_table dequeueReusableCellWithIdentifier:headCellIDKey];
        headCell.phoneNumLab.text = _userInfoDic[@"Mobile"];
        NSNumber * starFish = _userInfoDic[@"Starfish"];
        headCell.LincKiaCoinNum.text = [NSString stringWithFormat:@"%@",starFish];
        
        return headCell;
    }
    else if(indexPath.row == 1){
        PBMineTableViewSecondCell * secondCell = [_table dequeueReusableCellWithIdentifier:secondCellIDKey];
        
        if (_HasUnpayOrder) {
            secondCell.hintImg.hidden = NO;
        }else{
            secondCell.hintImg.hidden = YES;
        }
        
        return secondCell;
    }
    else{
        PBMineTableViewSingleLineCell * singleLineCell = [_table dequeueReusableCellWithIdentifier:singleLineCellIDKey];
        NSArray * array = _dataSource[indexPath.row-2];
        singleLineCell.img.image = [UIImage imageNamed:array[0]];
        singleLineCell.name.text = array[1];
        return singleLineCell;
    }
    
 
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma -- mark CheckUnpayOrder Request

-(void)checkUnpayOrder{
    
    if ([JCYGlobalData sharedInstance].LoginStatus) {
        NSUserDefaults * userInfo = [NSUserDefaults standardUserDefaults];
        NSString * userToken = [userInfo valueForKey:USERTOKEN];
        _CheckUnpaidOrder = [[AFRquest alloc]init];
        _CheckUnpaidOrder.subURLString =[NSString stringWithFormat:@"api/Orders/CheckUnpaidOrder?userToken=%@&deviceType=ios",userToken];
        _CheckUnpaidOrder.style = POST;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkUnpayDataReceived:) name:[NSString stringWithFormat:@"%i",CheckUnpaidOrder] object:nil];
        [_CheckUnpaidOrder requestDataFromWithFlag:CheckUnpaidOrder];
    }
    
}
-(void)checkUnpayDataReceived:(NSNotification *)notif{
    NSLog(@"%@",_CheckUnpaidOrder.resultDict);
    int result = [_CheckUnpaidOrder.resultDict[@"Code"] intValue];;
    if (result == SUCCESS) {
        NSNumber * unpay = _CheckUnpaidOrder.resultDict[@"Data"];
        _HasUnpayOrder = [unpay intValue];
    }
    [_table reloadData];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",CheckUnpaidOrder] object:nil];
}

#pragma -- mark GetUserInfo Request

-(void)getUserInfoData{
    
    NSUserDefaults * userInfo = [NSUserDefaults standardUserDefaults];
    NSString * userToken = [userInfo valueForKey:USERTOKEN];
    _GetUserInfo = [[AFRquest alloc]init];
    _GetUserInfo.subURLString =[NSString stringWithFormat:@"api/Users/GetUserInfo?userToken=%@&deviceType=ios",userToken];
    _GetUserInfo.style = GET;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userInfoDataReceived:) name:[NSString stringWithFormat:@"%i",GetUserInfo] object:nil];
    [_GetUserInfo requestDataFromWithFlag:GetUserInfo];
}

-(void)userInfoDataReceived:(NSNotification *)notif{
    NSLog(@"%@",_GetUserInfo.resultDict);
    _userInfoDic = _GetUserInfo.resultDict[@"Data"];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",GetUserInfo] object:nil];
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
