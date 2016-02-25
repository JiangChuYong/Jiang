//
//  NSDate+Logic.h
//  CustomCalendar
//

//

#import <Foundation/Foundation.h>

@interface NSDate (Logic)

- (NSUInteger)numberOfDaysInCurrentMonth;

- (NSUInteger)numberOfWeeksInCurrentMonth;

- (NSUInteger)weeklyOrdinality;

- (NSDate *)firstDayOfCurrentMonth;

- (NSDate *)lastDayOfCurrentMonth;

- (NSDate *)dayInThePreviousMonth;

- (NSDate *)dayInTheFollowingMonth;

- (NSDate *)dayInTheFollowingMonth:(int)month;//获取当前日期之后的几个月

- (NSDate *)dayInTheFollowingDay:(int)day;//获取当前日期之后的几个天

- (NSDateComponents *)YMDComponents;

- (NSDate *)dateFromString:(NSString *)dateString;//NSString转NSDate

- (NSString *)stringFromDate:(NSString *)format;//NSDate转NSString

- (NSDate *)dateFromDate:(NSString *)format;

+ (NSInteger)getDayNumbertoDay:(NSDate *)today beforDay:(NSDate *)beforday;

-(NSInteger)getWeekIntValueWithDate;



//判断日期是今天,明天,后天,周几
-(NSString *)compareIfTodayWithDate;
//通过数字返回星期几
+(NSString *)getWeekStringFromInteger:(NSInteger)week;

/**  maxDate大于self*/
-(BOOL)maxCompareDate:(NSDate *)maxDate;
/**  minDate小于self*/
-(BOOL)minCompareDate:(NSDate *)minDate;
/**  date等于self*/
-(BOOL)equalCompareDate:(NSDate *)date;

@end
