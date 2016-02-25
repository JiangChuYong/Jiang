//
//  ZZSpaceIntroduceViewController.m
//  LincKia
//
//  Created by Phoebe on 15/8/14.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import "ZZSpaceIntroduceViewController.h"

@interface ZZSpaceIntroduceViewControlle

@end

@implementation ZZSpaceIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    if ([JCYGlobalData sharedInstance].isActiveSpace) {
        _nameLable.text=@"空间简介";
        _activeSpaceDetailInfo = [JCYGlobalData sharedInstance].activeSpaceInfo;
        NSLog(@"HHHHHH%@",_activeSpaceDetailInfo);
        [self setFontAndSizeForintroduceContentForActiveSpace];

        
    }else
    {//获取数据
        _spaceDetailInfo = [JCYGlobalData sharedInstance].spaceDetailInfo;
        [self setFontAndSizeForintroduceContent];

    }

}

-(void)setFontAndSizeForintroduceContent
{
//    self.introduceContent.text = _spaceDetailInfo.Description;
//    self.titleLable.text=_spaceDetailInfo.Name;
//    //获取空间图片信息
//    NSMutableArray <SpacePicModel>* imageIntroArray = _spaceDetailInfo.IntroPictures;
//    NSMutableArray * imageStringArray = [NSMutableArray array];
//    for (SpacePicModel * spacePic in imageIntroArray) {
//        NSString * urlstring = spacePic.PicUrl;
//        [imageStringArray addObject:urlstring];
//    }
//    [self setSpaceImageWithImageArr:imageStringArray];

    
    
    NSLog(@"sdfasf");
}

-(void)setFontAndSizeForintroduceContentForActiveSpace
{
    self.introduceContent.text = _activeSpaceDetailInfo[@"Data"][@"descriptions"];
    self.titleLable.text=_activeSpaceDetailInfo[@"Data"][@"activeSpaceName"];
    //获取空间图片信息
    NSMutableArray * imageIntroArray = _activeSpaceDetailInfo[@"Data"][@"pictures"];
    NSMutableArray * imageStringArray = [NSMutableArray array];
    for ( NSDictionary * spacePic in imageIntroArray) {
        NSString * urlstring = spacePic[@"picUrl"];
        [imageStringArray addObject:urlstring];
    }
    [self setSpaceImageWithImageArr:imageStringArray];
    
    
    
    
}


#pragma mark -- SCROLLVIEW DELEGATE
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //根据滚动及时调整pagecontrol的显示
    if ([scrollView isEqual:_spaceScrollView]) {
        _currentPage = (int)scrollView.contentOffset.x/Main_Screen_Width+1;
        _pageLable.text = [NSString stringWithFormat:@"%i/%i",_currentPage,_numOfTotalPage];
    }
}

//设置scrollView广告图片
-(void)setSpaceImageWithImageArr:(NSMutableArray *)array
{
    
    _numOfTotalPage = (int)array.count;
    _pageLable.text = [NSString stringWithFormat:@"1/%i",_numOfTotalPage];
    [_spaceScrollView setFrame:CGRectMake(0, 0, Main_Screen_Width, 173)];
    _spaceScrollView.contentSize = CGSizeMake(Main_Screen_Width*array.count, 173);
    for (int i=0; i<array.count; i++) {
        NSString * urlString = [NSString stringWithFormat:@"%@",array[i]];
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width*i, 0, Main_Screen_Width, 173)];
        [image sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:Index_Recommond_Default_Image]];
        [_spaceScrollView addSubview:image];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)bactToLastPage:(UIButton *)sender {
    UINavigationController *navi=(UINavigationController *)self.parentViewController;
    [navi popViewControllerAnimated:YES];
}
@end
