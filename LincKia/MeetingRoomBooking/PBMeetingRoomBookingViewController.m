//
//  PBMeetingRoomBookingViewController.m
//  LincKia
//
//  Created by Phoebe on 16/2/26.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "PBMeetingRoomTableTopViewCell.h"
#import "PBMeetingRoomBookingViewController.h"
#import "NIDropDown.h"
#import "ZZCalendarViewController.h"
#import "ZZSpaceOnlineReserveSeartTableViewCell.h"
#import "MJRefresh.h"

@interface PBMeetingRoomBookingViewController () <UITableViewDataSource,UITableViewDelegate,NIDropDownDelegate>

@property (weak, nonatomic) IBOutlet UITableView *topTable;
@property (weak, nonatomic) IBOutlet UITableView *bottomTable;
@property (weak, nonatomic) IBOutlet UIButton *bookingBtn;
@property (weak, nonatomic) IBOutlet UIImageView *cuttingLine;
@property (strong, nonatomic) UIView * backgroundMaskView;
@property(nonatomic,strong)NIDropDown *dropDown;
@property (assign, nonatomic) int currentPage;

@property (strong, nonatomic) NSMutableArray * placeholders;
@property (strong, nonatomic) NSArray * subjects;
@property (strong, nonatomic) NSArray * images;
@property (strong, nonatomic) NSMutableArray * startTimes;
@property (strong, nonatomic) NSMutableArray * endTimes;

@property (strong, nonatomic) NSMutableArray * spaces;
@property (strong, nonatomic) NSMutableArray * spaceList;
@property (strong, nonatomic) AFRquest * GetSpaceNameList;
@property (strong, nonatomic) AFRquest * GetMeetingSpaceCell;

@property (assign,nonatomic) BOOL spaceSelected;
@property (assign,nonatomic) BOOL dateSelected;
@property (assign,nonatomic) BOOL startTimeSelected;
@property (assign,nonatomic) BOOL endTimeSelected;
@property (assign,nonatomic) NSNumber * spaceID;

@property (strong,nonatomic) NSMutableArray * meetingRooms;

@end



@implementation PBMeetingRoomBookingViewController

static NSString * topCellIDKey = @"PBMeetingRoomTableTopViewCell";
static NSString * bottomCellIDKey = @"ZZSpaceOnlineReserveSeartTableViewCell";

