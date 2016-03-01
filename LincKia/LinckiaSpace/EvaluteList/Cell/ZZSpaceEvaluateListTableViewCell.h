//
//  ZZSpaceEvaluateListTableViewCell.h

//

#import <UIKit/UIKit.h>

@interface ZZSpaceEvaluateListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) UITextView *comment;

-(void) addScroeView:(double)temple;
-(void)setCommentView:(NSString *)comment;
-(CGFloat)resetCellHeight;

@end
