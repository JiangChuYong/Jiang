//
//  PBActiveSpaceBookingViewController.m
//  LincKia
//
//  Created by Phoebe on 15/12/25.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import "PBActiveSpaceBookingViewController.h"
#import "PBActiveSpaceBookingTableViewCell.h"
#import "PBBookingTableViewSugestionCell.h"
#import "ZZCalendarViewController.h"

@interface PBActiveSpaceBookingViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *pickerSure;
@property (weak, nonatomic) IBOutlet UIButton *pickerCancel;
@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) NSArray * tableDataArr;
@property (strong, nonatomic) NSArray * numOfPerson;
@property (strong, nonatomic) UITextView * suggestion;
@property (strong, nonatomic) NSMutableArray * startTimeArray;
@property (strong, nonatomic) NSMutableArray * endTimeArray;
@property (strong, nonatomic) UITextField * textField_1;
@property (strong, nonatomic) UITextField * textField_2;
@property (strong, nonatomic) UITextField * textField_3;
@property (strong, nonatomic) UITextField * textField_4;
@property (strong, nonatomic) UITextField * textField_5;
@property (strong, nonatomic) UITextField * textField_6;

@property (strong, nonatomic) UIView * backgroundMaskView;
@property(nonatomic,strong)NIDropDown *dropDown;
@property (weak, nonatomic) IBOutlet UIView *headview;
@property (strong,nonatomic) NSDictionary *activeSpaceInfoDict;
@property (strong,nonatomic) NSDictionary *responseDataOfIndexDict;
@property (strong,nonatomic) NSString *peopleNum ;
@property (strong,nonatomic) NSString *phoneNum;
@property (strong,nonatomic) NSString *customerName;
@property (strong,nonatomic) NSString *suggest;
@property (assign,nonatomic) CGFloat tempFlag;
@property (strong,nonatomic) NSDate *today;
@property (assign,nonatomic) CGSize tableViewContentSize;
@property (strong,nonatomic) AFRquest *visitActiveSpace;




@end

@implementation PBActiveSpaceBookingViewController

