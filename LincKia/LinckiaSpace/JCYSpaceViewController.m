//
//  JCYSpaceViewController.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/1.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "JCYSpaceViewController.h"
#import "PBHardwareFacilitiesViewController.h"
#import "PBSpaceTableAdressCell.h"
#import "TQStarRatingView.h"
#import "PBTableSpaceTypeCell.h"
#import "SpaceTableFacilitiesCell.h"
#import "CommentCell.h"
//#import <ShareSDK/ShareSDK.h>
#import "Masonry.h"
#import "PBADBannerCellTableViewCell.h"
#import "LoginViewController.h"
@interface JCYSpaceViewController ()

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
//@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UIImageView *separaLine;
@property (weak, nonatomic) IBOutlet UIButton *bookingActionButton;
@property (weak, nonatomic) IBOutlet UIButton *shoppingActioButton;
@property (strong,nonatomic) UIScrollView * ADScrollView;
@property (strong, nonatomic) UIButton *phoneBtn;
@property (strong, nonatomic) UILabel *pageLabel;
//pagecontrol
@property (assign,nonatomic) int numOfTotalPage;
@property (assign,nonatomic) int currentPage;
//空间详情
@property (strong,nonatomic) NSDictionary * spaceInfoDict;
@property (strong,nonatomic) NSMutableArray * spaceCellsGroupArray ;
//判断是否拥有服务设施
@property (assign,nonatomic) BOOL hasFacility;
//判断是否提供介绍内容
@property (assign,nonatomic) BOOL hasIntroString;
//判断当前是否有可租赁空间
@property (assign,nonatomic) BOOL hasValidSpace;

@property (strong,nonatomic) AFRquest *LinckiaSpaceInfo;

@end

@implementation JCYSpaceViewController


static NSString *bannerCellIDKey = @"PBADBannerCellTableViewCell";
static NSString *addressCell = @"PBSpaceTableAdressCell";
static NSString *spaceStyleCell = @"PBTableSpaceTypeCell";
static NSString *facilitiesCell = @"SpaceTableFacilitiesCell";
static NSString *commentCellIdentifier = @"CommentCell";

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UINavigationController * navi = (UINavigationController *)self.navigationController;
    navi.tabBarController.tabBar.hidden = YES;
    navi.navigationBar.hidden = YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self registCell];
    [self requestDataFromServer];
}

#pragma -- mark UI PART
- (void)setUI
{
    //优化按钮外观
    _bookingActionButton.layer.cornerRadius = 5;
    _bookingActionButton.clipsToBounds = YES;
    _shoppingActioButton.layer.cornerRadius = 5;
    _shoppingActioButton.clipsToBounds = YES;
    
    [self initPhoneButton];
    
    [self initADBannerPageControl];
}

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
    [_table addSubview:_pageLabel];
    
    UIImageView * camera = [[UIImageView alloc]init];
    camera.frame=CGRectMake(30, 0, 30, 20);
    camera.image = [UIImage imageNamed:@"community_introduce_camer.png"];
    [_pageLabel addSubview:camera];
}
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
    [_table addSubview:_phoneBtn];
}

-(void)registCell
{
    //注册表格
    [self.table registerNib:[UINib nibWithNibName:@"PBADBannerCellTableViewCell" bundle:nil] forCellReuseIdentifier:bannerCellIDKey];
    [self.table registerNib:[UINib nibWithNibName:@"PBSpaceTableAdressCell" bundle:nil] forCellReuseIdentifier:addressCell];
    [self.table registerNib:[UINib nibWithNibName:@"PBTableSpaceTypeCell" bundle:nil] forCellReuseIdentifier:spaceStyleCell];
    [self.table registerNib:[UINib nibWithNibName:@"SpaceTableFacilitiesCell" bundle:nil] forCellReuseIdentifier:facilitiesCell];
    [self.table registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:commentCellIdentifier];
}
-(void)requestDataFromServer
{
    _hasValidSpace = NO;
    NSString * spaceId = [JCYGlobalData sharedInstance].SpaceId;
    NSLog(@"%@",spaceId);
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataReceived:) name:[NSString stringWithFormat:@"%i",LinckiaSpaceGetOne] object:nil];
    
    _LinckiaSpaceInfo = [[AFRquest alloc]init];
    _LinckiaSpaceInfo.subURLString = @"api/Spaces/GetOne?userToken=""&deviceType=ios";
    _LinckiaSpaceInfo.parameters = @{@"SpaceId":spaceId,@"language":@"cn"};
    _LinckiaSpaceInfo.style = GET;
    [_LinckiaSpaceInfo requestDataFromWithFlag:LinckiaSpaceGetOne];

    
    
}

