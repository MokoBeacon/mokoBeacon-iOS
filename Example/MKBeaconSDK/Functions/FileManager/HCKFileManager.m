//
//  HCKFileManager.m
//  HCKBeacon
//
//  Created by aa on 2018/5/10.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import "HCKFileManager.h"

@implementation HCKFileManager

/**
 获取document目录

 @return document目录
 */
+ (NSString *)document{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

/**
 获取document目录下面的所有文件

 @return @[]
 */
+ (NSArray *)getDocumentFiles{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    // 获取指定路径对应文件夹下的所有文件
    NSArray <NSString *> *fileArray = [fileManager contentsOfDirectoryAtPath:[self document] error:&error];
    return fileArray;
}

@end
