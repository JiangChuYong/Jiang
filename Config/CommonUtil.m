//
//  CommonUtil.m
//  LincKia
//

#import "CommonUtil.h"

@implementation CommonUtil
SingletonM(CommonUtil);

-(NSString *) nameForSpaceType:(SpaceType)spaceType{
    NSString *name=nil;

    switch (spaceType) {
        case SpaceType_Office:
            name=@"独立办公室";
            break;
        case SpaceType_ActivityRoom:
            name=@"开放办公桌";
            break;
        case SpaceType_Desk:
            name=@"半开放办公桌";
            break;
        case SpaceType_MeetingRoom:
            name=@"独立会议室";
            break;
        case SpaceType_Mix:
            name=@"混合";
            break;
        default:
            break;
    }
    return name;
}

-(NSString *) nameForOrderStatus:(OrderStatus)orderStatus{
    NSString *name=nil;
    switch (orderStatus) {
        case UnPayed:
            name=@"未支付";
            break;
        case Payed:
            name=@"已支付";
            break;
        case Canceled:
            name=@"已取消";
            break;
        case Invalid:
            name=@"已失效";
            break;
        case Draft:
            name=@"草稿";
            break;
		case StatusAll:
			name=@"全部";
			break;
        default:
            break;
    }
    return name;
}

- (NSString *) imgUrlForSpaceType:(SpaceType)spaceType{
    NSString *url=nil;
    switch (spaceType) {
        case SpaceType_Desk:
            url=@"open_desk.png";
            break;
        case SpaceType_Office:
            url=@"personal_office.png";
            break;
        case SpaceType_MeetingRoom:
           url=@"personal_office.png";
            break;
        case SpaceType_ActivityRoom:
            url=@"open_desk.png";
            break;
        case SpaceType_Mix:
            url=@"personal_office.png";
            break;
        default:
            break;
    }
    return url;
}
-(NSString *) payCountingIDUrlForPayAccountIDStyle:(PayAccountIDStyle)payAccountIDStyle{
    NSString *name=nil;
    switch (payAccountIDStyle) {
        case PayAccountID_AliPay:
            name=@"e6361b30-9125-4734-a730-0de0fa43b280";
            break;
        case PayAccountID_WeiXin:
            name=@"0f6a5647-42a6-49c0-a914-7df77d20fbd6";
            break;
               default:
            name=@"";
            break;
    }
    return name;

}
-(NSString *) dataStrWithDateStr:(NSString *)sourceDateStr{
    NSString *resultStr=@"";
    //取出 "yyyy-mm-dd"
    if (sourceDateStr.length>9) {
        resultStr=[sourceDateStr substringWithRange:NSMakeRange(0,10)];
    }
    return resultStr;
}
@end
