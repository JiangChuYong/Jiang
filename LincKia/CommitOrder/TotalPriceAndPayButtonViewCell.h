//
//  TotalPriceAndPayButtonViewCell.h

//

#import <UIKit/UIKit.h>

@interface TotalPriceAndPayButtonViewCell : UITableViewCell
//用于设置字体大小和颜色
@property (weak, nonatomic) IBOutlet UILabel *labelRemindNote;//"若订单48消失。。。"
@property (weak, nonatomic) IBOutlet UILabel *labelMbileNote;//"订单成功后，订单序号将发送到"

@end
