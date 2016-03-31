//
//  JCYBookingSpaceViewController.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/2.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "JCYBookingSpaceViewController.h"
#import "ZZCalendarViewController.h"
#import "ZZFInishOrderViewController.h"
#import "PBActiveSpaceBookingTableViewCell.h"
#import "PBBookingTableViewSugestionCell.h"
@interface JCYBookingSpaceViewController ()
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@property (strong, nonatomic) NSDictionary *spaceViewInfoDict;
@property (strong, nonatomic) NSString *numOfTeam;
@property (strong,nonatomic) NSArray * numOfPplArray;
@property (strong,nonatomic) NSArray * labelNameArray;
@property (strong,nonatomic) NSArray * imageNameArray;
@property (strong,nonatomic) NSArray * placeHolderArray;
@property (strong,nonatomic) UITextView *tempTextView;
@property (strong,nonatomic) NSMutableArray * cellArray;
@property (strong,nonatomic) AFRquest *AddCustomOfficeInfo;
@property (strong,nonatomic) NSMutableDictionary *parametersDict;
@property (strong,nonatomic) NSDictionary *receiveDataDict;
@end

@implementation JCYBookingSpaceViewController

static NSString * otherCellIDKey = @"PBActiveSpaceBookingTableViewCell";
static NSString * suggestCellIDKey = @"PBBookingTableViewSugestionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetUI];
    [self initDataSource];
    [self registerCellForTable];
}


