//
//  PBDiDiViewController.m
//  LincKia
//
//  Created by Phoebe on 16/2/23.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "PBDiDiViewController.h"

@interface PBDiDiViewController () 

@property (strong,nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIWebView *DiDiWebView;


@end

@implementation PBDiDiViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UINavigationController * navi = (UINavigationController *)self.parentViewController;
    navi.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[PBAlert sharedInstance]showProgressDialogText:@"加载中..." inView:self.view];
    //开始定位
    _locationManager=[[CLLocationManager alloc] init];
    _locationManager.delegate=self;
    _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    _locationManager.distanceFilter=10;
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=8) {
        [_locationManager requestWhenInUseAuthorization];
    }
    [_locationManager startUpdatingLocation];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(UIBarButtonItem *)sender {
    
    if ([self.DiDiWebView canGoBack]) {
        [self.DiDiWebView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - Location

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation * location = [locations firstObject];
    NSString * stringLat = [NSString stringWithFormat:@"%.14f",location.coordinate.latitude];
    NSString * stringLng = [NSString stringWithFormat:@"%.14f",location.coordinate.longitude];
    //加载页面
    NSString * urlString = [NSString stringWithFormat:@"http://webapp.diditaxi.com.cn/?maptype=wgs&lat=%@&lng=%@&channel=1363",stringLat,stringLng];
    NSLog(@"%@",urlString);
    NSURL * url = [[NSURL alloc]initWithString:urlString];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.DiDiWebView loadRequest:request];
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error {
    NSString *errorString;
    [manager stopUpdatingLocation];
    if ([error localizedDescription]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请前往设置－隐私－定位服务中开启LincKia定位服务" message:errorString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}
#pragma mark - webview delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[PBAlert sharedInstance]stopHud];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[PBAlert sharedInstance]stopHud];
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
