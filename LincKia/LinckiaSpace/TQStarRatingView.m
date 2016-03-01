//
//  TQStarRatingView.m
//  TQStarRatingView
//
//  Created by fuqiang on 13-8-28.
//  Copyright (c) 2013年 TinyQ. All rights reserved.
//

#import "TQStarRatingView.h"

@interface TQStarRatingView ()

@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;

@end

@implementation TQStarRatingView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame numberOfStar:5 flag:0 doubleCount:0.0];
}

- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number flag:(int)flag doubleCount:(double) doubleCount
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfStar = number;
        self.starBackgroundView = [self buidlStarViewWithImageName:@"star_empty@3x" imageCount:5];
        if (flag==1) {
             self.starForegroundView = [self buidlStarViewWithImageName:@"star_full@3x.png" imageCount:5];
            self.starForegroundView.hidden=YES;
        }
        if (flag==0) {

            doubleCount=[self dealScore:doubleCount];

            self.starForegroundView = [self buidlStarViewWithImageRound:@"star_full@3x.png" imageCount:doubleCount];
            
        }
       
        [self addSubview:self.starBackgroundView];
        [self addSubview:self.starForegroundView];
    }
    return self;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.starForegroundView.hidden=NO;
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if(CGRectContainsPoint(rect,point))
    {
        [self changeStarForegroundViewWithPoint:point];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __weak TQStarRatingView * weekSelf = self;
    
    [UIView transitionWithView:self.starForegroundView
                      duration:0.2
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^
     {
         [weekSelf changeStarForegroundViewWithPointEnd:point];
        

     }
                    completion:^(BOOL finished)
     {
         
     }];
}

- (UIView *)buidlStarViewWithImageName:(NSString *)imageName imageCount:(int)imageCount
{
    CGRect frame = self.bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    for (int i = 0; i < imageCount; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i * frame.size.width / self.numberOfStar, 0, frame.size.width / self.numberOfStar, frame.size.height);
        [view addSubview:imageView];
    }
    return view;
}


- (UIView *)buidlStarViewWithImageRound:(NSString *)imageName imageCount:(double)imageCount
{
    CGRect frame = self.bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    for (int i = 0; i < 5; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i * frame.size.width / self.numberOfStar, 0, frame.size.width / self.numberOfStar, frame.size.height);
        //NSLog(@"%@",NSStringFromCGRect(imageView.frame));
        [view addSubview:imageView];
    }
   // NSLog(@"%d",imageCount);
    view.frame = CGRectMake(0, 0,  imageCount*frame.size.width/self.numberOfStar, self.frame.size.height);


    return view;
}

//滑动显示
- (void)changeStarForegroundViewWithPoint:(CGPoint)point
{
    CGPoint p = point;
    
    if (p.x < 0)
    {
        p.x = 0;
    }
    else if (p.x > self.frame.size.width)
    {
        p.x = self.frame.size.width;
    }
    
    NSString * str = [NSString stringWithFormat:@"%0.2f",p.x / self.frame.size.width];
    float score = [str floatValue];
//    score=[self dealScore:score];
    p.x = score * self.frame.size.width;
    self.starForegroundView.frame = CGRectMake(0, 0, p.x, self.frame.size.height);
    
//    if(self.delegate && [self.delegate respondsToSelector:@selector(starRatingView: score:)])
//    {
//        [self.delegate starRatingView:self score:score];
//    }
}
//滑动结束
- (void)changeStarForegroundViewWithPointEnd:(CGPoint)point
{
    CGPoint p = point;
    
    if (p.x < 0)
    {
        p.x = 0;
    }
    else if (p.x > self.frame.size.width)
    {
        p.x = self.frame.size.width;
    }
    
    NSString * str = [NSString stringWithFormat:@"%0.2f",p.x / self.frame.size.width];
    float score = [str floatValue];
    
    score=[self dealScore:score*5];
     score=score/5.0;
    
    p.x = score * self.frame.size.width;
    self.starForegroundView.frame = CGRectMake(0, 0, p.x, self.frame.size.height);
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(starRatingView: score:)])
    {
        [self.delegate starRatingView:self score:score];
    }
}
//打分算法 0.0=< x <=0.5  x =0;    0.5< x < 1  x =1;

-(double)dealScore:(double)score{
    double resultScore=0.0;
    
    double tempScore=floor(score);
    double deltaScore=score-tempScore;
    if (deltaScore==0) {
        resultScore=tempScore;
    }
    if (deltaScore>0&&deltaScore<=0.5) {
        resultScore=tempScore+0.5;
    }
    
    if (deltaScore>0.5&&deltaScore<1) {
        resultScore=tempScore+1;
    }
    return resultScore;
}

@end
