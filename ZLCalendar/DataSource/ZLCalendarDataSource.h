//
//  CDataSource.h
//  ZLCalendar
//

//

#import <Foundation/Foundation.h>
#import "ZLCalendarDayModel.h"
#import "ZLCalendarUtil.h"

@interface ZLCalendarDataSource : NSObject

///计算当前日期之前几天或者是之后的几天（负数是之前几天，正数是之后的几天）
- (NSMutableArray *)reloadCalendarView:(NSDate *)date;
@end
