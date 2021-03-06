//
//  FirstViewController.m
//  LincKia
//
//  Created by Phoebe on 16/2/15.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "LoginViewController.h"
#import "HomePageViewController.h"
#import "ZZSpaceRecommendCellTableViewCell.h"
#import "PBADBannerCellTableViewCell.h"
#import "PBButtonChooseCell.h"
#import "PBIndustryViewController.h"
#import "UITabBar+badge.h"

@interface HomePageViewController ()

@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) NSDictionary * responseDataOfIndexDict;
@property (strong, nonatomic) NSMutableArray * adsArr;
@property (strong, nonatomic) NSMutableArray * spaceSummaryInfoArr;
@property (strong, nonatomic) PBADBannerCellTableViewCell *adcell;

@property (strong,nonatomic) AFRquest * SpacesGetIndex;

@property (strong,nonatomic) AFRquest * Login;

@property (strong,nonatomic) AFRquest * CheckUnpaidOrder;

@property (strong,nonatomic) AFRquest * GetMember;

@property (strong,nonatomic) NSString * errorDescription;

@property (assign,nonatomic) int isMember;

@end

@implementation HomePageViewController

static NSString *spaceListTableViewCell=@"spaceRecommendCellTableViewCell";
static NSString *ADCellIDKey = @"PBADBannerCellTableViewCell";
static NSString *ChooseCellIDKey = @"PBButtonChooseCell";

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self checkUnpayOrderFromServer];
    //判断会员资格
    [self requestGetMemberFromServer];
    UINavigationController * navi = (UINavigationController *)self.parentViewController;
    navi.tabBarController.tabBar.hidden = NO;
    navi.navigationBar.hidden = YES;
    navi.tabBarController.delegate = self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self checkLoginStatus];
    [self registCell];
    _adsArr =[NSMutableArray array];
    _spaceSummaryInfoArr=[NSMutableArray array];
    //监听退出登录的消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveExitInfo:) name:@"Exit" object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataReceived:) name:[NSString stringWithFormat:@"%i",GetIndex] object:nil];
    _SpacesGetIndex = [[AFRquest alloc]init];;
    _SpacesGetIndex.subURLString = @"api/Spaces/GetIndex?deviceType=ios&userToken=""";
    // af.parameters = @{@"Account":@"18602515155",@"Password":@"aaa111"};
    _SpacesGetIndex.style = GET;
    [_SpacesGetIndex requestDataFromWithFlag:GetIndex];
    
    [[PBAlert sharedInstance] showProgressDialogText:@"加载中，请稍候..." inView:self.view];
    
}

//退出登录时回到首页的动画
-(void)reciveExitInfo:(NSNotification *)notif{
    UINavigationController * navi = (UINavigationController *)self.parentViewController;
    //退出时隐藏小红点
    [navi.tabBarController.tabBar hideBadgeOnItemIndex:2];
       [[NSNotificationCenter defaultCenter]removeObserver:self name:@"Exit" object:nil];
}
-(void)dataReceived:(NSNotification *)notif{
    [[PBAlert sharedInstance] stopHud];
    _responseDataOfIndexDict = _SpacesGetIndex.resultDict;
    _adsArr=_responseDataOfIndexDict[@"Data"][@"ADs"];
    _spaceSummaryInfoArr=_responseDataOfIndexDict[@"Data"][@"Spaces"];
    [_listTableView reloadData];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",GetIndex] object:nil];
}
//注册cell
-(void)registCell{
    [_listTableView registerNib:[UINib nibWithNibName:@"ZZSpaceRecommendCellTableViewCell" bundle:nil] forCellReuseIdentifier:spaceListTableViewCell];
    [_listTableView registerNib:[UINib nibWithNibName:@"PBADBannerCellTableViewCell" bundle:nil] forCellReuseIdentifier:ADCellIDKey];
    [_listTableView registerNib:[UINib nibWithNibName:@"PBButtonChooseCell" bundle:nil] forCellReuseIdentifier:ChooseCellIDKey];
}

#pragma -- mark TABBARCONTROLLER DELEGEATE

//不想让用户进入此tab页面的话,可以用
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    if ([JCYGlobalData sharedInstance].LoginStatus) {
        if (viewController == [tabBarController.viewControllers objectAtIndex:1]){
            if (_isMember) {
                NSLog(@"%i",_isMember);
                return YES;
            }else{
                [[PBAlert sharedInstance] showText:_errorDescription inView:self.view withTime:2.0];
                return NO;
            }
            
        }else{
            return YES;

        }
    }else {
        if (viewController == [tabBarController.viewControllers objectAtIndex:1]||viewController == [tabBarController.viewControllers objectAtIndex:2]){
            [self performSegueWithIdentifier:@"ShowLoginView" sender:self];
        }
        return NO;
    }
    
    //检查订单的有效期 判断是否有会员资格
    
    
