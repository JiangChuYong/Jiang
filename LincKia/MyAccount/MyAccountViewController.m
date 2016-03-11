//
//  MyAccountViewController.m
//  LincKia
//
//  Created by JiangChuyong on 16/3/4.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "MyAccountViewController.h"
#import "PBChangeHeadPicTableViewCell.h"
#import <Masonry.h>
#import "LGTMBase64.h"

@interface MyAccountViewController ()
@property (strong, nonatomic) IBOutlet UIView *centerView;
@property (strong, nonatomic) IBOutlet UIImageView *myHeadPic;
@property (strong, nonatomic) IBOutlet UILabel *nickName;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *mobileNum;
@property (strong, nonatomic) NSDictionary *userInfoDict;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIImage *photoImage;
@property (strong, nonatomic) AFRquest *UploadAvatar;


@end

@implementation MyAccountViewController
static NSString *cellIdentifier = @"PBChangeHeadPicTableViewCell";


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UINavigationController * navi = (UINavigationController *)self.navigationController;
    navi.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDataAndSetUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotif:) name:@"UpdateName" object:nil];
}
-(void)receivedNotif:(NSNotification *)notification
{
    if ([JCYGlobalData sharedInstance].orderSubmitFlag==ModifyNickName) {
        _nickName.text = notification.object;
    }
    else if ([JCYGlobalData sharedInstance].orderSubmitFlag==ModifyName){
        _name.text = notification.object;
    }
}

-(void)getDataAndSetUI
{
    //头像优化
    _userInfoDict = [JCYGlobalData sharedInstance].userInfo;
    [_myHeadPic sd_setImageWithURL:[NSURL URLWithString:_userInfoDict[@"AvatarUrl"]]placeholderImage:[UIImage imageNamed:Space_DetailFacilities_Default_Image]];
    _myHeadPic.layer.cornerRadius = _myHeadPic.frame.size.width/2;
    _myHeadPic.clipsToBounds = YES;
    
    //昵称
    _nickName.text = _userInfoDict[@"DisplayName"];
    
    //姓名
    _name.text = _userInfoDict[@"UserName"];
    NSLog(@"mmm    %@",_userInfoDict[@"UserName"]);
    //手机号
    _mobileNum.text = _userInfoDict[@"Mobile"];
}





- (IBAction)changeHeadPicClicked:(UIButton *)sender {
    
    //代码添加背景图
    _backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    _backgroundView.alpha = 0.75;
    _backgroundView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_backgroundView];
    //添加手势响应
    UITapGestureRecognizer * singleTouch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundViewTouchDown:)];
    [_backgroundView addGestureRecognizer:singleTouch];
    //添加表格
    _tableView = [[UITableView alloc]init];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_backgroundView.mas_centerX);
        make.centerY.mas_equalTo(_backgroundView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width-30, 165));
    }];
    _tableView.layer.cornerRadius = 7;
    _tableView.clipsToBounds = YES;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    NSLog(@"sfdsd");
}

#pragma -- mark 打开相机、相册
-(void)goPhotoLibrary
{
    //去相册选择
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate=self;
        //是否允许图像编辑
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:^{        }];
    }
}
//开始拍照
-(void)takePhoto
{
    BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
    if (!isCamera) {
        NSLog(@"没有摄像头");
        return ;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    // 编辑模式
    imagePicker.allowsEditing = YES;
    imagePicker.mediaTypes =  [NSArray arrayWithObject:@"public.image"];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePicker
                       animated:YES
                     completion:^{}];
    
}
-(void)backgroundViewTouchDown:(UIGestureRecognizer *)singleTap
{
    [_tableView removeFromSuperview];
    [_backgroundView removeFromSuperview];
}

#pragma -- mark TABLEVIEW DELEGATE 表格代理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
            
        case 0:
            [self takePhoto];
            break;
            
        case 1:
            [self goPhotoLibrary];
            break;
            
        case 2:
            [self backgroundViewTouchDown:nil];
            break;
            
        default:
            break;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView registerNib:[UINib nibWithNibName:@"PBChangeHeadPicTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    PBChangeHeadPicTableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    switch (indexPath.row) {
        case 0:
            [cell.image setImage:[UIImage imageNamed:@"my_camer.png"]];
            cell.label.text = @"拍照";
            break;
        case 1:
            [cell.image setImage:[UIImage imageNamed:@"my_pic.png"]];
            cell.label.text = @"相册";
            break;
        case 2:
            cell.image.hidden = YES;
            cell.label.text = @"取消";
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma -- mark IMAGEPICKER DELEGATE 图片选择器代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self backgroundViewTouchDown:nil];
    _photoImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
    [self handleMyHeadImage:_photoImage];
}

-(void)handleMyHeadImage:(UIImage *)image
{
    NSString *pic;
 
    NSData *imageData = UIImagePNGRepresentation(image);
    pic = [LGTMBase64 stringByEncodingData:imageData];
    
    [self uploadAvatarToServerWithStr:pic];

}


-(void)uploadAvatarToServerWithStr:(NSString *)pic{
    
        NSUserDefaults * userInfo = [NSUserDefaults standardUserDefaults];
        NSString * userToken = [userInfo valueForKey:USERTOKEN];
        _UploadAvatar = [[AFRquest alloc]init];
        _UploadAvatar.subURLString =[NSString stringWithFormat:@"api/Users/UploadAvatar?userToken=%@&deviceType=ios",userToken];
        _UploadAvatar.parameters=@{@"Pic":pic};
    
        _UploadAvatar.style = POST;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(uploadAvatarDataReceived:) name:[NSString stringWithFormat:@"%i",UploadAvatar] object:nil];
        [_UploadAvatar requestDataFromWithFlag:UploadAvatar];
    
    [[PBAlert sharedInstance] showProgressDialogText:@"上传中" inView:self.view];
    
    
}
-(void)uploadAvatarDataReceived:(NSNotification *)notif{
    
    NSLog(@"%@",_UploadAvatar.resultDict);
    [[PBAlert sharedInstance] stopHud];
    int result = [_UploadAvatar.resultDict[@"Code"] intValue];;
    if (result == SUCCESS) {
        [[NSNotificationCenter defaultCenter] postNotificationName:PhotoUpload_Succeed object:nil];
        //头像照片名
        [[SDImageCache sharedImageCache]removeImageForKey:[JCYGlobalData sharedInstance].userInfo[@"AvatarUrl"]];
        _myHeadPic.image = _photoImage;
        
     
         [[PBAlert sharedInstance] showText:@"头像上传成功" inView:self.view withTime:2.0];
        
    }else{
        [[PBAlert sharedInstance] showText:_UploadAvatar.resultDict[@"Description"] inView:self.view withTime:2.0];
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%i",UploadAvatar] object:nil];
}





- (IBAction)changeNickNameClicked:(UIButton *)sender {
    
    [JCYGlobalData sharedInstance].orderSubmitFlag=ModifyNickName;
    
    [self performSegueWithIdentifier:@"MyAccountToName" sender:self];
    NSLog(@"修改昵称");
}
- (IBAction)changeNameClicked:(UIButton *)sender {
    
    [JCYGlobalData sharedInstance].orderSubmitFlag=ModifyName;
    
    [self performSegueWithIdentifier:@"MyAccountToName" sender:self];
    NSLog(@"修改姓名");

}
- (IBAction)changeMobileNumClicked:(UIButton *)sender {
    NSLog(@"sfdfs");

}
- (IBAction)changePasswordClicked:(id)sender {
    NSLog(@"sfdfs");

}
- (IBAction)back:(UIBarButtonItem *)sender {
    
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
