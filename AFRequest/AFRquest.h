//
//  AFRquest.h
//  LincKia
//
//  Created by Phoebe on 16/2/15.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

typedef enum{
    
    //POST请求
    POST,
    //GET请求
    GET,
    
}CONNECT_STYLE;

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface AFRquest : NSObject
SingletonH(AFRquest);

@property (assign,nonatomic) CONNECT_STYLE style;
@property (strong,nonatomic) NSMutableDictionary *Parameters;
@property (strong,nonatomic) NSString * subURLString;

-(void)requestDataFromServer;

@end
