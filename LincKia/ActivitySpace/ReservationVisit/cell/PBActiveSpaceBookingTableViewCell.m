//
//  PBActiveSpaceBookingTableViewCell.m
//  LincKia
//
//  Created by Phoebe on 15/12/25.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import "PBActiveSpaceBookingTableViewCell.h"

@implementation PBActiveSpaceBookingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)insertContentWithData:(NSArray *)array andIndexPath:(NSIndexPath*)index
{
    NSArray * data = array[index.row];
    self.icon.image = [UIImage imageNamed:data[0]];
    self.name.text = data[1];
    self.nameField.placeholder = data[2];
    if ((index.row > 2 && index.row < 7 )) {
        self.arrow.hidden = NO;
        self.nameField.userInteractionEnabled = NO;
    }else{
        self.arrow.hidden = YES;
        self.nameField.userInteractionEnabled = YES;
        if (index.row == 0) {
            self.name.textColor = CommonColor_Blue;
            self.nameField.textColor = CommonColor_Black;
            self.nameField.text = self.nameField.placeholder;
            self.nameField.userInteractionEnabled = NO;
        }
    }
}

@end
