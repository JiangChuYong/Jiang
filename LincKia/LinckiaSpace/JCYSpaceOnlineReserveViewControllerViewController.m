//
//  JCYSpaceOnlineReserveViewControllerViewController.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/2.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "JCYSpaceOnlineReserveViewControllerViewController.h"
#import "PBMeetingRoomTableTopViewCell.h"
#import "NIDropDown.h"
#import "ZZCalendarViewController.h"
#import "ZZSpaceOnlineReserveSeartTableViewCell.h"
#import "MJRefresh.h"
@interface JCYSpaceOnlineReserveViewControllerViewController ()<UITableViewDataSource,UITableViewDelegate,NIDropDownDelegate>
@property (weak, nonatomic) IBOutlet UITableView *topTable;
@property (weak, nonatomic) IBOutlet UITableView *bottomTable;
@property (weak, nonatomic) IBOutlet UIButton *bookingBtn;
@property (weak, nonatomic) IBOutlet UIImageView *cuttingLine;
//选择菜单背景
@property (strong, nonatomic) UIView * backgroundMaskView;
@property(nonatomic,strong)NIDropDown *dropDown;
@property (assign, nonatomic) int currentPage;

@property (strong, nonatomic) NSMutableArray * placeholders;
@property (strong, nonatomic) NSArray * subjects;
@property (strong, nonatomic) NSArray * images;

//存放月份的数组
@property(nonatomic,strong)NSMutableArray *monthArray;

@property (strong, nonatomic) NSMutableArray * spaceList;
@property (strong, nonatomic) NSMutableArray *cellsArr;
@property (strong, nonatomic) AFRquest * GetSpaceCell;

@property (assign,nonatomic) BOOL spaceSelected;
@property (assign,nonatomic) BOOL dateSelected;
@property (assign,nonatomic) BOOL monthSelected;


@property (strong,nonatomic) NSString *endStr;
@property (strong,nonatomic) NSString *numOfMonth;

@property (strong,nonatomic) NSMutableArray * spaceRooms;
@property (assign,nonatomic) int flag;
@property (strong,nonatomic) NSString *officeName;

@end

@implementation JCYSpaceOnlineReserveViewControllerViewController

static NSString * topCellIDKey = @"PBMeetingRoomTableTopViewCell";
static NSString * bottomCellIDKey = @"ZZSpaceOnlineReserveSeartTableViewCell";

-(void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerCellNibForTable];
    [self setUI];
    [self initData];
    [self showAlertView];
    [self prepareDataForTableView];
}

#pragma -- mark PRIVATE METHODS

-(void)setUI
{
    _bookingBtn.layer.cornerRadius = 5;
    _bookingBtn.clipsToBounds = YES;
    _cuttingLine.hidden = YES;
}

-(void)initData
{
    _currentPage = 1;
    _spaceRooms = [NSMutableArray array];
    _spaceList=[NSMutableArray array];
    _cellsArr =[NSMutableArray array];
    _spaceSelected = YES;
    _dateSelected = NO;
    _monthSelected=NO;
    
    _cellsArr= [JCYGlobalData sharedInstance].spaceDetailInfo[@"Data"][@"SpaceCell"];
    
    for (int i=0; i<_cellsArr.count; i++) {
        NSDictionary * cell = _cellsArr[i];
        if (cell[@"SpaceCellRemainderNumber"] > 0) {
            _flag= [cell[@"SpaceCellType"] intValue];
           _officeName =[[CommonUtil sharedInstance] nameForSpaceType:[cell[@"SpaceCellType"] intValue] ];
        }
    }

}

-(void)registerCellNibForTable
{
    [_topTable registerNib:[UINib nibWithNibName:@"PBMeetingRoomTableTopViewCell" bundle:nil] forCellReuseIdentifier:topCellIDKey];
    [_bottomTable registerNib:[UINib nibWithNibName:@"ZZSpaceOnlineReserveSeartTableViewCell" bundle:nil] forCellReuseIdentifier:bottomCellIDKey];
}

-(void)prepareDataForTableView
{
    
    _placeholders = [NSMutableArray arrayWithObjects:_officeName,@"请选择开始租用日期",@"请选择租用时间",@"", nil];
    _subjects = [NSMutableArray arrayWithObjects:[JCYGlobalData sharedInstance].spaceDetailInfo[@"Data"][@"Name"],@"开始租用日期", @"租用时间",@"查看空间位置图", nil];
    _images = [NSMutableArray arrayWithObjects:@"office_position@3x.png",@"date.png",@"date.png", @"photo@3x.png",nil];
        _monthArray = [NSMutableArray arrayWithObjects:@"1个月",@"2个月",@"3个月", @"4个月",@"5个月",@"6个月",@"7个月",@"8个月",@"9个月",@"10个月",@"11个月",@"12个月",nil];
    
    [_topTable reloadData];
}