#pragma -- mark TODO
    
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
    if (indexPath.row == 0) {
        
        PBADBannerCellTableViewCell * ADCell = [_listTableView dequeueReusableCellWithIdentifier:ADCellIDKey];
        ADCell.ADSrollView.delegate = self;
        _adcell = ADCell;
        [_adcell setScrollViewContentOfSize:_adsArr withCell:_adcell];
        
        return ADCell;
        
    }else if (indexPath.row == 1){
        
        PBButtonChooseCell * chooseCell = [_listTableView dequeueReusableCellWithIdentifier:ChooseCellIDKey];
                    [chooseCell.industryBtn addTarget:self action:@selector(pushToIndustryListPage:) forControlEvents:UIControlEventTouchDown];
                    [chooseCell.spaceBtn addTarget:self action:@selector(pushToLinckiaOffice:) forControlEvents:UIControlEventTouchDown];
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
        [UITouchBtn addTarget:self action:@selector(selectRecommond:) forControlEvents:UIControlEventTouchUpInside];
        
        return spacesListTableViewCell;
    }
    
    
}

//选中空间
-(void)selectRecommond:(UIImageView *)sender
{
    NSDictionary *spaceSummaryInfoDict=_spaceSummaryInfoArr[sender.tag-5002];
    [JCYGlobalData sharedInstance].SpaceId=spaceSummaryInfoDict[@"SpaceId"];
    [self performSegueWithIdentifier:@"HomeToLinckiaSpaceInfo" sender:self];
}


//跳转至 企业服务页面
- (void)pushToIndustryListPage:(UIButton *)sender{
    
    [self performSegueWithIdentifier:@"HomeToIndustry" sender:self];
}

//跳转至 活动空间页面
- (void)activitySpaceButtonPressed:(UIButton *)sender{
    
    [self performSegueWithIdentifier:@"HomeToActivity" sender:self];
    
}

//跳转至 活动空间页面
- (void)pushToLinckiaOffice:(UIButton *)sender{
    
    [self performSegueWithIdentifier:@"HomeToLinckiaSpace" sender:self];
    
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


-(void)checkLoginStatus{
    
    NSUserDefaults * userInfo = [NSUserDefaults standardUserDefaults];
    NSString * userName = [userInfo valueForKey:USERNAME];
    NSString * passWord = [userInfo valueForKey:PASSWORD];
    NSLog(@"%@",userName);
    NSLog(@"%@",passWord);
    
    if (userName && passWord) {
        [self autoLoginWith:userName andPassWord:passWord];
    }else{
        [JCYGlobalData sharedInstance].LoginStatus = NO;
    }
}

#pragma -- mark UserLogin Request


-(void)autoLoginWith:(NSString *)account andPassWord:(NSString *)password{
    
    _Login = [[AFRquest alloc]init];
    _Login.subURLString = @"api/Users/Login?deviceType=ios";
    _Login.parameters = @{@"Account":account,@"Password":password};
    _Login.style = POST;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userInfoDataReceived:) name:[NSString stringWithFormat:@"%i",UsersLogin] object:nil];
    [_Login requestDataFromWithFlag:UsersLogin];

}

-(void)userInfoDataReceived:(NSNotification *)notif{
    
    NSUserDefaults * userInfo = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = _Login.resultDict[@"Data"];
    [JCYGlobalData sharedInstance].userInfo=_Login.resultDict[@"Data"];
    [userInfo setValue:dict[@"UserToken"] forKey:USERTOKEN];
  
    NSString * userToken = [userInfo valueForKey:USERTOKEN];
    if (userToken) {
        [JCYGlobalData sharedInstance].LoginStatus = YES;
        [self checkUnpayOrderFromServer];
        NSLog(@"自动登录成功");
    }
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",UsersLogin] object:nil];
    NSLog(@"%@",_Login.resultDict);
}


#pragma -- mark CheckUnpayOrder Request

-(void)checkUnpayOrderFromServer{
    
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
        if ([unpay intValue]) {
            UINavigationController * navi = (UINavigationController *)self.parentViewController;
            [navi.tabBarController.tabBar showBadgeOnItemIndex:2];
        }
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",CheckUnpaidOrder] object:nil];
}

-(void)requestGetMemberFromServer{
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getmenberDataReceived:) name:[NSString stringWithFormat:@"%i",GetMember] object:nil];
    
        NSUserDefaults * userInfo = [NSUserDefaults standardUserDefaults];
    
        NSString * userToken = [userInfo valueForKey:USERTOKEN];
    
        _GetMember = [[AFRquest alloc]init];
    
        _GetMember.subURLString =[NSString stringWithFormat:@"api/Users/JudgeIsRentUser?userToken=%@&deviceType=ios",userToken];
    
        _GetMember.style = GET;
        
    
        [_GetMember requestDataFromWithFlag:GetMember];
    
}
-(void)getmenberDataReceived:(NSNotification *)notif{
    
    int result = [_GetMember.resultDict[@"Code"] intValue];;
    if (result == SUCCESS) {
        
        _isMember=[_GetMember.resultDict[@"Data"] intValue];
        
    }else{
        _errorDescription=_GetMember.resultDict[@"Description"];
        
    }
    
    NSLog(@"%@",_GetMember.resultDict);

    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",CheckUnpaidOrder] object:nil];
}


@end