-(void)dataReceived:(NSNotification *)notif{
    
    _spaceInfoDict=_LinckiaSpaceInfo.resultDict;
    
    NSLog(@"%@",_LinckiaSpaceInfo.resultDict);

    int result = [_LinckiaSpaceInfo.resultDict[@"Code"] intValue];;
    if (result == SUCCESS) {

        [self dealDataWithResponse:_spaceInfoDict[@"Data"]];
        
        
    }else{
        
        [[PBAlert sharedInstance]showText:_spaceInfoDict
         [@"Description"]inView:self.view withTime:2.0];
    }
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",LinckiaSpaceGetOne] object:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -- mark PrivateMethods PART
-(NSString *)checkSpacePriceWith:(float)price
{
    if (price<100) {
        return [NSString stringWithFormat:@"¥%0.f/人/小时",price];
    }else{
        return [NSString stringWithFormat:@"¥%0.f/人/月",price];
    }
}
#pragma -- mark ACTION PART
- (IBAction)backButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)phoneButtonPressed:(UIButton *)sender {
    NSString * phoneNum = [NSString stringWithFormat:@"telprompt://%@",_spaceInfoDict[@"Data"][@"Tel"]];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:phoneNum]];
}
//空间介绍页面
-(void)pushToSpaceIntroducePage:(UIButton *)sender
{
    
    [JCYGlobalData sharedInstance].spaceDetailInfo = _spaceInfoDict;
    [JCYGlobalData sharedInstance].isActiveSpace=NO;
    [self performSegueWithIdentifier:@"LinckiaSpaceToLinckiaSpaceIntroduce" sender:self];
    
}
//评论页面
-(void)pushToCommentPage:(UIButton *)sender
{

    [JCYGlobalData sharedInstance].spaceDetailInfo=_spaceInfoDict;
    [self performSegueWithIdentifier:@"LinckiaSpaceToEvaluate" sender:self];
}
//空间设施页面
-(void)pushToFacilitiesPage:(UIButton *)sender
{
    
    [JCYGlobalData sharedInstance].spaceDetailInfo=_spaceInfoDict;
    [JCYGlobalData sharedInstance].isActiveSpace=NO;
    [self performSegueWithIdentifier:@"LinckiaSpaceToHardware" sender:self];

   
}
- (IBAction)pushToBookingPage:(UIButton *)sender {
    
    if (![JCYGlobalData sharedInstance].LoginStatus) {
        
        [self performSegueWithIdentifier:@"LinckiaSpaceInfoToLogin" sender:self];
        
    }else{
        
        [JCYGlobalData sharedInstance].spaceDetailInfo = _spaceInfoDict;
        [self performSegueWithIdentifier:@"LinckiaSpaceInfoToBooking" sender:self];
    }
    
}
- (IBAction)pushToShoppingPage:(UIButton *)sender {
    
    if (![JCYGlobalData sharedInstance].LoginStatus) {
        [self performSegueWithIdentifier:@"LinckiaSpaceInfoToLogin" sender:self];
        
    }else{
        
//        ZZSpaceOnlineReserveViewController *viewController = [[ZZSpaceOnlineReserveViewController alloc] init];
//        
//        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}
-(void)openLocalMapWithLongitudeandLatitude
{
    CLGeocoder *geocoder =[[CLGeocoder alloc]init];
    NSString * geoString = [NSString stringWithFormat:@"%@",_spaceInfoDict[@"Data"][@"Location"]];
    [geocoder geocodeAddressString:geoString completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *clPlacemark=[placemarks firstObject];//获取第一个地标
        MKPlacemark *mkplacemark=[[MKPlacemark alloc]initWithPlacemark:clPlacemark];//定位地标转化为地图的地标
        NSDictionary *options=@{MKLaunchOptionsMapTypeKey:@(MKMapTypeStandard)};
        MKMapItem *mapItem=[[MKMapItem alloc]initWithPlacemark:mkplacemark];
        [mapItem openInMapsWithLaunchOptions:options];
    }];
}
//- (IBAction)shareButtonPressed:(UIButton *)sender {
//    
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"headphoto_defaluted@3x" ofType:@"png"];
//    
//    //1、构造分享内容
//    /*
//     id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat: @"http://www.linckia.cn/linckiaweixin/space_info.html?id=%d",self.spaceViewInfo.SpaceId] defaultContent:@"dsafdsafdasfdafdsa"
//     image:[ShareSDK imageWithPath:imagePath]
//     title:@"dgdsagdagdagdafsagdsagdafgdsagdfafdagdsgdsag"
//     url:[NSString stringWithFormat: @"http://www.linckia.cn/linckiaweixin/space_info.html?id=%d",self.spaceViewInfo.SpaceId]
//     description:@"这是一条演示信息" mediaType:SSPublishContentMediaTypeNews];
//     */
//    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat: @"http://www.linckia.cn/linckiaweixin_sub/space_info.html?id=%d",_spaceInfo.SpaceId] defaultContent:nil
//                                                image:[ShareSDK imageWithPath:imagePath]  title:_spaceInfo.Name
//                                                  url:[NSString stringWithFormat: @"http://www.linckia.cn/linckiaweixin_sub/space_info.html?id=%d",_spaceInfo.SpaceId] description:nil
//                                            mediaType:SSPublishContentMediaTypeNews];
//    
//    /*
//     //定制微信好友信息
//     [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
//     content:INHERIT_VALUE
//     title:NSLocalizedString(@"TEXT_HELLO_WECHAT_SESSION", @"Hello 微信好友!")
//     url:INHERIT_VALUE  image:INHERIT_VALUE  musicFileUrl:nil
//     extInfo:nil  fileData:nil
//     emoticonData:[NSData dataWithContentsOfFile:imagePath]];
//     
//     //定制微信朋友圈信息
//     [publishContent addWeixinTimelineUnitWithType:INHERIT_VALUE
//     content:INHERIT_VALUE
//     title:NSLocalizedString(@"TEXT_HELLO_WECHAT_TIMELINE", @"Hello 微信朋友圈!")
//     url:INHERIT_VALUE  image:INHERIT_VALUE
//     musicFileUrl:nil  extInfo:nil  fileData:nil
//     emoticonData:[NSData dataWithContentsOfFile:imagePath]];
//     */
//    
//    
//    //1+创建弹出菜单容器（iPad必要）
//    id<ISSContainer> container = [ShareSDK container];
//    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
//    //微信好友分享
//    id<ISSShareActionSheetItem> wxsItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeWeixiSession] icon:[ShareSDK getClientIconWithType:ShareTypeWeixiSession] clickHandler:^{
//        [ShareSDK clientShareContent:publishContent type:ShareTypeWeixiSession  statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//            if (state == SSPublishContentStateSuccess){
//                NSLog(NSLocalizedString(@"TEXt_SHARE_SUC", @"分享成功"));
//            }else if (state ==SSPublishContentStateFail){
//                NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
//            }
//        }];
//    }];
//    //QQ分享
//    id<ISSShareActionSheetItem> qqItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeQQ] icon:[ShareSDK getClientIconWithType:ShareTypeQQ] clickHandler:^{
//        [ShareSDK clientShareContent:publishContent type:ShareTypeQQ  statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//            if (state == SSPublishContentStateSuccess){
//                NSLog(NSLocalizedString(@"TEXt_SHARE_SUC", @"分享成功"));
//            }else if (state ==SSPublishContentStateFail){
//                NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
//            }
//        }];
//    }];
//    //    //新浪微博
//    //    id<ISSShareActionSheetItem> sinaItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo] icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo] clickHandler:^{
//    //        [ShareSDK clientShareContent:publishContent type:ShareTypeSinaWeibo  statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//    //            if (state == SSPublishContentStateSuccess){
//    //                NSLog(NSLocalizedString(@"TEXt_SHARE_SUC", @"分享成功"));
//    //            }else if (state ==SSPublishContentStateFail){
//    //                NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
//    //            }
//    //        }];
//    //    }];
//    //微信朋友圈分享
//    id<ISSShareActionSheetItem> wxtItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeWeixiTimeline] icon:[ShareSDK getClientIconWithType:ShareTypeWeixiTimeline] clickHandler:^{
//        [ShareSDK clientShareContent:publishContent type:ShareTypeWeixiTimeline  statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//            if (state == SSPublishContentStateSuccess){
//                NSLog(NSLocalizedString(@"TEXt_SHARE_SUC", @"分享成功"));
//            }else if (state ==SSPublishContentStateFail){
//                NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
//            }
//        }];
//    }];
//    
//    //创建自定义分享列表
//    NSArray *shareList = [ShareSDK customShareListWithType:wxsItem,wxtItem,qqItem,nil];
//    
//    //2、弹出分享菜单
//    [ShareSDK showShareActionSheet:container
//                         shareList:shareList  content:publishContent
//                     statusBarTips:YES    authOptions:nil
//                      shareOptions:nil
//                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end)
//     {
//         //可以根据回调提示用户。
//         if (state == SSResponseStateSuccess)
//         {
//             UIAlertView *alert = [[UIAlertView alloc]
//                                   initWithTitle:@"分享成功"
//                                   message:nil  delegate:self
//                                   cancelButtonTitle:@"OK"
//                                   otherButtonTitles:nil, nil];
//             [alert show];
//         }
//         else if (state == SSResponseStateFail)
//         {
//             UIAlertView *alert = [[UIAlertView alloc]
//                                   initWithTitle:@"分享失败"
//                                   message:[NSString stringWithFormat:@"失败描述：%@",[error errorDescription]]
//                                   delegate:self  cancelButtonTitle:@"OK"
//                                   otherButtonTitles:nil, nil];
//             [alert show];
//         }
//     }];
//}

