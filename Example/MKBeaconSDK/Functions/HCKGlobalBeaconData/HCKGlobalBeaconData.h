//
//  HCKGlobalBeaconData.h
//  HCKBeacon
//
//  Created by aa on 2018/5/9.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import "HCKBaseDataModel.h"

@interface HCKGlobalBeaconData : HCKBaseDataModel

+ (HCKGlobalBeaconData *)share;

/**
 电池电量
 */
@property (nonatomic, copy)NSString *battery;

/**
 beacon的UUID
 */
@property (nonatomic, copy)NSString *UUID;

/**
 主值
 */
@property (nonatomic, copy)NSString *major;

/**
 次值
 */
@property (nonatomic, copy)NSString *minor;

/**
 校验距离
 */
@property (nonatomic, copy)NSString *measurePower;

/**
 广播功率
 */
@property (nonatomic, copy)NSString *transmission;

/**
 广播周期
 */
@property (nonatomic, copy)NSString *broadcastInterval;

/**
 设备ID
 */
@property (nonatomic, copy)NSString *deviceID;

/**
 重启密码
 */
@property (nonatomic, copy)NSString *password;

/**
 MAC地址
 */
@property (nonatomic, copy)NSString *macAddress;

/**
 beacon名字
 */
@property (nonatomic, copy)NSString *beaconName;

/**
 可连接状态
 */
@property (nonatomic, assign)BOOL connectEnable;

#pragma mark - 设备系统信息
/**
 制造商信息
 */
@property (nonatomic, copy)NSString *manufacturers;

/**
 beacon型号
 */
@property (nonatomic, copy)NSString *model;

/**
 生产日期
 */
@property (nonatomic, copy)NSString *productionTime;

/**
 硬件使用的芯片型号
 */
@property (nonatomic, copy)NSString *hardwareModule;

/**
 硬件版本
 */
@property (nonatomic, copy)NSString *hardwareVersion;

/**
 固件版本
 */
@property (nonatomic, copy)NSString *firmwareVersion;

/**
 软件版本
 */
@property (nonatomic, copy)NSString *softVersion;

/**
 运行时间
 */
@property (nonatomic, copy)NSString *elapsedTime;

/**
 重启时间
 */
@property (nonatomic, copy)NSString *restartTime;

/**
 系统信息
 */
@property (nonatomic, copy)NSString *systemID;

/**
 IEEE标准信息
 */
@property (nonatomic, copy)NSString *IEEE;

#pragma mark - method
/**
 清空所有数据
 */
- (void)loadEmptyModels;

@end
