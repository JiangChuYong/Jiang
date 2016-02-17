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

-(void)registCell{
    [_listTableView registerNib:[UINib nibWithNibName:@"ZZSpaceRecommendCellTableViewCell" bundle:nil] forCellReuseIdentifier:spaceListTableViewCell];
    [_listTableView registerNib:[UINib nibWithNibName:@"PBADBannerCellTableViewCell" bundle:nil] forCellReuseIdentifier:ADCellIDKey];
    [_listTableView registerNib:[UINib nibWithNibName:@"PBButtonChooseCell" bundle:nil] forCellReuseIdentifier:ChooseCellIDKey];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _spaceSummaryInfoArr.count+2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"dfsf");
    if (indexPath.row==0) {
        if (indexPath.row == 0) {
            
            PBADBannerCellTableViewCell * ADCell = [_listTableView dequeueReusableCellWithIdentifier:ADCellIDKey];
            ADCell.ADSrollView.delegate = self;
             _adcell = ADCell;
            [_adcell setScrollViewContentOfSize:_adsArr withCell:_adcell];
            
            return ADCell;
            
        }
    }
    return [[UITableViewCell alloc]init];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
