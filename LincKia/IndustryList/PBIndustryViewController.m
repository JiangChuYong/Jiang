//
//  PBIndustryViewController.m
//  LincKia
//
//  Created by 董玲 on 11/16/15.
//  Copyright © 2015 ZZ. All rights reserved.
//

#import "PBIndustryViewController.h"
#import "PBCollectionCell.h"
//#import "PBIndustryDetailModel.h"
//#import "PBIndustryInfoModel.h"
//#import "PagingResultOfEnumerableOfIndustryInfoModel.h"
//#import "PBCompanyListViewController.h"

@interface PBIndustryViewController ()
@property (strong,nonatomic) NSMutableArray * industryArray;
@property (strong,nonatomic) NSDictionary *responseDataOfIndexDict;
@property (strong,nonatomic) AFRquest * GetIndustryList;

@end

@implementation PBIndustryViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UINavigationController * navi = (UINavigationController *)self.parentViewController;
    navi.tabBarController.tabBar.hidden = YES;
    navi.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",GetIndustryList] object:nil];
    _GetIndustryList = [[AFRquest alloc]init];
    _GetIndustryList.subURLString = @"api/Industry/GetIndustryList?userToken=""&deviceType=ios";
     _GetIndustryList.parameters = @{@"Page":@1,@"Rows":@10,@"SortProperty":@"Name",@"SortDirection":@"asc"};
    _GetIndustryList.style = GET;
    [_GetIndustryList requestDataFromWithFlag:GetIndustryList];

    [self.collectionView registerClass:[PBCollectionCell class] forCellWithReuseIdentifier:@"CollectionCell"];
   
}


-(void)dataReceived:(NSNotification *)notif{
    
    _responseDataOfIndexDict = _GetIndustryList.resultDict;
    
    NSLog(@"%@",_responseDataOfIndexDict);

    _industryArray=_responseDataOfIndexDict[@"Data"][@"Data"];

    [_collectionView reloadData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataReceived:) name:[NSString stringWithFormat:@"%i",GetIndustryList] object:nil];
}


- (IBAction)backButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -- mark COLLECTIONVIEW PART
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _industryArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{    
    PBCollectionCell *cell = (PBCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    NSDictionary *tempDict=[_industryArray objectAtIndex:indexPath.row];
    
    [cell.image sd_setImageWithURL:[NSURL URLWithString:tempDict[@"pic"]] placeholderImage:[UIImage imageNamed:Index_Recommond_Default_Image]];
    

    cell.name.text = tempDict[@"industryName"];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary  * industryDetail = _industryArray[indexPath.row];
    [JCYGlobalData sharedInstance].industryId = industryDetail[@"id"];
    [JCYGlobalData sharedInstance].industryName = industryDetail[@"industryName"];
//    PBCompanyListViewController * viewController = [[PBCompanyListViewController alloc]init];
//    [self.navigationController pushViewController:viewController animated:YES];
    [self performSegueWithIdentifier:@"IndustryToCompany" sender:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
