//
//  JCYEvaluateViewController.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/10.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "JCYEvaluateViewController.h"
#import "TQStarRatingView.h"
#import "ZLCalendarUtil.h"
@interface JCYEvaluateViewController ()<StarRatingViewDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *TQStarView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
//评论分数
@property (assign, nonatomic) float score;
//评论时间
@property (strong, nonatomic) NSString *commentTime;
//参数字典
@property (strong, nonatomic) NSDictionary *evaluateSpaceDic;

@property (strong, nonatomic) AFRquest *AddComment;

@end

@implementation JCYEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      _commentTime=[JCYGlobalData jcyDateConversionStr:[NSDate date]];
    _evaluateSpaceDic=[JCYGlobalData sharedInstance].evaluateSpace;
    
    [self initUI];

}

#pragma -- mark UI PART
-(void)initUI
{
    _submitButton.layer.cornerRadius = 5;
    [_submitButton clipsToBounds];
    _contentTextView.layer.borderColor = [UIColor colorWithRed:122/255 green:123/255 blue:124/255 alpha:0.1].CGColor;
    _contentTextView.clipsToBounds = YES;
    _contentTextView.layer.borderWidth = 1;
    
    TQStarRatingView *starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0, 0, 150, 30) numberOfStar:5 flag:1 doubleCount:0.0];
    starRatingView.delegate = self;
    [_TQStarView addSubview:starRatingView];
    
}
#pragma -- mark TQStar DELEGATE
-(void)starRatingView:(TQStarRatingView *)view score:(float)score
{
    _score = score*10/2;
}


- (IBAction)goback:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

}
- (IBAction)submitButtonPressed:(UIButton *)sender {
    
        BOOL isSpaceingText=[CommonUtil stringContainsSpacing:_contentTextView.text];
    
    
    //请求条件检查
    if (_score <= 0) {
      
        [[PBAlert sharedInstance] showText:@"请打分" inView:self.view withTime:2.0];
    }else if ([_contentTextView.text containsString:@"请留下"]||isSpaceingText) {
        
        [[PBAlert sharedInstance] showText:@"请输入评价" inView:self.view withTime:2.0];
        
    }else{
       
        [self requestDataFromServer];
    }

    [_contentTextView resignFirstResponder];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_contentTextView resignFirstResponder];
}

#pragma mark -- TEXTVIEW DELEGATE
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 200) {

        [[PBAlert sharedInstance] showText:@"您的评价不能超过200字" inView:self.view withTime:2.0];
        
        textView.text = [textView.text substringToIndex:200];
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请留下您的宝贵意见"]) {
        textView.text = @"";
        textView.textColor = CommonColor_Black;
    }
}
#pragma mark -- REQUEST DELEGATE

//从服务器请求数据 空间搜索列表
-(void)requestDataFromServer
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataReceived:) name:[NSString stringWithFormat:@"%i",AddComment] object:nil];
    
    NSUserDefaults * userInfo = [NSUserDefaults standardUserDefaults];
    NSString * userToken = [userInfo valueForKey:USERTOKEN];
    
    _AddComment = [[AFRquest alloc]init];
    
    _AddComment.subURLString =[NSString stringWithFormat:@"api/Orders/AddComment?userToken=%@&deviceType=ios",userToken];

    _AddComment.parameters = @{@"SpaceId":_evaluateSpaceDic[@"Space"][@"SpaceId"],@"OrderId":_evaluateSpaceDic[@"OrderId"],@"Score":[NSNumber numberWithFloat:_score],@"CommentTime":_commentTime,@"Comment":_contentTextView.text};
    
    _AddComment.style = POST;
    
    [_AddComment requestDataFromWithFlag:AddComment];
    
}

-(void)dataReceived:(NSNotification *)notif{
    
    
    
    
    int result = [_AddComment.resultDict[@"Code"] intValue];
    if (result == SUCCESS) {
        
        NSLog(@"评论");
      
        [[PBAlert sharedInstance] showText:@"评论成功" inView:self.view withTime:2.0];
        
    }else{
        [[PBAlert sharedInstance] showText:_AddComment.resultDict[@"Description"] inView:self.view withTime:2.0];
    }
    
    
    
    NSLog(@"%@",_AddComment.resultDict);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",AddComment] object:nil];
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
