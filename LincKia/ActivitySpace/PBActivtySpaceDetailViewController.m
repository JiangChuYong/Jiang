//
//  PBActivtySpaceDetailViewController.m
//  LincKia
//
//  Created by Phoebe on 15/12/26.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//
#import "Masonry.h"
#import "PBActivtySpaceDetailViewController.h"
#import "SpaceTableFacilitiesCell.h"
#import "JCYActivitySpaceInfoCellTableViewCell.h"
#import <MapKit/MapKit.h>
#import "PBADBannerCellTableViewCell.h"

@interface PBActivtySpaceDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (assign,nonatomic) unsigned int numOfRow;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic)  UIScrollView *ADScrollView;
@property (strong, nonatomic) UIButton *phoneBtn;
@property (strong, nonatomic) UILabel *pageLabel;
@property (assign,nonatomic) int numOfPage;
@property (assign,nonatomic) int currentPage;
@property (assign,nonatomic) BOOL hasFacility;
@property (assign,nonatomic) BOOL hasIntroString;
@property (strong,nonatomic) NSDictionary *responseDataOfIndexDict;
@property (strong,nonatomic) NSMutableArray *adsArr;
@property (strong,nonatomic) NSMutableArray *facilitiesArr;

@end

@implementation PBActivtySpaceDetailViewController

static NSString *facilitiesCell = @"SpaceTableFacilitiesCell";
static NSString *jcyAddressCell=@"JCYActivitySpaceInfoCellTableViewCell";
static NSString *bannerCellIDKey = @"PBADBannerCellTableViewCell";


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
    [self registerCell];
    
    [self requestData];
}

-(void)setUI
{
    _confirmBtn.layer.cornerRadius = 5;
    _confirmBtn.clipsToBounds = YES;
    _adsArr=[NSMutableArray array];
    _facilitiesArr=[NSMutableArray array];
    [self initPhoneButton];
    [self initADBannerPageControl];
}

//注册表格
-(void)registerCell
{
    [_tableView registerNib:[UINib nibWithNibName:@"PBADBannerCellTableViewCell" bundle:nil] forCellReuseIdentifier:bannerCellIDKey];
    [_tableView registerNib:[UINib nibWithNibName:@"JCYActivitySpaceInfoCellTableViewCell" bundle:nil] forCellReuseIdentifier:jcyAddressCell];
    [_tableView registerNib:[UINib nibWithNibName:@"SpaceTableFacilitiesCell" bundle:nil] forCellReuseIdentifier:facilitiesCell];
}

