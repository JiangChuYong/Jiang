//
//  CouponCodeViewCell.m

//

#import "CouponCodeViewCell.h"

@implementation CouponCodeViewCell

- (void)awakeFromNib {
    // Initialization code
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setViewFontAndColor];//设置文字的字号及颜色
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[[[NSBundle mainBundle] loadNibNamed:@"CouponCodeViewCell" owner:self options:nil] objectAtIndex:0];
    if (self) {
        //
    }
    return self;
}

//设置文字的字号及颜色
-(void)setViewFontAndColor{
    self.textFieldCouponCode.font=[UIFont systemFontOfSize:CommonFontSize_Middle];
    self.textFieldCouponCode.textColor=CommonColor_Black;
    self.btnSure.titleLabel.font=[UIFont systemFontOfSize:CommonFontSize_Middle];
    
    self.textFieldCouponCode.layer.cornerRadius = 3;
    self.textFieldCouponCode.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textFieldCouponCode.clipsToBounds = YES;
    self.textFieldCouponCode.layer.borderWidth = 1;
    
    self.btnSure.layer.cornerRadius = 3;
    [self.btnSure clipsToBounds];
    
}
@end
