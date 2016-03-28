//
//  AcceptContractViewCell.m

//

#import "AcceptContractViewCell.h"

@implementation AcceptContractViewCell

- (void)awakeFromNib {
    // Initialization code
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[[[NSBundle mainBundle] loadNibNamed:@"AcceptContractViewCell" owner:self options:nil] objectAtIndex:0];
    if (self) {
        //
    }
    return self;
}

@end
