//
//  DayLayoutView.m
//  ZLCalendar
//

//

#import "ZLDayLayoutView.h"
#import "ZLCalendarView.h"
@interface ZLDayLayoutView()
{
    int d_width;
    int d_x;
    int d_height;
}
@property (retain, nonatomic) NSMutableArray *dateArray;
@property (retain, nonatomic) ZLCalendarDayView *selectDayView;
@property (retain, nonatomic) NSMutableArray *monthArray;
@property (retain, nonatomic) ZLCalendarMonthModel *monthModel;
@end

@implementation ZLDayLayoutView

-(void)dealloc
{
    [_currentDate release];
    [super dealloc];
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

///dayView的排列布局
-(void)dayViewLayOutWithPage:(ZLCalendarMonthModel *)monthModel choiceType:(MonthChoiceType)type
{
    monthModel.selectDate = monthModel.selectDate?monthModel.selectDate:[NSDate date];
    self.monthModel = monthModel;
    for (UIView *dayView in self.subviews) {
        if ([dayView isKindOfClass:[ZLCalendarDayView class]] ||
            [dayView isKindOfClass:[UIImageView class]])
        {
            [dayView removeFromSuperview];
            dayView = nil;
        }
    }
    if (!self.dateArray) {
        self.dateArray = [NSMutableArray array];
    }
    [self.dateArray removeAllObjects];
    
    NSInteger count;
    if (_dataSource || [_dataSource respondsToSelector:@selector(numberInCalendarView:type:)]) {
        count = [_delegate numberInCalendarView:monthModel.currentDate type:type];
    }else{
        count = [self getMonthAllDayWithCurrentDate:monthModel.currentDate withType:type];
    }
    
    d_width = (self.frame.size.width-ROWNUMBER-1)/ROWNUMBER;
    int colNo = COLNUMBER;
    if (monthModel.constrainEqu) {
        colNo = (int)count/ROWNUMBER;
    }
    d_x = (self.frame.size.width-d_width *ROWNUMBER-(ROWNUMBER+1))/2;
    
    d_height = (self.frame.size.height-colNo-1)/colNo;
    
    for (int i=0; i<count/ROWNUMBER; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (i+1)*d_height+(i+1), CGRectGetWidth(self.frame), 1)];
        imageView.backgroundColor = [UIColor colorWithRed:179/255.0 green:201/255.0 blue:200/255.0 alpha:1.0];
        [self addSubview:imageView];
        [imageView release];
    }
    
    for (int i =0; i<count; i++) {
        int row = i/ROWNUMBER;
        int col = i%ROWNUMBER;
        CGRect frame = CGRectMake(d_x+d_width*col+(col+1), row*d_height+(row+1), d_width, d_height);
        ZLCalendarDayView *dayView;
        if (_dataSource || [_dataSource respondsToSelector:@selector(calendarViewForCell:dayViewWithSize:)]) {
            dayView = [_delegate calendarViewForCell:i dayViewWithSize:CGSizeMake(d_width, d_height)];
        }else{
            ZLCalendarDayModel *dayModel = self.monthArray[i];
            dayView = [[[ZLCalendarDayView alloc] initWithFrame:CGRectMake(0, 0, d_width, d_height)] autorelease];
            dayView.dayModel = dayModel;
        }
        dayView.frame = frame;
        [self.dateArray addObject:dayView];
        
        [self addGestureRecognizerWithDayView:dayView];
        [self addSubview:dayView];
    }
}
///刷新dayView的数据
-(void)reloadDayViewData
{
    for (ZLCalendarDayView *dayView in self.dateArray) {
        [dayView reloadDayViewStyle];
        
        if (self.monthModel.hideBeforeToday) {
            [dayView beforeTodayForHide];
        }
        
        if (self.monthModel.hideAfterValidDay) {
            [dayView afterValidDayForHide];
        }
    }
}
///加手势
-(void)addGestureRecognizerWithDayView:(UIView *)view
{
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [view addGestureRecognizer:singleRecognizer];
    
    [singleRecognizer release];
}
///实现方法
-(void)handleSingleTapFrom:(UITapGestureRecognizer*)recognizer
{
    ZLCalendarDayView *view = (ZLCalendarDayView *)recognizer.view;
    ZLCalendarDayView *preView = self.selectDayView;
    
    if ([view isEqual:preView] || [view isEmptyStatus])
        return;
    
    if ([view respondsToSelector:@selector(clickDayViewStyle)]) {
        [view clickDayViewStyle];
    }
    
    for (ZLCalendarDayView *dayView in self.dateArray) {
        
        if (preView && [dayView.dayModel.date isEqualToDate:preView.dayModel.date]) {
            
            if ([dayView respondsToSelector:@selector(cancleClickDayViewStyle)]) {
                
                [dayView cancleClickDayViewStyle];
            }
        }
    }
    self.selectDayView = view;
    _monthModel.selectDate = view.dayModel.date;

    if ([_delegate respondsToSelector:@selector(didSelectRowAtCalendarView:)])
    {
        [_delegate didSelectRowAtCalendarView:view];
    }
}

-(NSInteger)getMonthAllDayWithCurrentDate:(NSDate *)date withType:(MonthChoiceType)type
{
    date = date?date:[NSDate date];
    switch (type) {
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
-(NSMutableArray *)getMonthWithArray:(NSDate *)date
{
    ZLCalendarDataSource *data = [[ZLCalendarDataSource alloc] init];
    NSMutableArray *array =[data reloadCalendarView:date];
    [data release];
    return array;
}
@end