//判断是否还有租赁空间
-(void)commitData:(int)flag
{
    //判断该空间类型有无剩余可祖灵数量
    for (NSDictionary * cell in _cellsArr) {
        if ([cell[@"SpaceCellType"] intValue] == flag) {
            if (![cell[@"SpaceCellRemainderNumber"] intValue] >0) {
                
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"此空间单元该类型已租完" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
    }
    //当搜索条件发生变化时，重置pageCount
    self.currentPage=1;
    //获取空间单元
    [self getLinckiaSpaceCellDataFromServer];
}

/**显示社区办公室类型alertView*/
- (void)showAlertView
{
    //该空间拥有的空间单元的类型
    NSMutableArray *spaceCellType = [JCYGlobalData sharedInstance].spaceDetailInfo[@"Data"][@"SpaceCellType"];
    
    if(spaceCellType.count > 0)
    {
        for(id item in spaceCellType)
        {
            [_spaceList addObject:[[CommonUtil sharedInstance]nameForSpaceType:[item intValue]]];//空间类型的转换方法
        }

    }
    self.backgroundMaskView.hidden = NO;
    NSLog(@"spaceList=%@",_spaceList);
}


#pragma -- mark ACTION PART

- (IBAction)bookingBtnPressed:(UIButton *)sender {
    
   

    if (!_dateSelected){
        
        [[PBAlert sharedInstance]showText:@"请选择开始租用日期" inView:self.view withTime:2.0];
        return;
    }
    if (!_monthSelected){
        
        [[PBAlert sharedInstance]showText:@"请选择租用时间" inView:self.view withTime:2.0];
        return;
    }
    
    [self spaceCellWasSeleted];
    
}

-(void)spaceCellWasSeleted
{
    NSMutableArray * selectedRooms = [NSMutableArray array];
    for (NSDictionary * space in _spaceRooms) {
        if ([space[@"isSelected"] boolValue]) {
            
            NSMutableDictionary * addToCartDic = [[NSMutableDictionary alloc]init];
            [addToCartDic setObject:space[@"SpaceCellId"] forKey:@"SpaceCellId"];
            
            [addToCartDic setObject:_placeholders[1] forKey:@"RentStartTime"];
            
            [addToCartDic setObject:_endStr forKey:@"RentEndTime"];
            [addToCartDic setObject:@"月" forKey:@"PriceUnit"];
            
            NSString *monthNumStr = [self getOnlyNum:_placeholders[2]];
            [addToCartDic setObject:[NSNumber numberWithInt:[monthNumStr intValue]] forKey:@"MonthNum"];
            
            [selectedRooms addObject:addToCartDic];

        }
    }
    
    if (selectedRooms.count) {
         [JCYGlobalData sharedInstance].orderSubmitFlag = OrderSubmitFlag_OrdersAdd;
        [JCYGlobalData sharedInstance].meetingCarArr=selectedRooms;
        [JCYGlobalData sharedInstance].hasNavi=YES;

        [self performSegueWithIdentifier:@"LinckiaSpaceOlineBookingToPayOrder" sender:self];
    }else{
        [[PBAlert sharedInstance] showText:@"请选择要预定的社区" inView:self.view withTime:2.0];
    }
    
}


- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)topTableDidSelectRowAtIndex:(UIButton *)sender{
    
    int row = (int)sender.tag-999;
    //空间选择
    if (row == 0) {
        [self alertDropDownView:_spaceList tag:sender];
        //日历选择
    }else if (row == 1){
        ZZCalendarViewController *viewController = [ZZCalendarViewController shareCalendarVC];
        [JCYGlobalData sharedInstance].validDays = 365;
        viewController.hideAfterValidDay = YES;
        [viewController.selectDayView cancleClickDayViewStyle];
        viewController.view.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.7];
        [self.view addSubview:viewController.view];
        //获得用户选择的日期
        viewController.callBack=^(NSDate *date){
            if(!date){
                [[PBAlert sharedInstance]showText:@"请选择日期" inView:self.view withTime:2.0f];
            }else{
                _dateSelected = YES;
                NSString * rendDate;
                rendDate = [date stringFromDate:@"yyyy-MM-dd"];
                [_placeholders replaceObjectAtIndex:row withObject:rendDate];
                _currentPage=1;
                [self getLinckiaSpaceCellDataFromServer];
                [_topTable reloadData];
            }
        };
        
        //租用时间
    }else if (row == 2){
        [self alertDropDownView:_monthArray tag:sender];
        
    }else{
        //推向空间位置图
        [self performSegueWithIdentifier:@"LinckiaSpaceOnlineBookingToSpacePosition" sender:self];
    }
}

