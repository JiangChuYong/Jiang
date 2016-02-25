//
//  PBActiveSpaceBookingTableViewCell.h
//  LincKia
//
//  Created by Phoebe on 15/12/25.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBActiveSpaceBookingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet UITextField *nameField;

-(void)insertContentWithData:(NSArray *)array andIndexPath:(NSIndexPath*)index;

@end
