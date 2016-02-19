//
//  PBCompanyDetailViewController.m
//  LincKia
//
//  Created by 董玲 on 11/17/15.
//  Copyright © 2015 ZZ. All rights reserved.
//

#import "PBCompanyDetailViewController.h"
//#import "LinckiaPartnerInfo.h"
//#import "ResponseDataOfLinckiaPartnerInfo.h"
//#import "CompanyContacts.h"

@interface PBCompanyDetailViewController ()

//@property (nonatomic,strong) ResponseDataOfLinckiaPartnerInfo * partnerInfo;

@property (weak, nonatomic) IBOutlet UIPageControl *pagecontrol;
@property (weak, nonatomic) IBOutlet UIScrollView *bannerScrollView;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UITextView *companyDescribe;
@property (weak, nonatomic) IBOutlet UILabel *contratPersonName;
@property (weak, nonatomic) IBOutlet UILabel *contratPhoneNum;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (strong, nonatomic) NSDictionary *responseDataOfIndexDict;

@end

@implementation PBCompanyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backButtonPressed:(UIButton *)sender {
    [self dismissModalViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{

    START_OBSERVE_CONNECTION
    AFRquest * af = [AFRquest sharedInstance];
    af.subURLString = @"api/LinckiaPartner/GetLinckiaPartnerInfo?userToken""&deviceType=ios";
    af.parameters = @{@"linckiaPartnerId":[JCYGlobalData sharedInstance].companyID};
    af.requestFlag = GetLinckiaPartnerInfo;
    af.style = GET;
    [af requestDataFromServer];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dataReceived:(NSNotification *)notif{
    
    _responseDataOfIndexDict = [notif object];
    if ([AFRquest sharedInstance].requestFlag == GetLinckiaPartnerInfo) {
        NSLog(@"flag == %i",[AFRquest sharedInstance].requestFlag);
        NSLog(@"33333%@",_responseDataOfIndexDict);
        
        
        [self dealWithPartnerInfo:_responseDataOfIndexDict[@"Data"]];
        
    }
    
}




#pragma -- mark SCROLLVIEW DELEGATE
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pagecontrol.currentPage = scrollView.contentOffset.x/Main_Screen_Width;
}



///** *获取数据开始*/
//-(void)gainDataStart:(int)tag{
//    [[AlertUtils sharedInstance]showWithText:LOAD_Start_TEXT inView:self.view];
//}
////获取数据成功
//-(void)gainDataSuccess:(int)tag responseObj:(id)responseObj{
//    LinckiaPartnerInfo * response = [responseObj jsonToModel:LinckiaPartnerInfo.class];
//    if (response.Code == SERVER_SUCCESS) {
//        [self dealWithPartnerInfo:response.Data];
//    }
//    [[AlertUtils sharedInstance]stopHUD];
//}
//-(void)gainDataFailed:(int)tag errorInfo:(NSString *)errorInfo{
//    [[AlertUtils sharedInstance]stopHUD];
//    [[AlertUtils sharedInstance] showWithText:errorInfo inView:self.view lastTime:2.0];
//}
-(void)dealWithPartnerInfo:(NSDictionary *)info
{
    //公司名
    _companyLabel.text = info[@"companyName"];
    //公司介绍
    _companyDescribe.text = info[@"detailDescript"];
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGSize fontSize = [info[@"detailDescript"] sizeWithAttributes:attributes];
    //_companyDescribe.frame.size.height = fontSize.height;
    //_companyDescribe.bounds.size.height=fontSize.height;
    CGRect frame=_companyDescribe.frame;
    frame.size.height=fontSize.height;
    _companyDescribe.frame=frame;


    // 联系方式
    NSMutableArray * contacts = info[@"contactsList"];
    if (contacts.count <= 0) {
        
    }else{
        NSDictionary * contactDetail = contacts[0];
        _contratPersonName.text = [NSString stringWithFormat:@"联系人：%@",contactDetail[@"contactsName"]];
        [_phoneButton setTitle:contactDetail[@"contactsTel"] forState:UIControlStateNormal];
    }

    //banner图片与页面控制
    NSMutableArray * picListArr = info[@"picList"];
    if (picListArr <= 0) {
        
    }else{
        _pagecontrol.numberOfPages = picListArr.count;
        _pagecontrol.currentPage = 0;
        [_bannerScrollView setContentSize:CGSizeMake(Main_Screen_Width*picListArr.count, 130)];
        for (int i=0; i<picListArr.count; i++) {
            UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(i*Main_Screen_Width, 0, Main_Screen_Width, 148)];
            [image sd_setImageWithURL:[NSURL URLWithString:picListArr[i]] placeholderImage:[UIImage imageNamed:Index_Recommond_Default_Image]];
            [_bannerScrollView addSubview:image];
        }
    }
 
}
- (IBAction)phoneButtonPressed:(UIButton *)sender {
    
    NSMutableString *phoneNum=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",sender.titleLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNum]];
    NSLog(@"%@",phoneNum);
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
