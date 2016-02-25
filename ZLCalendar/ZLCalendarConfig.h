//
//  ZLCalendarConfig.h
//  CustomCalendar
//

//

#ifndef CustomCalendar_ZLCalendarConfig_h
#define CustomCalendar_ZLCalendarConfig_h
#import "ZLCalendaData.h"
typedef enum{
    ///垂直方向
    CalendarArrangeStyleVertical,
    ///水平方向
    CalendarArrangeStyleHorizontal
}CalendarArrangeStyle;

typedef enum{
    CalendarReuseStyleDefualt,//默认
    CalendarReuseStyleLeft,//左滑
    CalendarReuseStyleRight//右滑
}CalendarReuseStyle;

typedef enum{
    ///上个月
    MonthChoiceTypePre,
    ///当月
    MonthChoiceTypeCurrent,
    ///下个月
    MonthChoiceTypeNext,
    ///空
    MonthChoiceTypeNull
}MonthChoiceType;

#define ContrlViewHeight 30 //控制视图的高度
#define WeekViewHeight 30 //星期视图高度
#define MarginLeft 10
#define ArrowWidth 30
#define VIEWCOUNT 3 //首次加载
#define ROWNUMBER 7
#define COLNUMBER 6

#endif
