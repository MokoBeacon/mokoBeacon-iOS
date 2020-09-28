//
//  HCKDfuAdopter.h
//  HCKBeacon
//
//  Created by aa on 2018/5/10.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import "HCKBaseDataModel.h"

@interface HCKDfuAdopter : HCKBaseDataModel

// 监听指定目录的文件改动
- (void)startMonitoringDirectory:(void (^)(void))dfuFileDatasChangedBlock;

/**
 获取dfu数据，zip格式的
 
 @return @[]
 */
- (NSArray *)getDfuFilesList;

/**
 dfu升级

 @param fileName 选取的固件名字
 @param controller 当前控制器
 */
- (void)dfuUpdateWithFileName:(NSString *)fileName target:(UIViewController *)controller;

- (void)cancel;

@end
