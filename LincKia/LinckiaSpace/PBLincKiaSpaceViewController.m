//
//  ZZLincKiaSpaceViewController.m
//  LincKia
//
//  Created by 董玲 on 11/4/15.
//  Copyright © 2015 ZZ. All rights reserved.
//
#import "PBLincKiaSpaceViewController.h"
#import "JSDropDownMenu.h"
#import "ZZSpaceRecommendCellTableViewCell.h"
#import "MJRefresh.h"
#import "LinckiaSpace.h"

@interface PBLincKiaSpaceViewController () <JSDropDownMenuDataSource,JSDropDownMenuDelegate>
@property (weak, nonatomic) IBOutlet UIView *nodataView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *JSMenuBackgroundView;
@property (weak, nonatomic) IBOutlet UITableView *currentSpaceListTableView;
@property(strong,nonatomic) JSDropDownMenu *jsMenu;
@property(assign,nonatomic) NSInteger selectedRowInColumnLeft;
@property(assign,nonatomic) NSInteger selectedRowInColumnRight;

//当前表格需要显示的内容
@property (strong,nonatomic)  NSMutableArray * currentDataArray;
//JSMenu需要的数据
@property (strong,nonatomic)    NSArray * columeTitleArr;
@property (strong,nonatomic)    NSArray * leftTitleArr;
@property (strong,nonatomic)    NSMutableArray * jsmenuPriceDataMutArr;
@property (strong,nonatomic)    NSArray * priceArray;
@property (strong,nonatomic)    NSMutableArray * jsmenuAreaMutArr;
@property (strong,nonatomic)    NSMutableArray * jsmenuSubwayMutArr;
@property (strong,nonatomic)    NSMutableArray * jsmenutradAreaMutArr;
@property (strong,nonatomic)    NSMutableArray * tradeAreasInCurrentAreasArray;
//@property (strong,nonatomic)    SpaceSearchModel *spaceSelectedModel;
@property (assign,nonatomic)    BOOL isSearchingInDistrict;
@property (assign,nonatomic)    BOOL isSearchingInSubway;
@property (assign,nonatomic)    BOOL isSearchingInTradearea;
@property (assign,nonatomic)    BOOL isSearchingInPriceColumn;
@property (strong,nonatomic)    NSString * selectedDistrict;
@property (strong,nonatomic)    NSString * selectedSubwayLine;
@property (nonatomic, assign)   NSString * selectedTradeZone;
@property (strong,nonatomic)    NSString * selectedPriceString;
@property (assign,nonatomic)    int currentTableViewPage;//表格滚动到了第几页
//@property (strong,nonatomic)    SpaceSummaryInfo *spaceSummaryInfo;
@property (assign,nonatomic)    int focusTag;//当前选中收藏的数组光标位

@property (strong,nonatomic) AFRquest *GetAreas;
@property (strong,nonatomic) AFRquest *GetTradeAreas;
@property (strong,nonatomic) AFRquest *GetSubways;
@property (strong,nonatomic) AFRquest *GetAllSpaceList;
@property (strong,nonatomic) NSDictionary *getAreasIndexDict;
@property (strong,nonatomic) NSDictionary *getTradeAreasIndexDict;
@property (strong,nonatomic) NSDictionary *getSubwaysIndexDict;
@property (strong,nonatomic) LinckiaSpace *allSpaceListParameter;
@property (strong,nonatomic) NSDictionary *allSpaceListDict;






@end
@implementation PBLincKiaSpaceViewController

