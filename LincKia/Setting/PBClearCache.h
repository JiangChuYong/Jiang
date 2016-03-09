//
//  PBClearCache.h
//  LincKia
//
//  Created by Phoebe on 16/1/6.
//  Copyright (c) 2016年 ZZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBClearCache : NSObject 

+(float)folderSizeAtPath:(NSString *)path;
+(float)fileSizeAtPath:(NSString *)path;
+(void)clearCache:(NSString *)path;
+(NSString *)getMyCachePath;

@end