static NSString * normalCellIdKey = @"PBActiveSpaceBookingTableViewCell";
static NSString * lastCellIdKey = @"PBBookingTableViewSugestionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _activeSpaceInfoDict=[JCYGlobalData sharedInstance].activeSpaceInfo;
     _tempFlag=_tableView.bounds.origin.y;
    _tableViewContentSize=_tableView.contentSize;
    [self tableViewDataInit];
    [self pickerViewDataInit];
    //监听键盘控制确认按钮的动画
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    UIGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headViewTouchedDown:)];
    [_headview addGestureRecognizer:singleTap];
}
-(void)headViewTouchedDown:(id)sender
{
    [[self getFirstResponderSoon]resignFirstResponder];
}
-(void)keyboardWillShow:(NSNotification *)notification
{
    UITextView * textView = [self getFirstResponderSoon];
    if ([textView isEqual:_suggestion]) {
        NSLog(@"YES");
        NSNumber * duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        [UIView animateWithDuration:[duration doubleValue] animations:^{
            _tableView.contentOffset = CGPointMake(_tableView.bounds.origin.x, _tableView.bounds.origin.y+_suggestion.bounds.size.height+50);
            _tableView.contentSize=CGSizeMake(_tableView.contentSize.width, _tableView.bounds.size.height+_suggestion.bounds.size.height+50);
        }];
    }
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    UITextView * textView = [self getFirstResponderSoon];
   
    if ([textView isEqual:_suggestion]){
        NSNumber * duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        [UIView animateWithDuration:[duration doubleValue] animations:^{
            if (_tempFlag==_tableView.bounds.origin.y) {
                return ;
            }else{
                _tableView.contentOffset = CGPointMake(_tableView.bounds.origin.x,_tempFlag);
                
            }
            
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)pickNumOfPerson
{
    //获取第一响应者 并退出第一次响应者
    _pickerView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        _pickerView.frame = CGRectMake(0, Main_Screen_Height-_pickerView.frame.size.height+20, Main_Screen_Width, _pickerView.frame.size.height);
    }];
}
- (id)getFirstResponderSoon {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return [window performSelector:@selector(firstResponder)];
}
-(void)showCalendarView:(int)row
{
    //日历弹出
    ZZCalendarViewController * viewController = [ZZCalendarViewController shareCalendarVC];
    viewController.hideBeforeToday = YES;
    [viewController.selectDayView cancleClickDayViewStyle];
    viewController.view.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.7];
    [self.view addSubview:viewController.view];
    
    viewController.callBack=^(NSDate *date){
        
        if(!date){
            _textField_3.placeholder =@"请选择活动日期";
        }else{
            _textField_3.text = [date stringFromDate:@"yyyy-MM-dd"];
            _textField_3.textColor = [UIColor colorWithRed:1/255.0f green:12/255.0f blue:23/255.0f alpha:1];
            _today=date;
             _startTimeArray = [NSMutableArray arrayWithObjects:@"9:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00", nil];
             _endTimeArray = [NSMutableArray arrayWithObjects:@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00", nil];
            if ([date compare:[NSDate date]] == -1) {
                NSLog(@"%@,%@",date,[NSDate date]);
                _startTimeArray = [JCYGlobalData filterTimeArray:_startTimeArray];
                _endTimeArray =  [JCYGlobalData filterTimeArray:_endTimeArray];
            }
        }
    };
}
-(void)textFieldDidChange:(UITextField *)textField
{
    //输入框控制输入字数在15字以内
    if (textField.text.length > 15) {
        textField.text = [textField.text substringToIndex:10];
    }
}
#pragma -- mark ACTION PART
- (IBAction)confirmOrCancelButtonPressed:(UIButton *)sender {
    //取消与确认按钮的动画效果
    [UIView animateWithDuration:0.5 animations:^{
        _pickerView.frame = CGRectMake(0, Main_Screen_Height+20, Main_Screen_Width, _pickerView.frame.size.height);
    }];
    
    //如果用户选中取消按钮清除所选择的时间
    if ([sender isEqual:_pickerCancel]) {
        _textField_6.placeholder = @"请选择活动人数";
    }
}
- (IBAction)bookingButtonPressed:(UIButton *)sender {
    //检查各项条件
    //姓名
    if ([_textField_1.text isEqualToString:@""]) {
        
        [[PBAlert sharedInstance]showText:@"请输入您的姓名" inView:self.view withTime:2.0];
        return;
    }else{
        _customerName=_textField_1.text;
    }
    
    //手机
    if (![CommonUtil isValidateMobile:_textField_2.text]) {
        
        [[PBAlert sharedInstance]showText:@"请输入有效手机号码" inView:self.view withTime:2.0];
        return;
    }else{
        _phoneNum=_textField_2.text;
    }
    
    //日期与时间
    NSString * date,*start,*end,*startTime,*endTime;
    
    if ([_textField_3.text isEqualToString:@""]) {
        
        [[PBAlert sharedInstance]showText:@"请选择活动日期" inView:self.view withTime:2.0];
        return;
    }else{
        date = [NSString stringWithString:_textField_3.text];
    }
    
    if ([_textField_4.text isEqualToString:@""]) {
        
        [[PBAlert sharedInstance]showText:@"请选择开始时间" inView:self.view withTime:2.0];
        return;
    }else{
        start = [NSString stringWithString:_textField_4.text];
    }
    
    if ([_textField_5.text isEqualToString:@""]) {
        
        [[PBAlert sharedInstance]showText:@"请选择结束时间" inView:self.view withTime:2.0];
        return;
    }else{
        end = [NSString stringWithString:_textField_5.text];
    }
    if (date && start && end) {
        startTime = [NSString stringWithFormat:@"%@ %@",date,start];
        endTime = [NSString stringWithFormat:@"%@ %@",date,end];
    }
    
    //活动人数
    if([_textField_6.text isEqualToString:@""]){
        
        [[PBAlert sharedInstance]showText:@"请选择活动人数" inView:self.view withTime:2.0];
        return;
    }else{
        _peopleNum=_textField_6.text;
    }
    
    //其他补充
    _suggest=_suggestion.text;


    
    _visitActiveSpace = [[AFRquest alloc]init];
    _visitActiveSpace.subURLString = @"api/ActiveSpace/VisitActiveSpace?userToken=0346f03a-e63d-4691-9ea7-d22959bcb83a&deviceType=ios";
    _visitActiveSpace.parameters = @{@"activeSpaceName":_activeSpaceInfoDict[@"Data"][@"activeSpaceName"],@"name":_customerName,@"phoneNum":_phoneNum,@"startTime":startTime,@"endTime":endTime,@"peopleNum":_peopleNum,@"content":_suggest};
    _visitActiveSpace.style = POST;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataReceived:) name:[NSString stringWithFormat:@"%i",VisitActiveSpace] object:nil];
    [_visitActiveSpace requestDataFromWithFlag:VisitActiveSpace];

}


