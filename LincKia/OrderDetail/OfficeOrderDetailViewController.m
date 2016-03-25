//
//  OfficeOrderDetailViewController.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/25.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "OfficeOrderDetailViewController.h"
#import "ZZMyOderDetailTableViewCell.h"

@interface OfficeOrderDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *spaceNameLabel;
@property (strong, nonatomic) UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (weak, nonatomic) IBOutlet UILabel *paidAlreadyLabel;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) AFRquest *OrdersGetOne;
@end

@implementation OfficeOrderDetailViewController
static NSString *orderDetailTableViewCellIdentifier=@"zZMyOderDetailTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = false;

    _dataArr=[NSMutableArray array];
    [self requestFromServer];
}

//从服务器请求数据 空间搜索列表
-(void)requestFromServer
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataReceived:) name:[NSString stringWithFormat:@"%i",OrdersGetOne] object:nil];
    
    NSUserDefaults * userInfo = [NSUserDefaults standardUserDefaults];
    NSString * userToken = [userInfo valueForKey:USERTOKEN];
    
    _OrdersGetOne = [[AFRquest alloc]init];
    
    _OrdersGetOne.subURLString =[NSString stringWithFormat:@"api/Orders/GetOne?userToken=%@&deviceType=ios",userToken];
    
    _OrdersGetOne.parameters = @{@"orderID":[JCYGlobalData sharedInstance].orderId};
    
    _OrdersGetOne.style = GET;
    
    [_OrdersGetOne requestDataFromWithFlag:OrdersGetOne];
    
}

-(void)dataReceived:(NSNotification *)notif{
    int result = [_OrdersGetOne.resultDict[@"Code"] intValue];
    if (result == SUCCESS) {
        NSLog(@"办公室");
        
        [self dealResposeResult_OrderDtail:_OrdersGetOne.resultDict[@"Data"]];
    }else{
        [[PBAlert sharedInstance] showText:_OrdersGetOne.resultDict[@"Description"] inView:self.view withTime:2.0];
    }
    
    NSLog(@"%@",_OrdersGetOne.resultDict);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",OrdersGetOne] object:nil];
}







#pragma --表格代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.detailTableView registerNib:[UINib nibWithNibName:@"ZZMyOderDetailTableViewCell" bundle:nil] forCellReuseIdentifier:orderDetailTableViewCellIdentifier];
    ZZMyOderDetailTableViewCell * cell = (ZZMyOderDetailTableViewCell *)[self.detailTableView dequeueReusableCellWithIdentifier:orderDetailTableViewCellIdentifier];
    return cell.frame.size.height;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.detailTableView registerNib:[UINib nibWithNibName:@"ZZMyOderDetailTableViewCell" bundle:nil] forCellReuseIdentifier:orderDetailTableViewCellIdentifier];
    ZZMyOderDetailTableViewCell * cell = (ZZMyOderDetailTableViewCell *)[self.detailTableView dequeueReusableCellWithIdentifier:orderDetailTableViewCellIdentifier];
    
    NSDictionary * orderDetailDic = _dataArr[indexPath.row];
    
    cell.startTimeLab.text = [orderDetailDic[@"StartDate"] substringToIndex:10];
    cell.endTimeLab.text = [orderDetailDic[@"EndDate"] substringToIndex:10];
    cell.cellNumLab.text = [[NSString alloc]initWithFormat:@"%i",[orderDetailDic[@"SpaceCell"][@"CellNum"] intValue]];
    
    NSDictionary * spaceCellPriceDic = orderDetailDic[@"SpaceCell"][@"CellPrice"][0];
    NSString * amount = @"¥";
    NSString * cellPriceStr = [[NSString alloc]initWithFormat:@"%.0f",[spaceCellPriceDic[@"Amount"] floatValue]];
    cell.cellPriceLab.text = [amount stringByAppendingString:cellPriceStr];
    cell.spaceCellTypeLab.text = [[CommonUtil sharedInstance]nameForSpaceType:[spaceCellPriceDic[@"SpaceCellType"] intValue]];
    //cellcode单元编号
    cell.cellCodeLab.text = orderDetailDic[@"SpaceCell"][@"CellCode"];
    return cell;
}
#pragma --私有方法
- (IBAction)backButtonPressed:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//处理空间单元返回后的结果
-(void)dealResposeResult_OrderDtail:(NSDictionary *)response{
    
    _dataArr = response[@"OrderDetailInfo"];
    [self UISetting:response];
    [self.detailTableView reloadData];
}

-(void)UISetting:(NSDictionary *)orderInfo
{
    //实付金额
    [self.paidAlreadyLabel setText:[NSString stringWithFormat:@"¥%.0f",[orderInfo[@"Amount"] floatValue]]];
    //支付状态
    self.paymentStatusLabel.text = [[CommonUtil sharedInstance]nameForOrderStatus:[orderInfo[@"Status"] intValue]];
    //订单总额
    self.amountLabel.text = [NSString stringWithFormat:@"¥%.0f",[orderInfo[@"Amount"] floatValue]+[orderInfo[@"Discount"] floatValue]];;
    //订单编号
    self.orderIdLabel.text = [NSString stringWithFormat:@"订单编号：%@",orderInfo[@"OrderId"]];
    //下单时间
    self.orderTimeLabel.text = [NSString stringWithFormat:@"下单时间：%@",orderInfo[@"OrderTime"]];
    //获取空间名称
    self.spaceNameLabel.text = orderInfo[@"Space"][@"Name"];
    //空间地址
    if (_locationLabel) {
        [_locationLabel removeFromSuperview];
    }
    _locationLabel = [[UILabel alloc]init];
    self.locationLabel.text = [NSString stringWithFormat:@"社区地址：%@",orderInfo[@"Space"][@"Location"]];
    _locationLabel.font = [UIFont systemFontOfSize:13];
    _locationLabel.textColor = CommonColor_Black;

    
    _locationLabel.frame=CGRectMake(_orderTimeLabel.frame.origin.x, _orderTimeLabel.frame.origin.y+_orderTimeLabel.frame.size.height+5, self.view.frame.size.width-30, _locationLabel.frame.size.height);
    
    _locationLabel.numberOfLines = 2;
    [_locationLabel sizeToFit];
    [_bottomView addSubview:_locationLabel];
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
