//
//  MonthView.h
//  ZLCalendar
//

//

#import <UIKit/UIKit.h>
#import "ZLDayLayoutView.h"


@interface ZLCalendarMonthPage : UIView

@property (assign, nonatomic) id delegate;
@property (assign, nonatomic) id dataSource;

@property (retain, nonatomic) ZLCalendarMonthModel *monthModel;
///矫正日期
-(void)correctDate;
/** 日历滑动利用重用机制*/
-(void)reuseMechanismsLoadScrollViewData:(CalendarReuseStyle)style;
@end
