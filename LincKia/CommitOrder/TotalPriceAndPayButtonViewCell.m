//
//  TotalPriceAndPayButtonViewCell.m

//

#import "TotalPriceAndPayButtonViewCell.h"

@implementation TotalPriceAndPayButtonViewCell

- (void)awakeFromNib {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[[[NSBundle mainBundle] loadNibNamed:@"TotalPriceAndPayButtonViewCell" owner:self options:nil] objectAtIndex:0];
    if (self) {
        //
    }
    return self;
}



@end
