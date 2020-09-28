//
//  HCKConfigurationPageController.h
//  HCKBeacon
//
//  Created by aa on 2017/10/31.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBaseViewController.h"

@interface HCKConfigurationPageController : HCKBaseViewController

/**
 已经连接的设备
 */
@property (nonatomic, strong)CBPeripheral *peripheral;

/**
 设备连接密码
 */
@property (nonatomic, copy)NSString *password;

/**
 当前已连接的iBeacon设备类型
 */
@property (nonatomic, assign)HCKBeaconDeviceType deviceType;

@end
