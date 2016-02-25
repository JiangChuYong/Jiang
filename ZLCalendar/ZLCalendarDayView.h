//
//  DayView.h
//  ZLCalendar
//

//

#import <UIKit/UIKit.h>
#import "ZLCalendarDayModel.h"
#import "ZLCalendaData.h"
@interface ZLCalendarDayView : UIView

@property (retain, nonatomic) UILabel *label;
@property (retain, nonatomic) UIImageView *bgImgView;
@property (retain, nonatomic) ZLCalendarDayModel *dayModel;
///刷新视图的样式
-(void)reloadDayViewStyle;
///选中的状态
-(void)clickDayViewStyle;
///取消选中的状态
-(void)cancleClickDayViewStyle;
///不可以点击 哪些情况下点击后不改变样式
-(BOOL)isEmptyStatus;
///小于今天灰掉
-(void)beforeTodayForHide;
-(void)afterValidDayForHide;
@end