#pragma mark NIDropDown delegate
//结束租用日期下拉列表
-(void)alertDropDownView:(NSMutableArray *)arr tag:(id)sender
{
    
    if(self.dropDown == nil) {
        if(!self.backgroundMaskView)
        {
            self.backgroundMaskView = [[UIView alloc]initWithFrame:self.view.frame];
            //背景设置为半透明黑色
            self.backgroundMaskView.backgroundColor = HalfClearColor;
            [self.view addSubview:self.backgroundMaskView];
        }
        self.backgroundMaskView.hidden = NO;
        CGFloat f = 160;
        self.dropDown = [[NIDropDown alloc]initShowDropDown:sender :&f :arr :self.view];
        self.dropDown.tag = [sender tag];
        self.dropDown.delegate = self;
    }else {
        [self.dropDown hideDropDown];
        [self rel];
    }
    
}

- (void)niDropDownDelegateMethod: (NIDropDown *) sender text:(NSString *)text
{
    int tag = (int)sender.tag - 999;
    
    if (tag == 0) {
        _spaceSelected = YES;
        //当搜索条件发生变化时，重置pageCount
        self.currentPage=1;

        NSMutableArray *tempArr=[JCYGlobalData sharedInstance].spaceDetailInfo[@"Data"][@"SpaceCellType"];
        
        for (id item in tempArr) {
            NSString *tempStr=[[CommonUtil sharedInstance]nameForSpaceType:[item intValue]];
            if ([text isEqualToString:tempStr]) {
                _flag=[item intValue];
                [self commitData:_flag];
            }
        }
        
        
    }
   
    
    if (tag == 2) {
        _monthSelected = YES;
        self.numOfMonth = [self getOnlyNum:text];
        NSDate *endDate = [JCYGlobalData jcyDateByAddingMonths:[self.numOfMonth intValue] From:_placeholders[1]];
        NSDate *lastEndDate = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:endDate];
        self.endStr = [lastEndDate stringFromDate:@"yyyy-MM-dd"];

        //当搜索条件发生变化时，重置pageCount
        self.currentPage=1;

    }
    
    
    [_placeholders replaceObjectAtIndex:tag withObject:text];
    
  
    
    [self rel];
    
    [_topTable reloadData];

    [self getLinckiaSpaceCellDataFromServer];
}

- (NSString *)getOnlyNum:(NSString *)str
{
    return [str stringByReplacingOccurrencesOfString:@"[^0-9,]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [str length])];
}


-(void)rel{
    self.backgroundMaskView.hidden = YES;
    self.dropDown = nil;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.dropDown hideDropDown];
    [self rel];
}


#pragma -- mark UITABLEVIEW DELEGATE
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:_topTable]) {
        
        PBMeetingRoomTableTopViewCell * topcell = [_topTable dequeueReusableCellWithIdentifier:topCellIDKey];
        topcell.leftIcon.image = [UIImage imageNamed:_images[indexPath.row]];
        topcell.leftLab.text = _subjects[indexPath.row];
        
        topcell.rightLab.text = _placeholders[indexPath.row];
        
        topcell.actionBtn.tag = 999+indexPath.row;
        [topcell.actionBtn addTarget:self action:@selector(topTableDidSelectRowAtIndex:) forControlEvents:UIControlEventTouchDown];
        //cell的字体颜色控制
            topcell.leftLab.textColor = CommonColor_Black;
        //作出选择后的字体颜色
        if (_spaceSelected && indexPath.row == 0) {
            topcell.rightLab.textColor = CommonColor_Blue;
        }
        if (_dateSelected && indexPath.row == 1) {
            topcell.rightLab.textColor = CommonColor_Blue;
        }
        if (_monthSelected && indexPath.row == 2) {
            topcell.rightLab.textColor = CommonColor_Blue;
        }
        
        return topcell;
        
    }else{
        
        ZZSpaceOnlineReserveSeartTableViewCell * bottomCell = [_bottomTable dequeueReusableCellWithIdentifier:bottomCellIDKey];
        [bottomCell initCellProperty:_spaceRooms index:indexPath.row name:nil];
        bottomCell.btnCheckBox.tag=indexPath.row;
        [bottomCell.btnCheckBox addTarget:self action:@selector(selectedButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        int i = (int)indexPath.row;
        bottomCell.btnCheckBox.selected = [((NSDictionary *)_spaceRooms[i])[@"isSelected"] boolValue] ;
       // bottomCell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return bottomCell;
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:_topTable]) {
        return 52;
    }else{
        return 55;
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([tableView isEqual:_topTable]) {
        return _subjects.count;
    }else return _spaceRooms.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([tableView isEqual:_bottomTable]) {
        UIButton * selectedBtn = [[UIButton alloc]init];
        selectedBtn.tag = (int)indexPath.row;
        [self selectedButtonPressed:selectedBtn];
    }

}


-(void)selectedButtonPressed:(UIButton *)sender
{
    int i = (int)sender.tag;
    //    ((SpaceCellModel *)_validMeetingRooms[i]).isSelected = !((SpaceCellModel *)_validMeetingRooms[i]).isSelected;
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:_spaceRooms[i]];
    if ([dict[@"isSelected"] boolValue]) {
        
        [dict removeObjectForKey:@"isSelected"];
        [dict setObject:[NSNumber numberWithBool:NO] forKey:@"isSelected"];
    }else{
        [dict removeObjectForKey:@"isSelected"];
        [dict setObject:[NSNumber numberWithBool:YES] forKey:@"isSelected"];
    }
    
    [_spaceRooms removeObjectAtIndex:i];
    [_spaceRooms insertObject:dict atIndex:i];
    NSLog(@"%@   %i",_spaceRooms,i);
    NSLog(@"2222");
}

