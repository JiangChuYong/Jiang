//
//  ExpressTableViewCell.h
//  LincKia
//
//  Created by Phoebe on 16/2/22.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpressTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *leftIcon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;
@property (weak, nonatomic) IBOutlet UIImageView *rightIcon;

@end
