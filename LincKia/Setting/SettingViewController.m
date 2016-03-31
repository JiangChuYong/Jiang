//
//  SettingViewController.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/8.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "SettingViewController.h"
#import "OtherTableViewCell.h"
#import "PBClearCache.h"
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITabBarControllerDelegate>
{
    //自定义cell其他的lable值
    NSMutableArray *otherCellInfoList;
    NSArray *versionLanguageList;
    UIButton *btnSubmit;
}

//枚举（给设置页面弹出的五个alertView的Tag赋值）
typedef enum {
    AlertVersionUpdateTag=11,
    AlertClearCacheTag=12,
    AlertClearCacheSuccessTag=13,
    AlertVersionLanguageTag=14,
    AlertReceiveInfoTag=15
} AlertTagType;

@property (weak, nonatomic) IBOutlet UITableView *setInfoTableView;
@property(strong,nonatomic)UIPickerView *versionLanguagePickerView;
@property(strong,nonatomic)UIView *versionLanguageBackgroundView;
@property(strong,nonatomic)UIView *bigBackGroundView;

@property (weak, nonatomic) IBOutlet UIButton *exitBtn;

@property (assign,nonatomic) CGFloat cacheSize;
@property (strong,nonatomic) NSString * cachePath;

@end

@implementation SettingViewController
//其他自定义cell的cellIdentifier
static NSString *otherTableViewCell = @"otherTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _exitBtn.layer.cornerRadius = 5;
    _exitBtn.clipsToBounds = YES;
    [self initDataSource];
    [self registerCell];
    /*获取缓存大小*/
    _cachePath = [PBClearCache getMyCachePath];
    _cacheSize = [PBClearCache folderSizeAtPath:_cachePath];
    [_setInfoTableView reloadData];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UINavigationController *navi=(UINavigationController *)self.parentViewController;
    navi.tabBarController.tabBar.hidden=YES;
    
}

#pragma mark --设置数据源

-(void)initDataSource{
    //其他的自定义cell中lable数据源
    otherCellInfoList=[NSMutableArray arrayWithArray:@[@"消息推送",@"清理缓存"]];
}

#pragma mark --注册自定义cell
-(void)registerCell{
    
    //注册其他的cell
    [self.setInfoTableView registerNib:[UINib nibWithNibName:@"OtherTableViewCell" bundle:nil] forCellReuseIdentifier:otherTableViewCell];
}


-(IBAction)goback:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)exit:(UIButton *)sender{
    
    
    UIAlertView *alter=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确认退出？" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    alter.tag=10001;
    [alter show];
    
    
    
}


#pragma mark -- UITableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return otherCellInfoList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OtherTableViewCell *otherCell=[tableView dequeueReusableCellWithIdentifier:otherTableViewCell];
    [otherCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    otherCell.labelSetInfo.text=otherCellInfoList[indexPath.row];
    if (indexPath.row == 1) {
        otherCell.cacheNumLab.text = [NSString stringWithFormat:@"%.2fM",_cacheSize/1024/1024];
    }
    return otherCell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row==0){
        
        //[self pushToMessagePullPage];
        NSLog(@"推向 通知页面");

        
    }else if (indexPath.row == 1){
        //浮点数不能直接进行比较，将两个值相减之后在与0.00001比较
        if (_cacheSize-0> 0.00001) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"是否清除全部缓存数据？"  delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            NSLog(@"_cacheSize  %f",_cacheSize);
            alert.tag = AlertClearCacheTag;
            [alert show];
        }else{
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"暂无可清理缓存" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alert show];
        }
    }
}

#pragma mark -- UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == AlertClearCacheTag && buttonIndex == 1) {
        [self clearCache];
        NSLog(@"清除缓存");
    }
    
    
    if(alertView.tag==10001 ){
        
        if (buttonIndex==0) {
            [self cleanUserInfo];
            NSLog(@"退出登录");

        }else{
            NSLog(@"取消");
            
        }
        
    }
}
#pragma mark -- 私有方法
//清空缓存
-(void)clearCache
{
    [PBClearCache clearCache:_cachePath];
    _cacheSize = [PBClearCache folderSizeAtPath:_cachePath];
    if (!_cacheSize) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"清除成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    [_setInfoTableView reloadData];
}

//清空登录设置
-(void)cleanUserInfo
{
    [JCYGlobalData sharedInstance].userInfo = nil;
    //清空登录缓存
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:nil forKey:USERNAME];
    [user setObject:nil forKey:PASSWORD];
    [user synchronize];
    
    [JCYGlobalData sharedInstance].LoginStatus=NO;
    
    UINavigationController *navi=(UINavigationController *)self.parentViewController;
    [navi popToRootViewControllerAnimated:NO];
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"Exit" object:nil];
    
    if (navi.tabBarController.selectedIndex!=0) {
        navi.tabBarController.selectedIndex=0;
        
        //回到首页动画
        CATransition *animation =[CATransition animation];
        [animation setDuration:0.3f];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromLeft];
        [navi.tabBarController.view.layer addAnimation:animation forKey:@"reveal"];
    }
    
//    CATransition *transition = [CATransition animation];
//    [transition setDuration:0.3];
//    [transition setType:@"reveal"];
//    [self.tabBarController.view.layer addAnimation:transition forKey:nil];

    
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