-(void)registerCellForTable
{
    [_table registerNib:[UINib nibWithNibName:@"PBActiveSpaceBookingTableViewCell" bundle:nil] forCellReuseIdentifier:otherCellIDKey];
    [_table registerNib:[UINib nibWithNibName:@"PBBookingTableViewSugestionCell" bundle:nil] forCellReuseIdentifier:suggestCellIDKey];
}
-(void)initDataSource
{
    _parametersDict=[NSMutableDictionary dictionary];
    _spaceViewInfoDict = [JCYGlobalData sharedInstance].spaceDetailInfo;
    //人数选择数据
    _numOfPplArray = [NSArray arrayWithObjects:@"请选择",@"1-5人",@"5-10人",@"10-20人",@"20-50人",@"50人以上", nil];
    //表格数据
    _labelNameArray = [NSArray arrayWithObjects:@"办公社区",@"姓名",@"手机",@"行业",@"入驻时间",@"团队人数",nil];
    _imageNameArray = [NSArray arrayWithObjects:@"office_location",@"name",@"phone",@"industry",@"time",@"team", nil];
    _placeHolderArray = [NSArray arrayWithObjects:_spaceViewInfoDict[@"Data"][@"Name"],@"请输入姓名",@"请输入手机号",@"请输入行业",@"请选择入驻时间",@"请选择团队人数", nil];
    //cell数组初始化
    _cellArray = [NSMutableArray array];
}
#pragma -- mark UITABLEVIEW DELEGATE
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _labelNameArray.count+1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _labelNameArray.count) {
        return 42;
    }else{
        return 186;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PBActiveSpaceBookingTableViewCell * otherCell = [_table dequeueReusableCellWithIdentifier:otherCellIDKey];
    PBBookingTableViewSugestionCell * suggestCell = [_table dequeueReusableCellWithIdentifier:suggestCellIDKey];
    
    if (indexPath.row < 6) {
        //显示控制
        if (indexPath.row < 4) {
            if (indexPath.row == 0) {
                otherCell.name.textColor = CommonColor_Blue;
                otherCell.nameField.text = _placeHolderArray[indexPath.row];
            }
            otherCell.arrow.hidden = YES;
            otherCell.nameField.userInteractionEnabled = YES;
        }else{
            otherCell.arrow.hidden = NO;
            otherCell.nameField.userInteractionEnabled = NO;
        }
        //赋值
        otherCell.icon.image = [UIImage imageNamed:_imageNameArray[indexPath.row]];
        otherCell.name.text = _labelNameArray[indexPath.row];
        otherCell.nameField.placeholder = _placeHolderArray[indexPath.row];
        //获取cell
        otherCell.nameField.tag = 2000+indexPath.row;
        otherCell.nameField.delegate = self;
        [otherCell.nameField addTarget:self action:@selector(textFieldDidChangeEditing:) forControlEvents:UIControlEventEditingChanged];
        [_cellArray addObject:otherCell];
        return otherCell;
    }else{
        suggestCell.suggestion.tag = 2000+indexPath.row;
        _tempTextView=suggestCell.suggestion;
        suggestCell.suggestion.delegate = self;
        [_cellArray addObject:suggestCell];
        return suggestCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tempTextView resignFirstResponder];
    if (indexPath.row == 4) {
        [self pickTimeButtonPressed];
    }else if (indexPath.row == 5){
        [self pickNumOfPersonsButtonPressed];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITextField *)getFirstResponder
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    return firstResponder;
}
#pragma -- mark Action part
- (IBAction)backButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)pickTimeButtonPressed{
    //退出第一响应者
    [[self getFirstResponder] resignFirstResponder];
    [JCYGlobalData sharedInstance].validDays = 365;
    //日历弹出
    ZZCalendarViewController *viewController = [ZZCalendarViewController shareCalendarVC];
    viewController.hideAfterValidDay = YES;
    [viewController.selectDayView cancleClickDayViewStyle];
    viewController.view.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.7];
    [self.view addSubview:viewController.view];
    //入驻时间
    PBActiveSpaceBookingTableViewCell * cell = _cellArray[4];
    viewController.callBack=^(NSDate *date){
        if(!date){
            cell.nameField.text = @"请选择入驻时间";
        }else{
            cell.nameField.text = [date stringFromDate:@"yyyy-MM-dd"];
        }
    };
}
- (void)pickNumOfPersonsButtonPressed{
    //获取第一响应者 并退出第一次响应者
    [[self getFirstResponder] resignFirstResponder];
    _pickerView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        _pickerView.frame = CGRectMake(0, Main_Screen_Height-_pickerView.frame.size.height+20, Main_Screen_Width, _pickerView.frame.size.height);
    }];
}
- (IBAction)confirmOrCancelButtonPressed:(UIButton *)sender {
    NSLog(@"arr=%@",_numOfPplArray);
    //取消与确认按钮的动画效果
    [UIView animateWithDuration:0.5 animations:^{
        _pickerView.frame = CGRectMake(0, Main_Screen_Height+20, Main_Screen_Width, _pickerView.frame.size.height);
    }];
    //如果用户选中取消按钮清除所选择的时间
    PBActiveSpaceBookingTableViewCell * cell = _cellArray[5];
    if ([sender isEqual:_cancelBtn]) {
        cell.nameField.placeholder = @"请选择团队人数";
        cell.nameField.text = @"";
    }
}
- (IBAction)submitButtonPressed:(UIButton *)sender {
    
    for (int i=0; i<_cellArray.count-1; i++) {
        
        PBActiveSpaceBookingTableViewCell * cell = _cellArray[i];
        NSString * text = cell.nameField.text;
        
        //空间名
        if (i==0) {
            [_parametersDict setValue:text forKey:@"OfficeAddress" ];
            
        }
        
        //姓名
        if (i==1) {
            [_parametersDict setValue:text forKey:@"Name"];
            if ([CommonUtil isBlankString:text]) {
                 [[PBAlert sharedInstance]showText:@"请输入您的姓名" inView:self.view withTime:2.0];
                return;
            }
        }
        
        //手机号
        if (i==2) {
            [_parametersDict setValue:text forKey:@"TelPhone"];
            if ([CommonUtil isBlankString:text]) {
                [[PBAlert sharedInstance]showText:@"请输入您的手机号" inView:self.view withTime:2.0];
                return;
            }
        }
        
        //行业
        if (i==3) {
            [_parametersDict setValue:text forKey:@"Industry"];

            if ([CommonUtil isBlankString:text]) {
                  [[PBAlert sharedInstance]showText:@"请输入行业名称" inView:self.view withTime:2.0];
                return;
            }
        }
        
        //入驻时间
        if (i==4) {
         
            [_parametersDict setValue:text forKey:@"ExpectedTme"];

            if ([CommonUtil isBlankString:text]) {
                [[PBAlert sharedInstance]showText:@"请选择入驻时间" inView:self.view withTime:2.0];
                return;
            }
        }
        
        //团队人数
        if (i==5) {
            [_parametersDict setValue:text forKey:@"TeamNmber"];
            if ([CommonUtil isBlankString:text]) {
                [[PBAlert sharedInstance]showText:@"请选择团队人数" inView:self.view withTime:2.0];
                return;
            }
        }
    }
    PBBookingTableViewSugestionCell * otherCell = [_cellArray lastObject];
   
    [_parametersDict setValue:otherCell.suggestion.text forKey:@"OtherSpplements"];

    [self requestDataFromServer];

}
-(void)requestDataFromServer
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataReceived:) name:[NSString stringWithFormat:@"%i",AddCustomOfficeInfo] object:nil];
    
    _AddCustomOfficeInfo= [[AFRquest alloc]init];
    _AddCustomOfficeInfo.subURLString = @"api/CustomOffice/AddCustomOfficeInfo?deviceType=ios";
    _AddCustomOfficeInfo.parameters = @{@"OfficeAddress":_parametersDict[@"OfficeAddress"],@"Name":_parametersDict[@"Name"],@"TelPhone":_parametersDict[@"TelPhone"],@"TeamNmber":_parametersDict[@"TeamNmber"],@"ExpectedTme":_parametersDict[@"ExpectedTme"],@"OtherSpplements":_parametersDict[@"OtherSpplements"],@"Industry":_parametersDict[@"Industry"]};
    _AddCustomOfficeInfo.style = POST;
    [_AddCustomOfficeInfo requestDataFromWithFlag:AddCustomOfficeInfo];
    
    
    
}