-(void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.tabBarController.tabBar.hidden = YES;
    if (_meetingRooms) {
      //  [self requestValidMeetingRoomDataFromServer];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareDataForTableView];
    [self registerCellNibForTable];
    [self setUI];
    [self initData];
    [self requestGetSpaceNameListDataFromServer];
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
    _meetingRooms = [NSMutableArray array];
    _spaceSelected = NO;
    _dateSelected = NO;
    _startTimeSelected = NO;
    _endTimeSelected = NO;
    _meetingRooms = [NSMutableArray array];
}

-(void)registerCellNibForTable
{
    [_topTable registerNib:[UINib nibWithNibName:@"PBMeetingRoomTableTopViewCell" bundle:nil] forCellReuseIdentifier:topCellIDKey];
    [_bottomTable registerNib:[UINib nibWithNibName:@"ZZSpaceOnlineReserveSeartTableViewCell" bundle:nil] forCellReuseIdentifier:bottomCellIDKey];
}

-(void)prepareDataForTableView
{
    _placeholders = [NSMutableArray arrayWithObjects:@"请选择办公位置",@"请选择租用日期",@"请选择开始租用时间",@"请选择结束租用时间", nil];
    _subjects = [NSMutableArray arrayWithObjects:@"办公位置",@"租用日期", @"开始租用时间",@"结束租用时间", nil];
    _images = [NSMutableArray arrayWithObjects:@"office_position@3x.png",@"date.png",@"time.png", @"time.png",nil];
    //未选中状态下 默认的开始时间与结束时间
    _startTimes = [NSMutableArray arrayWithObjects:@"9:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00", nil];
    _endTimes = [NSMutableArray arrayWithObjects:@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00", nil];
    
    [_topTable reloadData];
}
#pragma -- mark ACTION PART

- (IBAction)bookingBtnPressed:(UIButton *)sender {
}
- (IBAction)back:(UIBarButtonItem *)sender {
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
        viewController.hideBeforeToday = YES;
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
                [_topTable reloadData];
                if ([date compare:[NSDate date]] == -1) {
                    _startTimes = [JCYGlobalData filterTimeArray:_startTimes];
                    _endTimes =  [JCYGlobalData filterTimeArray:_endTimes];
                }
               [self getMeetingSpaceCellDataFromServer];
            }
        };
        
        //开始时间
    }else if (row == 2){
        [self alertDropDownView:_startTimes tag:sender];
        
        //结束时间
    }else{
        [self alertDropDownView:_endTimes tag:sender];
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
    }
    
    if (tag == 2) {
        _startTimeSelected = YES;
        //选中开始时间后处理即将显示的结束时间数据
        _endTimes = [NSMutableArray arrayWithObjects:@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00", nil];
        for (int i=0; i<_endTimes.count; i++) {
            if ([_endTimes[i] isEqualToString:text]) {
                NSArray * temp = [_endTimes subarrayWithRange:NSMakeRange(i+1, _endTimes.count-i-1)];
                _endTimes = [NSMutableArray arrayWithArray:temp];
            }
        }
    }
    
    if(tag == 3){

        _endTimeSelected = YES;
        //选中结束时间后处理即将显示的结束时间数据
        _startTimes = [NSMutableArray arrayWithObjects:@"9:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00", nil];
        for (int i=0; i<_startTimes.count; i++) {
            if ([_startTimes[i] isEqualToString:text]) {
                NSLog(@"%@",text);
                NSArray * temp = [_startTimes subarrayWithRange:NSMakeRange(0,i)];
                _startTimes = [NSMutableArray arrayWithArray:temp];
            }
        }
    }
    [_placeholders replaceObjectAtIndex:tag withObject:text];
    [_topTable reloadData];
    [self rel];
    
    //获取选中空间的ID
    if (tag == 0) {
        for (int i=0; i<_spaces.count; i++) {
            NSDictionary * space = _spaces[i];
            if ([space[@"SpaceName"] isEqual:text]) {
                _spaceID = space[@"SpaceId"];
            }
        }
    }
    
    [self getMeetingSpaceCellDataFromServer];
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
        if (indexPath.row == 0) {
            topcell.leftLab.textColor = CommonColor_Blue;
        }else{
            topcell.leftLab.textColor = CommonColor_Black;
        }
        //作出选择后的字体颜色
        if (_spaceSelected && indexPath.row == 0) {
            topcell.rightLab.textColor = CommonColor_Blue;
        }
        if (_dateSelected && indexPath.row == 1) {
            topcell.rightLab.textColor = CommonColor_Blue;
        }
        if (_startTimeSelected && indexPath.row == 2) {
            topcell.rightLab.textColor = CommonColor_Blue;
        }
        if (_endTimeSelected && indexPath.row == 3) {
            topcell.rightLab.textColor = CommonColor_Blue;
        }
        
        return topcell;
        
    }else{
        
        ZZSpaceOnlineReserveSeartTableViewCell * bottomCell = [_bottomTable dequeueReusableCellWithIdentifier:bottomCellIDKey];
        [bottomCell initCellProperty:_meetingRooms index:indexPath.row name:nil];
//        //选择框
//        @property (weak, nonatomic) IBOutlet UIButton *btnCheckBox;
//        //房间号
//        @property (weak, nonatomic) IBOutlet UILabel *labelRoomNum;
//        //价格
//        @property (weak, nonatomic) IBOutlet UILabel *labelPriceNum;
//        //房间人数
//        @property (weak, nonatomic) IBOutlet UILabel *labelPeopleNum;
//        @property (weak, nonatomic) IBOutlet UILabel *officeTypeLabel;
//        @property (weak, nonatomic) IBOutlet UILabel *officePersonNum;
//        @property (weak, nonatomic) IBOutlet UIImageView *separateLine;
//        @property (weak, nonatomic) IBOutlet UILabel *unitLabel;
     //   bottomCell.btnCheckBox.selected = ((SpaceCellModel *)_validMeetingRooms[i]).isSelected ;
       // bottomCell.unitLabel.text = @"/小时";
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
    }else return _meetingRooms.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

   
}


