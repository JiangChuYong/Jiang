//
//  JCYSpaceEvaluateListViewController.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/1.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "JCYSpaceEvaluateListViewController.h"
#import "MJRefresh.h"

@interface JCYSpaceEvaluateListViewController ()
@property(nonatomic,assign)BOOL hasOtherData;
@property(nonatomic,strong) AFRquest *GetSpaceComment;
@property(nonatomic,strong) NSDictionary *spaceCommentDict;
@property(nonatomic,strong) NSMutableArray *commentArr;

@end

@implementation JCYSpaceEvaluateListViewController
//空间评价列表TableView ZZSpaceEvaluateListTableViewCell标志
static NSString *cellIDKey = @"ZZSpaceEvaluateListTableViewCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.emptyView.hidden = YES;
    
    self.pageCount = 1;
    
    [self initDataSource];
    
    [_spaceEvaluateListTableView registerNib:[UINib nibWithNibName:@"ZZSpaceEvaluateListTableViewCell" bundle:nil] forCellReuseIdentifier:cellIDKey];
    //从服务器请求数据 获取空间评价
    [self requestDataFromServer];
}

-(void)isShowEmptyTable{
    
    if([_commentArr count] >0){
        self.emptyView.hidden = YES;
    }else{
        self.emptyView.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark -- 数据源 初始化UI组件
/**
 *  设置数据源
 */
-(void)initDataSource{
    self.spaceViewInfoDict= [JCYGlobalData sharedInstance].spaceDetailInfo;
    _commentArr=[NSMutableArray array];
}


#pragma mark--委托方法
//TableView行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_commentArr count];
}
//返回cell
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *commentModel = _commentArr[indexPath.row];
    ZZSpaceEvaluateListTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellIDKey];
    cell.date.text = commentModel[@"CommentTime"];
    [cell setCommentView:commentModel[@"Comment"]];
    NSURL * url = [NSURL URLWithString:commentModel[@"PhotoUrl"]];
    [cell.icon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:Space_Comment_Default_Image]];
    [cell addScroeView:[commentModel[@"Score"] doubleValue]];
    [cell resetCellHeight];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *commentModel = _commentArr[indexPath.row];
    ZZSpaceEvaluateListTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellIDKey];
    [cell setCommentView:commentModel[@"Comment"]];
    NSLog(@"uuuuuuu%f",[cell resetCellHeight]);
    return [cell resetCellHeight];
}

//返回
- (IBAction)backBtnPress:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


//从服务器请求数据
-(void)requestDataFromServer{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataReceived:) name:[NSString stringWithFormat:@"%i",GetSpaceComment] object:nil];
    
    _GetSpaceComment = [[AFRquest alloc]init];
    _GetSpaceComment.subURLString = @"api/Spaces/GetSpaceComment?userToken=""&deviceType=ios";
    _GetSpaceComment.parameters = @{@"Page":[NSNumber numberWithInt:_pageCount],@"Rows":[NSNumber numberWithInt:10],@"SortProperty":@"Name",@"SortDirection":@"asc",@"SpaceId":_spaceViewInfoDict[@"Data"][@"SpaceId"]};
    _GetSpaceComment.style = GET;
    [_GetSpaceComment requestDataFromWithFlag:GetSpaceComment];
    

    
    
}


-(void)dataReceived:(NSNotification *)notif{
    
    _spaceCommentDict=_GetSpaceComment.resultDict;
    
    NSLog(@"%@",_GetSpaceComment.resultDict);
    
    int result = [_GetSpaceComment.resultDict[@"Code"] intValue];;
    if (result == SUCCESS) {
        
        [self dealResposeResult:_spaceCommentDict[@"Data"][@"Data"]];
        
    }else{
        
        [[PBAlert sharedInstance]showText:_spaceCommentDict
         [@"Description"]inView:self.view withTime:2.0];
    }
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",GetSpaceComment] object:nil];
}



#pragma mark -- 请求 代理

//处理请求返回后的结果
-(void)dealResposeResult:(NSMutableArray *)responseArr
{
    
    if(self.pageCount==1){
        _commentArr=[NSMutableArray array] ;
    }else{
        self.hasOtherData = NO;
    }
    
    //还有更多的数据加载
    if(responseArr.count<10){
        self.spaceEvaluateListTableView.mj_footer.hidden = YES;
    }else{
        // 添加传统的上拉刷新
        _spaceEvaluateListTableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            
            [self requestDataFromServer];
        }];
        

    }
    
    //说明更多数据也全部加载完成
    if(self.pageCount >1 && responseArr.count<10){
        self.hasOtherData = YES;
    }
    
    [_commentArr addObjectsFromArray:responseArr];
    
    NSLog(@"countcountcountcountcount%lu",(unsigned long)_commentArr.count);
    
    [self.spaceEvaluateListTableView reloadData];
    
    // 拿到当前的上拉刷新控件，结束刷新状态
    [self.spaceEvaluateListTableView.mj_footer endRefreshing];
    self.pageCount++;
    //如果进页面时没数据则显示，有数据则不显示
    [self isShowEmptyTable];
//    NSLog(@"%@ :%@",NSStringFromClass([response class]),[response jsonString]);
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
