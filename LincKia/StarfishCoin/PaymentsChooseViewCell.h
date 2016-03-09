//
//  PaymentsChooseViewCell.h

//

#import <UIKit/UIKit.h>

@interface PaymentsChooseViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *paymentImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelPayment;
@property (weak, nonatomic) IBOutlet UILabel *labelPaymentDeclare;
@property (weak, nonatomic) IBOutlet UIButton *btnPaymentCheckBox;
@property (weak, nonatomic) IBOutlet UIImageView *blueLineImageView;

-(void)initUIComponentWithImage:(NSString *)imageName paymentName:(NSString *)payment declare:(NSString *)declare;
@end
