//
//  ZZSpaceRecommendCellTableViewCell.h


#import <UIKit/UIKit.h>
#import "Masonry.h"

@interface ZZSpaceRecommendCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *spaceNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *spaceImageView;
@property (weak, nonatomic) IBOutlet UILabel *spaceAdressLabel;
@property (weak, nonatomic) IBOutlet UIButton *UITouchBtn;

@end
