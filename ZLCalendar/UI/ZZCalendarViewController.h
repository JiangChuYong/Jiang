//
//  ViewController.h
//  ZLCalendar
//

//

#import <UIKit/UIKit.h>
#import "ZLCalendarView.h"

typedef void(^CallBackWithCalendar) (NSDate *date);
@interface ZZCalendarViewController : UIViewController<ZLCalendarViewDataSoucre,ZLCalendarViewDelegate>

@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet ZLCalendarView *calendarView;
@property (copy, nonatomic) CallBackWithCalendar callBack;
@property (assign, nonatomic) BOOL hideBeforeToday;
@property (assign, nonatomic) BOOL hideAfterValidDay;
@property (retain, nonatomic) ZLCalendarDayView *selectDayView;

+(ZZCalendarViewController *)shareCalendarVC;
@end
