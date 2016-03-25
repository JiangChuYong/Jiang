//
//  ZZMyOderDetailTableViewCell.h
//  LincKia
//
//  Created by 董玲 on 15/8/31.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZMyOderDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *endTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *cellNumLab;
@property (weak, nonatomic) IBOutlet UILabel *spaceCellTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *cellPriceLab;
@property (weak, nonatomic) IBOutlet UIImageView *partinglingImV;
@property (weak, nonatomic) IBOutlet UILabel *cellCodeLab;

@end
