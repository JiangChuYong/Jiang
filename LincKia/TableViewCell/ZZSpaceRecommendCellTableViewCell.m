//
//  ZZSpaceRecommendCellTableViewCell.m


#import "ZZSpaceRecommendCellTableViewCell.h"


@implementation ZZSpaceRecommendCellTableViewCell

- (void)awakeFromNib
{
    [_spaceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo((Main_Screen_Height+20)*0.3f);
    }];
    
    [_spaceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).with.offset(15);
        make.top.mas_equalTo(self.spaceImageView.mas_bottom).with.offset(8);
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(15);
        make.height.mas_equalTo(22);
    }];
    
    [_spaceAdressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.spaceNameLabel.mas_left);
        make.top.mas_equalTo(self.spaceNameLabel.mas_bottom);
        make.right.mas_equalTo(self.spaceNameLabel.mas_right);
        make.height.mas_equalTo(30);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}




@end
