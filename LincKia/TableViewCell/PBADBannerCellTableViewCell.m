//
//  PBADBannerCellTableViewCell.m
//  LincKia
//
//  Created by Phoebe on 16/1/19.
//  Copyright © 2016年 ZZ. All rights reserved.
//

#import "PBADBannerCellTableViewCell.h"
#import "Masonry.h"
//#import "AD.h"

@implementation PBADBannerCellTableViewCell

- (void)awakeFromNib {
    [_ADSrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_right);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.ADSrollView.mas_bottom).with.offset(0);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setScrollViewContentOfSize:(NSMutableArray *)picArr withCell:(PBADBannerCellTableViewCell *)cell
{
    _ADSrollView.contentSize = CGSizeMake(Main_Screen_Width*picArr.count, 0);
    NSMutableArray * ads = [NSMutableArray array];
    
    for (NSDictionary *tempDict  in picArr) {
        NSString * url = tempDict[@"PicUrl"];
        [ads addObject:url];
    }
    
    _pageControl.numberOfPages = ads.count;
    
    [self deleteSubviewsOfScrollView];
    
    for (int i=0; i<ads.count; i++) {
        UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width*i, 0, Main_Screen_Width, cell.bounds.size.height)];
        
        
        [img sd_setImageWithURL:[NSURL URLWithString:ads[i]] placeholderImage:[UIImage imageNamed:Index_Recommond_Default_Image]];

        [_ADSrollView addSubview:img];
    }
}



-(void)deleteSubviewsOfScrollView
{
    if (_ADSrollView.subviews.count) {
        for (id temp in _ADSrollView.subviews) {
            [temp removeFromSuperview];
        }
    }
}
@end
