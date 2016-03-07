//
//  AllOrderListViewCell.m

//

#import "AllOrderListViewCell.h"

@implementation AllOrderListViewCell

- (void)awakeFromNib {
    // Initialization code
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];//设置cell点击效果为空
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

//对cell中的lable等元素赋值
-(void)initCellDataSourceWithOrder:(NSDictionary *)orderInfo{
    self.orderListSpaceNameLab.text=orderInfo[@"Space"][@"Name"];
    self.orderListPriceLab.text=[NSString stringWithFormat:@"¥%i",[orderInfo[@"Amount"] intValue]];
     self.orderListOrderTime.text=[[CommonUtil sharedInstance] dataStrWithDateStr:orderInfo[@"OrderTime"]];
    if([orderInfo[@"Status"] intValue]==UnPayed){
        self.btnSure.enabled=YES;
        self.btnSure.backgroundColor=[[UIColor alloc] initWithRed:245/255.0 green:182/255.0 blue:51/255.0 alpha:1.0];
        [self.btnSure setTitleColor:[[UIColor alloc] initWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    }else if([orderInfo[@"Status"] intValue]==Payed){
      self.btnSure.enabled=NO;
        self.btnSure.backgroundColor=[[UIColor alloc] initWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
        [self.btnSure setTitleColor:[[UIColor alloc] initWithRed:84/255.0 green:84/255.0 blue:84/255.0 alpha:1.0] forState:UIControlStateNormal];
        
    }else if([orderInfo[@"Status"] intValue] == Draft){
        self.btnSure.backgroundColor=[[UIColor alloc] initWithRed:245/255.0 green:182/255.0 blue:51/255.0 alpha:1.0];
        [self.btnSure setTitleColor:[[UIColor alloc] initWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
        self.btnSure.enabled=YES;
    }
    
    
    
    self.orderListOrderStatusLab.text=[[CommonUtil sharedInstance] nameForOrderStatus:[orderInfo[@"Status"] intValue]];//订单状态
    

}
@end
