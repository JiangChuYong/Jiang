//
//  JCYStarfishCoinViewController.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/9.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "JCYStarfishCoinViewController.h"
#import "JCYCollectionCell.h"
@interface JCYStarfishCoinViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UILabel *balanceLable;



@property (strong, nonatomic) IBOutlet UILabel *paymentLabel;


@property (strong, nonatomic) IBOutlet UILabel *discountLabel;


@property (strong,nonatomic) NSMutableArray *buttonArr;

@property (strong,nonatomic) UIButton *currentButton;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
//价格数组
@property (strong,nonatomic) NSMutableArray *buttonTitleArr;

@property (strong, nonatomic) NSDate *currentDate;


@property (nonatomic, strong) NSMutableArray * discountInfoArr;

@property (strong, nonatomic) AFRquest *GetStarfishDiscountList;

@end

@implementation JCYStarfishCoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _buttonTitleArr=[NSMutableArray arrayWithObjects:@"200 币",@"400 币",@"800 币",@"1600 币",@"3200 币", nil];
    _buttonArr=[NSMutableArray new];
    _balanceLable.text=[NSString stringWithFormat:@"余额：%i",[[JCYGlobalData sharedInstance].userInfo[@"Starfish"] intValue]];
    _currentDate=[NSDate date];
    _currentDate=[self getNowDateFromatAnDate:_currentDate];
    NSLog(@"_current=%@",_currentDate);
    
    [self requestDataFromServer];

}

-(void)viewWillAppear:(BOOL)animated
{
    UINavigationController *navi=(UINavigationController *)self.parentViewController;
    navi.tabBarController.tabBar.hidden=YES;
}

//从服务器请求数据 空间搜索列表
-(void)requestDataFromServer
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataReceived:) name:[NSString stringWithFormat:@"%i",GetStarfishDiscountList] object:nil];
    
    NSUserDefaults * userInfo = [NSUserDefaults standardUserDefaults];
    NSString * userToken = [userInfo valueForKey:USERTOKEN];
    
    _GetStarfishDiscountList = [[AFRquest alloc]init];
    
    _GetStarfishDiscountList.subURLString =[NSString stringWithFormat:@"api/Coffee/GetStarfishDiscountList?userToken=%@&deviceType=ios",userToken];
    _GetStarfishDiscountList.style = GET;
    
    [_GetStarfishDiscountList requestDataFromWithFlag:GetStarfishDiscountList];
    
}

-(void)dataReceived:(NSNotification *)notif{
    int result = [_GetStarfishDiscountList.resultDict[@"Code"] intValue];
    if (result == SUCCESS) {
        
        NSLog(@"办公室");
        [self dealResposeResult:_GetStarfishDiscountList.resultDict[@"Data"]];
    }else{
        [[PBAlert sharedInstance] showText:_GetStarfishDiscountList.resultDict[@"Description"] inView:self.view withTime:2.0];
    }
    NSLog(@"%@",_GetStarfishDiscountList.resultDict);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",GetStarfishDiscountList] object:nil];
}


- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate] ;
    return destinationDateNow;
}



- (IBAction)goBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)instantRechargeButtonPressed:(UIButton *)sender {
    
//    JCYStarfishCoinRechargeViewController *starfishCoinRechargeVc=[[JCYStarfishCoinRechargeViewController alloc]initWithNibName:@"JCYStarfishCoinRechargeViewController" bundle:nil];
//    starfishCoinRechargeVc.starfishCoin=[_currentButton.titleLabel.text substringToIndex:_currentButton.titleLabel.text.length-2];
//    starfishCoinRechargeVc.starfishPrice=_paymentLabel.text;
//    [self.navigationController pushViewController:starfishCoinRechargeVc animated:YES];
    
    NSMutableDictionary *dataSource=[NSMutableDictionary dictionary];
    [dataSource setValue:[_currentButton.titleLabel.text substringToIndex:_currentButton.titleLabel.text.length-2] forKey:@"StarfishCoin"];
    [dataSource setValue:_paymentLabel.text forKey:@"StarfishPrice"];
    [JCYGlobalData sharedInstance].commonViewData=dataSource;
    
    [self performSegueWithIdentifier:@"StarFishCoinToRecharge" sender:self];
    
}

