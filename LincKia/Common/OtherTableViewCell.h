//
//  OtherTableViewCell.h

//自定义其他的cell

#import <UIKit/UIKit.h>

@interface OtherTableViewCell : UITableViewCell

//设置tableView中其他自定义cell的信息lable值
@property (weak, nonatomic) IBOutlet UILabel *labelSetInfo;
@property (weak, nonatomic) IBOutlet UIImageView *separateLineImageView;
@property (weak, nonatomic) IBOutlet UILabel *cacheNumLab;

@end
