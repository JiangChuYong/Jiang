//
//  ZZFInishOrderViewController.h
//  LincKia
//
//  完成订单

#import <UIKit/UIKit.h>


@interface ZZFInishOrderViewController : UIViewController
//设置字体大小和颜色
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelPaySuccessNote;
@property (weak, nonatomic) IBOutlet UILabel *labelMobileNote;
@property (weak, nonatomic) IBOutlet UIButton *myOrderDetailBtn;
@property (weak, nonatomic) IBOutlet UILabel *mobile;


- (IBAction)pushToMyOrderDetailPage:(UIButton *)sender;

@end
