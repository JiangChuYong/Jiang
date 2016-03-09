//
//  PBAlertViewController.m
//  LincKia
//
//  Created by Phoebe on 16/1/8.
//  Copyright (c) 2016年 ZZ. All rights reserved.
//

#import "PBAlertViewController.h"
#import "Masonry.h"

@interface PBAlertViewController ()

@property (strong,nonatomic) UIImageView * alertView;

@end

@implementation PBAlertViewController

static PBAlertViewController *instance = nil;

+(PBAlertViewController *)shareInstance
{
    @synchronized(self){
        if (instance == nil) {
            instance = [[self alloc]init];
        }
    }
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView *)creatBackgroundViewAndAlertView
{
    self.view.userInteractionEnabled = YES;
    if (_backgroundImage) {
        [_backgroundImage removeFromSuperview];
    }
    _backgroundImage = [[UIImageView alloc]initWithFrame:self.view.frame];
    _backgroundImage.userInteractionEnabled = YES;
    //_backgroundImage.image = [UIImage imageNamed:@"bg.png"];
    _backgroundImage.backgroundColor=HalfClearColor;
    [self.view addSubview:_backgroundImage];
    
    CGFloat alertViewHeight = self.view.frame.size.height/3+40;
    CGFloat alertViewWidth = self.view.frame.size.width-80;
    if (_alertView) {
        [_alertView removeFromSuperview];
    }
    _alertView = [[UIImageView alloc]init];
    _alertView.userInteractionEnabled = YES;
    _alertView.frame= CGRectMake(_alertView.frame.origin.x, _alertView.frame.origin.y, alertViewWidth, alertViewHeight);
    
    [_alertView setCenter:CGPointMake(self.view.center.x, self.view.center.y-30)];
    _alertView.image = [UIImage imageNamed:@"pop-up.png"];
    [self.view addSubview:_alertView];

    return self.view;
}
-(void)addLeftButtonTile:(NSString *)leftString andRightButtonTitle:(NSString *)rightString withMessage:(NSString *)message
{
    
    CGFloat buttonWidth = (_alertView.frame.size.width-45)/2;
    CGFloat buttonHeight = 52;
    
    CGFloat buttonY = _alertView.frame.size.height-15-buttonHeight;
    /**取消按钮*/
    if (_cancelBtn) {
        [_cancelBtn removeFromSuperview];
    }
    _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, buttonY, buttonWidth, buttonHeight)];
    [_cancelBtn setTitle:leftString forState:UIControlStateNormal];
    _cancelBtn.backgroundColor = CommonColor_Gray;
    _cancelBtn.layer.cornerRadius = 5;
    _cancelBtn.clipsToBounds = YES;
    [_alertView addSubview:_cancelBtn];
    
    /**确定按钮*/
    if (_smallerSureBtn) {
        [_smallerSureBtn removeFromSuperview];
    }
    _smallerSureBtn = [[UIButton alloc]initWithFrame:CGRectMake(30+buttonWidth, buttonY, buttonWidth, buttonHeight)];
    [_smallerSureBtn setTitle:rightString forState:UIControlStateNormal];
    _smallerSureBtn.backgroundColor = CommonBackgroundColor_Orange;
    _smallerSureBtn.layer.cornerRadius = 5;
    _smallerSureBtn.clipsToBounds = YES;
    [_alertView addSubview:_smallerSureBtn];
    
    /**提示信息*/
    if (_messageLab) {
        [_messageLab removeFromSuperview];
    }
    _messageLab = [[UILabel alloc]init];
    _messageLab.text = message;
    [_messageLab setFont:[UIFont systemFontOfSize:17]];
    _messageLab.textColor = CommonColor_Gray;
    [_messageLab sizeToFit];
    [self.view addSubview:_messageLab];
    [_messageLab setCenter:_alertView.center];
}

-(void)addButtonWithTile:(NSString *)buttonTitle withMessage:(NSString *)message withSubSting:(NSString *)subString
{
    CGFloat buttonWidth = _alertView.frame.size.width-30;
    CGFloat buttonHeight = 52;
    CGFloat buttonY = _alertView.frame.size.height-15-buttonHeight;
    
    /**确认按钮*/
    if (_biggerSureBtn) {
        [_biggerSureBtn removeFromSuperview];
    }
    _biggerSureBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, buttonY, buttonWidth, buttonHeight)];
    [_biggerSureBtn setTitle:buttonTitle forState:UIControlStateNormal];
    _biggerSureBtn.backgroundColor = CommonBackgroundColor_Orange;
    _biggerSureBtn.layer.cornerRadius = 5;
    _biggerSureBtn.clipsToBounds = YES;

    [_alertView addSubview:_biggerSureBtn];
    
    
    /**提示信息*/
    if (_messageLab) {
        [_messageLab removeFromSuperview];
    }
    _messageLab = [[UILabel alloc]init];
    _messageLab.text = message;
    [_messageLab setFont:[UIFont systemFontOfSize:17]];
    _messageLab.textColor = CommonColor_Gray;
    [_messageLab sizeToFit];
    [self.view addSubview:_messageLab];
    [_messageLab setCenter:_alertView.center];
    
    /**解释信息*/
    CGFloat subLabCenterY = _messageLab.center.y+25;
    CGFloat subLabCenterX = _alertView.center.x;
    
    if (_subMessageLab) {
        [_subMessageLab removeFromSuperview];
    }
    _subMessageLab = [[UILabel alloc]init];
    _subMessageLab.text = subString;
    [_subMessageLab setFont:[UIFont systemFontOfSize:15]];
    _subMessageLab.textColor = CommonColor_Gray;
    [_subMessageLab sizeToFit];
    [self.view addSubview:_subMessageLab];
    [_subMessageLab setCenter:CGPointMake(subLabCenterX, subLabCenterY)];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
