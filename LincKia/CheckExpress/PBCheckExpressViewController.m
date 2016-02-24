//
//  PBCheckExpressViewController.m
//  LincKia
//
//  Created by Phoebe on 16/2/24.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "PBCheckExpressViewController.h"

@interface PBCheckExpressViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *expressCheckView;

@end

@implementation PBCheckExpressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationController * navi = (UINavigationController *)self.navigationController;
    navi.tabBarController.tabBar.hidden = YES;
    
    
    //加载页面
    NSString * urlString = [NSString stringWithFormat:@"http://m.kuaidi100.com/index_all.html"];
    //NSString * urlString = [NSString stringWithFormat:@"http://www.kuaidi100.com/"];
    NSURL * url = [[NSURL alloc]initWithString:urlString];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.expressCheckView loadRequest:request];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(UIBarButtonItem *)sender {
    
    if ([self.expressCheckView canGoBack]) {
        [self.expressCheckView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - webview delegate

-(void)webViewDidFinishLoad:(UIWebView *)webView{
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
