//
//  JCYSpaceEvaluateListViewController.h
//  LincKia
//
//  Created by JiangChuyong on 16/3/1.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZSpaceEvaluateListTableViewCell.h"

@interface JCYSpaceEvaluateListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
}
@property (strong, nonatomic) NSDictionary *spaceViewInfoDict;

//查看评价tableView
@property (weak, nonatomic) IBOutlet UITableView *spaceEvaluateListTableView;
//标题
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property(assign,nonatomic)int pageCount;
@property (weak, nonatomic) IBOutlet UIView *emptyView;

@end
