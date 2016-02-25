//
//  AFRquest.h
//  LincKia
//
//  Created by Phoebe on 16/2/15.
//  Copyright © 2016年 Phoebe. All rights reserved.
//


/**
 *请求类型
 */
typedef enum{
    //POST请求
    POST,
    //GET请求
    GET,
}CONNECT_STYLE;

/**
 *请求结果
 */
#define SUCCESS 0
#define FAILURE 1

#define SERVER_IP @"http://112.74.75.66/OfficeAPI/"
//提示框控制
#define SHOW_LOADING  [[PBAlert sharedInstance]showProgressDialogText:@"加载中..." inView:self.view];
#define STOP_LOADING  [[PBAlert sharedInstance]stopHud];

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "AppDelegate.h"
#import "RequestFlag.h"

@interface AFRquest : NSObject

@property (strong,nonatomic) AppDelegate * appDelegate;
@property (strong,nonatomic) NSString * IPADRESS;
/**
 *使用规则，新建单例对象，属性赋值，调用requestDataFromServer方法；
 *注意：⚠调用requestDataFromServer方法前一定要给style\parameters\subURLString属性赋值！
 */
@property (assign,nonatomic) CONNECT_STYLE style;
@property (strong,nonatomic) NSDictionary *parameters;
@property (strong,nonatomic) NSString * subURLString;
/**
 *以下为接收结果的属性
 */
@property (strong,nonatomic) NSDictionary * resultDict;

-(void)requestDataFromWithFlag:(int)flag;

@end
