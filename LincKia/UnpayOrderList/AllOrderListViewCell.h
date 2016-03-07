//
//  AllOrderListViewCell.h

//

#import <UIKit/UIKit.h>
#import "CommonUtil.h"

@interface AllOrderListViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderListSpaceNameLab;//"空间名称"
@property (weak, nonatomic) IBOutlet UILabel *orderListPriceLab;//价格
@property (weak, nonatomic) IBOutlet UILabel *orderListOrderStatusLab;//订单状态
@property (weak, nonatomic) IBOutlet UILabel *orderListOrderTime;//下单日期
@property (weak, nonatomic) IBOutlet UIButton *btnSure;//“付款”按钮

@property (weak, nonatomic) IBOutlet UILabel *labelTotalPriceTitle;//"总价："
@property (weak, nonatomic) IBOutlet UILabel *labelPayTimeTitle;//“订单支付”



//@property (weak, nonatomic) IBOutlet UIButton *btnCancelPay;

-(void)initCellDataSourceWithOrder:(NSString *)orderInfo;
@end
