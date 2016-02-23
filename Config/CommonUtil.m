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

//手机号码验证
+ (BOOL)isValidateMobile:(NSString *)mobile
{
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0-9]))\\d{8}$";
;
    //@"[0-9]{11}";
    //手机号以13， 15，18，17开头，八个 \d 数字字符
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

//遍历表情字符
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}
//遍历非法字符
+(BOOL)stringContainsIllegalChar:(NSString *)string
{
    BOOL hasIllegalChar = NO;
    NSString * illegalString = @"!@#$%^&*()_-+=~`|\n}{[]:;<>?,./｛｝［］；：“”‘《》？，。／｀～！@＃¥％……&＊（）——＋－＝、";
    for (int i=0; i<string.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString * textStr = [string substringWithRange:range];
        if ([illegalString rangeOfString:textStr].location != NSNotFound) {
            hasIllegalChar = YES;
        }else{
            hasIllegalChar = NO;
        }
    }
    return hasIllegalChar;
}
//判断内容是否为全部空字符
+(BOOL)stringContainsSpacing:(NSString *)string
{
    BOOL hasSpaceingChar = NO;
    int counter = 0;
    for (int i=0; i<string.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString * temp = [string substringWithRange:range];
        if ([temp isEqualToString:@" "]||[temp isEqualToString:@"\n"]) {
            counter++;
        }
    }
    if (counter == string.length) {
        hasSpaceingChar = YES;
    }else{
        hasSpaceingChar = NO;
    }
    return hasSpaceingChar;
}
//遍历文字内容是否包含 非法字符 全部空格 表情符
+ (BOOL)stringContainsIllegalContent:(NSString *)string
{
    BOOL hasIllegalContent = NO;
    if ([CommonUtil stringContainsEmoji:string]||[CommonUtil stringContainsIllegalChar:string]||[CommonUtil stringContainsSpacing:string]) {
        hasIllegalContent = YES;
    }
    return hasIllegalContent;
}

//判断字符是否为空
+ (BOOL) isBlankString:(NSString *)string {
    
    if (string == nil || string == NULL) {
        
        return YES;
        
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
        
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
        return YES;
        
    }
    
    return NO;
    
}


//检查当前网络
+ (NSString *)networkingStatesFromStatebar {
    // 状态栏是由当前app控制的，首先获取当前app
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    int type = 0;
    for (id child in children)
    {
        if ([child isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]])
        {
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }
    NSString *stateString = nil;
    switch (type) {
        case 0:
            stateString = @"no net";
            break;
            
        case 1:
            stateString = @"2G";
            break;
            
        case 2:
            stateString = @"3G";
            break;
            
        case 3:
            stateString = @"4G";
            break;
            
        case 4:
            stateString = @"LTE";
            break;
            
        case 5:
            stateString = @"wifi";
            break;
            
        default:
            break;
    }
    
    return stateString;
}

@end
