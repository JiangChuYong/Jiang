//
//  JCYGlobalData.m
//  LincKia
//
//  Created by JiangChuyong on 16/2/18.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "JCYGlobalData.h"

@implementation JCYGlobalData
SingletonM(JCYGlobalData)

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

//时间大小遍历
+(NSMutableArray *)filterTimeArray:(NSMutableArray *)timeArray
{
    NSMutableArray * array = [NSMutableArray array];
    for (int i=0; i<timeArray.count; i++) {
        
        //        NSString * date = [[NSDate date]zldDateToStrWithFormart:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate* today = [NSDate date];
        NSLog(@"%@",today);
        
        NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString* s1 = [df stringFromDate:today];
        NSLog(@" s1s1s1s%@",s1);
        
        int now = [[s1 substringWithRange:NSMakeRange(11, 2)]intValue];
        int temp = [[timeArray[i] substringToIndex:2]intValue];
        if (temp > now) {
            [array addObject:timeArray[i]];
        }
    }
    
    NSLog(@"%@",array);
    return array;
}


@end
