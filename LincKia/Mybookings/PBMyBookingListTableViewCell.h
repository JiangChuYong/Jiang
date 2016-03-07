//
//  PBMyBookingListTableViewCell.h
//  LincKia
//
//  Created by Phoebe on 15/11/30.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBMyBookingListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *numOfPerson;
@property (weak, nonatomic) IBOutlet UILabel *others;
@property (weak, nonatomic) IBOutlet UILabel *bookingTime;

@end