//添加页码和相机图片
-(void)initADBannerPageControl
{
    _currentPage = 1;
    
    if (_pageLabel) {
        [_pageLabel removeFromSuperview];
    }
    
    CGFloat fontSize;
    if (Main_Screen_Width == 414) {
        fontSize = 16;
    }else{
        fontSize = 13;
    }
    
    _pageLabel = [[UILabel alloc]init];
    _pageLabel.frame=CGRectMake(15, ADVIEW_HEIGHT-35, Main_Screen_Width, 20);
    _pageLabel.font = [UIFont systemFontOfSize:fontSize];
    _pageLabel.text = @"0/0";
    _pageLabel.textColor = CommonColor_White;
    [_tableView addSubview:_pageLabel];
    
    UIImageView * camera = [[UIImageView alloc]init];
    camera.frame=CGRectMake(30, 0, 30, 20);
    
    camera.image = [UIImage imageNamed:@"community_introduce_camer.png"];
    [_pageLabel addSubview:camera];
}
//添加电话按钮
-(void)initPhoneButton
{
    CGSize size;
    if (Main_Screen_Width == 414) {
        size = CGSizeMake(70, 70);
    }else{
        size = CGSizeMake(50, 50);
    }
    
    CGFloat originY = ADVIEW_HEIGHT-size.height/2;
    CGFloat originX = Main_Screen_Width-15-size.width;
    
    if (_phoneBtn) {
        [_phoneBtn removeFromSuperview];
    }
    _phoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(originX, originY, size.width, size.height)];
    [_phoneBtn setBackgroundImage:[UIImage imageNamed:@"community_introduce_but_phone.png"]forState:UIControlStateNormal];
    [_phoneBtn addTarget:self action:@selector(phoneButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [_tableView addSubview:_phoneBtn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)confirmBtnPressed:(UIButton *)sender {
    
    
//    [ZZGlobalModel sharedInstance].activeSpaceInfo = _spaceInfo;
//    PBActiveSpaceBookingViewController * VC = [[PBActiveSpaceBookingViewController alloc]initWithNibName:@"PBActiveSpaceBookingViewController" bundle:nil];
//    
//    [self.navigationController pushViewController:VC animated:YES];
    
    
}
- (void)phoneButtonPressed:(UIButton *)sender {
    NSString * phoneNum = [NSString stringWithFormat:@"telprompt://%@",_responseDataOfIndexDict[@"Data"][@"phoneNum"]];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:phoneNum]];
}
#pragma -- mark TABLEVIEW DELEGATE
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2+_hasFacility;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        PBADBannerCellTableViewCell * bannerCell = [tableView dequeueReusableCellWithIdentifier:bannerCellIDKey];
        bannerCell.ADSrollView.delegate = self;
        bannerCell.pageControl.hidden = YES;
        if (_adsArr.count) {
            [self setBannerViewInCell:bannerCell];
        }
        return bannerCell;
    }else if (indexPath.row == 1) {
        
        JCYActivitySpaceInfoCellTableViewCell *Adresscell=[_tableView dequeueReusableCellWithIdentifier:jcyAddressCell];
        Adresscell.nameLable.text=_responseDataOfIndexDict[@"Data"][@"activeSpaceName"];
        Adresscell.activitySpaceDetailsInfoLable.text=_responseDataOfIndexDict[@"Data"][@"descriptions"];
        Adresscell.addressLable.text=_responseDataOfIndexDict[@"Data"][@"address"];
        Adresscell.priceLable.text=[NSString stringWithFormat:@"￥%@/%@",_responseDataOfIndexDict[@"Data"][@"amount"],_responseDataOfIndexDict[@"Data"][@"priceUnit"]];
        //按钮触发本机自带地图
        //空间介绍
        if (!_hasIntroString) {
            Adresscell.pushToIntroPageButton.hidden = YES;
        }else{
            //推向空间介绍页面
            [Adresscell.pushToIntroPageButton addTarget:self action:@selector(pushToSpaceIntroducePage:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [Adresscell.naviButton addTarget:self action:@selector(openLocalMapWithLongitudeandLatitude) forControlEvents:UIControlEventTouchUpInside];
        
        return Adresscell;
    }else{
        SpaceTableFacilitiesCell * FacilitiesCell = [_tableView dequeueReusableCellWithIdentifier:facilitiesCell];
        
        
        for (int i=0; i<4; i++) {
            NSDictionary *facilityDict=[_facilitiesArr objectAtIndex:i];
            //图片
            NSURL * URL = [NSURL URLWithString:facilityDict[@"picUrl"]];
            NSString * imageName = [NSString stringWithFormat:@"pic_%i",i+1];
            UIImageView * image = [FacilitiesCell valueForKey:imageName];
            [image sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:Index_Recommond_Default_Image]];
            //名称
            NSString * labelName = [NSString stringWithFormat:@"name_%i",i+1];
            UILabel * label = [FacilitiesCell valueForKey:labelName];
            label.text = facilityDict[@"name"];
        }
        FacilitiesCell.lineImage.hidden=YES;
        //推送至下一个页面
        [FacilitiesCell.actionButton addTarget:self action:@selector(pushToFacilitiesPage:) forControlEvents:UIControlEventTouchUpInside];
        return FacilitiesCell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return ADVIEW_HEIGHT;
    }else if (indexPath.row == 1) {
        JCYActivitySpaceInfoCellTableViewCell * Adresscell = [_tableView dequeueReusableCellWithIdentifier:jcyAddressCell];
        return Adresscell.bounds.size.height-(34*!_hasIntroString);
    }else{
        SpaceTableFacilitiesCell * FacilitiesCell = [_tableView dequeueReusableCellWithIdentifier:facilitiesCell];
        return FacilitiesCell.bounds.size.height;
    }
}

-(void)setBannerViewInCell:(PBADBannerCellTableViewCell *)cell
{
    _ADScrollView = cell.ADSrollView;
    _numOfPage = (int)_adsArr.count;
    //获取空间图片信息
    _ADScrollView.contentSize = CGSizeMake(Main_Screen_Width*_numOfPage, 0);
    [self reloadPageControl];
    NSMutableArray * urlArr = [NSMutableArray array];
    for (NSDictionary *dict in _adsArr) {
        [urlArr addObject:dict[@"picUrl"]];
    }
    
    if (_ADScrollView.subviews.count) {
        for (id temp in cell.ADSrollView.subviews) {
            [temp removeFromSuperview];
        }
    }
    
    for (int i=0; i<_adsArr.count; i++) {
        UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width*i, 0, Main_Screen_Width, cell.bounds.size.height)];
        [img sd_setImageWithURL:[NSURL URLWithString:urlArr[i]] placeholderImage:[UIImage imageNamed:Index_Recommond_Default_Image]];
        [_ADScrollView addSubview:img];
    }
}