-(void)dataReceived:(NSNotification *)notif{
    
    _receiveDataDict=_AddCustomOfficeInfo.resultDict;
    
    NSLog(@"%@",_AddCustomOfficeInfo.resultDict);
    
    int result = [_AddCustomOfficeInfo.resultDict[@"Code"] intValue];;
    if (result == SUCCESS) {
        
        //[self dealDataWithResponse:_spaceInfoDict[@"Data"]];
        [JCYGlobalData sharedInstance].spaceVisitDict=_parametersDict;
        [JCYGlobalData sharedInstance].isActiveSpace=NO;
        
        [JCYGlobalData sharedInstance].sucessFromPage=MyOnlineBooking;
        [self performSegueWithIdentifier:@"LinckiaSpaceBookingToFinish" sender:self];
        
        
    }else{
        
        [[PBAlert sharedInstance]showText:_receiveDataDict
         [@"Description"]inView:self.view withTime:2.0];
    }
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",LinckiaSpaceGetOne] object:nil];
}

#pragma -- mark UITextField delegate
-(void)textFieldDidChangeEditing:(UITextField *)textField
{
    if (textField.text.length > 15) {
        textField.text = [textField.text substringToIndex:15];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    //判断是否合法字符
    if ([CommonUtil stringContainsEmoji:textField.text]||[CommonUtil stringContainsIllegalChar:textField.text]) {
//        [[PBAlert sharedInstance] showWithText:@"请输入正确的字符" inView:self.view lastTime:2.0];
        textField.text = @"";
    }
    //判断手机号是否正确
    if (textField.tag == 2000+2) {
        if (![CommonUtil isValidateMobile:textField.text]&&![textField.text isEqualToString:@""]) {
//            [[AlertUtils sharedInstance] showWithText:@"您输入的手机号有误" inView:self.view lastTime:2.0];
            textField.text = @"";
        }
    }
}
#pragma -- mark UITextView delegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@" 请输入"]) {
        textView.text = @"";
    }
    textView.alpha = 1;
    textView.textColor = CommonColor_Black;
    [UIView animateWithDuration:0.4 animations:^{
        _table.contentOffset = CGPointMake(0, 186);
    }];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([CommonUtil isBlankString:textView.text]) {
        textView.text = @" 请输入";
        textView.textColor = CommonColor_Gray;
        textView.alpha = 0.5;
    }
    
    if (_table.frame.origin.y > 0) {
        [UIView animateWithDuration:0.4 animations:^{
            _table.contentOffset = CGPointMake(0, 0);
        }];
    }
    
    if (textView.text.length > 200) {
        textView.text = [textView.text substringToIndex:200];
    }
}
-(void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text containsString:@"\n"]) {
        [textView resignFirstResponder];
    }
}
#pragma -- mark UIPickerView delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 25;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _numOfPplArray.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _numOfPplArray[row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //团队人数
    PBActiveSpaceBookingTableViewCell * cell = _cellArray[5];
    _numOfTeam = _numOfPplArray[row];
    if (![_numOfTeam isEqualToString:@"请选择"]) {
        cell.nameField.text = _numOfTeam;
    }else{
        cell.nameField.text = @"";
        cell.nameField.placeholder = @"请选择团队人数";
    }
}
#pragma -- mark UI Part
-(void)resetUI
{
    //提交按钮
    _submitButton.layer.cornerRadius = 5;
    _submitButton.clipsToBounds = YES;
}

#pragma mark -- Data Request Part


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
