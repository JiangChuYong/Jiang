//
//  OrderInformationViewCell.h

//

#import <UIKit/UIKit.h>
//#import "OrderDetailModel.h"

@interface OrderInformationViewCell : UITableViewCell
//用于设置字体大小和颜色
@property (weak, nonatomic) IBOutlet UILabel *labelStartTimeTitle;//“开始租用"
@property (weak, nonatomic) IBOutlet UILabel *labelEndTimeTitle;//“结束租用"
@property (weak, nonatomic) IBOutlet UILabel *labelTotalPriceTitle;//“总结：用"

@property (weak, nonatomic) IBOutlet UILabel *lableSpaceName;//空间名称
@property (weak, nonatomic) IBOutlet UILabel *lableStartTime;//开始时间
@property (weak, nonatomic) IBOutlet UILabel *lableEndTime;//结束时间
@property (weak, nonatomic) IBOutlet UILabel *lableOfficeType;//空间类型
@property (weak, nonatomic) IBOutlet UILabel *lableOfficeAddress;//空间地址
@property (weak, nonatomic) IBOutlet UILabel *lableOfficeContain;//容量
@property (weak, nonatomic) IBOutlet UILabel *lablePrice;//价格
@property (weak, nonatomic) IBOutlet UIImageView *separeLine;

-(void)initDataSourceWithOrderDetailModel:(NSDictionary *)orderDetailModel withOrderViewInfo:(NSDictionary *)orderViewInfo;
@end
