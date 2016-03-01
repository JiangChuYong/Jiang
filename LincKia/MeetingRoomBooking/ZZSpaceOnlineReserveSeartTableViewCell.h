//
//  ZZSpaceOnlineReserveSeartTableViewCell.h

//

#import <UIKit/UIKit.h>

@interface ZZSpaceOnlineReserveSeartTableViewCell : UITableViewCell
//选择框
@property (weak, nonatomic) IBOutlet UIButton *btnCheckBox;
//房间号
@property (weak, nonatomic) IBOutlet UILabel *labelRoomNum;
//价格
@property (weak, nonatomic) IBOutlet UILabel *labelPriceNum;
//房间人数
@property (weak, nonatomic) IBOutlet UILabel *labelPeopleNum;

@property (weak, nonatomic) IBOutlet UILabel *officeTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *officePersonNum;

@property (weak, nonatomic) IBOutlet UIImageView *separateLine;

@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

//分割线是否隐藏
- (void)separateLineHidden:(BOOL)hidden;
//初始化属性
- (void)initCellProperty:(NSMutableArray *)cellModels index:(NSInteger)index name:(NSString *)name;

@property (weak, nonatomic) IBOutlet UIImageView *spaceLineIV;


@end
