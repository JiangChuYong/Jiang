//
//  OtherTableViewCell.m

//自定义其他的cell

#import "OtherTableViewCell.h"

@implementation OtherTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
//分割线是否隐藏
- (void)separateLineHidden:(BOOL)hidden{
    [self.separateLineImageView setHidden:hidden];
}

@end
