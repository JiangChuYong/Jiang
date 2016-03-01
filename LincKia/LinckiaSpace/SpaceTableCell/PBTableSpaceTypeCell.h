//
//  PBTableSpaceTypeCell.h
//  
//
//  Created by 董玲 on 11/19/15.
//
//

#import <UIKit/UIKit.h>

@interface PBTableSpaceTypeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picImage;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *surplusLabel;
@property (weak, nonatomic) IBOutlet UIButton *touchButton;
@property (weak, nonatomic) IBOutlet UIImageView *singleLine;
@property (weak, nonatomic) IBOutlet UIImageView *doubleLine;

@end
