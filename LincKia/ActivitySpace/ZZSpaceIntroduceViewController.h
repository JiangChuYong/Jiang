//
//  ZZSpaceIntroduceViewController.h
//  LincKia
//
//  Created by Phoebe on 15/8/14.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZSpaceIntroduceViewController : UIViewController<UIScrollViewDelegate,UIScrollViewAccessibilityDelegate>

//pagecontrol
@property (assign,nonatomic) int numOfTotalPage;
@property (assign,nonatomic) int currentPage;

@property (weak, nonatomic) IBOutlet UILabel *pageLable;

@property (weak, nonatomic) IBOutlet UITextView *introduceContent;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (strong, nonatomic) NSDictionary *spaceDetailInfo;

@property (strong, nonatomic) NSDictionary *activeSpaceDetailInfo;

@property (weak, nonatomic) IBOutlet UIScrollView *spaceScrollView;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (assign,nonatomic) BOOL isActiveSpace;
@property (strong, nonatomic) IBOutlet UILabel *nameLable;

- (IBAction)bactToLastPage:(UIButton *)sender;

@end
