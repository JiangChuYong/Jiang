//
//  PBEnvironmentViewController.m
//  LincKia
//
//  Created by Phoebe on 16/2/22.
//  Copyright © 2016年 Phoebe. All rights reserved.
//


//空气质量类型
typedef enum{
    PM = 0,
    EPA = 1,
    MEP = 2
}AQType;


#import "PBEnvironmentViewController.h"

@interface PBEnvironmentViewController ()

//选项按钮
@property (weak, nonatomic) IBOutlet UIButton *PMBtn;
@property (weak, nonatomic) IBOutlet UIButton *EPABtn;
@property (weak, nonatomic) IBOutlet UIButton *MEPBtn;
//室内标签
@property (weak, nonatomic) IBOutlet UILabel *AQNumLab;
@property (weak, nonatomic) IBOutlet UILabel *levelLab;
@property (weak, nonatomic) IBOutlet UILabel *inroomunitLab;
//室外标签
@property (weak, nonatomic) IBOutlet UILabel *outdoorAQNumLab;
@property (weak, nonatomic) IBOutlet UILabel *outdoorAQLevelLab;
@property (weak, nonatomic) IBOutlet UILabel *outdoorUpdateTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *outdoorunitLab;
@property (weak, nonatomic) IBOutlet UILabel *aqioutdoorLab;
@property (weak, nonatomic) IBOutlet UILabel *aqiinroomLab;
//刷新按钮
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;

@property (assign, nonatomic) int currentaAQType;

@property (nonatomic,strong) NSMutableDictionary * PMDataDic;
@property (nonatomic,strong) NSMutableDictionary * EPADataDic;
@property (nonatomic,strong) NSMutableDictionary * MEPDataDic;
//数据请求链接
@property (nonatomic,strong) NSURLConnection * loginconnet;
@property (nonatomic,strong) NSURLConnection * deviceconnet;
//定时器
@property(nonatomic,strong)NSTimer *currentTimer;

@end

@implementation PBEnvironmentViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UINavigationController * navi = (UINavigationController *)self.parentViewController;
    navi.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _currentaAQType = PM;
    [self interfaceOptimization];
    [self setButtonUIAndDisplayLabForChanging];
    
    dispatch_queue_t highLevelQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(highLevelQueue, ^{
        [self AQTypeBtnPressed:_PMBtn];
    }); 
    
}

#pragma -- mark  按钮的响应事件
- (IBAction)AQTypeBtnPressed:(UIButton *)sender {
    if ([sender isEqual:self.PMBtn]) {
        _currentaAQType = PM;
    }else if ([sender isEqual:self.EPABtn]){
        _currentaAQType = EPA;
    }else if ([sender isEqual:self.MEPBtn]){
        _currentaAQType = MEP;
    }else{
        [self setRefreshBtnRotate];
    }
    [self setButtonUIAndDisplayLabForChanging];
    [self requestAQDataDicFromSever:_currentaAQType];
}
- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 刷新按钮
-(void)setRefreshBtnRotate{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0*M_PI];
    animation.toValue = [NSNumber numberWithFloat:1.0*M_PI];
    animation.duration = 1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.cumulative = YES;
    animation.removedOnCompletion = NO; //No Remove
    animation.repeatCount = 3;
    [self.refreshBtn.layer addAnimation:animation forKey:@"AnimatedKey"];
    self.refreshBtn.layer.speed = 3.0;
    self.refreshBtn.layer.beginTime = 0.0;
}

#pragma -- mark UI PART
-(void)interfaceOptimization
{
    [self labelOptimization:self.levelLab];
    [self labelOptimization:self.outdoorAQLevelLab];
    [self buttonOptimization:self.PMBtn];
    [self buttonOptimization:self.EPABtn];
    [self buttonOptimization:self.MEPBtn];
}
-(void)labelOptimization:(UILabel *)label
{
    label.layer.cornerRadius = 4;
    label.clipsToBounds = YES;
}
-(void)buttonOptimization:(UIButton *)button
{
    button.layer.borderWidth = 1;
    button.layer.borderColor = CommonBackgroundColor_gray.CGColor;
}

