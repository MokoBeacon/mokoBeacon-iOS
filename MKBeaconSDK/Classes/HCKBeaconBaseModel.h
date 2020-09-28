//
//  HCKBeaconBaseModel.h
//  HCKBeacon
//
//  Created by aa on 2018/1/15.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef NS_ENUM(NSInteger, HCKBeaconDeviceType) {
    HCKBeaconDeviceTypeNormal,                      //通用设备，不带三轴加速度数据
    HCKBeaconDeviceTypeWithXYZData,                 //带三轴加速度数据
};

@interface HCKBeaconBaseModel : NSObject

/**
 扫描到的设备
 */
@property (nonatomic, strong)CBPeripheral *peripheral;

/**
 当前设备类型
 */
@property (nonatomic, assign)HCKBeaconDeviceType deviceType;

/**
 扫描到的设备名字
 */
@property (nonatomic, copy)NSString *peripheralName;

/**
 信号值强度
 */
@property (nonatomic, copy)NSString *rssi;

/**
 广播功率，与transmission的对应关系为：transmission允许用户输入的数值范围为 0 – 8 ，依次表示广播功率为:4, 0, -4, -8, -12,-16, -20, -30, -40，单位为-dBm
 */
@property (nonatomic, copy)NSString *txPower;

/**
 主值
 */
@property (nonatomic, copy)NSString *major;

/**
 次值
 */
@property (nonatomic, copy)NSString *minor;

/**
 计算出来的距离
 */
@property (nonatomic, copy)NSString *distance;

/**
 远近信息，immediate(10cm以内)，near(1m以内)，far(1m以外)，unknown(没有信号)
 */
@property (nonatomic, copy)NSString *proximity;

/**
 是否可连接，YES可连接，NO不可连接
 */
@property (nonatomic, assign)BOOL connectEnble;

/**
 电池电量
 */
@property (nonatomic, copy)NSString *battery;

/**
 校验距离
 */
@property (nonatomic, copy)NSString *measurePower;

- (HCKBeaconBaseModel *)initWithAdvertiseData:(NSData *)advertiseData additionalDic:(NSDictionary *)additionalDic;

@end


@interface HCKXYZBeaconModel : HCKBeaconBaseModel

@property (nonatomic, copy)NSString *xData;

@property (nonatomic, copy)NSString *yData;

@property (nonatomic, copy)NSString *zData;

- (HCKXYZBeaconModel *)initWithAdvertiseData:(NSData *)advertiseData additionalDic:(NSDictionary *)additionalDic;

@end
