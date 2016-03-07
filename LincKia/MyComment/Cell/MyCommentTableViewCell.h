//
//  MyCommentTableViewCell.h

//

#import <UIKit/UIKit.h>

@interface MyCommentTableViewCell : UITableViewCell
//待点评-地址
@property (weak, nonatomic) IBOutlet UILabel *UILableAddress;
//待点评-总价
@property (weak, nonatomic) IBOutlet UILabel *UILablePriceNum;
//点评按钮
@property (weak, nonatomic) IBOutlet UIButton *btnComment;
//开始时间
@property (weak, nonatomic) IBOutlet UILabel *UILableBeginTime;
//结束时间
@property (weak, nonatomic) IBOutlet UILabel *UILableEndTime;
//显示的价格
@property (weak, nonatomic) IBOutlet UILabel *labelprice;

@property (weak, nonatomic) IBOutlet UILabel *labelCommentInfo;

-(void)setMyCommentCellInfo:(NSDictionary *)orderListInfo;

@end
