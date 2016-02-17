//
//  PBADBannerCellTableViewCell.h
//  LincKia
//
//  Created by Phoebe on 16/1/19.
//  Copyright © 2016年 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBADBannerCellTableViewCell : UITableViewCell <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *ADSrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
-(void)setScrollViewContentOfSize:(NSMutableArray *)picArr withCell:(PBADBannerCellTableViewCell *)cell;

@end