static NSString *spaceListTableViewCell=@"spaceRecommendCellTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化数据
    _allSpaceListParameter=[[LinckiaSpace alloc]init];
    _isSearchingInDistrict = NO;
    _isSearchingInSubway = NO;
    _isSearchingInTradearea = NO;
    _isSearchingInPriceColumn = NO;
    _currentTableViewPage = 1;
    _currentDataArray = [NSMutableArray array];
    
    
    [self prepareJSMenuDataFromServer];//求情下拉菜单数据
    [self setJsMenuUIAndJSMenuTitle];//代码创建JsMenu下拉菜单
    [self requestDataFromServer];//请求当前页面下推荐的空间
    
    dispatch_queue_t defaulthqueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(defaulthqueue, ^{
        [self.currentSpaceListTableView registerNib:[UINib nibWithNibName:@"ZZSpaceRecommendCellTableViewCell" bundle:nil] forCellReuseIdentifier:spaceListTableViewCell];//注册表格xib文件
    });
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UINavigationController *navi=(UINavigationController *)self.parentViewController;
    navi.tabBarController.tabBar.hidden=YES;
}
#pragma -- mark UI PART
-(void)setJsMenuUIAndJSMenuTitle
{
    //设置初始页面数据
    _columeTitleArr = [NSArray arrayWithObjects:@"区域",@"价格", nil];
    _leftTitleArr = [NSArray arrayWithObjects:@"行政区域",@"地铁",@"商圈",@"重置", nil];
    NSDictionary * zero = @{@"pricestring":@"全部",@"startPrice":@"0",@"endprice":@"0"};
    NSDictionary * five = @{@"pricestring":@"¥0-500/人/月",@"startPrice":@"1",@"endprice":@"500"};
    NSDictionary * ten = @{@"pricestring":@"¥500-1000/人/月",@"startPrice":@"501",@"endprice":@"1000"};
    NSDictionary * fifty = @{@"pricestring":@"¥1000-1500/人/月",@"startPrice":@"1001",@"endprice":@"1500"};
    NSDictionary * twentyFive = @{@"pricestring":@"¥1500-2500/人/月",@"startPrice":@"1501",@"endprice":@"2500"};
    NSDictionary * thirtyFive = @{@"pricestring":@"¥2500-3500/人/月",@"startPrice":@"2501",@"endprice":@"3500"};
    NSDictionary * uptop = @{@"pricestring":@"¥3500/人/月以上",@"startPrice":@"3501",@"endprice":@"10000"};
    _priceArray = [NSArray arrayWithObjects:zero,five,ten,fifty,twentyFive,thirtyFive,uptop,nil];
    _jsmenuPriceDataMutArr = [NSMutableArray array];
    for (NSDictionary * dict in _priceArray) {
        NSString * price = [dict valueForKey:@"pricestring"];
        [_jsmenuPriceDataMutArr addObject:price];
    }
    self.jsMenu = [[JSDropDownMenu alloc] initWithOrigin:_JSMenuBackgroundView.frame.origin andHeight:36];
    //下拉选择框的界面布置
    self.jsMenu.backgroundColor = [UIColor colorWithRed:83.0f/255.0f green:171.0f/255.0f blue:242.0f/255.0f alpha:1.0];
    self.jsMenu.tableViewHeight = 176;
    self.jsMenu.highlightColor = [UIColor colorWithRed:83.0f/255.0f green:171.0f/255.0f blue:242.0f/255.0f alpha:1.0];
    self.jsMenu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    self.jsMenu.separatorColor = [UIColor colorWithWhite:0.534 alpha:1.000];
    self.jsMenu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    self.jsMenu.dataSource = self;
    self.jsMenu.delegate = self;
    self.jsMenu.userInteractionEnabled = YES;
    [self.view addSubview:self.jsMenu];
    
}
#pragma -- mark JSDropDownMenuDataSource DELEGATE
- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column
{
    //下拉菜单左右表格长宽比例
    if (column == 0) {
        return 0.5;
    }else{
        return 1;
    }
}
- (BOOL)haveRightTableViewInColumn:(NSInteger)column
{
    if (column == 0) {
        return YES;
    }else{
        return NO;
    }
}
-(NSInteger)currentLeftSelectedRow:(NSInteger)column
{
    if (column==0) {
        return _selectedRowInColumnLeft ;
    }else{
        return _selectedRowInColumnRight;
    }
}
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu
{
    return _columeTitleArr.count;
}
- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath
{
    //获取当前选中行
    if (indexPath.column == 0) {
        _selectedRowInColumnLeft = indexPath.leftRow;
    }else{
        _selectedRowInColumnRight= indexPath.row;
    }
    //当选中区域时更新商圈选项内的数组
    if (indexPath.column == 0 && indexPath.leftRow == 0 && indexPath.leftOrRight == 1) {//选中右边选项后获取选中的商圈
        _isSearchingInDistrict = YES;
        //区域栏只允许一个选择条件，当选中行政区后关掉其他两个开关
        _isSearchingInSubway = NO;
        _isSearchingInTradearea = NO;
        NSDictionary * area = _jsmenuAreaMutArr[indexPath.row];
        _selectedDistrict = area[@"Key"];//获取当前选中的区域Code
        [self requestDataFromServer];
        //        通过当前选中的区域获取该区域相应的商圈
        for (NSDictionary * tradearea in _jsmenutradAreaMutArr) {
            if ([tradearea[@"AreaCode"] isEqualToString:_selectedDistrict]) {
                _tradeAreasInCurrentAreasArray = [NSMutableArray arrayWithArray:tradearea[@"TradeAreas"]];
            }
        }
        [self.jsMenu reloadAllTableView];
    }
    if (indexPath.column == 0 && indexPath.leftRow == 1 && indexPath.leftOrRight == 1) {//选中右边选项后获取选中的线路
        _isSearchingInSubway = YES;
        //区域栏只允许一个选择条件，当选地铁后关掉其他两个开关
        _isSearchingInTradearea = NO;
        _isSearchingInDistrict = NO;
        NSDictionary * dict = _jsmenuSubwayMutArr[indexPath.row];
        NSLog(@"dic%@",dict);
        _selectedSubwayLine = [dict valueForKey:@"Key"];
        [self requestDataFromServer];
        
    }
    if (indexPath.column == 0 && indexPath.leftRow == 2 && indexPath.leftOrRight == 1) {//选中右边选项后获取选中的商圈
        _isSearchingInTradearea = YES;
        //区域栏只允许一个选择条件，当选中商圈后关掉其他两个开关
        _isSearchingInDistrict = NO;
        _isSearchingInSubway = NO;
        NSDictionary * trade = _tradeAreasInCurrentAreasArray[indexPath.row];
        _selectedTradeZone = trade[@"Key"];
        [self requestDataFromServer];
    }
    if (indexPath.column == 0 && indexPath.leftRow == 3 && indexPath.leftOrRight == 1) {//选中重置
        //初始化数据
        _isSearchingInDistrict = NO;
        _isSearchingInSubway = NO;
        _isSearchingInTradearea = NO;
        _isSearchingInPriceColumn = NO;
        _currentTableViewPage = 1;
        _allSpaceListParameter = [[LinckiaSpace alloc]init];
        _currentDataArray = [NSMutableArray array];
        [self requestDataFromServer];//重新获取数据
        [self prepareJSMenuDataFromServer];//求情下拉菜单数据
        [self setJsMenuUIAndJSMenuTitle];//代码创建JsMenu下拉菜单
    }
    if (indexPath.column == 1 ) {//选中右边选项后获取选中的价格
        _isSearchingInPriceColumn = YES;
        _selectedPriceString = _jsmenuPriceDataMutArr[indexPath.row];
        [self requestDataFromServer];
    }
}
-(NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column
{
    return _columeTitleArr[column];
}
-(NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath
{
    if (indexPath.column == 0) {//区域列
        if (indexPath.leftOrRight == 0) {
            return _leftTitleArr[indexPath.row];
        }else{
            if (indexPath.leftRow == 0) {
                NSDictionary * area = _jsmenuAreaMutArr[indexPath.row];
                NSLog(@"######%@",area[@"Value"]);
                return area[@"Value"];
            }else if (indexPath.leftRow == 1){
                NSDictionary * dict = _jsmenuSubwayMutArr[indexPath.row];
                return [dict valueForKey:@"Value"];;
            }else if(indexPath.leftRow == 2){
                NSDictionary * trade = _tradeAreasInCurrentAreasArray[indexPath.row];
                return trade[@"Value"];
            }else{
                return @"确认重置所有选项";
            }
        }
    }else{//价格列
        return _jsmenuPriceDataMutArr[indexPath.row];
    }
}
-(NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow
{
    if (column == 0) {//区域列
        if (leftOrRight == 0) {
            return _leftTitleArr.count;
        }else{
            if (leftRow == 0) {
                return _jsmenuAreaMutArr.count;
            }else if (leftRow == 1){
                return _jsmenuSubwayMutArr.count;
            }else if (leftRow == 2){
                return _tradeAreasInCurrentAreasArray.count;
            }else{
                return 1;
            }
        }
    }else{//价格列
        return _jsmenuPriceDataMutArr.count;
    }
}
#pragma -- mark TABLEVIEW DELEGATE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _currentDataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (Main_Screen_Height+20)*0.3f+60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZSpaceRecommendCellTableViewCell *spacesListTableViewCell=[tableView dequeueReusableCellWithIdentifier:spaceListTableViewCell];
    NSDictionary * space = _currentDataArray[indexPath.row];
    NSString *imageUrl=space[@"PicUrl"];
    //主图
    UIImageView *imageViewRecommend =[spacesListTableViewCell valueForKey:@"spaceImageView"];
    [imageViewRecommend sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:Index_Recommond_Default_Image]];
    //读取空间名称
    NSString *spaceName = space[@"Name"];
    UILabel * spaceNameLabel = [spacesListTableViewCell valueForKey:@"spaceNameLabel"];
    spaceNameLabel.text = spaceName;
    //读取空间地址
    NSString *spaceAdress =space[@"Location"];
    UILabel * spaceAdressLabel = [spacesListTableViewCell valueForKey:@"spaceAdressLabel"];
    spaceAdressLabel.text = spaceAdress;
    
    //添加用户交互图片
    UIButton *UITouchBtn =[spacesListTableViewCell valueForKey:@"UITouchBtn"];
    UITouchBtn.tag = 5000+indexPath.row;
    [UITouchBtn addTarget:self action:@selector(selectRecommond:) forControlEvents:UIControlEventTouchUpInside];
    return spacesListTableViewCell;
}
//选中空间
-(void)selectRecommond:(UIImageView *)sender
{
    
    
    NSDictionary *spaceSummaryInfoDict=_currentDataArray[sender.tag-5000];
    [JCYGlobalData sharedInstance].SpaceId=spaceSummaryInfoDict[@"SpaceId"];
    [self performSegueWithIdentifier:@"LinckiaSpaceToLinckiaSpaceInfo" sender:self];
    
}
-(void)requestDataFromServer
{
    
    //不管处于哪个搜索条件下都把页数初始化为：1<--------
    if (_isSearchingInDistrict||_isSearchingInPriceColumn||_isSearchingInSubway||_isSearchingInTradearea) {
        _currentTableViewPage = 1;
    }else{
        _allSpaceListParameter=[[LinckiaSpace alloc]init];
    }
    //选中区域后
    if (_isSearchingInDistrict) {
        _allSpaceListParameter=[[LinckiaSpace alloc]init];
        _allSpaceListParameter.District=[NSString stringWithFormat:@"310000.310100.%@",_selectedDistrict];
    }else{
        _allSpaceListParameter.District=@"";
    }
    //选中地铁后
    if (_isSearchingInSubway){
        _allSpaceListParameter=[[LinckiaSpace alloc]init];
        _allSpaceListParameter.Metro=_selectedSubwayLine;
        _allSpaceListParameter.District=@"";
        
        NSLog(@"_selectedSubwayLine%@",_selectedSubwayLine);
    }else{
        _allSpaceListParameter.Metro=@"";
    }
    //选中商圈后
    if (_isSearchingInTradearea){
        
        _allSpaceListParameter.Zone=_selectedTradeZone;
    }else{
        _allSpaceListParameter.Zone=@"";
    }
    //选中价格后
    if (_isSearchingInPriceColumn) {
        for (NSDictionary * dict in _priceArray) {
            NSString * string = [dict valueForKey:@"pricestring"];
            if ([string isEqualToString:_selectedPriceString]) {
                
                _allSpaceListParameter.SpaceCellPriceStart = [[dict valueForKey:@"startPrice"] floatValue];
                _allSpaceListParameter.SpaceCellPriceEnd = [[dict valueForKey:@"endprice"] floatValue];
            }
        }
    }else{
        _allSpaceListParameter.SpaceCellPriceStart = 0;
        _allSpaceListParameter.SpaceCellPriceEnd = 0;
    }
    
    _allSpaceListParameter.Page=_currentTableViewPage;
    NSLog(@"\n\n\n\n\n\n%i\n\n\n\n\n\n\n\n\n",_allSpaceListParameter.Page);
    _allSpaceListParameter.Rows=10;
    _allSpaceListParameter.IsRecommend=YES;
    _allSpaceListParameter.SortDirection=@"asc";
    _allSpaceListParameter.SortProperty=@"Name";
    //http://112.74.75.66/OfficeAPI/api/Spaces/GetSpaceList?deviceType=ios&usertoken=98a29185-6bc4-44bf-90f3-4a10de84c5f6&Page=1&SpaceCellPriceEnd=120&Latitude=0&SpaceCellPriceStart=91&Longitude=0&IsRecommend=1&SortProperty=Name&Metre=0&SortDirection=asc&IsLinckia=true&Rows=10
    
    
    
    _GetAllSpaceList=[[AFRquest alloc]init];
    _GetAllSpaceList.subURLString=@"api/Spaces/GetAllSpaceList?userToken=""&deviceType=ios";
    
    NSLog(@"DDDDDD%@",@{@"Page":[NSNumber numberWithInt:_allSpaceListParameter.Page]});
    
    
    NSLog(@"adfdsfa");
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAllSpaceListDataReceived:) name:[NSString stringWithFormat:@"%i",GetAllSpaceList] object:nil];
    
    _GetAllSpaceList.parameters=@{@"Page":[NSNumber numberWithInt:_allSpaceListParameter.Page],@"Rows":[NSNumber numberWithInt:_allSpaceListParameter.Rows],@"IsRecommend":[NSNumber numberWithBool:_allSpaceListParameter.IsRecommend],@"SortProperty":@"Name",@"SortDirection":@"asc",@"District":_allSpaceListParameter.District,@"Metro":_allSpaceListParameter.Metro,@"Zone":_allSpaceListParameter.Zone,@"SpaceCellPriceStart":[NSNumber numberWithFloat:_allSpaceListParameter.SpaceCellPriceStart],@"SpaceCellPriceEnd":[NSNumber numberWithFloat:_allSpaceListParameter.SpaceCellPriceEnd]};
    _GetAllSpaceList.style = GET;
    [_GetAreas requestDataFromWithFlag:GetAllSpaceList];
    
    
    
}
-(void)prepareJSMenuDataFromServer
{
    //最高级处理速度获取区域的数据
    dispatch_queue_t highlevelqueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);//<-----
    dispatch_async(highlevelqueue, ^{
        
        /*行政区域发起请求*/
        _GetAreas=[[AFRquest alloc]init];
        _GetAreas.subURLString=@"api/Sys/GetAreas?userToken=""&deviceType=ios";
        _GetAreas.parameters=@{@"city":@"310100"};
        _GetAreas.style = GET;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAreasDataReceived:) name:[NSString stringWithFormat:@"%i",GetAreas] object:nil];
        [_GetAreas requestDataFromWithFlag:GetAreas];
        
        /*商圈列表发起请求*/
        _GetTradeAreas = [[AFRquest alloc]init];
        _GetTradeAreas.subURLString =[NSString stringWithFormat:@"api/Sys/GetTradeAreas?userToken=""&deviceType=ios"];
        _GetTradeAreas.parameters=@{@"city":@"310100"};
        _GetTradeAreas.style = GET;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getTradeAreasDataReceived:) name:[NSString stringWithFormat:@"%i",GetTradeAreas] object:nil];
        [_GetTradeAreas requestDataFromWithFlag:GetTradeAreas];
        
        /*地铁列表发起请求*/
        _GetSubways = [[AFRquest alloc]init];
        _GetSubways.subURLString =[NSString stringWithFormat:@"api/Sys/GetSubways?userToken=""&deviceType=ios"];
        _GetSubways.parameters=@{@"city":@"310100"};
        _GetSubways.style = GET;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getsubwaysDataReceived:) name:[NSString stringWithFormat:@"%i",GetSubways] object:nil];
        [_GetSubways requestDataFromWithFlag:GetSubways];
        
    });
    //    //采用多线程加快数据处理速度 勿删除
    //    dispatch_queue_t defaulthqueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //    dispatch_async(defaulthqueue, ^{
    ////
    ////        /*地铁列表发起请求*/
    ////        _GetSubways = [[AFRquest alloc]init];
    ////        _GetSubways.subURLString =[NSString stringWithFormat:@"api/Sys/GetSubways?userToken=""&deviceType=ios"];
    ////        _GetSubways.parameters=@{@"city":@"310100"};
    ////        _GetSubways.style = GET;
    ////        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getsubwaysDataReceived:) name:[NSString stringWithFormat:@"%i",GetSubways] object:nil];
    ////        [_GetSubways requestDataFromWithFlag:GetSubways];
    //    });
}

