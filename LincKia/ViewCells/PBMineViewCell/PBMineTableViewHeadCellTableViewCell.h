//
//  PBMineTableViewHeadCellTableViewCell.h
//  LincKia
//
//  Created by Phoebe on 16/1/5.
//  Copyright (c) 2016年 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBMineTableViewHeadCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *phoneNumLab;
@property (weak, nonatomic) IBOutlet UILabel *LincKiaCoinNum;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UIImageView *bgview;
@property (weak, nonatomic) IBOutlet UIImageView *starFishCard;
@property (weak, nonatomic) IBOutlet UILabel *memLab;
@property (weak, nonatomic) IBOutlet UILabel *coinLab;
-(CGFloat)getCellHeight;

@end
