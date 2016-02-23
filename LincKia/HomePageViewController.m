//
//  FirstViewController.m
//  LincKia
//
//  Created by Phoebe on 16/2/15.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "HomePageViewController.h"
#import "ZZSpaceRecommendCellTableViewCell.h"
#import "PBADBannerCellTableViewCell.h"
#import "PBButtonChooseCell.h"
#import "PBIndustryViewController.h"
@interface HomePageViewController ()

@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) NSDictionary * responseDataOfIndexDict;
@property (strong, nonatomic) NSMutableArray * adsArr;
@property (strong, nonatomic) NSMutableArray * spaceSummaryInfoArr;
@property (strong, nonatomic) PBADBannerCellTableViewCell *adcell;


@end

@implementation HomePageViewController
static NSString *spaceListTableViewCell=@"spaceRecommendCellTableViewCell";
static NSString *ADCellIDKey = @"PBADBannerCellTableViewCell";
static NSString *ChooseCellIDKey = @"PBButtonChooseCell";

//注册cell
-(void)registCell{
    [_listTableView registerNib:[UINib nibWithNibName:@"ZZSpaceRecommendCellTableViewCell" bundle:nil] forCellReuseIdentifier:spaceListTableViewCell];
    [_listTableView registerNib:[UINib nibWithNibName:@"PBADBannerCellTableViewCell" bundle:nil] forCellReuseIdentifier:ADCellIDKey];
    [_listTableView registerNib:[UINib nibWithNibName:@"PBButtonChooseCell" bundle:nil] forCellReuseIdentifier:ChooseCellIDKey];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    UINavigationController * navi = (UINavigationController *)self.parentViewController;
    navi.tabBarController.tabBar.hidden = NO;
    navi.navigationBar.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registCell];
    _adsArr =[NSMutableArray array];
    _spaceSummaryInfoArr=[NSMutableArray array];
    START_OBSERVE_CONNECTION
    AFRquest * af = [AFRquest sharedInstance];
    af.subURLString = @"api/Spaces/GetIndex?deviceType=ios&userToken=""";
    // af.parameters = @{@"Account":@"18602515155",@"Password":@"aaa111"};
    af.requestFlag = GetIndex;
    af.style = GET;
    [af requestDataFromServer];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    STOP_OBSERVE_CONNECTION
}



-(void)dataReceived:(NSNotification *)notif{
    
    _responseDataOfIndexDict = [notif object];
    if ([AFRquest sharedInstance].requestFlag == GetIndex) {
        NSLog(@"flag == %i",[AFRquest sharedInstance].requestFlag);
        NSLog(@"%@",_responseDataOfIndexDict);
        
        _adsArr=_responseDataOfIndexDict[@"Data"][@"ADs"];
        
        _spaceSummaryInfoArr=_responseDataOfIndexDict[@"Data"][@"Spaces"];
        [_listTableView reloadData];
    }
    
}


#pragma -- mark UITABLEVIEW DELEGATE
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return (Main_Screen_Height+20)*0.3f;
    }else if (indexPath.row == 1){
        PBButtonChooseCell * chooseCell = [_listTableView dequeueReusableCellWithIdentifier:ChooseCellIDKey];
        return chooseCell.bounds.size.height;
    }else{
        return (Main_Screen_Height+20)*0.3f+60;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _spaceSummaryInfoArr.count+2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"dfsf");
    
    if (indexPath.row == 0) {
        
        PBADBannerCellTableViewCell * ADCell = [_listTableView dequeueReusableCellWithIdentifier:ADCellIDKey];
        ADCell.ADSrollView.delegate = self;
        _adcell = ADCell;
        [_adcell setScrollViewContentOfSize:_adsArr withCell:_adcell];
        
        return ADCell;
        
    }else if (indexPath.row == 1){
        
        PBButtonChooseCell * chooseCell = [_listTableView dequeueReusableCellWithIdentifier:ChooseCellIDKey];
                    [chooseCell.industryBtn addTarget:self action:@selector(pushToIndustryListPage:) forControlEvents:UIControlEventTouchDown];
        //            [chooseCell.spaceBtn addTarget:self action:@selector(pushToLinckiaOffice:) forControlEvents:UIControlEventTouchDown];
                [chooseCell.activityBtn addTarget:self action:@selector(activitySpaceButtonPressed:) forControlEvents:UIControlEventTouchDown];
        
        return chooseCell;
        
    }else{
        ZZSpaceRecommendCellTableViewCell *spacesListTableViewCell=[_listTableView dequeueReusableCellWithIdentifier:spaceListTableViewCell];
        //获取数据
        NSDictionary *spaceDict=_spaceSummaryInfoArr[indexPath.row-2];
        //主图
        [spacesListTableViewCell.spaceImageView sd_setImageWithURL:[NSURL URLWithString:spaceDict[@"PicUrl"]] placeholderImage:[UIImage imageNamed:Index_Recommond_Default_Image]];
        //读取空间名称
        spacesListTableViewCell.spaceNameLabel.text = spaceDict[@"Name"];
        //读取空间地址
        spacesListTableViewCell.spaceAdressLabel.text =spaceDict[@"Location"];
        //添加用户交互图片
        UIButton *UITouchBtn =[spacesListTableViewCell valueForKey:@"UITouchBtn"];
        UITouchBtn.tag = 5000+indexPath.row;
        //            [UITouchBtn addTarget:self action:@selector(selectRecommond:) forControlEvents:UIControlEventTouchUpInside];
        
        return spacesListTableViewCell;
    }
    
    
}

//跳转至 企业服务页面
- (void)pushToIndustryListPage:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"HomeToIndustry" sender:self];
}

//跳转至 活动空间页面
- (void)activitySpaceButtonPressed:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"HomeToActivity" sender:self];
}



#pragma -- mark SCROLLVIEW PART
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_adcell.ADSrollView]) {
        _adcell.pageControl.currentPage = scrollView.contentOffset.x/Main_Screen_Width;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