//行政区划列表
-(void)getAreasDataReceived:(NSNotification *)notif{
    
    NSLog(@"行政区划列表%@",_GetAreas.resultDict);
    _getAreasIndexDict=_GetAreas.resultDict;
    int result = [_GetAreas.resultDict[@"Code"] intValue];;
    if (result == SUCCESS) {
        _jsmenuAreaMutArr = [NSMutableArray arrayWithArray:_getAreasIndexDict[@"Data"]];
        NSLog(@"_jsmenuAreaMutArr%@",_jsmenuAreaMutArr);
        
    }else{
        
        [[PBAlert sharedInstance]showText:_getAreasIndexDict
         [@"Description"]inView:self.view withTime:2.0];
    }
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",GetAreas] object:nil];
}

//商圈列表
-(void)getTradeAreasDataReceived:(NSNotification *)notif{
    
    NSLog(@"商圈列表%@",_GetTradeAreas.resultDict);
    _getTradeAreasIndexDict=_GetTradeAreas.resultDict;
    int result = [_GetTradeAreas.resultDict[@"Code"] intValue];;
    if (result == SUCCESS) {
        _jsmenutradAreaMutArr = [NSMutableArray arrayWithArray:_getTradeAreasIndexDict[@"Data"]];
        
        NSDictionary * dict = _jsmenuAreaMutArr[0];
        for (NSDictionary * tradearea in _jsmenutradAreaMutArr) {
            if ([tradearea[@"AreaCode"] isEqualToString:dict[@"Key"]]) {
                _tradeAreasInCurrentAreasArray = [NSMutableArray arrayWithArray:tradearea[@"TradeAreas"]];
                
            }
        }
    }else{
        [[PBAlert sharedInstance]showText:_getTradeAreasIndexDict
         [@"Description"]inView:self.view withTime:2.0];
        
    }
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",GetTradeAreas] object:nil];
}


