//
//  OrderInformationViewCell.m

//

#import "OrderInformationViewCell.h"

@implementation OrderInformationViewCell

- (void)awakeFromNib {
    // Initialization code
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

//使代码与xib关联起来，在tableView里使用cell时可以不用注册，直接使用此初始化方法进行实例化
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[[[NSBundle mainBundle] loadNibNamed:@"OrderInformationViewCell" owner:self options:nil] objectAtIndex:0];
    if (self) {
        //
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

//订单信息
-(void)initDataSourceWithOrderDetailModel:(NSDictionary *)orderDetailModel withOrderViewInfo:(NSDictionary *)orderViewInfo{

    self.lableSpaceName.text=orderViewInfo[@"Space"][@"Name"];
    self.lableOfficeType.text=[[CommonUtil sharedInstance] nameForSpaceType: [orderDetailModel[@"SpaceCell"][@"SpaceCellType"] intValue]];
    
    //空间地址
    self.lableOfficeAddress.text=orderDetailModel[@"SpaceCell"][@"CellCode"];

    self.lableOfficeContain.text=[NSString stringWithFormat:@"%d", [orderDetailModel[@"SpaceCell"][@"CellNum"] intValue]];

    self.lableStartTime.text=[[CommonUtil sharedInstance] dataStrWithDateStr:orderDetailModel[@"StartDate"]];
    self.lableEndTime.text=[[CommonUtil sharedInstance] dataStrWithDateStr:orderDetailModel[@"EndDate"]];

    if ([orderDetailModel[@"SpaceCell"][@"CellPrice"] count]>0) {
        NSDictionary *spaceCellPrice=orderDetailModel[@"SpaceCell"][@"CellPrice"][0];
       NSString * amountStr=[NSString stringWithFormat:@"%.0f",[spaceCellPrice[@"Amount"] floatValue]];
        NSString * amountPrice = @"¥";
        self.lablePrice.text = [amountPrice stringByAppendingString:amountStr];
    }

}


@end
