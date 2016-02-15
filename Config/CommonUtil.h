//
//  CommonUtil.h
//  LincKia
//

//

#import <Foundation/Foundation.h>

@interface CommonUtil : NSObject
SingletonH(CommonUtil);

//空间类型的转换方法
-(NSString *) nameForSpaceType:(SpaceType)spaceType;
-(NSString *) nameForOrderStatus:(OrderStatus)orderStatus;
-(NSString *) imgUrlForSpaceType:(SpaceType)spaceType;
-(NSString *) payCountingIDUrlForPayAccountIDStyle:(PayAccountIDStyle)payAccountIDStyle;
-(NSString *) dataStrWithDateStr:(NSString *)sourceDateStr;
@end
