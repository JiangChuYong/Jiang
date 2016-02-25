//
//  NSDate+Logic.h
//  CustomCalendar
//

//
#import "ZLCalendarDayModel.h"
#import "ZLNSDate+Logic.h"

@implementation ZLCalendarDayModel

-(void)dealloc
{
	// TODO ****  
    [super dealloc];
}

-(BOOL)isWeek
{
    NSInteger week = [self.date getWeekIntValueWithDate];
    if (week == 1 || week == 7) {
        return NO;
    }else{
        return YES;
    }
}
@end
