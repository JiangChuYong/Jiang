//
//  ZZSpaceIntroductionViewController.m
//  LincKia
//
//

#import "PBHardwareFacilitiesViewController.h"
#import "Masonry.h"
#import "PBCollectionCell.h"

@interface PBHardwareFacilitiesViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSDictionary *spaceViewInfo;
@property (strong, nonatomic) NSDictionary *activeSpaceViewInfo;
@property (strong, nonatomic) NSMutableArray *activeSpaceFacilitiesArr;
@property (strong, nonatomic) NSMutableArray *spaceFacilitiesArr;


@end

@implementation PBHardwareFacilitiesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _activeSpaceFacilitiesArr=[NSMutableArray array];
    _spaceFacilitiesArr=[NSMutableArray array];
    
    //获取数据
    _spaceViewInfo = [JCYGlobalData sharedInstance].spaceDetailInfo;
    
    _spaceFacilitiesArr =_spaceViewInfo[@"Data"][@"Facilities"];
    _activeSpaceViewInfo =[JCYGlobalData sharedInstance].activeSpaceInfo;
    _activeSpaceFacilitiesArr=_activeSpaceViewInfo[@"Data"][@"facilities"];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -- UICOLLECTIONVIEW DELEGATE
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_collectionView registerClass:[PBCollectionCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    PBCollectionCell *cell = (PBCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    NSDictionary *facility;
    if ([JCYGlobalData sharedInstance].isActiveSpace) {
        facility = [_activeSpaceFacilitiesArr objectAtIndex:indexPath.row];
    }else
    {
        facility = [_spaceFacilitiesArr objectAtIndex:indexPath.row];
    }
    
    
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(cell.bounds.size.width/4, 20, cell.bounds.size.width/2, cell.bounds.size.width/2)];
    if ([JCYGlobalData sharedInstance].isActiveSpace) {
        [image sd_setImageWithURL:[NSURL URLWithString:facility[@"picUrl"]] placeholderImage:[UIImage imageNamed:Space_DetailFacilities_Default_Image]];
        cell.name.text = facility[@"name"];
        
    }else
    {
        [image sd_setImageWithURL:[NSURL URLWithString:facility[@"FacilitiesTypeImgUrl"]] placeholderImage:[UIImage imageNamed:Space_DetailFacilities_Default_Image]];
        cell.name.text = facility[@"FacilitiesType"];
        
    }
    
    
    while ([cell.image.subviews lastObject] != nil) {
        [[cell.image.subviews lastObject] removeFromSuperview];
    }
    
    [cell.image addSubview:image];
    
    return cell;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([JCYGlobalData sharedInstance].isActiveSpace) {
        return _activeSpaceFacilitiesArr.count;
        
    }else
    {
        return _spaceFacilitiesArr.count;
        
    }
}


#pragma mark -- ACTION PART
//返回
- (IBAction)backBtnPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
