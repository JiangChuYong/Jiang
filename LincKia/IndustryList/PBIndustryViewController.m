//
//  PBIndustryViewController.m
//  LincKia
//
//  Created by 董玲 on 11/16/15.
//  Copyright © 2015 ZZ. All rights reserved.
//

#import "PBIndustryViewController.h"
//#import "PBCollectionCell.h"
//#import "PBIndustryDetailModel.h"
//#import "PBIndustryInfoModel.h"
//#import "PagingResultOfEnumerableOfIndustryInfoModel.h"
//#import "PBCompanyListViewController.h"

@interface PBIndustryViewController ()
@property (strong,nonatomic) NSMutableArray * industryArray;

@end

@implementation PBIndustryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[ZZAllService sharedInstance] serviceQueryByObj:@{@"Page":@1,@"Rows":@10,@"SortProperty":@"Name",@"SortDirection":@"asc"} delegate:self httpTag:HTTPHelperTag_Spaces_GetIndustryList];
//    [self.collectionView registerClass:[PBCollectionCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    NSLog(@"dfafdsf");
   
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
//    PBCollectionCell *cell = (PBCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
//    PBIndustryDetailModel * industryDetail = _industryArray[indexPath.row];
//    [cell.image sd_setImageWithURL:[NSURL URLWithString:industryDetail.pic] placeholderImage:[UIImage imageNamed:Index_Recommond_Default_Image]];
//    cell.name.text = industryDetail.industryName;
//    return cell;
    return [[UICollectionViewCell alloc]init];
}
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    PBIndustryDetailModel * industryDetail = _industryArray[indexPath.row];
//    [ZZGlobalModel sharedInstance].industryId = industryDetail.id;
//    [ZZGlobalModel sharedInstance].industryName = industryDetail.industryName;
//    PBCompanyListViewController * viewController = [[PBCompanyListViewController alloc]init];
//    [self.navigationController pushViewController:viewController animated:YES];
//}
//#pragma -- mark REQUEST PART
///** *校验数据开始，如果没有通过校验，则返回校验提示*/
//-(void)validateFailed:(int)tag validateInfo:(NSString *)validateInfo{
//    NSLog(@"validateFailed");
//}
///** *获取数据开始*/
//-(void)gainDataStart:(int)tag{
//    [[AlertUtils sharedInstance]showWithText:LOAD_Start_TEXT inView:self.view];
//}
////获取数据成功
//-(void)gainDataSuccess:(int)tag responseObj:(id)responseObj{
//    PBIndustryInfoModel * response = [responseObj jsonToModel:PBIndustryInfoModel.class];
//    if (response.Code == SERVER_SUCCESS) {
//        _industryArray = [NSMutableArray arrayWithArray:response.Data.Data];
//        [self.collectionView reloadData];
//    }
//    [[AlertUtils sharedInstance]stopHUD];
//}
//-(void)gainDataFailed:(int)tag errorInfo:(NSString *)errorInfo{
//    [[AlertUtils sharedInstance]stopHUD];
//    [[AlertUtils sharedInstance] showWithText:errorInfo inView:self.view lastTime:2.0];
//}
//
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