//每次按钮按下变换对应的位置 并 提亮选中按钮的颜色
-(void)setButtonUIAndDisplayLabForChanging{
    
    switch (_currentaAQType) {
        case PM:{
            _PMBtn.layer.borderWidth = 0;
            _EPABtn.layer.borderWidth = 1;
            _MEPBtn.layer.borderWidth = 1;
            _AQNumLab.hidden = NO;
            _inroomunitLab.hidden = NO;
            _aqiinroomLab.hidden = YES;
            _outdoorAQNumLab.hidden = NO;
            _outdoorunitLab.hidden = NO;
            _aqioutdoorLab.hidden = YES;
        }
            break;
            
        case EPA:{
            _PMBtn.layer.borderWidth = 1;
            _EPABtn.layer.borderWidth = 0;
            _MEPBtn.layer.borderWidth = 1;
            _AQNumLab.hidden = YES;
            _inroomunitLab.hidden = YES;
            _aqiinroomLab.hidden = NO;
            _outdoorAQNumLab.hidden = YES;
            _outdoorunitLab.hidden = YES;
            _aqioutdoorLab.hidden = NO;
        }
            break;
            
        case MEP:{
            _PMBtn.layer.borderWidth = 1;
            _EPABtn.layer.borderWidth = 1;
            _MEPBtn.layer.borderWidth = 0;
            _AQNumLab.hidden = YES;
            _inroomunitLab.hidden = YES;
            _aqiinroomLab.hidden = NO;
            _outdoorAQNumLab.hidden = YES;
            _outdoorunitLab.hidden = YES;
            _aqioutdoorLab.hidden = NO;
        }
            break;
            
        default:
            break;
    }
}
#pragma -- mark 数据请求
//请求数据
-(void)requestAQDataDicFromSever:(int)cunrrentAQType
{
    NSString * networkingStr = [CommonUtil networkingStatesFromStatebar];
    if ([networkingStr isEqualToString:@"no net"]) {
        [[PBAlert sharedInstance]showText:@"请检查您的网络" inView:self.view withTime:2.0 ];
        return;
    }else{
        [self getDeviceAQDateWithMyDeviceID:nil];
        [self getOutDoorAQIByCityStation];
    }
}
-(void)getOutDoorAQIByCityStation
{
    NSError * error;
    NSURL * URL = [NSURL URLWithString:@"http://api.gam-systems.com.cn/v1/outdoor_aqis/shanghai/latest/"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [self setAllValuesForHTTPHeaderFieldOf:request];
    NSData *receiveData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (!receiveData) {
        return;
    }
    NSDictionary * recievedDict = [NSJSONSerialization JSONObjectWithData:receiveData options:0 error:&error];
    NSLog(@"%@",recievedDict);
    [self resetOutdoorInterfaceWith:recievedDict];
}

-(void)resetOutdoorInterfaceWith:(NSDictionary *)dictionary
{
    int value = 0;
    switch (_currentaAQType) {
        case PM:
            value = [[dictionary valueForKey:@"pm25"] intValue];
            break;
        case EPA:
            value = [[dictionary valueForKey:@"pm25_epa"] intValue];
            break;
        case MEP:
            value = [[dictionary valueForKey:@"pm25_mep"] intValue];
            break;
        default:
            value = 0;
            break;
    }
    
    if (_currentaAQType == PM) {
        _outdoorAQNumLab.text = [NSString stringWithFormat:@"%i",value];
    }else{
        _aqioutdoorLab.text = [NSString stringWithFormat:@"%i",value];
    }
    [self setAQLevelAndHealthyLabelColorWithPM:value andLabel:_outdoorAQLevelLab];
    NSMutableString * updateTimeText = [NSMutableString stringWithString:@"更新时间："];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    [updateTimeText appendString:currentDateStr];
    _outdoorUpdateTimeLab.text = updateTimeText;
    
}
-(void)resetInRoomInterfaceWith:(NSDictionary *)dictionary
{
    NSLog(@"%@",dictionary);
    NSMutableDictionary * dataDict = [dictionary valueForKey:@"last_normal"];
    int value = 0;
    switch (_currentaAQType) {
        case PM:
            value = [[dataDict valueForKey:@"pm25"] intValue];
            break;
        case EPA:
            value = [[dataDict valueForKey:@"epa_aqi"] intValue];
            break;
        case MEP:
            value = [[dataDict valueForKey:@"mep_aqi"] intValue];
            break;
        default:
            value = 0;
            break;
    }
    NSMutableString * valuestring = [NSMutableString stringWithFormat:@"%i",value];
    if (_currentaAQType == PM) {
        _AQNumLab.text = valuestring;
    }else{
        _aqiinroomLab.text = valuestring;
    }
    [self setAQLevelAndHealthyLabelColorWithPM:value andLabel:_levelLab];
    NSMutableString * updateTimeText = [NSMutableString stringWithString:@"更新时间："];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    [updateTimeText appendString:currentDateStr];
}
-(void)setAQLevelAndHealthyLabelColorWithPM:(int)value andLabel:(UILabel *)label
{
    if (_currentaAQType == EPA||_currentaAQType == MEP) {
        if (value>=0&&value<=50) {
            label.text = @"优质";
            [label setBackgroundColor:ExcellentColor];
        }else if (value>50&&value<=100){
            label.text = @"良好";
            [label setBackgroundColor:GoodColor];
        }else if (value>100&&value<=150){
            label.text = @"轻度污染";
            [label setBackgroundColor:MildConcentrationColor];
        }else if (value>150&&value<=200){
            label.text = @"中度污染";
            [label setBackgroundColor:MiddleLevelPollutionColor];
        }else{
            label.text = @"污染严重";
            [label setBackgroundColor:SevereContaminationColor];
        }
    }else if(_currentaAQType == PM){
        if (value>=0&&value<=35) {
            label.text = @"优质";
            [label setBackgroundColor:ExcellentColor];
        }else if (value>35&&value<=75){
            label.text = @"良好";
            [label setBackgroundColor:GoodColor];
        }else if (value>75&&value<=115){
            label.text = @"轻度污染";
            [label setBackgroundColor:MildConcentrationColor];
        }else if (value>115&&value<=150){
            label.text = @"中度污染";
            [label setBackgroundColor:MiddleLevelPollutionColor];
        }else{
            label.text = @"污染严重";
            [label setBackgroundColor:SevereContaminationColor];
        }
    }
}

-(void)setAllValuesForHTTPHeaderFieldOf: (NSMutableURLRequest*)request
{
    [request setValue:@"Bearer YzgwZTE3YjItYzEyMy00Y2ZiLTk1MDEtOGJlNzIwNGM5ZGI3" forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
}

//获取设备所在室内空气质量数据
-(void)getDeviceAQDateWithMyDeviceID:(NSString *)IDString
{
    NSArray * idarray = [NSArray arrayWithObject:@"2e9c62b4-1969-11e5-af54-e4956e400b57"];
    NSURL *URL= [[NSURL alloc]initWithString:@"http://api.gam-systems.com.cn/v1/aqis/latest"];
    NSError * error;
    NSData * data = [NSJSONSerialization dataWithJSONObject:idarray options:0 error:&error];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [self setAllValuesForHTTPHeaderFieldOf:request];
    request.HTTPBody = data;
    self.deviceconnet = [NSURLConnection connectionWithRequest:request delegate:self];
    if (self.deviceconnet) {
        return;
    }
}


#pragma mark - connection dalegate methods
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSError *error;
    NSMutableArray * recievedArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if ([connection isEqual:_deviceconnet]) {
        NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
        dictionary = recievedArray[0];
        [self resetInRoomInterfaceWith:dictionary];
    }
    //暂时不用
    //    if ([connection isEqual:_loginconnet]) {
    //        NSString * myCode = [recieveDict valueForKey:@"code"];
    //        [self getMyDeviceIDNumWith:myCode];
    //    }
}



/************************************暂时不用*************************************/

//获取设备id
//-(void)getMyDeviceIDNumWith:(NSString *)myCode
//{
//    NSError * error;
//    NSString * urlStr = [NSString stringWithFormat:@"http://api.gam-systems.com.cn/v1/devices?code=%@",myCode];
//    NSURL * URL = [NSURL URLWithString:urlStr];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//    [self setAllValuesForHTTPHeaderFieldOf:request];
//    NSData *receiveData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSDictionary * recievedDict = [NSJSONSerialization JSONObjectWithData:receiveData options:0 error:&error];
//    NSString * idstring = [recievedDict valueForKey:@"id"];
//    [self getDeviceAQDateWithMyDeviceID:idstring];
//}
//登陆空气质量检测服务器
//-(void)loginDeviceServer
//{
//    NSMutableDictionary *parameterDic = [NSMutableDictionary dictionary];
//    [parameterDic setObject:@"linckia" forKey:@"name"];
//    [parameterDic setObject:@"bUF7KzC" forKey:@"password"];
//    NSURL *URL= [[NSURL alloc]initWithString:@"http://api.gam-systems.com.cn/v1/account_auth"];
//    NSError * error;
//    NSData * data = [NSJSONSerialization dataWithJSONObject:parameterDic options:0 error:&error];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
//    [request setHTTPMethod:@"POST"];
//    [self setAllValuesForHTTPHeaderFieldOf:request];
//    request.HTTPBody = data;
//    self.loginconnet = [NSURLConnection connectionWithRequest:request delegate:self];
//    if (self.loginconnet != nil) {
//        return;
//    }
//}
/************************************暂时不用*************************************/

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
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
