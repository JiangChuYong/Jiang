//
//  SwitchChoiseViewCell.h

//

#import <UIKit/UIKit.h>

@interface SwitchChoiseViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelSelectName;
@property (weak, nonatomic) IBOutlet UILabel *lableDescribe;
@property (weak, nonatomic) IBOutlet UIButton *btnSwitch;

-(void)initDateSourceWithSelectName:(NSString *)name describe:(NSString *)describe;
@end
