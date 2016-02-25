//
//  DayLayoutView.h
//  ZLCalendar
//

//

#import <UIKit/UIKit.h>
#import "ZLCalendarConfig.h"
#import "ZLCalendarDayView.h"
#import "ZLCalendarMonthModel.h"
#import "ZLCalendarDataSource.h"

@interface ZLDayLayoutView : UIView
@property (retain, nonatomic) NSDate *currentDate;
@property (assign, nonatomic) id delegate;
@property (assign, nonatomic) id dataSource;

///dayView的排列布局
-(void)dayViewLayOutWithPage:(ZLCalendarMonthModel *)monthModel choiceType:(MonthChoiceType)type;
///刷新dayView的数据
-(void)reloadDayViewData;
@end
