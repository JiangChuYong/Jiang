//
//  NSDate+Logic.h
//  CustomCalendar
//

//

#import <Foundation/Foundation.h>

@interface ZLCalendarDayModel : NSObject

///是否是工作日
@property (nonatomic,assign) BOOL isWeek;
///是否过期
@property (nonatomic,assign) BOOL isEmpty;
///是否今天
@property (nonatomic,assign) BOOL isToday;
///日期
@property (nonatomic,retain) NSDate *date;
///农历
@property (nonatomic,retain) NSString *Chinese_calendar;
///节日
@property (nonatomic,retain) NSString *holiday;
///是否可被选中
@property (nonatomic,assign) BOOL isClick;

@end
