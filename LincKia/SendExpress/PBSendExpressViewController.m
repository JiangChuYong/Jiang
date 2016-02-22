//
//  PBSendExpressViewController.m
//  LincKia
//
//  Created by Phoebe on 16/2/22.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "PBSendExpressViewController.h"
#import "ExpressTableViewCell.h"

@interface PBSendExpressViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backItem;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong,nonatomic) NSArray * expressData;
@end

@implementation PBSendExpressViewController

static NSString * CellIDKey = @"PBSendExpressViewController";

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UINavigationController * navi = (UINavigationController *)self.parentViewController;
    navi.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _backItem.target = self;
    _backItem.action = @selector(back:);
    [self creatExpressDataSources];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)creatExpressDataSources
{
    _expressData = [NSMutableArray arrayWithObjects:
                   @[@"顺丰速运",@"95338"],
                   @[@"申通快递",@"400-889-5543"],
                   @[@"圆通速递",@"021-69777888"],
                   @[@"中通快递",@"95311"],
                   @[@"韵达快递",@"95546"],
                   @[@"宅急送",@"400-678-9000"],
                   @[@"天天快递",@"400-188-8888"], nil];
    [_table reloadData];
}
#pragma -- mark TABLEVIEW DELEGATE
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _expressData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ExpressTableViewCell * cell = [_table dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.name.text = _expressData[indexPath.row][0];
    cell.leftIcon.image = [UIImage imageNamed:_expressData[indexPath.row][0]];
    cell.phoneNum.text = _expressData[indexPath.row][1];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * phoneNum = _expressData[indexPath.row][1];
    NSString * callPhoneNum = [NSString stringWithFormat:@"telprompt://%@",phoneNum];
    NSLog(@"正在拨打：%@",phoneNum);
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:callPhoneNum]];
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
