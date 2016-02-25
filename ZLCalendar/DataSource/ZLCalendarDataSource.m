//
//  CDataSource.m
//  ZLCalendar
//

//

#import "ZLCalendarDataSource.h"
#import "ZLCalendarConfig.h"
@interface ZLCalendarDataSource()
{
    NSDate *today;
}
@end

@implementation ZLCalendarDataSource

//计算当前日期之前几天或者是之后的几天（负数是之前几天，正数是之后的几天）
- (NSMutableArray *)reloadCalendarView:(NSDate *)date
{
    today = [[NSDate date] dateFromDate:@"yyyy-MM-dd"];
    //如果为空就从当天的日期开始
    if(date == nil){
        date = [NSDate date];
    }
    
    NSDate *month = [date dayInTheFollowingMonth:0];
    NSMutableArray *calendarDays = [NSMutableArray array];
    [self calculateDaysInPreviousMonthWithDate:month andArray:calendarDays];
    [self calculateDaysInCurrentMonthWithDate:month andArray:calendarDays];
    [self calculateDaysInFollowingMonthWithDate:month andArray:calendarDays];//计算下月份的天数
    
    return calendarDays;
    
}
#pragma mark - 日历上+当前+下月份的天数

//计算上月份的天数

- (NSMutableArray *)calculateDaysInPreviousMonthWithDate:(NSDate *)date andArray:(NSMutableArray *)array
{
    NSUInteger weeklyOrdinality = [[date firstDayOfCurrentMonth] weeklyOrdinality];//计算这个的第一天是礼拜几,并转为int型
    NSDate *dayInThePreviousMonth = [date dayInThePreviousMonth];//上一个月的NSDate对象
    NSUInteger daysCount = [dayInThePreviousMonth numberOfDaysInCurrentMonth];//计算上个月有多少天
    NSUInteger partialDaysCount = weeklyOrdinality - 1;//获取上月在这个月的日历上显示的天数
    NSDateComponents *components = [dayInThePreviousMonth YMDComponents];//获取年月日对象
    
    for (NSUInteger i = daysCount - partialDaysCount + 1; i < daysCount + 1; ++i) {
        
        ZLCalendarDayModel *dayModel = [[ZLCalendarDayModel alloc] init];
        dayModel.date = [ZLCalendarUtil compartDate:components withDay:i];
        dayModel.isEmpty = YES;
        [array addObject:dayModel];
        
        [dayModel release];
    }
    
    
    return NULL;
}



//计算下月份的天数

- (void)calculateDaysInFollowingMonthWithDate:(NSDate *)date andArray:(NSMutableArray *)array
{
    NSUInteger weeklyOrdinality = [[date lastDayOfCurrentMonth] weeklyOrdinality];
    if (weeklyOrdinality == 7) return ;
    
    NSUInteger partialDaysCount = 7 - weeklyOrdinality;
    NSDateComponents *components = [[date dayInTheFollowingMonth] YMDComponents];
    
    for (int i = 1; i < partialDaysCount + 1; ++i) {
        ZLCalendarDayModel *dayModel = [[ZLCalendarDayModel alloc] init];
        dayModel.date = [ZLCalendarUtil compartDate:components withDay:i];
        dayModel.isEmpty = YES;
        [array addObject:dayModel];
        [dayModel release];
    }
}


//计算当月的天数

- (void)calculateDaysInCurrentMonthWithDate:(NSDate *)date andArray:(NSMutableArray *)array
{
    
    NSUInteger daysCount = [date numberOfDaysInCurrentMonth];//计算这个月有多少天
    NSDateComponents *components = [date YMDComponents];//今天日期的年月日
    
    for (int i = 1; i < daysCount + 1; ++i) {
        ZLCalendarDayModel *dayModel = [[ZLCalendarDayModel alloc] init];
        dayModel.date = [ZLCalendarUtil compartDate:components withDay:i];
        [self changeStyle:dayModel];
        [array addObject:dayModel];
        [dayModel release];
    }
}

-(void)changeStyle:(ZLCalendarDayModel *)dayModel
{
    if ([dayModel.date isEqualToDate:today]) {
        dayModel.isToday = YES;
    }
}
@end