-(void)reloadPageControl
{
    _pageLabel.text = [NSString stringWithFormat:@"%i/%i",_currentPage,_numOfPage];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%i",(int)indexPath.row);
}
#pragma -- mark ACTION PART
- (IBAction)backButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma -- mark SCROLLVIEW DELEGATE
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //判断但前的scrollview是广告图的还是tableview的
    if ([scrollView isEqual:_ADScrollView]) {
        _currentPage = scrollView.contentOffset.x/Main_Screen_Width+1;
        _pageLabel.text = [NSString stringWithFormat:@"%i/%i",_currentPage,_numOfPage];
    }
}

#pragma -- mark REQUEST PART
-(void)requestData
{
    NSString * spaceId = [JCYGlobalData sharedInstance].ActivitySpaceId;
    NSLog(@"%@",spaceId);
    START_OBSERVE_CONNECTION
    AFRquest * af = [AFRquest sharedInstance];
    af.subURLString = @"api/ActiveSpace/GetOne?userToken=""&deviceType=ios";
    af.parameters = @{@"activeSpaceId":spaceId,@"language":@"cn"};
    af.requestFlag = ActiveSpaceGetOne;
    af.style = GET;
    [af requestDataFromServer];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    STOP_OBSERVE_CONNECTION
}



-(void)dataReceived:(NSNotification *)notif{
    
    _responseDataOfIndexDict = [notif object];
    if ([AFRquest sharedInstance].requestFlag == ActiveSpaceGetOne) {
        NSLog(@"flag == %i",[AFRquest sharedInstance].requestFlag);
        NSLog(@"%@",_responseDataOfIndexDict);
        // _currentDataArray=_responseDataOfIndexDict[@"Data"][@"Data"];
        
        
        _adsArr=_responseDataOfIndexDict[@"Data"][@"pictures"];
        _facilitiesArr=_responseDataOfIndexDict[@"Data"][@"facilities"];
        
        //判断是否提供硬件设施，是则加载cell,否责不加载
        if (_facilitiesArr.count >0) {
            _hasFacility = YES;
        }else{
            _hasFacility = NO;
        }
        
        if ([_responseDataOfIndexDict[@"Data"][@"descriptions"] isEqualToString:@""]) {
            _hasIntroString = NO;
        }else{
            _hasIntroString = YES;
        }
        [_tableView reloadData];
        
        
    }
    
}