-(void)dataReceived:(NSNotification *)notif{
    
    
    
    _responseDataOfIndexDict = _visitActiveSpace.resultDict;
    
    NSLog(@"%@",_responseDataOfIndexDict);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",GetActiveSpaceList] object:nil];
}




- (IBAction)backButtonPressed:(UIButton *)sender {
    UINavigationController *navi=(UINavigationController *)self.parentViewController;
    [navi popViewControllerAnimated:YES];
}
#pragma -- mark DATA PART
-(void)tableViewDataInit
{
    NSString * activeSpaceName = _activeSpaceInfoDict[@"Data"][@"activeSpaceName"];
    NSArray * row01 = [NSArray arrayWithObjects:@"office_position@3x.png",@"活动空间",activeSpaceName, nil];
    NSArray * row02 = [NSArray arrayWithObjects:@"name.png",@"姓名",@"请输入姓名", nil];
    NSArray * row03 = [NSArray arrayWithObjects:@"cellphone_number@3x.png",@"手机",@"请输入手机号码", nil];
    NSArray * row04 = [NSArray arrayWithObjects:@"date.png",@"活动日期",@"请选择活动日期", nil];
    NSArray * row05 = [NSArray arrayWithObjects:@"time.png",@"开始时间",@"请选择开始时间", nil];
    NSArray * row06 = [NSArray arrayWithObjects:@"time.png",@"结束时间",@"请选择结束时间", nil];
    NSArray * row07 = [NSArray arrayWithObjects:@"team.png",@"活动人数",@"请选择活动人数", nil];
    _tableDataArr = [NSArray arrayWithObjects:row01,row02,row03,row04,row05,row06,row07, nil];
    
    //未选中状态下 默认的开始时间与结束时间
    _startTimeArray = [NSMutableArray arrayWithObjects:@"9:00",@"10:00",@"11:00",@"11:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00", nil];
    _endTimeArray = [NSMutableArray arrayWithObjects:@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00", nil];
}

-(void)pickerViewDataInit
{
    _numOfPerson = [NSArray arrayWithObjects:@"请选择",@"1-5人",@"5-10人",@"10-20人",@"20-50人",@"50-100人",@"100人以上", nil];
}
#pragma -- mark UITEXTFIELD DELEGTE
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (NSString *)getOnlyNum:(NSString *)str
{
    return [str stringByReplacingOccurrencesOfString:@"[^0-9,]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [str length])];
}


#pragma mark NIDropDown delegate
//结束租用日期下拉列表
-(void)alertDropDownView:(NSMutableArray *)arr tag:(id)sender
{
    if(self.dropDown == nil) {
        if(!self.backgroundMaskView)
        {
            self.backgroundMaskView = [[UIView alloc]initWithFrame:self.view.frame];
            //            //背景设置为半透明黑色
            self.backgroundMaskView.backgroundColor = HalfClearColor;
            [self.view addSubview:self.backgroundMaskView];
        }
        self.backgroundMaskView.hidden = NO;
        CGFloat f = 160;
        self.dropDown = [[NIDropDown alloc]initShowDropDown:sender :&f :arr :self.view];
        self.dropDown.tag = [sender tag];
        self.dropDown.delegate = self;
    }else {
        [self.dropDown hideDropDown];
        [self rel];
    }
}
- (void)niDropDownDelegateMethod:(NIDropDown *) sender text:(NSString *)text
{
    int tag = (int)sender.tag;
    NSLog(@"%i",(int)tag);
    if (tag == 4) {
        //选中开始时间后处理即将显示的结束时间数据
        _endTimeArray = [NSMutableArray arrayWithObjects:@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00", nil];
        for (int i=0; i<_endTimeArray.count; i++) {
            if ([_endTimeArray[i] isEqualToString:text]) {
                NSLog(@"text%@",text);
                NSArray * temp = [_endTimeArray subarrayWithRange:NSMakeRange(i+1, _endTimeArray.count-i-1)];
                _endTimeArray = [NSMutableArray arrayWithArray:temp];
                NSLog(@"today%@",_today);

                
            }
        }
        if ([_today compare:[NSDate date]] == -1) {
            _startTimeArray = [JCYGlobalData filterTimeArray:_startTimeArray];
            _endTimeArray =  [JCYGlobalData filterTimeArray:_endTimeArray];
        }
        _textField_4.text = text;
        
    }else if(tag == 5){
        //选中结束时间后处理即将显示的结束时间数据
        _startTimeArray = [NSMutableArray arrayWithObjects:@"9:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00", nil];
        for (int i=0; i<_startTimeArray.count; i++) {
            if ([_startTimeArray[i] isEqualToString:text]) {
                NSLog(@"%@",text);
                NSArray * temp = [_startTimeArray subarrayWithRange:NSMakeRange(0,i)];
                _startTimeArray = [NSMutableArray arrayWithArray:temp];
              
                NSLog(@"today%@",_today);
                
                
            }
        }
        _textField_5.text = text;
        if ([_today compare:[NSDate date]] == -1) {
            _startTimeArray = [JCYGlobalData filterTimeArray:_startTimeArray];
            _endTimeArray =  [JCYGlobalData filterTimeArray:_endTimeArray];
        }
    }
    
    NSLog(@"%@",text);
    
    [self rel];
}

-(void)rel{
    self.backgroundMaskView.hidden = YES;
    self.dropDown = nil;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.dropDown hideDropDown];
    [self rel];
}

#pragma -- mark UITEXTVIEW DELEGTE
-(void)textViewDidChange:(UITextView *)textView
{
    //限制录入字符字数200以内
    if (textView.text.length > 200) {
        textView.text = [textView.text substringToIndex:200];
    }
    if ([textView.text containsString:@"\n"]) {
        [textView resignFirstResponder];
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@" 请输入"]) {
        textView.text = @"";
        textView.alpha = 1;
        textView.textColor = CommonColor_Black;
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @" 请输入";
        textView.alpha = 0.5;
        textView.textColor = CommonColor_Gray;
    }
}
#pragma -- mark TABLEVIEW DELEGTE
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _tableDataArr.count) {
        
        [_tableView registerNib:[UINib nibWithNibName:@"PBActiveSpaceBookingTableViewCell" bundle:nil] forCellReuseIdentifier:normalCellIdKey];
        PBActiveSpaceBookingTableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:normalCellIdKey];
        cell.nameField.delegate = self;
        cell.nameField.tag = indexPath.row;
        [cell.nameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        //获取输入框
        if (indexPath.row ==  1) {
            _textField_1 = cell.nameField;
        }
        if (indexPath.row ==  2) {
            _textField_2 = cell.nameField;
        }
        if (indexPath.row ==  3) {
            _textField_3 = cell.nameField;
        }
        if (indexPath.row ==  4) {
            _textField_4 = cell.nameField;
            UIButton * button = [[UIButton alloc]initWithFrame:cell.frame];
            button.tag = indexPath.row;
            [cell addSubview:button];
            [button addTarget:self action:@selector(selectedRowAtIndex:) forControlEvents:UIControlEventTouchDown];
        }
        if (indexPath.row ==  5) {
            _textField_5 = cell.nameField;
            UIButton * button = [[UIButton alloc]initWithFrame:cell.frame];
            button.tag = indexPath.row;
            [cell addSubview:button];
            [button addTarget:self action:@selector(selectedRowAtIndex:) forControlEvents:UIControlEventTouchDown];
        }
        if (indexPath.row ==  6) {
            _textField_6 = cell.nameField;
        }
        
        //赋值
        [cell insertContentWithData:_tableDataArr andIndexPath:indexPath];
        
        return cell;
    }else{
        [_tableView registerNib:[UINib nibWithNibName:@"PBBookingTableViewSugestionCell" bundle:nil] forCellReuseIdentifier:lastCellIdKey];
        PBBookingTableViewSugestionCell * cell = [_tableView dequeueReusableCellWithIdentifier:lastCellIdKey];
        cell.suggestion.delegate = self;
        _suggestion = cell.suggestion;
        _suggestion.delegate =self;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id firstResponder = [self getFirstResponderSoon];
    [firstResponder resignFirstResponder];
    
    if (indexPath.row == 3) {
        [self showCalendarView:(int)indexPath.row];
    }else if (indexPath.row == 6){
        [self pickNumOfPerson];
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableDataArr.count+1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _tableDataArr.count) {
        return 48;
    }else{
        return 168;
    }
}
-(void)selectedRowAtIndex:(UIButton *)button
{
    if (button.tag == 4){
        [self alertDropDownView:_startTimeArray tag:button];
    }else if (button.tag == 5){
        [self alertDropDownView:_endTimeArray tag:button];
    }
}

#pragma -- mark PICKER DELEGTE

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _numOfPerson.count;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _numOfPerson[row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _peopleNum=_numOfPerson[row];
    _textField_6.text = _numOfPerson[row];
    
    if ([_textField_6.text isEqualToString:@"请选择"]) {
        _textField_6.text = @"";
        _textField_6.placeholder = @"请选择活动人数";
    }
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
