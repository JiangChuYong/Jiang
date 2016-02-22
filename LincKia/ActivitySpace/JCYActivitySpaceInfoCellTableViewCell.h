//
//  JCYActivitySpaceInfoCellTableViewCell.h
//  LincKia
//
//  Created by JiangChuyong on 15/12/28.
//  Copyright © 2015年 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCYActivitySpaceInfoCellTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLable;
@property (strong, nonatomic) IBOutlet UILabel *priceLable;
@property (strong, nonatomic) IBOutlet UILabel *activitySpaceDetailsInfoLable;
@property (strong, nonatomic) IBOutlet UILabel *addressLable;
@property (strong, nonatomic) IBOutlet UIButton *pushToIntroPageButton;
@property (strong, nonatomic) IBOutlet UIButton *naviButton;

@end
