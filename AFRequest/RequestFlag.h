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
    //获取有会议室的空间列表
    GetSpaceNameList,
    //获取会议室列表
    GetMeetingSpaceCell,
    
}RequestFlag;

#endif /* RequestFlag_h */
