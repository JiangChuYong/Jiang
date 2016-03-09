//
//  MessageClassifyViewCell.m

//

#import "MessageClassifyViewCell.h"

@implementation MessageClassifyViewCell

- (void)awakeFromNib {
    // Initialization code
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[[[NSBundle mainBundle] loadNibNamed:@"MessageClassifyViewCell" owner:self options:nil] objectAtIndex:0];
    if (self) {
        //
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
