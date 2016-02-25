//
//  ZLCalendaData.m
//  ZLCalendar
//

//

#import "ZLCalendaData.h"
static ZLCalendaData *shareCalendar = nil;
@implementation ZLCalendaData
+(ZLCalendaData *)shareCalendarData
{
    if (!shareCalendar) {
        shareCalendar = [[ZLCalendaData alloc] init];
    }
    return shareCalendar;
}
+(void)calendarDataNull
{
    if (shareCalendar) {
        shareCalendar = nil;
    }
}
@end
