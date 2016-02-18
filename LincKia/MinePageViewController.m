//
//  MinePageViewController.m
//  LincKia
//
//  Created by Phoebe on 16/2/15.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "MinePageViewController.h"

@interface MinePageViewController ()

@end

@implementation MinePageViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self cheakLoginStatus];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma -- mark CHEAK USER INFO
-(BOOL)cheakLoginStatus{
    
    
    [self performSegueWithIdentifier:@"MineToLogin" sender:self];
    
//    NSUserDefaults * userInfo = [NSUserDefaults standardUserDefaults];
//    NSString * userName = [userInfo valueForKey:USERNAME];
//    NSString * passWord = [userInfo valueForKey:PASSWORD];
//    if (!userName||!passWord) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alert show];
//    }
//    
//    
    
    
    return 0;
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