#pragma mark -- SCROLLVIEW DELEGATE
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_ADScrollView]) {
        _currentPage = (int)scrollView.contentOffset.x/Main_Screen_Width+1;
        [self reloadPageControl];
    }
}

-(void)reloadPageControl
{
    _pageLabel.text = [NSString stringWithFormat:@"%i/%i",_currentPage,_numOfTotalPage];
}
-(void)setBannerViewInCell:(PBADBannerCellTableViewCell *)cell
{
    _ADScrollView = cell.ADSrollView;
    _numOfTotalPage = (int)[_spaceInfoDict[@"Data"][@"IntroPictures"] count];
    //获取空间图片信息
    _ADScrollView.contentSize = CGSizeMake(Main_Screen_Width*_numOfTotalPage, 0);
    [self reloadPageControl];
    NSMutableArray * urlArr = [NSMutableArray array];
    for (NSDictionary * spacePic in _spaceInfoDict[@"Data"][@"IntroPictures"]) {
        [urlArr addObject:spacePic[@"PicUrl"]];
    }
    
    if (_ADScrollView.subviews.count) {
        for (id temp in cell.ADSrollView.subviews) {
            [temp removeFromSuperview];
        }
    }
    
    for (int i=0; i<[_spaceInfoDict[@"Data"][@"IntroPictures"] count]; i++) {
        UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width*i, 0, Main_Screen_Width, cell.bounds.size.height)];
        [img sd_setImageWithURL:[NSURL URLWithString:urlArr[i]] placeholderImage:[UIImage imageNamed:Index_Recommond_Default_Image]];
        [_ADScrollView addSubview:img];
    }
}
#pragma mark -- TABLEVIEW DELEGATE
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        PBADBannerCellTableViewCell * bannerCell = [tableView dequeueReusableCellWithIdentifier:bannerCellIDKey];
        bannerCell.ADSrollView.delegate = self;
        bannerCell.pageControl.hidden = YES;
        if ([_spaceInfoDict[@"Data"][@"IntroPictures"] count]) {
            [self setBannerViewInCell:bannerCell];
        }
        return bannerCell;
    }else if (indexPath.row == 1) {
        PBSpaceTableAdressCell * Adresscell = [tableView dequeueReusableCellWithIdentifier:addressCell];
        Adresscell.spacenameLabel.text = _spaceInfoDict[@"Data"][@"Name"];
        //获取评分
        double score = [_spaceInfoDict[@"Data"][@"CommentScore"] doubleValue];
        TQStarRatingView *starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0, 0, 75, 14) numberOfStar:5 flag:0 doubleCount:score];
        starRatingView.userInteractionEnabled=NO;
        [Adresscell.scoreview addSubview:starRatingView];
        //空间介绍
        Adresscell.introLabel.text = _spaceInfoDict[@"Data"][@"Description"];
        if (!_hasIntroString) {
            Adresscell.pushToIntroPageButton.hidden = YES;
        }else{
            //推向空间介绍页面
            [Adresscell.pushToIntroPageButton addTarget:self action:@selector(pushToSpaceIntroducePage:) forControlEvents:UIControlEventTouchUpInside];
        }
        //空间地址
        [Adresscell.adressLabel setTextAlignment:NSTextAlignmentCenter];
        [Adresscell.adressLabel setTextAlignment:NSTextAlignmentLeft];
        Adresscell.adressLabel.text = _spaceInfoDict[@"Data"][@"Location"];
        //按钮触发本机自带地图
        [Adresscell.naviButton addTarget:self action:@selector(openLocalMapWithLongitudeandLatitude) forControlEvents:UIControlEventTouchDown];
        return Adresscell;
    }else if (indexPath.row >= 2 && indexPath.row < [_spaceInfoDict[@"Data"][@"SpaceCell"] count]+2){
        
        PBTableSpaceTypeCell * SpaceStyleCell = [_table dequeueReusableCellWithIdentifier:spaceStyleCell];
        //空间办公室类型
        NSDictionary * spaceCell =_spaceInfoDict[@"Data"][@"SpaceCell"][indexPath.row-2];
        if (indexPath.row>1&&indexPath.row<([_spaceInfoDict[@"Data"][@"SpaceCell"] count]+2)) {
            
            //类型图标
            [SpaceStyleCell.picImage setImage:[UIImage imageNamed:[[CommonUtil sharedInstance] imgUrlForSpaceType:[spaceCell[@"SpaceCellType"] intValue]]]];
            //类型名称
            SpaceStyleCell.styleLabel.text = [[CommonUtil sharedInstance]nameForSpaceType:[spaceCell[@"SpaceCellType"] intValue]];
            //单价
            SpaceStyleCell.priceLabel.text = [self checkSpacePriceWith:[spaceCell[@"MinPrice"] floatValue]];
            //总数量
            SpaceStyleCell.totalNumLabel.text = [NSString stringWithFormat:@"共%i间",[spaceCell[@"SpaceCellCount"] intValue]];
            //剩余数量
            if (spaceCell[@"SpaceCellRemainderNumber"] <= 0) {
                SpaceStyleCell.surplusLabel.text = @"全部售出";
            }else{
                SpaceStyleCell.surplusLabel.text = [NSString stringWithFormat:@"剩余%i间",[spaceCell[@"SpaceCellRemainderNumber"] intValue]];
            }
            //分割线控制
            if (indexPath.row != [_spaceInfoDict[@"Data"][@"SpaceCell"] count]) {
                SpaceStyleCell.doubleLine.hidden = YES;
            }else{
                SpaceStyleCell.singleLine.hidden = YES;
            }
        }
        return SpaceStyleCell;
    }else if(indexPath.row == [_spaceInfoDict[@"Data"][@"SpaceCell"] count]+2&&_hasFacility){
        SpaceTableFacilitiesCell * FacilitiesCell = [_table dequeueReusableCellWithIdentifier:facilitiesCell];
        NSArray *imageArr=[[NSArray alloc]initWithObjects:FacilitiesCell.pic_1,FacilitiesCell.pic_2,FacilitiesCell.pic_3,FacilitiesCell.pic_4, nil];
        NSArray *nameArr=[[NSArray alloc]initWithObjects: FacilitiesCell.name_1, FacilitiesCell.name_2, FacilitiesCell.name_3, FacilitiesCell.name_4, nil];
        
        int i=0;
        for ( NSDictionary * facility in _spaceInfoDict[@"Data"][@"Facilities"]) {
            
            [imageArr[i] sd_setImageWithURL:[NSURL URLWithString:facility[@"FacilitiesTypeImgUrl"]] placeholderImage:[UIImage imageNamed:Space_Hot_Default_Image]];
            ((UILabel *)nameArr[i]).text = facility[@"FacilitiesType"];
            i++;
            if (i>=4) {
                break;
            }
        }
        
        [FacilitiesCell.actionButton addTarget:self action:@selector(pushToFacilitiesPage:) forControlEvents:UIControlEventTouchDown];
        
        return FacilitiesCell;
    }else{
        CommentCell * commentCell = [_table dequeueReusableCellWithIdentifier:commentCellIdentifier];
        if ([_spaceInfoDict[@"Data"][@"Comment"] count] > 0) {
            NSDictionary * comment = _spaceInfoDict[@"Data"][@"Comment"][0];
            //用户头像
            [commentCell.pic sd_setImageWithURL:[NSURL URLWithString:comment[@"PhotoUrl"]] placeholderImage:[UIImage imageNamed:Space_Hot_Default_Image]];
            //评论日期
            NSString * date = [comment[@"CommentTime"] substringToIndex:10];
            commentCell.dateLabel.text = date;
            //评论内容
            commentCell.commentLabel.text = comment[@"Comment"];
            commentCell.commentLabel.numberOfLines = 3;
            //评分
            TQStarRatingView *starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0, 0, 75, 14) numberOfStar:5 flag:0 doubleCount:[comment[@"Score"] doubleValue]];
            starRatingView.userInteractionEnabled=NO;
            [commentCell.scoreView addSubview:starRatingView];
        }
        //触发评论页面
        [commentCell.ActionButton addTarget:self action:@selector(pushToCommentPage:) forControlEvents:UIControlEventTouchDown];
        commentCell.pic.layer.cornerRadius = 25;
        commentCell.pic.clipsToBounds = YES;//切割头像为圆形
        return commentCell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return ADVIEW_HEIGHT;
    }   //地址行
    else if (indexPath.row == 1) {
        PBSpaceTableAdressCell * Adresscell = [_table dequeueReusableCellWithIdentifier:addressCell];
        return Adresscell.bounds.size.height-(34*!_hasIntroString);//无介绍内容行高减少34像素
    }
    //空间分类行
    else if (indexPath.row >1 && indexPath.row < [_spaceInfoDict[@"Data"][@"SpaceCell"] count]+2){
        PBTableSpaceTypeCell * SpaceStyleCell = [_table dequeueReusableCellWithIdentifier:spaceStyleCell];
        return SpaceStyleCell.bounds.size.height;
    }
    //硬件设施行
    else if (indexPath.row == [_spaceInfoDict[@"Data"][@"SpaceCell"] count]+2&&_hasFacility){
        SpaceTableFacilitiesCell * FacilitiesCell = [_table dequeueReusableCellWithIdentifier:facilitiesCell];
        return FacilitiesCell.bounds.size.height;
    }
    //评论行
    else{
        CommentCell * commentCell = [_table dequeueReusableCellWithIdentifier:commentCellIdentifier];
        return commentCell.bounds.size.height;
    }

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3+[_spaceInfoDict[@"Data"][@"SpaceCell"] count]+_hasFacility;
}
#pragma mark -- REQUEST PART
-(void)dealDataWithResponse:(NSDictionary *)dict
{
    //拿到数据
   // _spaceInfo = response.Data;
    //空间介绍页面传值
    [JCYGlobalData sharedInstance].spaceDetailInfo = dict;
    //在线预订按钮和立即预约按钮的控制
    if (![dict[@"IsLinckia"] boolValue]) {
        //非linckia空间在线订位功能灰掉
        [self hiddenShoppingOnlineButton];
    }else{
        //未提供可租用类型 在线预订按钮隐藏
        if (![dict[@"SpaceCell"] count]) {
            [self hiddenShoppingOnlineButton];
        }else{
            //判断剩余数量
            for (NSDictionary * cell in dict[@"SpaceCell"]) {
                if ([cell[@"SpaceCellRemainderNumber"] intValue]) {
                    _hasValidSpace = YES;
                }
            }
        }
    }
    if (!_hasValidSpace) {
        _shoppingActioButton.backgroundColor = [UIColor lightGrayColor];
        _shoppingActioButton.userInteractionEnabled = NO;
    }
    //判断是否提供硬件设施，是则加载cell,否责不加载
    if ([dict[@"Facilities"] count]) {
        _hasFacility = YES;
    }else{
        _hasFacility = NO;
    }
    //判断是否有空间介绍
    if ([dict[@"Description"] isEqualToString:@""]) {
        _hasIntroString = NO;
    }else{
        _hasIntroString = YES;
    }
    //处理完数据刷新表格
    [self.table reloadData];
}
-(void)hiddenShoppingOnlineButton
{
    _shoppingActioButton.hidden = YES;
    _bookingActionButton.frame = CGRectMake(_bookingActionButton.bounds.origin.x, _bookingActionButton.bounds.origin.y, Main_Screen_Width-30, _bookingActionButton.bounds.size.height);
    
    _bookingActionButton.hidden = YES;
    
    UIButton * bookingButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 15, Main_Screen_Width-30, _footView.bounds.size.height-30)];
    bookingButton.backgroundColor = _bookingActionButton.backgroundColor;
    bookingButton.layer.cornerRadius = 5;
    bookingButton.clipsToBounds = YES;
    [bookingButton setTitle:@"立即预约" forState:UIControlStateNormal];
    [bookingButton addTarget:self action:@selector(pushToBookingPage:) forControlEvents:UIControlEventTouchDown];
    [_footView addSubview:bookingButton];
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
