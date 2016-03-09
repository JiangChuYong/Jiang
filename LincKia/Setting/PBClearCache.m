//
//  PBClearCache.m
//  LincKia
//
//  Created by Phoebe on 16/1/6.
//  Copyright (c) 2016年 ZZ. All rights reserved.
//

#import "PBClearCache.h"

@implementation PBClearCache

+(float)folderSizeAtPath:(NSString *)path
{
    NSFileManager * manager = [NSFileManager defaultManager];
    float folderSize;
    if ([manager fileExistsAtPath:path]) {
        NSArray * subFilePathes = [manager subpathsAtPath:path];
        for (NSString * filePath in subFilePathes) {
            NSString * resultFilePath = [path stringByAppendingString:filePath];
            if ([resultFilePath rangeOfString:@"Preferences"].location ==NSNotFound) {
                folderSize += [self fileSizeAtPath:resultFilePath];
            }
        }
        folderSize += [[SDImageCache sharedImageCache] getSize];
        return folderSize;
    }
    return 0;
}
+(float)fileSizeAtPath:(NSString *)path
{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        long long size = [manager attributesOfItemAtPath:path error:nil].fileSize;
        return size;
    }
    return 0;
}
+(void)clearCache:(NSString *)path
{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        NSArray * subFilePathes = [manager subpathsAtPath:path];
        for (NSString * fileName in subFilePathes) {
                NSString * resultFilePath =[NSString stringWithFormat:@"%@/%@",path,fileName];
            if ([resultFilePath rangeOfString:@"Preferences"].location ==NSNotFound) {
                [manager removeItemAtPath:resultFilePath error:nil];

            }
            
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}
+(NSString *)getMyCachePath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [paths lastObject];
}

@end
