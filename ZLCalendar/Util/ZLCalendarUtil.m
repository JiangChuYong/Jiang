//
//  CUtil.m
//  ZLCalendar
//

//

#import "ZLCalendarUtil.h"

@implementation ZLCalendarUtil

//components转换成日期
+(NSDate *)convertDateByDateComponents:(NSDateComponents *)components
{
    if (!components) return nil;
    
    NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-%ld",components.year,components.month,components.day];
    
    return [[NSDate date] dateFromString:dateStr];
}
+(NSDate *)compartDate:(NSDateComponents *)components withDay:(NSInteger)day
{
    if (!components) return nil;
    
    NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-%ld",components.year,components.month,day];
    
    return [[NSDate date] dateFromString:dateStr];
}
@end
