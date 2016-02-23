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
//判断手机号是否有效
+ (BOOL)isValidateMobile:(NSString *)mobile;
//遍历非法字符
+ (BOOL)stringContainsEmoji:(NSString *)string;//是否含有表情
+ (BOOL)stringContainsIllegalChar:(NSString *)string;//是否含有非法字符
+ (BOOL)stringContainsSpacing:(NSString *)string;//是否含有空格
+ (BOOL)stringContainsIllegalContent:(NSString *)string;//包含以上三个任何一个返回NO
+ (BOOL) isBlankString:(NSString *)string ;
+ (NSString *)networkingStatesFromStatebar ;

@end
