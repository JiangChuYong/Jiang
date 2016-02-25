//
//  PBCompanyListViewController.m
//  LincKia
//
//  Created by 董玲 on 11/16/15.
//  Copyright © 2015 ZZ. All rights reserved.
//

#import "PBCompanyListViewController.h"
#import "PBCompanyListTableViewCell.h"

@interface PBCompanyListViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSMutableArray *companyListArray;
@property (weak, nonatomic) IBOutlet UITableView *companyTableView;
@property (weak, nonatomic) IBOutlet UIView *nodataView;
@property (strong ,nonatomic) NSDictionary *responseDataOfIndexDict;

@property (strong,nonatomic) AFRquest * GetLinckiaPartnerList;

@end

@implementation PBCompanyListViewController

static NSString *identifier=@"PBCompanyListTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    _titleLabel.text = [JCYGlobalData sharedInstance].industryName;
//    [[ZZAllService sharedInstance] serviceQueryByObj:@{@"Page":@1,@"Rows":@10,@"SortProperty":@"Name",@"SortDirection":@"asc",@"industryId":[ZZGlobalModel sharedInstance].industryId} delegate:self httpTag:HTTPHelperTag_Spaces_GetLinckiaPartnerList];
    
    [self.companyTableView registerNib:[UINib nibWithNibName:@"PBCompanyListTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",GetLinckiaPartnerList] object:nil];

    _GetLinckiaPartnerList = [[AFRquest alloc]init];
    _GetLinckiaPartnerList.subURLString = @"api/Industry/GetLinckiaPartnerList?userToken=""&deviceType=ios";
    _GetLinckiaPartnerList.parameters = @{@"Page":@1,@"Rows":@10,@"SortProperty":@"Name",@"SortDirection":@"asc",@"industryId":[JCYGlobalData sharedInstance].industryId};
    _GetLinckiaPartnerList.style = GET;
    [_GetLinckiaPartnerList requestDataFromWithFlag:GetLinckiaPartnerList];
    
}


-(void)dataReceived:(NSNotification *)notif{
    
    _responseDataOfIndexDict = [notif object];
    if (_GetLinckiaPartnerList) {
        NSLog(@"%@",_responseDataOfIndexDict);
        
        _companyListArray=_responseDataOfIndexDict[@"Data"][@"Data"];
        
        [_companyTableView reloadData];
        
        if (_companyListArray.count <= 0) {
            [self.view bringSubviewToFront:_nodataView];
        }else{
            [self.view bringSubviewToFront:_companyTableView];
        }

    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataReceived:) name:[NSString stringWithFormat:@"%i",GetLinckiaPartnerList] object:nil];

}


-(void)phoneButtonPressed:(UIButton *)button
{
    NSDictionary *tempDict= _companyListArray[button.tag];
   NSMutableString *phoneNum=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",tempDict[@"companyTel"]];    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNum]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonPressed:(UIButton *)sender {

    [self.navigationController popViewControllerAnimated:YES];
}
#pragma -- mark TABLEVIEW PART
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PBCompanyListTableViewCell * cell = [self.companyTableView dequeueReusableCellWithIdentifier:identifier];
    NSDictionary * partnerDict = _companyListArray[indexPath.row];
    cell.companyNameLabel.text = partnerDict[@"companyName"];
    cell.locationLabel.text = [NSString stringWithFormat:@"%@ %@ %@",partnerDict[@"country"],partnerDict[@"city"],partnerDict[@"area"]];
    cell.describeLabel.text = partnerDict[@"companyDescription"];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:partnerDict[@"logo"]] placeholderImage:[UIImage imageNamed:Index_Recommond_Default_Image]];
    cell.image.layer.cornerRadius = 35;
    cell.image.layer.borderWidth = 0.4;
    cell.image.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.image.clipsToBounds = YES;
    
    cell.phoneButton.tag = indexPath.row;
    [cell.phoneButton addTarget:self action:@selector(phoneButtonPressed:) forControlEvents:UIControlEventTouchDown];
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _companyListArray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *partnerDict = _companyListArray[indexPath.row];
    [JCYGlobalData sharedInstance].companyID = partnerDict[@"vguid"];
    
    [self performSegueWithIdentifier:@"CompanyToDetail" sender:self];
    
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
