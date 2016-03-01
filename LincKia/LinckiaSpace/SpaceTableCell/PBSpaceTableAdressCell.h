//
//  PBSpaceTableCell.h
//  
//
//  Created by 董玲 on 11/18/15.
//
//

#import <UIKit/UIKit.h>

@interface PBSpaceTableAdressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *spacenameLabel;
@property (weak, nonatomic) IBOutlet UIView *scoreview;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UIButton *pushToIntroPageButton;
@property (weak, nonatomic) IBOutlet UIButton *naviButton;

@end