#pragma -- mark GetMeetingSpaceCell REQUEST PART
-(void)getLinckiaSpaceCellDataFromServer
{
    BOOL selectedStarTime = NO,selectedEndTime = NO;
    
    if (![_placeholders[1] isEqualToString: @"请选择开始租用日期"]) {
        selectedStarTime = YES;
    }
    if(![_placeholders[2] isEqualToString: @"请选择租用时间"]){
        selectedEndTime = YES;
    }
    //满足条件发送请求
    if (selectedStarTime && selectedEndTime) {
        NSLog(@"开始发送请求");
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        NSString * userToken = [user valueForKey:USERTOKEN];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getSpaceCellDataRecieved:) name:[NSString stringWithFormat:@"%i",GetSpaceCell] object:nil];
        _GetSpaceCell = [[AFRquest alloc]init];
        _GetSpaceCell.style = GET;
        _GetSpaceCell.subURLString = @"api/Spaces/GetSpaceCell?";
        _GetSpaceCell.parameters = @{@"userToken":userToken,@"deviceType":@"ios",@"Page":[NSNumber numberWithInt:_currentPage],@"Rows":@10,@"SortProperty":@"Name",@"SortDirection":@"asc",@"SpaceId":[JCYGlobalData sharedInstance].spaceDetailInfo[@"Data"][@"SpaceId"],@"SpaceCellType":[NSNumber numberWithInt:_flag],@"StartTime":_placeholders[1],@"EndTime":_endStr};
        NSLog(@"%@",_GetSpaceCell.parameters);
        
        [_GetSpaceCell requestDataFromWithFlag:GetSpaceCell];
    }
}


-(void)getSpaceCellDataRecieved:(NSNotification *)notif{
    
     NSLog(@"%@",_GetSpaceCell.resultDict);
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",GetSpaceCell] object:nil];

   
    int code = [_GetSpaceCell.resultDict[@"Code"] intValue];
    if (code == SUCCESS) {
        NSMutableArray * rooms = _GetSpaceCell.resultDict[@"Data"][@"Data"];
        NSLog(@"rooms ================ %@",rooms);
        [self meetingSpaceCellDataHandle:rooms];
    }
    
}

-(void)meetingSpaceCellDataHandle:(NSMutableArray *)rooms{
    //如果返回的数据小于10条则隐藏加载更多数据的提示条
    if(rooms.count<10){
        _bottomTable.mj_footer.hidden = YES;
    }else{
        _bottomTable.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            [self getLinckiaSpaceCellDataFromServer];
        }];
        
    }
    if (_currentPage == 1) {
        _spaceRooms = [NSMutableArray array];
    }
    NSMutableArray *tempArr=[NSMutableArray array];
    for (NSDictionary *temp in rooms) {
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:temp];
        [dict setObject:[NSNumber numberWithBool:NO] forKey:@"isSelected"];
        [tempArr addObject:dict];
    }
    [_spaceRooms addObjectsFromArray:tempArr];

    [_bottomTable reloadData];
    _currentPage++;//拿到数据后页面数自加
    [_bottomTable.mj_footer endRefreshing];
    
    
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
