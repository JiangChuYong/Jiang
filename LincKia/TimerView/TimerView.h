#import <UIKit/UIKit.h>

#define TIME_INTERVAL		1.0
#define GAME_TIME			60

typedef enum {
    
    TimerViewSMSInPolicy,
    
    TimerViewSMSInPay
    
} TimerViewSate;


@protocol TimerViewDelegate <NSObject>;
@optional

- (void)timerViewInvalidate:(TimerViewSate)state;
@end



/*
 *TimerView Class 
 */

@interface TimerView : UIView
{
    int secondsCountDown;
    NSTimer *countDownTimer;
    UIButton *currentBtn;
    UILabel *label;
}
@property (retain, nonatomic) NSTimer *countDownTimer;
@property(nonatomic, strong) void(^getCallBlock)();

+(id)shareTimerView;
-(void)currentTime:(UIButton *)sender endTime:(void (^)())callback;

@end




