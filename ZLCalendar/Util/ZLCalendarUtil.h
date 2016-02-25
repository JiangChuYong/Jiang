//
//  CUtil.h
//  ZLCalendar
//

//

#import <Foundation/Foundation.h>
#import "ZLNSDate+Logic.h"

@interface ZLCalendarUtil : NSObject

//根据日期判断农历
//根据日期判断节日
//components转换成日期
+(NSDate *)convertDateByDateComponents:(NSDateComponents *)components;

+(NSDate *)compartDate:(NSDateComponents *)components withDay:(NSInteger)day;
@end
