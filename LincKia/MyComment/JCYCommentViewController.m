//
//  JCYCommentViewController.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/7.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "JCYCommentViewController.h"
#import "MyCommentTableViewCell.h"
#import <MJRefresh.h>
@interface JCYCommentViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myCommentTableView;
@property(assign,nonatomic)int pageCount;
@property (strong,nonatomic) AFRquest *GetNotCommentedList;
@property (strong,nonatomic) NSDictionary *commentedListDic;
@property (strong,nonatomic) NSMutableArray *commentedListArr;

@end

@implementation JCYCommentViewController
//我的评论TableView cell标志
static NSString *cellIdentifier = @"MyCommentTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //表格cell注册
    [self.myCommentTableView registerNib:[UINib nibWithNibName:@"MyCommentTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    //数据初始化
    self.pageCount = 1;
    _commentedListDic=[NSDictionary dictionary];
    _commentedListArr=[NSMutableArray array];
    //从服务器请求数据  待点评列表
    [self requestDataFromServer];
}

-(void)viewWillAppear:(BOOL)animated
{
    UINavigationController *navi=(UINavigationController *)self.parentViewController;
    navi.tabBarController.tabBar.hidden=YES;
}

#pragma mark -- TABLEVIEW DELEGATE
//TableView行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentedListArr.count;
}
//返回cell
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCommentTableViewCell *myCommentTableViewCell= [self.myCommentTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    myCommentTableViewCell.tag=indexPath.row;
    //获取数据
    NSDictionary *orderListInfo=[self.commentedListArr objectAtIndex:indexPath.row];
    [myCommentTableViewCell setMyCommentCellInfo:orderListInfo];
    //点评按钮加触发事件
    [myCommentTableViewCell.btnComment addTarget:self action:@selector(commentBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    myCommentTableViewCell.btnComment.tag=indexPath.row;
    
    return myCommentTableViewCell;
}

#pragma mark --私有方法
//点评按钮被触发
-(void)commentBtnPress:(UIButton *)sender{
    
//    //向点评页面传值
//    [ZZGlobalModel sharedInstance].evaluateSpace = [self.orderListInfoModel.OrderListArray objectAtIndex:sender.tag];
//    PBEvaluateViewController * VC = [[PBEvaluateViewController alloc]init];
//    [self.navigationController pushViewController:VC animated:YES];
    
    NSLog(@"点评");
    
}

//返回按钮触发
- (IBAction)bakBtnPress:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//从服务器请求数据  待点评列表
-(void)requestDataFromServer{

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataReceived:) name:[NSString stringWithFormat:@"%i",GetNotCommentedList] object:nil];
    NSUserDefaults * userInfo = [NSUserDefaults standardUserDefaults];
    NSString * userToken = [userInfo valueForKey:USERTOKEN];
    _GetNotCommentedList = [[AFRquest alloc]init];
    _GetNotCommentedList.subURLString =[NSString stringWithFormat:@"api/Orders/GetNotCommentedList?userToken=%@&deviceType=ios",userToken];
    _GetNotCommentedList.parameters = @{@"Id":@1,@"Page":[NSNumber numberWithInt:self.pageCount],@"Rows":@10,@"SortProperty":@"Name",@"SortDirection":@"asc"};
    _GetNotCommentedList.style = GET;
    [_GetNotCommentedList requestDataFromWithFlag:GetNotCommentedList];
}




-(void)dataReceived:(NSNotification *)notif{
    
    _commentedListDic = _GetNotCommentedList.resultDict;
    // _orderListArr=_GetMeetingList.resultDict[@"Data"][@"Data"];
    
    _commentedListDic=_GetNotCommentedList.resultDict[@"Data"];
    int result = [_GetNotCommentedList.resultDict[@"Code"] intValue];
    if (result == SUCCESS) {
        
        //[self dealDataWithResponse:_spaceInfoDict[@"Data"]];
        //[self dealOrderReciveData:_GetOrderList.resultDict[@"Data"][@"Data"]];
        
    [self dealResposeResult:_GetNotCommentedList.resultDict[@"Data"][@"Data"]];
        
    }else{
        [[PBAlert sharedInstance] showText:_GetNotCommentedList.resultDict[@"Description"] inView:self.view withTime:2.0];
    }
    
    
    
    NSLog(@"%@",_commentedListDic);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",GetNotCommentedList] object:nil];
}


#pragma mark -- 请求

//处理请求返回后的结果
-(void)dealResposeResult:(NSMutableArray *)dataArr{
    //第一页清除数据
    if(self.pageCount==1)
    {
        [_commentedListArr removeAllObjects];
        
    }
    //数据追加
    [_commentedListArr addObjectsFromArray:dataArr];
    //数据显示
    if ([_commentedListDic[@"Total"] intValue] == 0) {
        _myCommentTableView.hidden = YES;
    }else{
        _myCommentTableView.hidden = NO;
        [_myCommentTableView reloadData];
    }
    //下拉刷新
//    if (dataArr.count<10) {
//        [_myCommentTableView.footer noticeNoMoreData];
//        [_myCommentTableView.footer setTitle:@"加载完成" forState:MJRefreshFooterStateNoMoreData];
//        _pageCount = 1;
//    }else{
//        [_myCommentTableView addLegendFooterWithRefreshingBlock:^{
//            _pageCount++;
//            [self requestDataFromServer];
//        }];
//    }
    
    
    
    if(dataArr.count<10){
        _myCommentTableView.mj_footer.hidden = YES;
    }else{
        _myCommentTableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            [self requestDataFromServer];
        }];
        
    }
    
    
    
    // 拿到当前的上拉刷新控件，结束刷新状态
    [self.myCommentTableView.mj_footer endRefreshing];
    
    
    
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
