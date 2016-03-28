//
//  MeetingOrderDetailViewController.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/25.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "MeetingOrderDetailViewController.h"
#import "MeetingRoomOrderTableViewCell.h"
@interface MeetingOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UILabel *sumPrince;
@property (weak, nonatomic) IBOutlet UILabel *paidPrice;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *spaceName;
@property (weak, nonatomic) IBOutlet UILabel *orderID;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) UILabel *spaceAddress;

@property (strong, nonatomic) NSMutableArray * tableDataArr;

@property (strong, nonatomic) AFRquest *OrdersGetOne;

@end

@implementation MeetingOrderDetailViewController
static NSString * cellIdKey = @"MeetingRoomOrderTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = false;

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
        [self dealWithResponsedData:_OrdersGetOne.resultDict[@"Data"]];
        
    }else{
        [[PBAlert sharedInstance] showText:_OrdersGetOne.resultDict[@"Description"] inView:self.view withTime:2.0];
    }
    
    NSLog(@"%@",_OrdersGetOne.resultDict);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",OrdersGetOne] object:nil];
}


#pragma -- mark TableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableDataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_table registerNib:[UINib nibWithNibName:@"MeetingRoomOrderTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdKey];
    MeetingRoomOrderTableViewCell * cell = [_table dequeueReusableCellWithIdentifier:cellIdKey];
    NSDictionary * orderDetail = _tableDataArr[indexPath.row];
    [self setOrderDetailInfo:orderDetail forCell:cell];
    return cell;
}
-(void)setOrderDetailInfo:(NSDictionary *)orderDetail forCell:(MeetingRoomOrderTableViewCell *)cell
{
    //日期
    NSString * date = [orderDetail[@"StartDate"] substringWithRange:NSMakeRange(2, 9)];
    cell.date.text = [date stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    //开始时间
    cell.startTime.text = [orderDetail[@"StartDate"] substringWithRange:NSMakeRange(11, 5)];
    //结束时间
    cell.endTime.text = [orderDetail[@"EndDate"] substringWithRange:NSMakeRange(11, 5)];
    
    NSDictionary * spaceInfo = orderDetail[@"SpaceCell"];
    //人数
    cell.numOfPerson.text = [NSString stringWithFormat:@"%i",[spaceInfo[@"CellNum"] intValue]];
    //编码
    cell.officeNo.text = spaceInfo[@"CellCode"];
    //售价
    NSDictionary * price = spaceInfo[@"CellPrice"][0];
    cell.price.text = [NSString stringWithFormat:@"¥%0.f", [price[@"Amount"] floatValue]];
    //类型
    cell.type.text = [[CommonUtil sharedInstance]nameForSpaceType:[spaceInfo[@"SpaceCellType"] intValue]];
    
}
- (IBAction)goback:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealWithResponsedData:(NSDictionary *)spaceInfo
{
    [self reloadDataForView:spaceInfo];
    _tableDataArr = [NSMutableArray arrayWithArray:spaceInfo[@"OrderDetailInfo"]];
    [_table reloadData];
}

-(void)reloadDataForView:(NSDictionary *)spaceInfo
{
    _sumPrince.text = [NSString stringWithFormat:@"¥%0.f",[spaceInfo[@"Amount"] floatValue]];
    _paidPrice.text = [NSString stringWithFormat:@"¥%0.f",[spaceInfo[@"Amount"] floatValue]-[spaceInfo[@"Discount"] floatValue]];
    
    _spaceName.text = spaceInfo[@"Space"][@"Name"];
    _orderID.text = [NSString stringWithFormat:@"订单编号：%@",spaceInfo[@"OrderId"]];
    _orderTime.text = [NSString stringWithFormat:@"下单时间：%@",spaceInfo[@"OrderTime"]];
    
    if (_spaceAddress) {
        [_spaceAddress removeFromSuperview];
    }
    _spaceAddress = [[UILabel alloc]init];
    _spaceAddress.text = [NSString stringWithFormat:@"社区地址：%@",spaceInfo[@"Space"][@"Location"]];
    _spaceAddress.font = [UIFont systemFontOfSize:13];
    _spaceAddress.textColor = CommonColor_Black;
    
    _spaceAddress.frame=CGRectMake(15, _orderTime.frame.origin.y+_orderTime.frame.size.height+5, self.view.frame.size.width-30, _spaceAddress.frame.size.height);
    
    _spaceAddress.numberOfLines = 2;
    [_spaceAddress sizeToFit];
    [_bottomView addSubview:_spaceAddress];
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
