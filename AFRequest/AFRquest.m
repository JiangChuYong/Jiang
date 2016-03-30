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

-(void)requestDataFromWithFlag:(int)flag{
    
    _appDelegate = [UIApplication sharedApplication].delegate;
    _IPADRESS = [SERVER_IP stringByAppendingString:_subURLString];
    NSLog(@"请求地址：%@",_IPADRESS);

    if (!_subURLString) {
        NSLog(@"请检查链接子字符串");
    }else{
        
        if (_style == POST) {
            [self ConnectServerViaPostStyleWith:[NSString stringWithFormat:@"%i",flag]];
        }
        
        if (_style == GET) {
            [self ConnectServerViaGetStyleWithFlag:[NSString stringWithFormat:@"%i",flag]];
        }
    }
    
}
-(void)ConnectServerViaPostStyleWith:(NSString *)flag{
    
    if (!_parameters) {
        _parameters = nil;
    }
    [_appDelegate.manager POST:_IPADRESS parameters:_parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSData * response = [NSData dataWithData:responseObject];
        _resultDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:flag object:nil];
    }failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"POST服务器未响应");
        _resultDict = @{@"Code":@1};
        [[NSNotificationCenter defaultCenter]postNotificationName:flag object:nil];
    }];
}

-(void)ConnectServerViaGetStyleWithFlag:(NSString *)flag{
    
    [_appDelegate.manager GET:_IPADRESS parameters:_parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSData * response = [NSData dataWithData:responseObject];
        _resultDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:flag object:nil];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"GET服务器未响应");
        _resultDict = @{@"Code":@1};
        [[NSNotificationCenter defaultCenter]postNotificationName:flag object:nil];
    }];
}




@end
