//
//  HCKBeaconInterface.h
//  testSDK
//
//  Created by aa on 2018/5/5.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 当前beacon广播功率
 4, 0, -4, -8, -12,-16, -20, -30, -40
 */
typedef NS_ENUM(NSInteger, beaconTransmission) {
    beaconTransmission4dBm,       //广播功率为4dBm
    beaconTransmission0dBm,       //广播功率为0dBm
    beaconTransmissionNeg4dBm,    //广播功率为-4dBm
    beaconTransmissionNeg8dBm,    //广播功率为-8dBm
    beaconTransmissionNeg12dBm,   //广播功率为-12dBm
    beaconTransmissionNeg16dBm,   //广播功率为-16dBm
    beaconTransmissionNeg20dBm,   //广播功率为-20dBm
    beaconTransmissionNeg30dBm,   //广播功率为-30dBm
    beaconTransmissionNeg40dBm,   //广播功率为-40dBm
};

@interface HCKBeaconInterface : NSObject
#pragma mark - 通用服务,FF00

/**
 读取beacon的UUID,特征UUID为FF01
 
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconUUIDWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;
/**
 读取beacon主值，特征UUID为FF02
 
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconMajorWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;
/**
 读取beacon的次值，特征UUID为FF03
 
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconMinorWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;
/**
 读取beacon的校验距离，特征UUID为FF04
 
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconMeasurePowerWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;
/**
 读取beacon的广播功率，特征UUID为FF05
 
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconTransmissionWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;
/**
 读取beacon的广播周期，特征UUID为FF07
 
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconBroadcastIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;
/**
 读取beacon的设备ID，特征UUID为FF08
 
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconDeviceIDWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;
/**
 读取beacon的名字，特征UUID为FF09
 
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconNameWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;
/**
 读取beacon的mac地址，特征UUID为FF0C
 
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;
/**
 读取beacon的可连接状态，特征UUID为FF0E
 
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconConnectStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;
/**
 读取beacon的运行时间，特征UUID为FFE0
 
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconElapsedTimeWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;
/**
 读取beacon的芯片类型，特征UUID为FFE0
 
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconHardwareModuleWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;
/**
 读取三轴加速度数据
 
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)startReadXYZDataWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;
/**
 停止读取三轴加速度数据
 
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)stopReadXYZDataWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;
#pragma mark - 设置类
/**
 设置UUID
 
 @param uuid UUID
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setBeaconUUID:(NSString *)uuid
             sucBlock:(void (^)(id returnData))sucBlock
          failedBlock:(void (^)(NSError *error))failedBlock;
/**
 设置major，特征UUID为FF02
 
 @param major major,0~65535
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setBeaconMajor:(NSInteger)major
              sucBlock:(void (^)(id returnData))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock;
/**
 设置minor，特征UUID为FF03
 
 @param minor minor,0~65535
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setBeaconMinor:(NSInteger)minor
              sucBlock:(void (^)(id returnData))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock;
/**
 设置校验距离，特征UUID为FF04
 
 @param measurePower -119dBm ~ 0dBm
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setBeaconMeasurePower:(NSInteger)measurePower
                     sucBlock:(void (^)(id returnData))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;
/**
 设置广播功率，特征UUID为FF05
 
 @param transmission 广播功率
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setBeaconTransmission:(beaconTransmission)transmission
                     sucBlock:(void (^)(id returnData))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;
/**
 设置密码，特征UUID为FF06.beacon返回00(非连接状态，连接成功)、01(密码错误)、02(修改密码成功，只有连接状态下才能修改密码)三种状态
 
 @param password 必须是8个字符,数字或者字母
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setBeaconPassword:(NSString *)password
                 sucBlock:(void (^)(id returnData))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;
/**
 设置beacon的广播周期，特征UUID为FF07
 
 @param broadcastInterval 广播周期,100ms为单位，broadcastInterval * 100ms就是最后的广播周期,1~100
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setBeaconBroadcastInterval:(NSInteger)broadcastInterval
                          sucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;
/**
 设置beacon的device id,特征UUID为FF08
 
 @param deviceID device id,只能是数字，最大长度为5
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setBeaconDeviceID:(NSString *)deviceID
                 sucBlock:(void (^)(id returnData))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;
/**
 设置beacon的名字，特征UUID为FF09
 
 @param beaconName beacon的名字,字符串，通用不带三轴数据的最大长度为10个，带三轴数据的最大长度为4个,字母数字下划线其中的一种
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setBeaconName:(NSString *)beaconName
             sucBlock:(void (^)(id returnData))sucBlock
          failedBlock:(void (^)(NSError *error))failedBlock;
/**
 设置beacon的可连接状态,特征UUID为FF0E
 
 @param connectEnable YES可连接，NO不可连接
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setBeaconConnectStatus:(BOOL)connectEnable
                      sucBlock:(void (^)(id returnData))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock;
#pragma mark - 电池服务180F,全部只读
/**
 获取iBeacon的电量
 
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconBatteryWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;
#pragma mark - 系统信息服务180A,全部只读

/**
 读取系统标示，特征UUID为2A23
 
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconSystemIDWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;
/**
 读取产品型号信息，特征UUID为2A24
 
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconModeIDWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;
/**
 读取生产日期，特征UUID为2A25
 
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconProductionDateWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;
/**
 读取beacon固件信息，特征UUID为2A26
 
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;
/**
 读取beacon硬件信息，特征UUID为2A27
 
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;
/**
 读取beacon软件版本，特征UUID为2A28
 
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;
/**
 读取厂商信息，特征UUID为2A29
 
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconVendorWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;
/**
 读取IEEE标准，特征UUID为2A2A
 
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconIEEEInfoWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - 心跳包

/**
 发送心跳包给beacon

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)sendHeartBeatToBeaconWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

@end
