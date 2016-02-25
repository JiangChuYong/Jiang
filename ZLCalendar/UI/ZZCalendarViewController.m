//
//  ViewController.m
//  ZLCalendar
//

//

#import "ZZCalendarViewController.h"
#import "Masonry.h"

static ZZCalendarViewController *shareCalendarVC = nil;

@interface ZZCalendarViewController ()

@property (retain, nonatomic) NSMutableArray *monthArray;
@property (retain, nonatomic) UIButton *dateBtn;
@property (retain, nonatomic) NSDate *selectDate;
@end

@implementation ZZCalendarViewController
- (void)dealloc {
    [_dateLabel release];
    [_calendarView release];
    [_selectDayView release];
    [super dealloc];
}

+(ZZCalendarViewController *)shareCalendarVC
{
	if (!shareCalendarVC) {
		shareCalendarVC = [[ZZCalendarViewController alloc] initWithNibName:@"ZZCalendarViewController" bundle:nil];
    }else{
        [shareCalendarVC release];
        shareCalendarVC = [[ZZCalendarViewController alloc]initWithNibName:@"ZZCalendarViewController" bundle:nil];
    }
	return shareCalendarVC;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.monthArray = [NSMutableArray array];
    self.calendarView.monthModel.hideBeforeToday = self.hideBeforeToday;//小于今日不可点击
    self.calendarView.monthModel.arrangeStyle = CalendarArrangeStyleHorizontal;
    self.calendarView.monthModel.hideAfterValidDay = self.hideAfterValidDay;
    if (SCREEN_HEIGHT == 480.0f) {//判断iPhone4s
        CGRect frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 88, self.view.frame.size.width, self.view.frame.size.height);
        self.view.frame = frame;
    }else{
        CGRect frame = CGRectMake(0,0, Main_Screen_Width,Main_Screen_Height+20);
        self.view.frame = frame;
    }
    
    
//    self.calendarView.monthModel.currentDate = [[NSDate date] dayInTheFollowingMonth];  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch  locationInView:self.view];
    CGRect rect = self.view.frame;
    rect.size.height -= CGRectGetHeight(_calendarView.frame);
    
    if (CGRectContainsPoint(rect, point)) {
        [self.view removeFromSuperview];
    }
}

#pragma mark - CalendarDelegate
//返回headerView
-(UIView *)calendarViewForHeader
{
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 50)];
    tempView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 52)];
    imageView.image = [UIImage imageNamed:@"calendarTop"];
    [tempView addSubview:imageView];
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(10, 0, 30, CGRectGetHeight(tempView.frame));
    [leftBtn setTitle:@"<" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:leftBtn];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(CGRectGetWidth(tempView.frame)-10-30, 0, 30, CGRectGetHeight(tempView.frame));
    [rightBtn setTitle:@">" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:rightBtn];
    
    
    self.dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dateBtn.frame = CGRectMake(30+10, 0, CGRectGetWidth(tempView.frame)-30*2-10*2, CGRectGetHeight(tempView.frame));
    [self.dateBtn setTitleColor:[UIColor colorWithRed:21.0/255.0 green:159.0/255.0 blue:190.0/255.0 alpha:1] forState:UIControlStateNormal];
    self.dateBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.dateBtn setTitle:@"" forState:UIControlStateNormal];
    [self.dateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.dateBtn addTarget:self action:@selector(dateBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:self.dateBtn];
    
    return tempView;
}
-(UIView *)calendarViewForFooter
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 50)];
    footerView.backgroundColor = [UIColor colorWithRed:213/255.0 green:225/255.0 blue:235/255.0 alpha:1];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(0, 0, CGRectGetWidth(footerView.frame), CGRectGetHeight(footerView.frame));
    [sureBtn setTitleColor:[UIColor colorWithRed:21/255.0 green:98/255.0 blue:175/255.0 alpha:1] forState:UIControlStateNormal];;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:sureBtn];
    
    return footerView;
}
//返回数组长度
-(NSInteger)numberInCalendarView:(NSDate *)curretDate type:(MonthChoiceType)monthType
{
    NSDate *date = curretDate?curretDate:[NSDate date];
    switch (monthType) {
        case MonthChoiceTypePre:
        {
            date = [date dayInThePreviousMonth];
            break;
        }
        case MonthChoiceTypeCurrent:
        {
            break;
        }
        case MonthChoiceTypeNext:
        {
            date = [date dayInTheFollowingMonth];
            
            break;
        }
        default:
            break;
    }
    self.monthArray = [self getMonthWithArray:date];
    
    return self.monthArray.count;
}
//输入默认日期
-(NSDate *)defualtDateWithCalendarView
{
    return [NSDate date];
}
//自定义dayView Cell
-(ZLCalendarDayView *)calendarViewForCell:(NSInteger)index dayViewWithSize:(CGSize)viewSize
{
    ZLCalendarDayModel *dayModel = self.monthArray[index];
    ZLCalendarDayView *dayView = [[ZLCalendarDayView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height)];
    dayView.dayModel = dayModel;
    return dayView;
}

#define ZLDateFormatString @"yyyy年MM月"
//显示选择后的日期
-(void)calendarViewWithShowDate:(NSDate *)date
{
    [self.dateBtn setTitle:[date stringFromDate:ZLDateFormatString] forState:UIControlStateNormal];
}
-(void)didSelectRowAtCalendarView:(ZLCalendarDayView *)dayView
{
    [ZLCalendaData shareCalendarData].selectDate = dayView.dayModel.date;
    ZLCalendarDayModel *dayModel = dayView.dayModel;
    self.dateLabel.text = [dayModel.date stringFromDate:@"yyyy-MM-dd"];
    _selectDayView = dayView;
}

-(NSMutableArray *)getMonthWithArray:(NSDate *)date
{
    ZLCalendarDataSource *data = [[ZLCalendarDataSource alloc] init];
    NSMutableArray *array =[data reloadCalendarView:date];
    return array;
}
#pragma mark - 按钮点击事件
-(void)leftBtnPressed:(UIButton *)button
{
    NSString *dateStr = [self.dateBtn titleForState:UIControlStateNormal];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:ZLDateFormatString];
    
    NSDate *date = [formatter dateFromString:dateStr];
    date = [date dayInThePreviousMonth];
    
    self.calendarView.monthModel.currentDate = date;
    
    [self.calendarView leftAndRightClickByDate:CalendarReuseStyleRight];
}
-(void)rightBtnPressed:(UIButton *)button
{
    NSString *dateStr = [self.dateBtn titleForState:UIControlStateNormal];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:ZLDateFormatString];
    
    NSDate *date = [formatter dateFromString:dateStr];
    date = [date dayInTheFollowingMonth];
    
    self.calendarView.monthModel.currentDate = date;
    
    [self.calendarView leftAndRightClickByDate:CalendarReuseStyleLeft];
}
-(void)dateBtnPressed:(UIButton *)button
{
    
}
-(void)sureBtnPressed:(UIButton *)button
{
//    NSLog(@"----%@",[self.calendarView.monthModel.selectDate stringFromDate:@"yyyy-MM-dd"]);
    if (self.callBack) {
        self.callBack(self.calendarView.monthModel.selectDate);
    }
    
    [self.view removeFromSuperview];
}
@end
