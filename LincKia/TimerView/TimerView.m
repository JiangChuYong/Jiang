#import "TimerView.h"


@implementation TimerView
@synthesize countDownTimer;
static TimerView *timerView = nil;
+(id)shareTimerView
{
    if (timerView == nil) {
        timerView = [[TimerView alloc] init];
    }
    return timerView;
}
-(void)currentTime:(UIButton *)sender endTime:(void (^)())callback
{
    self.getCallBlock = callback;
    currentBtn = sender;
    secondsCountDown = GAME_TIME;//120秒倒计时
    
    for (UIView *view in sender.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(sender.frame), CGRectGetHeight(sender.frame))];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor redColor];
    //设置字体为斜体
    label.backgroundColor = [UIColor clearColor];
    label.text = [NSString stringWithFormat:@"剩余%d秒",secondsCountDown] ;
    [sender addSubview:label];
    
    if (sender.frame.size.width < 100) {
        [label setFont:[UIFont systemFontOfSize:11]];
    }
    
    if (countDownTimer) {
        [countDownTimer invalidate];
        countDownTimer = nil;
    }
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    
}

-(void)timeFireMethod{
    
    if (currentBtn.frame.size.width < 100) {
        [label setFont:[UIFont systemFontOfSize:11]];
    }
    
    secondsCountDown--;
    if(secondsCountDown==0){
        [countDownTimer invalidate];
        countDownTimer = nil;
        label.textColor = [UIColor blackColor];
        label.text = @"获取验证码";
        currentBtn.userInteractionEnabled = YES;
        if (_getCallBlock) {
            _getCallBlock();
        }
    }else{
        label.text = [NSString stringWithFormat:@"剩余%d秒",secondsCountDown];
        currentBtn.userInteractionEnabled = NO;
    }
}
@end
