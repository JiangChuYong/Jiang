//
//  PBMineTableViewHeadCellTableViewCell.m
//  LincKia
//
//  Created by Phoebe on 16/1/5.
//  Copyright (c) 2016年 ZZ. All rights reserved.
//

#import "PBMineTableViewHeadCellTableViewCell.h"
#import "Masonry.h"

@implementation PBMineTableViewHeadCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
    //头像处理
    _headPic.layer.cornerRadius = _headPic.frame.size.height/2;
    _headPic.clipsToBounds = YES;
    
    if (Main_Screen_Width > 320) {
        [self resetBgView];
        [self resetPhoneLab];
        [self resetHeadUI];
        [self resetStarFishCardImage];
    }

}

-(CGFloat)getCellHeight{
    CGFloat scale = Main_Screen_Width/320;
    CGFloat height = CGRectGetHeight(self.contentView.frame)*scale;
    return height;
}
-(void)resetBgView{
    CGFloat scale = Main_Screen_Width/320;
    CGFloat height = CGRectGetHeight(_bgview.frame)*scale;
    
    [_bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(height);
    }];
}

-(void)resetPhoneLab
{
    [_phoneNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgview.mas_bottom);
        make.left.mas_equalTo(self.bgview.mas_left).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(Main_Screen_Width-30, 60));
    }];
    _phoneNumLab.font = [UIFont systemFontOfSize:17];
}

-(void)resetHeadUI
{
    [_headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bgview.mas_centerY);
        make.left.mas_equalTo(self.bgview.mas_left).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(104,104));
    }];
    
    [_headPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bgview.mas_centerY);
        make.left.mas_equalTo(self.bgview.mas_left).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(104,104));
    }];
    _headPic.layer.cornerRadius  = _headPic.frame.size.width/1.5;
}

-(void)resetStarFishCardImage
{
    CGFloat sizeScale = Main_Screen_Width/320;
    
    
    [_starFishCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgview.mas_top).with.offset(15);
        make.right.mas_equalTo(self.bgview.mas_right).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(_starFishCard.frame.size.width*sizeScale,_starFishCard.frame.size.height*sizeScale));
    }];
    
    
    [_memLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.starFishCard.mas_top).with.offset(30);
        make.left.mas_equalTo(self.starFishCard.mas_left).with.offset(30);
        make.size.mas_equalTo(CGSizeMake(_starFishCard.frame.size.width-60,21));
    }];
    _memLab.font = [UIFont boldSystemFontOfSize:17];
    
    [_coinLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.starFishCard.mas_bottom).with.offset(-50);
        make.right.mas_equalTo(self.starFishCard.mas_right).with.offset(-30);
        [_coinLab sizeToFit];
        _coinLab.font = [UIFont boldSystemFontOfSize:17];
    }];
    
    [_LincKiaCoinNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.coinLab.mas_left).with.offset(-8);
        make.bottom.mas_equalTo(self.coinLab.mas_bottom).with.offset(5);
        [_LincKiaCoinNum sizeToFit];
        _LincKiaCoinNum.font = [UIFont boldSystemFontOfSize:35];
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
