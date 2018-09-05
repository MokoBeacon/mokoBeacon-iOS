//
//  CBPeripheral+HCKCharacters.h
//  testSDK
//
//  Created by aa on 2018/8/3.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface CBPeripheral (HCKCharacters)

#pragma mark - 电池电量服务下面的特征
/**
 电池电量特征,R
 */
@property (nonatomic, strong, readonly)CBCharacteristic *battery;

#pragma mark - 系统信息下面的特征
/**
 厂商信息,R
 */
@property (nonatomic, strong, readonly)CBCharacteristic *vendor;

/**
 产品型号信息,R
 */
@property (nonatomic, strong, readonly)CBCharacteristic *modeID;

/**
 硬件信息,R
 */
@property (nonatomic, strong, readonly)CBCharacteristic *hardware;

/**
 固件信息,R
 */
@property (nonatomic, strong, readonly)CBCharacteristic *firmware;

/**
 软件版本信息,R
 */
@property (nonatomic, strong, readonly)CBCharacteristic *software;

/**
 系统标示信息,R
 */
@property (nonatomic, strong, readonly)CBCharacteristic *systemID;

/**
 IEEE标准信息,R
 */
@property (nonatomic, strong, readonly)CBCharacteristic *IEEEInfo;

#pragma mark - DFU下面的特征

/**
 dfu升级用的
 */
@property (nonatomic, strong, readonly)CBCharacteristic *dfu;




#pragma mark - 通用服务下面的特征

/**
 总的运行时间,可监听/W
 */
@property (nonatomic, strong, readonly)CBCharacteristic *elapsedTime;

/**
 beacon的uuid,R/W
 */
@property (nonatomic, strong, readonly)CBCharacteristic *beaconUUID;

/**
 主值,R/W
 */
@property (nonatomic, strong, readonly)CBCharacteristic *major;

/**
 次值,R/W
 */
@property (nonatomic, strong, readonly)CBCharacteristic *minor;

/**
 校验距离,Beacon 模块与接收器之间相距 1m 时的参考接收信号强(RSSI: Received Signal Strength Indicator)，接收器根据该参考 RSSI 与接收信号的强度来推算发送模 块与接收器的距离。
 该特性数据为 1 字节，用户可以修改该参考值。R/W
 */
@property (nonatomic, strong, readonly)CBCharacteristic *measurePower;

/**
 广播功率,允许用户输入的数值范围为 0 – 8 ，依次表示发射功率为:4, 0, -4, -8, -12,
 -16, -20, -30, -40，单位为-dBm ,R/W
 */
@property (nonatomic, strong, readonly)CBCharacteristic *transmission;

/**
 修改重启密码,W
 */
@property (nonatomic, strong, readonly)CBCharacteristic *changePassword;

/**
 广播周期,这是配置设备的广播间隔，该数值的合法范围为 1 到 100，用以表示 100ms 到 10s 的广播间隔,R/W
 */
@property (nonatomic, strong, readonly)CBCharacteristic *broadcastInterval;

/**
 设备编号,R/W
 */
@property (nonatomic, strong, readonly)CBCharacteristic *deviceID;

/**
 beacon名称,R/W
 */
@property (nonatomic, strong, readonly)CBCharacteristic *beaconName;

/**
 修改可连接状态,R/W
 */
@property (nonatomic, strong, readonly)CBCharacteristic *connectMode;

/**
 mac地址，R
 */
@property (nonatomic, strong, readonly)CBCharacteristic *macAddress;

/**
 设备重启,W
 */
@property (nonatomic, strong, readonly)CBCharacteristic *softReboot;

/**
 心跳包
 */
@property (nonatomic, strong, readonly)CBCharacteristic *heartBeat;

/**
 生产日期,R
 */
@property (nonatomic, strong, readonly)CBCharacteristic *productionDate;

- (void)updateCharacterWithService:(CBService *)service;

- (BOOL)getAllCharacteristics;

- (void)setNil;

@end
