//
//  JCYStorePaymentOrderViewController.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/31.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "JCYStorePaymentOrderViewController.h"

@interface JCYStorePaymentOrderViewController ()
@property (strong, nonatomic) IBOutlet UILabel *phoneNumLabel;

@end

@implementation JCYStorePaymentOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _phoneNumLabel.text=[JCYGlobalData sharedInstance].userInfo[@"Mobile"];

}
- (IBAction)goBack:(UIBarButtonItem *)sender {
    
    UINavigationController *navi=(UINavigationController *)self.parentViewController;
    [navi popToRootViewControllerAnimated:NO];
    
    if (navi.tabBarController.selectedIndex!=0) {
        navi.tabBarController.selectedIndex=0;
        //动画
        CATransition *animation =[CATransition animation];
        [animation setDuration:0.3f];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromLeft];
        [navi.tabBarController.view.layer addAnimation:animation forKey:@"reveal"];
    }
}

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
