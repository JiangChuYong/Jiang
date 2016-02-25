//
//  ZLCalendaData.h
//  ZLCalendar
//

//

#import <Foundation/Foundation.h>

@interface ZLCalendaData : NSObject
@property (retain, nonatomic) NSDate *selectDate;
@property (retain, nonatomic) NSMutableArray *dateArray;
+(ZLCalendaData *)shareCalendarData;
+(void)calendarDataNull;
@end
