//
//  MyCommentTableViewCell.m

//

#import "MyCommentTableViewCell.h"

@implementation MyCommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

-(void)setMyCommentCellInfo:(NSDictionary *)orderListInfo{
    
    self.UILableAddress.text=orderListInfo[@"Space"][@"Name"];
    self.labelprice.text=[NSString stringWithFormat:@"￥%.0f",[orderListInfo[@"Amount"] floatValue]];
    self.UILableBeginTime.text = [[CommonUtil sharedInstance] dataStrWithDateStr: orderListInfo[@"OrderTime"]];
    self.labelCommentInfo.text=[[CommonUtil sharedInstance] nameForOrderStatus:[orderListInfo[@"Status"] intValue]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _btnComment.layer.cornerRadius = 5;
    _btnComment.clipsToBounds = YES;
    
}


@end
