//
//  JCYGlobalData.h
//  LincKia
//
//  Created by JiangChuyong on 16/2/18.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCYGlobalData : NSObject
SingletonH(JCYGlobalData)
typedef NS_ENUM(NSInteger,OrderDetailStyle ) {
    MyOrderDetail,
    MyOnlineBooking,
    ActiveSpaceOrderDetail,
    MeetingRoomPage
};


//选中行业分类的ID
@property (nonatomic, strong) NSString *industryId;
//选中行业分类的名称
@property (nonatomic, strong) NSString *industryName;
//选中公司的详细信息
@property (nonatomic, strong) NSString * companyID;
//活动空间ID
@property (strong, nonatomic) NSString * ActivitySpaceId ;
//活动空间详细信息
@property (strong,nonatomic) NSDictionary *activeSpaceInfo;
//活动空间判断
@property (assign,nonatomic) BOOL isActiveSpace;
//社区简介详细信息
@property (strong,nonatomic) NSDictionary *spaceDetailInfo;
//登陆状态判断
@property (assign,nonatomic) BOOL LoginStatus;
//日历可选日期控制
@property (assign, nonatomic) int validDays;

//从哪个页面过来的订单
@property (assign, nonatomic) OrderDetailStyle sucessFromPage;

//用户信息
@property (strong,nonatomic) NSDictionary *userInfo;
//活动空间预约信息
@property (strong,nonatomic) NSDictionary *activeSpaceBookingInfo;


//时间大小遍历
+(NSMutableArray *)filterTimeArray:(NSMutableArray *)timeArray;
@end
