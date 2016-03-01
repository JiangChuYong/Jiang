//
//  PBMeetingRoomTableTopViewCell.h
//  LincKia
//
//  Created by Phoebe on 15/12/10.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBMeetingRoomTableTopViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *leftIcon;
@property (weak, nonatomic) IBOutlet UILabel *leftLab;
@property (weak, nonatomic) IBOutlet UIImageView *rightIcon;
@property (weak, nonatomic) IBOutlet UILabel *rightLab;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

@end
