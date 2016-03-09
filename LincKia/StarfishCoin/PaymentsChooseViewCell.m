//
//  PaymentsChooseViewCell.m

//

#import "PaymentsChooseViewCell.h"

@implementation PaymentsChooseViewCell

- (void)awakeFromNib {
    // Initialization code
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setViewFontAndColor];//设置文字的字号及颜色
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark --自定义方法
//重写init
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[[[NSBundle mainBundle] loadNibNamed:@"PaymentsChooseViewCell" owner:self options:nil] objectAtIndex:0];
    if (self) {
        //
    }
    return self;
}

//初始化数据源
-(void)initUIComponentWithImage:(NSString *)imageName paymentName:(NSString *)payment declare:(NSString *)declare{
    self.labelPayment.text=payment;
    self.paymentImageView.image=[UIImage imageNamed:imageName];
    self.labelPaymentDeclare.text=declare;
}

//设置文字的字号及颜色
-(void)setViewFontAndColor{
    self.labelPayment.font=[UIFont systemFontOfSize:CommonFontSize_Middle];
    self.labelPayment.textColor=CommonColor_Black;
    self.labelPaymentDeclare.font=[UIFont systemFontOfSize:CommonFontSize_Small];
    self.labelPaymentDeclare.textColor=CommonColor_Gray;
}
@end
