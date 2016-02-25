//
//  DayView.m
//  ZLCalendar
//

//

#import "ZLCalendarDayView.h"
#import "ZLNSDate+Logic.h"

@implementation ZLCalendarDayView
#define WEEKCOLOR  [UIColor colorWithRed:54/255.0 green:191/255.0 blue:165/255.0 alpha:1]
#define WORKCOLOR  [UIColor colorWithRed:1/255.0 green:12/255.0 blue:23/255.0 alpha:1]
#define TODAYCOLOR [UIColor colorWithRed:247/255.0 green:187/255.0 blue:3/255.0 alpha:1]
#define EMPTYCOLOR [UIColor colorWithRed:170/255.0 green:171/255.0 blue:173/255.0 alpha:1]
#define CLICKCOLOR [UIColor colorWithRed:62/255.0 green:145/255.0 blue:249/255.0 alpha:1.0]

-(void)dealloc
{
    [_label release];
    [_bgImgView release];
    [_dayModel release];
    [super dealloc];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        self.bgImgView = imageView;
        [self addSubview:self.bgImgView];
        [imageView release];
        
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        tempLabel.textAlignment = NSTextAlignmentCenter;
        tempLabel.backgroundColor = [UIColor clearColor];
        tempLabel.textColor = [UIColor blackColor];
        self.label = tempLabel;
        [self addSubview:self.label];
        [tempLabel release];
    }
    return self;
}
///不可以点击 哪些情况下点击后不改变样式
-(BOOL)isEmptyStatus
{
    return self.dayModel.isEmpty;
}

///选中的状态
-(void)clickDayViewStyle
{
    if (self.dayModel.isEmpty) return;
    self.bgImgView.backgroundColor = CLICKCOLOR;
    [self selectStatus];
    self.label.textColor = [UIColor whiteColor];
}

///取消选中的状态
-(void)cancleClickDayViewStyle
{
    [self defualtStyleDayView];
}
///刷新视图的样式
-(void)reloadDayViewStyle
{
    self.label.text = [self.dayModel.date stringFromDate:@"dd"];
    
    [self defualtStyleDayView];///默认样式
    
    ///当先选中的日期样式
    if ([[ZLCalendaData shareCalendarData].selectDate isEqualToDate:self.dayModel.date] && !_dayModel.isEmpty) {
        self.bgImgView.backgroundColor = CLICKCOLOR;
        [self selectStatus];
        self.label.textColor = [UIColor whiteColor];
    }
    
}
///默认视图的样式
-(void)defualtStyleDayView
{
    self.label.textColor = WORKCOLOR;
    self.bgImgView.backgroundColor = [UIColor clearColor];
    [self noSelectStatus];
    ///补全上个月与下个月日期不可以编辑
    if (self.dayModel.isEmpty) {
        self.label.textColor = EMPTYCOLOR;
    }
    if (!self.dayModel.isWeek) {
        self.label.textColor = WEEKCOLOR;
    }
  
}
///小于今天灰掉
-(void)beforeTodayForHide
{
    NSDate *date = [[NSDate date] dateFromDate:@"yyyy-MM-dd"];
    if ([date minCompareDate:self.dayModel.date]) {
        self.label.textColor = EMPTYCOLOR;
        self.userInteractionEnabled = NO;
    }else{
        self.userInteractionEnabled = YES;
    }
}
///大于有效期的灰掉
-(void)afterValidDayForHide
{
    /**如果此处你需要修改日历显示的开始日期，请修改startDate,如果需要修改结束的日期请修改endDate,也可通过单例传值自动化处理显示的开始与结束日期*/
    NSDate *validDay = [NSDate dateWithTimeIntervalSinceNow:[JCYGlobalData sharedInstance].validDays*24*60*60];
    NSDate * temp = [NSDate dateWithTimeIntervalSinceNow:24*60*60];
    NSDate *startDate = [temp dateFromDate:@"yyyy-MM-dd"];
    NSDate *endDate = [validDay dateFromDate:@"yyyy-MM-dd"];
    if ([endDate maxCompareDate:self.dayModel.date] || [startDate minCompareDate:self.dayModel.date] ) {
        self.label.textColor = EMPTYCOLOR;
        self.userInteractionEnabled = NO;
    }else{
        self.userInteractionEnabled = YES;
    }
}
-(void)noSelectStatus
{
    CGRect rect = _bgImgView.frame;
    rect.size = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    rect.origin.y = 0;
    rect.origin.x = 0;
    _bgImgView.frame = rect;
    
    _bgImgView.layer.cornerRadius = 0;
}
-(void)selectStatus
{
    CGRect rect = _bgImgView.frame;
    int w_h = MIN(CGRectGetWidth(_bgImgView.frame), CGRectGetHeight(_bgImgView.frame));
    rect.size = CGSizeMake(w_h, w_h);
    rect.origin.y = (CGRectGetHeight(self.frame)-w_h)/2;
    rect.origin.x = (CGRectGetWidth(self.frame)-w_h)/2;
    _bgImgView.frame = rect;
    
    _bgImgView.layer.cornerRadius = w_h/2;
}
@end
