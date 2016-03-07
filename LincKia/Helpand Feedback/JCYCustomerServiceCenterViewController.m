//
//  JCYCustomerServiceCenterViewController.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/7.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "JCYCustomerServiceCenterViewController.h"
#import "JCYCustomerServiceCenterTableViewCell.h"

@interface JCYCustomerServiceCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property (strong,nonatomic) NSMutableArray *titleArr;
@property (strong,nonatomic) NSMutableArray *subTitleArr;

@end

@implementation JCYCustomerServiceCenterViewController
static NSString * customerServiceCenterCell = @"JCYCustomerServiceCenterTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArr=[[NSMutableArray alloc]initWithObjects:@"会员账户",@"海星币",@"咖啡客",@"预约参观", nil];
    _subTitleArr=[[NSMutableArray alloc]initWithObjects:@"会员注册，找回密码",@"充值，退款",@"线上预订，线上支付",@"线上预约，取消预约，更爱时间", nil];

    // Do any additional setup after loading the view.
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    
    return 44;
}


- (IBAction)backButtonPress:(id )sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_listTableView registerNib:[UINib nibWithNibName:@"JCYCustomerServiceCenterTableViewCell" bundle:nil] forCellReuseIdentifier:customerServiceCenterCell];
    JCYCustomerServiceCenterTableViewCell * cell = [_listTableView dequeueReusableCellWithIdentifier:customerServiceCenterCell];
    cell.titleLable.text=[_titleArr objectAtIndex:indexPath.row];
    cell.subTitleLable.text=[_subTitleArr objectAtIndex:indexPath.row];
    
    return cell;
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