//空间设施页面
-(void)pushToFacilitiesPage:(UIButton *)sender
{
    
//    PBHardwareFacilitiesViewController * facilitiesVC = [[PBHardwareFacilitiesViewController alloc]init];
//    [ZZGlobalModel sharedInstance].activeSpaceInfo=_spaceInfo;
//    facilitiesVC.isActivitySpace=YES;
//    [self.navigationController pushViewController:facilitiesVC animated:YES];
    NSLog(@"aaaa");
}

//空间介绍页面
-(void)pushToSpaceIntroducePage:(UIButton *)sender
{
//    [ZZGlobalModel sharedInstance].activeSpaceInfo = _spaceInfo;
//    ZZSpaceIntroduceViewController *viewController = [[ZZSpaceIntroduceViewController alloc] init];
//    viewController.isActiveSpace=YES;
//    [self.navigationController pushViewController:viewController animated:YES];
    NSLog(@"aaaa");

}



-(void)openLocalMapWithLongitudeandLatitude
{
    CLGeocoder *geocoder =[[CLGeocoder alloc]init];
    NSString * geoString = [NSString stringWithFormat:@"%@",_responseDataOfIndexDict[@"Data"][@"address"]];
    [geocoder geocodeAddressString:geoString completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *clPlacemark=[placemarks firstObject];//获取第一个地标
        MKPlacemark *mkplacemark=[[MKPlacemark alloc]initWithPlacemark:clPlacemark];//定位地标转化为地图的地标
        NSDictionary *options=@{MKLaunchOptionsMapTypeKey:@(MKMapTypeStandard)};
        MKMapItem *mapItem=[[MKMapItem alloc]initWithPlacemark:mkplacemark];
        [mapItem openInMapsWithLaunchOptions:options];
    }];
}


///** *校验数据开始，如果没有通过校验，则返回校验提示*/
//-(void)validateFailed:(int)tag validateInfo:(NSString *)validateInfo{
//    NSLog(@"validateFailed");
//}
///** *获取数据开始*/
//-(void)gainDataStart:(int)tag{
//    
//}
////获取数据成功
//-(void)gainDataSuccess:(int)tag responseObj:(id)responseObj{
//    [[AlertUtils sharedInstance]stopHUD];
//    NSLog(@"%@",responseObj);
//    ResponseDataOfActiveSpaceViewInfoModel * response = [responseObj jsonToModel:ResponseDataOfActiveSpaceViewInfoModel.class];
//    if (response.Code == SERVER_SUCCESS) {
//        class_copyPropertyList([ActiveSpaceViewInfoModel class],&_numOfRow);
//        [self dealRecievedData:response];
//    }else{
//        [[AlertUtils sharedInstance] showWithText:response.Description inView:self.view lastTime:2.0];
//    }
//    
//}
//-(void)gainDataFailed:(int)tag errorInfo:(NSString *)errorInfo{
//    [[AlertUtils sharedInstance]stopHUD];
//    [[AlertUtils sharedInstance] showWithText:errorInfo inView:self.view lastTime:2.0];
//}
//
//-(void)dealRecievedData:(ResponseDataOfActiveSpaceViewInfoModel *)respone
//{
//    
//    /*获取数据*/
//    _spaceInfo = respone.Data;
//    /*获取数据*/
//    _spaceInfo = respone.Data;
//    //判断是否提供硬件设施，是则加载cell,否责不加载
//    if (_spaceInfo.facilities.count >0) {
//        _hasFacility = YES;
//    }else{
//        _hasFacility = NO;
//    }
//    
//    if ([_spaceInfo.descriptions isEqualToString:@""]) {
//        _hasIntroString = NO;
//    }else{
//        _hasIntroString = YES;
//    }
//    [_tableView reloadData];
//}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
