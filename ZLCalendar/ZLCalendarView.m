//
//  Calendar.m
//  ZLCalendar
//

//

#import "ZLCalendarView.h"
@interface ZLCalendarView()
@property (retain, nonatomic) UIView *weekView;
@property (retain, nonatomic) UIView *headerView;
@property (retain, nonatomic) UIView *footerView;
@property (retain, nonatomic) ZLCalendarMonthPage *monthView;
@end
@implementation ZLCalendarView
#define FOOTERVIEWHEIGHT 50 //底部view的高度
-(void)dealloc
{
    [_weekView release];
    [_monthModel release];
    [_monthView release];
    [ZLCalendaData calendarDataNull];
    [super dealloc];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        CGFloat height = Main_Screen_Height/3*2;
        self.frame=CGRectMake(0,Main_Screen_Height-height+20, Main_Screen_Width,height);
        [self initWeekView];
        [self initMonthModel];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat height = Main_Screen_Height/3*2;
        self.frame=CGRectMake(0,Main_Screen_Height-height+20, Main_Screen_Width,height);
        [self initWeekView];
        [self initMonthModel];
    }
    
    return  self;
}
-(void)initMonthModel
{
    ZLCalendarMonthModel *model = [[ZLCalendarMonthModel alloc] init];
    model.choiceMode = DateChoiceMode_Radio;
    model.arrangeStyle = CalendarArrangeStyleHorizontal;//默认水平
    model.isAllDate = YES;
    model.currentDate = [NSDate date];
    model.constrainEqu = YES;
    model.hideBeforeToday = NO;
    self.monthModel = model;
    [model release];
}
-(void)initWeekView
{
    NSArray *weekArray = [NSArray arrayWithObjects:@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 40)];
    view.backgroundColor = [UIColor colorWithRed:83/255.0 green:171/255.0 blue:242/255.0 alpha:1.0];
    self.weekView = view;
    [self addSubview:self.weekView];
    [view release];
    
    float width = (CGRectGetWidth(self.frame)-(weekArray.count+1))/weekArray.count;
    float x = (CGRectGetWidth(self.frame)-width*weekArray.count)/2;
    for (int i=0; i<weekArray.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x+width*i, 0, width, CGRectGetHeight(_weekView.frame))];
        label.backgroundColor = [UIColor clearColor];
        label.text = weekArray[i];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:15];
        label.adjustsFontSizeToFitWidth = YES;
        label.textAlignment = NSTextAlignmentCenter;
        [self.weekView addSubview:label];
        
        [label release];
    }
}

-(void)drawRect:(CGRect)rect
{
    [self headerViewWithCalendar];
    
    [self footerViewWitCalendar];
    
    [self contextView];
}

-(void)headerViewWithCalendar
{
    if ([_dataSource respondsToSelector:@selector(calendarViewForHeader)]) {
        
        if (self.headerView) {
            [self.headerView removeFromSuperview];
            self.headerView = nil;
        }
        
        UIView *view = [_dataSource calendarViewForHeader];
        view.frame = CGRectInset(view.frame, 0, 0);
        self.headerView = view;
        [view release];
        [self addSubview:self.headerView];
        CGRect rect = self.weekView.frame;
        rect.origin.y = CGRectGetHeight(self.headerView.frame);
        self.weekView.frame = rect;
    }
}

-(void)footerViewWitCalendar
{
    if ([_dataSource respondsToSelector:@selector(calendarViewForFooter)]) {
        if (self.footerView) {
            [self.footerView removeFromSuperview];
            self.footerView = nil;
        }
        
        UIView *view = [_dataSource calendarViewForFooter];
        CGRect rect = view.frame;
        rect.origin.y=CGRectGetHeight(self.frame)-CGRectGetHeight(view.frame);
        view.frame = rect;
        self.footerView = view;
        [view release];
        [self addSubview:self.footerView];
    }
    
}

-(void)contextView
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[ZLCalendarMonthPage class]]) {
            [view removeFromSuperview];
            view = nil;
        }
    }
    int footerHeight = 0;
    if (self.footerView) {
        footerHeight = CGRectGetHeight(self.footerView.frame);
    }
    CGFloat height = (_weekView.frame.origin.y + CGRectGetHeight(_weekView.frame));
    ZLCalendarMonthPage *view = [[ZLCalendarMonthPage alloc] initWithFrame:CGRectMake(0, height, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - height-footerHeight)];
    view.backgroundColor  = [UIColor yellowColor];
    view.delegate = _delegate;
    view.dataSource = _dataSource;
    view.monthModel = _monthModel;
    self.monthView = view;
    [self addSubview:_monthView];
    [view release];
}
-(void)leftAndRightClickByDate:(CalendarReuseStyle)style
{
    self.monthView.monthModel = self.monthModel;
    [self.monthView correctDate];
    [self.monthView reuseMechanismsLoadScrollViewData:style];
}
@end
