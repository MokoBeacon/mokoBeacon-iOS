//
//  HCKFileManager.h
//  HCKBeacon
//
//  Created by aa on 2018/5/10.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import "HCKBaseDataModel.h"

@interface HCKFileManager : HCKBaseDataModel

/**
 获取document目录
 
 @return document目录
 */
+ (NSString *)document;

/**
 获取document目录下面的所有文件
 
 @return @[]
 */
+ (NSArray *)getDocumentFiles;

@end