#pragma -- mark GetSpaceNameList Request

-(void)requestGetSpaceNameListDataFromServer{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * userToken = [user valueForKey:USERTOKEN];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetSpaceListDataReceived:) name:[NSString stringWithFormat:@"%i",GetSpaceNameList] object:nil];
    _GetSpaceNameList = [[AFRquest alloc]init];
    _GetSpaceNameList.style = GET;
    _GetSpaceNameList.subURLString = @"api/Spaces/GetSpaceNameList?";
    _GetSpaceNameList.parameters = @{@"userToken":userToken,@"deviceType":@"ios",@"Page":@1,@"Rows":@10,@"SortProperty":@"Name",@"SortDirection":@"asc"};
    [_GetSpaceNameList requestDataFromWithFlag:GetSpaceNameList];
}



-(void)GetSpaceListDataReceived:(NSNotification *)notif{
    
    NSDictionary * dict = _GetSpaceNameList.resultDict[@"Data"];
    _spaces = dict[@"Data"];
    NSMutableArray * nameList = [NSMutableArray array];
    for (NSDictionary * temp in _spaces) {
        [nameList addObject:temp[@"SpaceName"]];
    }
    _spaceList = [NSMutableArray arrayWithArray:nameList];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",GetSpaceNameList] object:nil];
}



#pragma -- mark GetMeetingSpaceCell REQUEST PART
-(void)getMeetingSpaceCellDataFromServer
{
    //满足条件发送请求
    if (_spaceSelected && _dateSelected && _startTimeSelected && _endTimeSelected) {
        NSLog(@"开始发送请求");
        NSString * start = [NSString stringWithFormat:@"%@ %@:00",_placeholders[1],_placeholders[2]];
        NSString * end = [NSString stringWithFormat:@"%@ %@:00",_placeholders[1],_placeholders[3]];
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        NSString * userToken = [user valueForKey:USERTOKEN];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getMeetingSpaceCellDataRecieved:) name:[NSString stringWithFormat:@"%i",GetMeetingSpaceCell] object:nil];
        _GetMeetingSpaceCell = [[AFRquest alloc]init];
        _GetMeetingSpaceCell.style = GET;
        _GetMeetingSpaceCell.subURLString = @"api/Spaces/GetMeetingSpaceCell?";
        _GetMeetingSpaceCell.parameters = @{@"userToken":userToken,@"deviceType":@"ios",@"Page":[NSNumber numberWithInt:_currentPage],@"Rows":@10,@"SortProperty":@"Name",@"SortDirection":@"asc",@"SpaceId":_spaceID,@"RentDate":_placeholders[1],@"StartTime":start,@"EndTime":end};
        
        NSLog(@"%@",_GetMeetingSpaceCell.parameters);
        
        [_GetSpaceNameList requestDataFromWithFlag:GetMeetingSpaceCell];
    }
}


-(void)getMeetingSpaceCellDataRecieved:(NSNotification *)notif{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",GetMeetingSpaceCell] object:nil];
    int code = [_GetMeetingSpaceCell.resultDict[@"Code"] intValue];
    if (code == SUCCESS) {
        NSMutableArray * rooms = _GetMeetingSpaceCell.resultDict[@"Data"][@"Data"];
        NSLog(@"rooms ================ %@",rooms);
        [self meetingSpaceCellDataHandle:rooms];
    }
}

-(void)meetingSpaceCellDataHandle:(NSMutableArray *)rooms{
    
    //首先判断是否第一次加载数据，如果是清空数组
    if (rooms.count < 10 && _currentPage == 1) {
        [_meetingRooms removeAllObjects];
    }
    //加载拿到的数据
    [_meetingRooms addObjectsFromArray:rooms];
    [_bottomTable reloadData];
    
    //如果拿到的数据等于10提示加载更多数据
    if (rooms.count == 10) {
        _currentPage++;
        MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMeetingSpaceCellDataFromServer)];
        _bottomTable.mj_footer = footer;
    }
    
    //如果拿到的数据小于10提示无更多数据
    else if (rooms.count < 10) {
        _currentPage = 1;
        [_bottomTable.mj_footer endRefreshingWithNoMoreData];
    }
    
}





























@end