//处理折扣后的价格
- (void)priceButtonPressed:(UIButton *)sender {
    [self buttonSelectedCorlor:sender];
    for (UIButton * button in _buttonArr) {
        if (![button isEqual:sender]) {
            button.selected = NO;
            [self setButtonTextCorlor:button];
        }
    }
    //获取选中按钮的海星币金额
    NSMutableString * text = [NSMutableString stringWithString:sender.titleLabel.text] ;
    int index = (int)text.length-1;
    [text substringToIndex:index];
    float payNum = [text floatValue];
    //处理折扣后的金额显示
    float discout = [self selectedNumOfStarFish:payNum];
    if (discout==0) {
        self.discountLabel.hidden=YES;
        int payPriceNum=((NSString *)[NSString stringWithFormat:@"%@",[sender.titleLabel.text substringToIndex:sender.titleLabel.text.length-2]]).intValue;
        _paymentLabel.text=[NSString stringWithFormat:@"￥%i",payPriceNum/10];
        
    }else{
        self.discountLabel.hidden=NO;
        self.discountLabel.text = [NSString stringWithFormat:@"(%@折)",[self stringDisposeWithFloat:discout*10]];
        
        int payPriceNum=((NSString *)[NSString stringWithFormat:@"%@",[sender.titleLabel.text substringToIndex:sender.titleLabel.text.length-2]]).intValue;
        _paymentLabel.text=[NSString stringWithFormat:@"￥%@",[self stringDisposeWithFloat:payPriceNum/10*discout]];
    }

}

//浮点数处理并去掉多余的0
-(NSString *)stringDisposeWithFloat:(float)floatValue
{
    NSString *str = [NSString stringWithFormat:@"%f",floatValue];
    int len = (int)str.length;
    for (int i = 0; i < len; i++)
    {
        if (![str  hasSuffix:@"0"])
            break;
        else
            str = [str substringToIndex:[str length]-1];
    }
    if ([str hasSuffix:@"."])//避免像2.0000这样的被解析成2.
    {
        return [str substringToIndex:[str length]-1];//s.substring(0, len - i - 1);
    }
    else
    {
        return str;
    }
}


//选中button后，button的样式
-(void)buttonSelectedCorlor:(UIButton *)sender
{
    _currentButton=sender;
    sender.backgroundColor = CommonBackgroundColor_Orange;
    sender.layer.borderWidth = 0;
    sender.clipsToBounds = NO;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:sender.titleLabel.text];
    NSRange strRange = {0,str.length};
    [str addAttribute:NSForegroundColorAttributeName value:CommonColor_White range:strRange];
    [sender setAttributedTitle:str forState:UIControlStateNormal];
    sender.selected = !sender.selected;
}

//设置为选中button的样式
-(void)setButtonTextCorlor:(UIButton *)sender
{
    sender.backgroundColor = CommonColor_White;
    sender.layer.cornerRadius = 5;
    sender.clipsToBounds = YES;
    sender.layer.borderColor = CommonColor_Black.CGColor;
    sender.layer.borderWidth = 2;
    //改变button里面字体的颜色(sender.titleLabel.attributedText)
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:sender.titleLabel.text];
    NSRange strRange = {str.length-1,1};
    [str addAttribute:NSForegroundColorAttributeName value:CommonColor_Gray range:strRange];
    [sender setAttributedTitle:str forState:UIControlStateNormal];
}

#pragma -- mark CollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _buttonTitleArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_collectionView registerClass:[JCYCollectionCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    
    JCYCollectionCell *cell = (JCYCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    [cell.priceButton setTitle:[_buttonTitleArr objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    
    [cell.priceButton addTarget:self action:@selector(priceButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self setButtonTextCorlor:cell.priceButton];
    
    if (indexPath.row==0) {
        cell.priceButton.selected=YES;
        [self buttonSelectedCorlor:cell.priceButton];
    }
    
    [_buttonArr addObject:cell.priceButton];
    
    return cell;
}

#pragma -- REQUEST PART

/** *处理请求返回后的结果*/
-(void)dealResposeResult:(NSMutableArray *)responseArr{
    
    _discountInfoArr = [NSMutableArray arrayWithArray:responseArr];
    [self priceButtonPressed:_currentButton];
}

-(float)selectedNumOfStarFish:(float)chooseNum
{
    for (NSDictionary * starFishDict in _discountInfoArr) {
        
        NSDate * beginDate = [self translateStringToDate:starFishDict[@"beginTime"]];
        NSDate * endDate = [self translateStringToDate:starFishDict[@"endTime"]];
        NSLog(@"%@,%@",beginDate,endDate);
        if ([_currentDate compare:beginDate] == -1) {
            NSLog(@"日期太小");
            return 0;
        }else if ([_currentDate compare:endDate] == 1){
            NSLog(@"日期太大");
            return 0;
        }else{
            if (chooseNum <= [starFishDict[@"endRange"] floatValue] && chooseNum >= [starFishDict[@"beginRange"] floatValue]) {
                NSLog(@"正常折扣");
                return [starFishDict[@"discount"] floatValue];
            }
        }
    }
    return 0;
}

-(NSDate *)translateStringToDate:(NSString *)dateString
{
    
    NSDate *date=[JCYGlobalData jcyStringConversionDate:dateString WithFommater:@"yyyy-MM-dd HH:mm:ss"];
    
    return date;
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
