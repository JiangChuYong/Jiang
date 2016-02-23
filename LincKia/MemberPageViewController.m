//
//  LincKia
//
//  Created by Phoebe on 16/2/15.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "MemberPageViewController.h"
#import "LoginViewController.h"
#import "MemberCollectionViewCell.h"
#import "PBSendExpressViewController.h"

@interface MemberPageViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (strong,nonatomic) NSArray * cellNameArray;
@end

@implementation MemberPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _cellNameArray = [NSArray arrayWithObjects:@"发快递",@"滴滴出行",@"快递查询",@"环境监测",@"会议室", nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [super viewWillAppear:animated];
    UINavigationController * navi = (UINavigationController *)self.parentViewController;
    navi.tabBarController.tabBar.hidden = NO;
    
}
#pragma -- mark CollectionView Delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _cellNameArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
       MemberCollectionViewCell * cell = [_collection dequeueReusableCellWithReuseIdentifier:@"MemberCollectionViewCell" forIndexPath:indexPath];
    cell.label.text = _cellNameArray[indexPath.row];
    cell.image.image = [UIImage imageNamed:_cellNameArray[indexPath.row]];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        [self performSegueWithIdentifier:@"MemberToSendExpress" sender:self];
    }
    
    if (indexPath.row == 3) {
        [self performSegueWithIdentifier:@"MemberToEnvironment" sender:self];
    }
}
@end
