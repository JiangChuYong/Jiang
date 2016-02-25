//
//  ZLCalendarMonthModel.h
//  ZLCalendar
//

//

#import <Foundation/Foundation.h>
#import "ZLCalendarConfig.h"

typedef enum {
	///单选
	DateChoiceMode_Radio,
	///滑动多选
	DateChoiceMode_Multiple,
	///两点之间取时间段
	DateChoiceMode_DoublePoint
}DateChoiceMode;
@interface ZLCalendarMonthModel : NSObject
///模式
@property (nonatomic,assign) DateChoiceMode choiceMode;
///排版方式
@property (nonatomic,assign) CalendarArrangeStyle arrangeStyle;
///是否补全日期
@property (nonatomic,assign) BOOL isAllDate;
///当前时间
@property (nonatomic,retain) NSDate *currentDate;
///最大日期值
@property (nonatomic,retain) NSDate *maxDate;
///最小日期值
@property (nonatomic,retain) NSDate *minDate;
///等比例高度
@property (nonatomic,assign) BOOL constrainEqu;
@property (nonatomic, retain) NSDate *selectDate;
///小于今天灰掉
@property (nonatomic,assign) BOOL hideBeforeToday;
///大于有效期灰掉
@property (nonatomic,assign) BOOL hideAfterValidDay;

@end
