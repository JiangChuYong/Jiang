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
    /** *地铁列表*/
    GetSubways=12,
    /** *商圈列表*/
    GetTradeAreas=13,
    //获取所有海星客空间
    GetAllSpaceList=14,
    //社区详情
    LinckiaSpaceGetOne=15,
    //获取空间评价
    GetSpaceComment=16,
    //获取有会议室的空间列表
    GetSpaceNameList,
    //获取会议室列表
    GetMeetingSpaceCell,
    //社区预约参观
    AddCustomOfficeInfo,
    //获取社区可租用空间列表
    GetSpaceCell,
    //上传头像
    UploadAvatar,
    //获取为支付列表
    GetUnpayOrderList,
    //获取为会议室待支付列表
    GetMeetingList,
    //获取带点评列表
    GetNotCommentedList,
    //获取办公预约
    GetCustomOfficeList,
    //获取活动预约
    GetMyVisitActiveSpace,
    //获取办公预订列表
    GetOfficeOrdersList,
    //获取会议室预订列表
    GetMeetingOrdersList,
    //提交意见反馈
    CommitFeedback,
    //获取海星币折扣
    GetStarfishDiscountList,
    //增加空间评论
    AddComment,
    //获取短信验证码
    SendValidCode,
    //重置密码
    ResetPassword,
    //用户注册
    Register,
    //获取协议信息
    GetProtocol,
    //修改姓名或者昵称
    EditUserInfo,
    //通过手机验证码验证用户
    CheckUserByValidCode,
    //修改手机号
    SetPhoneNum,
    //修改密码
    ChangePassword,
    //获取办公预订订单详情
    OrdersGetOne,
    
    
    
    
}RequestFlag;

#endif /* RequestFlag_h */
