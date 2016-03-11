//
//  JCYSpacePositionViewControlle.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/11.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "JCYSpacePositionViewControlle.h"
#define MaximumZoomScale 2.0
#define MinimumZoomScale 0.5
#define ReduceZoomScale 0.8
#define AmplificationZoomScale 1.2
@interface JCYSpacePositionViewControlle ()<UIScrollViewDelegate>
{
    UIScrollView *scrollerView;
    UIImageView *imageview;
    float scaleValue;
}
@property (strong, nonatomic) IBOutlet UIView *nodataView;


@end

@implementation JCYSpacePositionViewControlle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    scrollerView=[[UIScrollView alloc]init];
    scrollerView.frame=CGRectMake(0, 64, Main_Screen_Width, Main_Screen_Height-44);
    
    
    [self.view addSubview:scrollerView];
    scaleValue = 1;
    
    if (scrollerView.subviews.count) {
        for (id temp in scrollerView.subviews) {
            [temp removeFromSuperview];
        }
    }
    
    imageview = [[UIImageView alloc]init];
    CGFloat height =(Main_Screen_Height-44)/2;
   
    imageview.frame=CGRectMake(0, 0, Main_Screen_Width, height);
    if([[JCYGlobalData sharedInstance].spaceDetailInfo[@"Data"]
       [@"SeatPictures"]  count]){
        _nodataView.hidden=YES;
        imageview.hidden=NO;
        NSDictionary *spacePicDic=[JCYGlobalData sharedInstance].spaceDetailInfo[@"Data"][@"SeatPictures"][0];
        [imageview sd_setImageWithURL:[NSURL URLWithString:spacePicDic[@"PicUrl"]]];
    }else{
        imageview.hidden=YES;
        _nodataView.hidden=NO;
        [self.view bringSubviewToFront:_nodataView];
    }
    
    [scrollerView addSubview:imageview];
    
    //设置UIScrollView的滚动范围和图片的真实尺寸一致
    [scrollerView setShowsHorizontalScrollIndicator:NO];
    [scrollerView setShowsVerticalScrollIndicator:NO];
    
    //设置实现缩放
    //设置代理scrollview的代理对象
    scrollerView.delegate=self;
    //设置最大伸缩比例
    scrollerView.maximumZoomScale=MaximumZoomScale;
    //设置最小伸缩比例
    scrollerView.minimumZoomScale=MinimumZoomScale;
    [scrollerView setZoomScale:scaleValue animated:YES];
}


- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageview;
}

- (IBAction)backBtnPress:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

@end
