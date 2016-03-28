//
//  AcceptContractViewCell.h

//

#import <UIKit/UIKit.h>

@interface AcceptContractViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelIAgree;//”我同意“
@property (weak, nonatomic) IBOutlet UIButton *btnRentContract;//租赁合同按钮
@property (weak, nonatomic) IBOutlet UIButton *btnCheckBox;

@end
