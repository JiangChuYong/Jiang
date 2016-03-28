//
//  SwitchChoiseViewCell.m

//

#import "SwitchChoiseViewCell.h"
#import "Masonry.h"
@implementation SwitchChoiseViewCell

- (void)awakeFromNib {
    // Initialization code
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark --自定义方法
//将nib文件与文件名关联起来
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[[[NSBundle mainBundle] loadNibNamed:@"SwitchChoiseViewCell" owner:self options:nil] objectAtIndex:0];
    if (self) {
        //
    }
    return self;
}
//初始化数据
-(void)initDateSourceWithSelectName:(NSString *)name describe:(NSString *)describe{
    self.labelSelectName.text=name;
    self.lableDescribe.text=describe;
    if ([name isEqualToString:@"门店支付"]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.lableDescribe.textColor = CommonColor_Orange;
    }
}


@end
