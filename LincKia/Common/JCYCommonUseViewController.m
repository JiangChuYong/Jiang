//
//  JCYCommonUseViewController.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/7.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "JCYCommonUseViewController.h"
#import "OtherTableViewCell.h"
@interface JCYCommonUseViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * dataSource;

@end

@implementation JCYCommonUseViewController
static NSString * cellKey = @"otherTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDictionary * data = [JCYGlobalData sharedInstance].commonViewData;
   // _titleLab.text = [data valueForKey:@"title"];
    self.title=[data valueForKey:@"title"];
    self.automaticallyAdjustsScrollViewInsets = false;
    _dataSource = [data valueForKey:@"data"];
    [_tableView registerNib:[UINib nibWithNibName:@"OtherTableViewCell" bundle:nil] forCellReuseIdentifier:cellKey];
    [_tableView reloadData];

}
- (IBAction)backButtonPressed:(id )sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UINavigationController *navi=(UINavigationController *)self.parentViewController;
    navi.tabBarController.tabBar.hidden=YES;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OtherTableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:cellKey];
    cell.labelSetInfo.text = _dataSource[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView registerNib:[UINib nibWithNibName:@"OtherTableViewCell" bundle:nil] forCellReuseIdentifier:cellKey];
    OtherTableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:cellKey];
    return cell.frame.size.height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {

        
        [self performSegueWithIdentifier:@"CommonToCustomerCenter" sender:self];
        
    }
    else if (indexPath.row == 1) {

        [self performSegueWithIdentifier:@"CommonToFeedback" sender:self];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
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
