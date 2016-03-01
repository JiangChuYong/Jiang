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
    //企业服=
    GetIndustryList=4,
    //获取海星伙伴列表
    GetLinckiaPartnerList=5,
    //获取海星伙伴详细信息
    GetLinckiaPartnerInfo=6,
    //获取活动空间
    GetActiveSpaceList=7,
    //活动空间详情
    ActiveSpaceGetOne=8,
    //检查是否有未支付订单
    CheckUnpaidOrder=9,
    //活动空间预约参观
    VisitActiveSpace=10,
    
    /** *行政区划列表*/
    GetAreas=11,
    /** *城市列表*/
    GetCities=12,
    /** *地铁列表*/
    GetSubways=13,
    /** *商圈列表*/
    GetTradeAreas=14,
    /** *支付账户列表*/
    GetPayAccounts=15,
    /** *获取协议信息*/
    GetProtocol=16,
    /** *客户端App更新*/
    SysUpdate=17,
    //获取所有海星客空间
    GetAllSpaceList=18,
    //社区详情
    LinckiaSpaceGetOne=19,
    //获取空间评价
    GetSpaceComment=20,

}RequestFlag;

#endif /* RequestFlag_h */
