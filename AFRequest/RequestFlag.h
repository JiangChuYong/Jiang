//
//  RequestFlag.h
//  LincKia
//
//  Created by Phoebe on 16/2/16.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#ifndef RequestFlag_h
#define RequestFlag_h

/**
 *请求标识
 */
typedef enum{
    //用户登录
    UsersLogin=1,
    //获取用户信息
    GetUserInfo=2,
    //首页
    GetIndex=3,
    
}RequestFlag;

#endif /* RequestFlag_h */
