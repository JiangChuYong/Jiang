//
//  ZZSpaceEvaluateListTableViewCell.m

//

#import "ZZSpaceEvaluateListTableViewCell.h"
#import "TQStarRatingView.h"

@implementation ZZSpaceEvaluateListTableViewCell


- (void)awakeFromNib {
    // Initialization code
    _icon.layer.cornerRadius = _icon.bounds.size.width/2;
    _icon.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

//给cell添加打分组件(控制不可编辑)
-(void) addScroeView:(double)temple{
    CGFloat width = 75;
    TQStarRatingView *starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(Main_Screen_Width-90, 15, width, 14) numberOfStar:5 flag:0 doubleCount:temple];
    starRatingView.userInteractionEnabled=NO;
    [self addSubview:starRatingView];
}

-(void)setCommentView:(NSString *)comment
{
    if (_comment) {
        [_comment removeFromSuperview];
    }
    _comment = [[UITextView alloc]init];
    CGRect frame=_comment.frame;
    _comment.frame=CGRectMake(75, 36, Main_Screen_Width-90, frame.size.height);
    
    _comment.text = comment;
    
    [_comment setFont:[UIFont systemFontOfSize:12]];
    _comment.textColor = [UIColor lightGrayColor];
    [_comment sizeToFit];
    
    _comment.scrollEnabled = NO;
    _comment.editable = NO;
    [self.contentView addSubview:_comment];
    
}

-(CGFloat)resetCellHeight
{
  
    return _comment.frame.size.height+_comment.frame.origin.y+15;
}
@end
