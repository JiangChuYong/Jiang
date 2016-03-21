//
//  JCYModifiedPhoneNumberViewController.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/14.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "JCYModifiedPhoneNumberViewController.h"

@interface JCYModifiedPhoneNumberViewController ()
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation JCYModifiedPhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)goBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)sendMessageButtonPressed:(UIButton *)sender {
//    [ZZGlobalModel sharedInstance].isMotifyViaMessage = YES;
//    PBChangedPhoneNumViewController * VC = [[PBChangedPhoneNumViewController alloc]init];
//    [self.navigationController pushViewController:VC animated:YES];
    //[JCYGlobalData sharedInstance].isMotifyViaMessage=YES;
    [self performSegueWithIdentifier:@"ModifyPhoneNumOfMessage" sender:self];
    
}
- (IBAction)loginButtonPressed:(UIButton *)sender {
//    [ZZGlobalModel sharedInstance].isMotifyViaMessage = NO;
//    PBModifyPhoneNumViaPasswordViewController * VC = [[PBModifyPhoneNumViaPasswordViewController alloc]init];
//    [self.navigationController pushViewController:VC animated:YES];
    
    [self performSegueWithIdentifier:@"ModifyPhoneNumOfLogin" sender:self];
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
