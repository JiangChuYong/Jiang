//
//  MeetingRoomOrderTableViewCell.h
//  LincKia
//
//  Created by Phoebe on 16/1/14.
//  Copyright (c) 2016年 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingRoomOrderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *numOfPerson;
@property (weak, nonatomic) IBOutlet UILabel *officeNo;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *type;

@end
