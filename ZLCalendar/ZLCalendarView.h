//
//  Calendar.h
//  ZLCalendar
//

//

#import <UIKit/UIKit.h>
#import "ZLCalendarMonthPage.h"

@protocol ZLCalendarViewDelegate;
@protocol ZLCalendarViewDataSoucre;

@interface ZLCalendarView : UIView
@property (assign, nonatomic) IBOutlet id<ZLCalendarViewDelegate> delegate;
@property (assign, nonatomic) IBOutlet id<ZLCalendarViewDataSoucre> dataSource;
///月份model
@property (retain, nonatomic) ZLCalendarMonthModel *monthModel;

-(void)leftAndRightClickByDate:(CalendarReuseStyle)style;
@end

@protocol ZLCalendarViewDataSoucre <NSObject>
-(UIView *)calendarViewForHeader;
-(UIView *)calendarViewForFooter;
-(ZLCalendarDayView *)calendarViewForCell:(NSInteger)index dayViewWithSize:(CGSize)viewSize;
-(NSDate *)defualtDateWithCalendarView;
-(NSInteger)numberInCalendarView:(NSDate *)curretDate type:(MonthChoiceType)monthType;
@end

@protocol ZLCalendarViewDelegate  <NSObject>
@optional
-(void)didSelectRowAtCalendarView:(ZLCalendarDayView *)dayView;
-(void)calendarViewWithShowDate:(NSDate *)date;
@end
