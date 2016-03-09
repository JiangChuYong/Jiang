//
//  PBAlertViewController.h
//  LincKia
//
//  Created by Phoebe on 16/1/8.
//  Copyright (c) 2016年 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
@protocol PBAlerViewDelegate <NSObject>



@end

@interface PBAlertViewController : UIViewController

/** 代理对象 */
@property (nonatomic, strong) id<PBAlerViewDelegate> delegate;

@property (strong,nonatomic) UILabel * messageLab;
@property (strong,nonatomic) UILabel * subMessageLab;
@property (strong,nonatomic) UIButton * cancelBtn;
@property (strong,nonatomic) UIButton * smallerSureBtn;
@property (strong,nonatomic) UIImageView * backgroundImage;
@property (strong,nonatomic) UIButton * biggerSureBtn;

+(PBAlertViewController *)shareInstance;

- (UIView *)creatBackgroundViewAndAlertView;
//创建带两个按钮的提示页面
-(void)addLeftButtonTile:(NSString *)leftString andRightButtonTitle:(NSString *)rightString withMessage:(NSString *)message;
//创建带单个按钮的提示页面
-(void)addButtonWithTile:(NSString *)buttonTitle withMessage:(NSString *)message withSubSting:(NSString *)subString;

@end