//地铁列表
-(void)getsubwaysDataReceived:(NSNotification *)notif{
    NSLog(@"地铁列表%@",_GetSubways.resultDict);
    _getSubwaysIndexDict=_GetSubways.resultDict;
    int result = [_GetSubways.resultDict[@"Code"] intValue];
    if (result == SUCCESS) {
        _jsmenuSubwayMutArr = [NSMutableArray arrayWithArray:_getSubwaysIndexDict[@"Data"]];
        NSLog(@"_jsmenuSubwayMutArr%@",_jsmenuSubwayMutArr);
        
    }else{
        [[PBAlert sharedInstance]showText:_getSubwaysIndexDict
         [@"Description"]inView:self.view withTime:2.0];
        
    }
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",GetSubways] object:nil];
}


//获取所有海星客空间列表
-(void)getAllSpaceListDataReceived:(NSNotification *)notif{
    
    NSLog(@"6666666666%@",_GetAllSpaceList.resultDict);
    _allSpaceListDict=_GetAllSpaceList.resultDict;
    int result = [_GetTradeAreas.resultDict[@"Code"] intValue];;
    if (result == SUCCESS) {
        [self dealResposeResult:_allSpaceListDict[@"Data"][@"Data"]];
       
        
    }else{
        
        [[PBAlert sharedInstance]showText:_allSpaceListDict
         [@"Description"]inView:self.view withTime:2.0];
    }
    
     [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",GetAllSpaceList] object:nil];
    
}
/** *处理请求返回后的结果*/
-(void)dealResposeResult:(NSMutableArray *)arr{
    //如果返回的数据小于10条则隐藏加载更多数据的提示条
    if(arr.count<10){
        self.currentSpaceListTableView.mj_footer.hidden = YES;
    }else{
        _currentSpaceListTableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            
            [self requestDataFromServer];
        }];
        
        
    }
    
    if (_currentTableViewPage == 1) {
        _currentDataArray = [NSMutableArray array];
    }
    [_currentDataArray addObjectsFromArray:arr];
    if (_currentDataArray.count > 0) {
        [self.view bringSubviewToFront:_currentSpaceListTableView];
        [self.currentSpaceListTableView reloadData];
    }else{
        [self.view bringSubviewToFront:_nodataView];
    }
    
    _currentTableViewPage++;//拿到数据后页面数自加
    NSLog(@"\n\n\n\n_currentTableViewPage   %i\n\n\n\n\n\n",_currentTableViewPage);
    //无论获取成功或者失败都清除上次选中的选项
    _isSearchingInDistrict = NO;
    _isSearchingInSubway = NO;
    _isSearchingInTradearea = NO;
    // 拿到当前的上拉刷新控件，结束刷新状态
    [self.currentSpaceListTableView.mj_footer endRefreshing];
}
#pragma -- mark EVENTS ACTION
- (IBAction)backButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES ];
}
- (IBAction)searchButtonPressed:(UIButton *)sender {

    [JCYGlobalData sharedInstance].orderSubmitFlag = FromOfficeListPage;
    [self performSegueWithIdentifier:@"LinckiaSpaceToSearch" sender:self];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
