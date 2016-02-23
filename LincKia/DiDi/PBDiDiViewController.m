//
//  PBDiDiViewController.m
//  LincKia
//
//  Created by Phoebe on 16/2/23.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "PBDiDiViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface PBDiDiViewController () <UIWebViewDelegate,CLLocationManagerDelegate>


@end

@implementation PBDiDiViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UINavigationController * navi = [[UINavigationController alloc]init];
    navi.tabBarController.tabBar.hidden = YES;
    NSLog(@"**********************************");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
