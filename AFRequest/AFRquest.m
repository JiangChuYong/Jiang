//
//  AFRquest.m
//  LincKia
//
//  Created by Phoebe on 16/2/15.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "AFRquest.h"

@implementation AFRquest
SingletonM(AFRquest);

-(void)requestDataFromServer{
    
    _appDelegate = [UIApplication sharedApplication].delegate;
    _IPADRESS = [SERVER_IP stringByAppendingString:_subURLString];
    NSLog(@"请求地址：%@",_IPADRESS);

    if (!_subURLString && _requestFlag) {
        NSLog(@"请检查链接子字符串或者请求标识");
    }else{
        
        if (_style == POST) {
            [self ConnectServerViaPostStyle];
        }
        
        if (_style == GET) {
            [self ConnectServerViaGetStyle];
        }
    }
    
}
-(void)ConnectServerViaPostStyle{
    
    if (!_parameters) {
        _parameters = nil;
    }
    
    [_appDelegate.manager POST:_IPADRESS parameters:_parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSData * response = [NSData dataWithData:responseObject];
        _resultDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
        POST_NOTIFICATION
    }failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"POST服务器未响应");
        _resultDict = @{@"Code":@1};
        POST_NOTIFICATION
    }];
    
}

-(void)ConnectServerViaGetStyle{
    
    [_appDelegate.manager GET:_IPADRESS parameters:_parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSData * response = [NSData dataWithData:responseObject];
        _resultDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
        POST_NOTIFICATION
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"GET服务器未响应");
        _resultDict = @{@"Code":@1};
        POST_NOTIFICATION
    }];
}




@end
