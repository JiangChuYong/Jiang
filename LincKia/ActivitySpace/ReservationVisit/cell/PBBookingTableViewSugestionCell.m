//
//  PBBookingTableViewSugestionCell.m
//  LincKia
//
//  Created by Phoebe on 15/12/25.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import "PBBookingTableViewSugestionCell.h"

@implementation PBBookingTableViewSugestionCell

- (void)awakeFromNib {
    // Initialization code
    _suggestion.layer.cornerRadius = 5;
    _suggestion.clipsToBounds = YES;
    _suggestion.layer.borderWidth = 0.5;
    _suggestion.layer.borderColor = CommonBackgroundColor_gray.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
