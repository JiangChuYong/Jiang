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

//通用页面数据
@property (nonatomic, strong) NSMutableDictionary *commonViewData;
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
//社区ID
@property (strong,nonatomic) NSString *SpaceId;
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
//社区空间预约信息
@property (strong,nonatomic) NSDictionary *spaceVisitDict;
//注册协议信息
@property (strong,nonatomic) NSDictionary *protocolDic;

//从哪个页面跳转到搜索页面，和提交订单的方式
@property (assign, nonatomic) OrderSubmitFlag orderSubmitFlag;
//手机号码修改成功之后，不登录跳转到首页
@property (assign, nonatomic) BOOL isBackHome;
//当前选中的评论空间
@property (strong, nonatomic) NSDictionary * evaluateSpace;
//判断修改手机号页面是否来自短信修改
@property (assign, nonatomic) BOOL isMotifyViaMessage;

//订单编号
@property (strong, nonatomic) NSString *orderId;

//会议室数组
@property (strong, nonatomic) NSMutableArray *meetingCarArr;




//时间大小遍历
+(NSMutableArray *)filterTimeArray:(NSMutableArray *)timeArray;
// 从某日期往后推几月后的日期
+(NSDate *)jcyDateByAddingMonths:(NSInteger)months From:(NSString *)dataStr;
//字符串转化成日期
+(NSDate *)jcyStringConversionDate:(NSString *)dateStr WithFommater:(NSString*)fommater;
//矫正时区，将当前时间调整为北京时间
+(NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;

//将日期转换成字符串"YYYYMMdd"
+(NSString *)jcyDateConversionStr:(NSDate *)date;

//监测网络状态
+ (NSString *)networkingStatesFromStatebar;
@end
