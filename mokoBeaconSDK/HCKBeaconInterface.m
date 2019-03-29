//
//  HCKBeaconInterface.m
//  testSDK
//
//  Created by aa on 2018/5/5.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import "HCKBeaconInterface.h"
#import "HCKBeaconParser.h"
#import "HCKBeaconTaskIDDefines.h"
#import "HCKBeaconRegularsDefine.h"
#import "HCKBeaconCentralManager.h"
#import "CBPeripheral+HCKCharacters.h"

@implementation HCKBeaconInterface

#pragma mark - 通用服务,FF00

/**
 读取beacon的UUID,特征UUID为FF01

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconUUIDWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock{
    [self addReadTaskWithHeartBeat:HCKBeaconReadUUIDOperation
                    characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.beaconUUID
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
}

/**
 读取beacon主值，特征UUID为FF02

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconMajorWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock{
    [self addReadTaskWithHeartBeat:HCKBeaconReadMajorOperation
                    characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.major
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
}

/**
 读取beacon的次值，特征UUID为FF03

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconMinorWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock{
    [self addReadTaskWithHeartBeat:HCKBeaconReadMinorOperation
                    characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.minor
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
}

/**
 读取beacon的校验距离，特征UUID为FF04

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconMeasurePowerWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock{
    [self addReadTaskWithHeartBeat:HCKBeaconReadMeasurePowerOperation
                    characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.measurePower
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
}

/**
 读取beacon的广播功率，特征UUID为FF05。获取的数值范围为 0 – 8 ，依次表示发射功率为:4, 0, -4, -8, -12,-16, -20, -30, -40，单位为-dBm

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconTransmissionWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock{
    [self addReadTaskWithHeartBeat:HCKBeaconReadTransmissionOperation
                    characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.transmission
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
}

/**
 读取beacon的广播周期，特征UUID为FF07

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconBroadcastIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock{
    [self addReadTaskWithHeartBeat:HCKBeaconReadBroadcastIntervalOperation
                    characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.broadcastInterval
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
}

/**
 读取beacon的设备ID，特征UUID为FF08

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconDeviceIDWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock{
    [self addReadTaskWithHeartBeat:HCKBeaconReadDeviceIDOperation
                    characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.deviceID
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
}

/**
 读取beacon的名字，特征UUID为FF09

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconNameWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock{
    [self addReadTaskWithHeartBeat:HCKBeaconReadDeviceNameOperation
                    characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.beaconName
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
}

/**
 读取beacon的mac地址，特征UUID为FF0C

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock{
    [self addReadTaskWithHeartBeat:HCKBeaconReadMacAddressOperation
                    characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.macAddress
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
}

/**
 读取beacon的可连接状态，特征UUID为FF0E

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconConnectStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock{
    [self addReadTaskWithHeartBeat:HCKBeaconReadConnectStatusOperation
                    characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.connectMode
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
}

/**
 读取beacon的运行时间，特征UUID为FFE0

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconElapsedTimeWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock{
    NSString *commandString = @"ea590000";
    [self addTaskWithHeartBeat:HCKBeaconReadElapsedTimeOperation
                characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.elapsedTime
                 commandString:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

/**
 读取beacon的芯片类型，特征UUID为FFE0

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconHardwareModuleWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock{
    NSString *commandString = @"ea5b0000";
    [self addTaskWithHeartBeat:HCKBeaconReadHardwareModuleOperation
                characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.elapsedTime
                 commandString:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

/**
 读取三轴加速度数据

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)startReadXYZDataWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock{
    if ([HCKBeaconCentralManager sharedInstance].deviceType != HCKBeaconDeviceTypeWithXYZData) {
        [HCKBeaconParser operationDeviceTypeErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = @"ea6c000100";
    [self addTaskWithHeartBeat:HCKBeaconStartReadXYZDataOperation
                characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.elapsedTime
                 commandString:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

/**
 停止读取三轴加速度数据

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)stopReadXYZDataWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock{
    if ([HCKBeaconCentralManager sharedInstance].deviceType != HCKBeaconDeviceTypeWithXYZData) {
        [HCKBeaconParser operationDeviceTypeErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = @"ea6c000101";
    [self addTaskWithHeartBeat:HCKBeaconStopReadXYZDataOperation
                characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.elapsedTime
                 commandString:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark - 设置类

/**
 设置UUID

 @param uuid UUID
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setBeaconUUID:(NSString *)uuid
             sucBlock:(void (^)(id returnData))sucBlock
          failedBlock:(void (^)(NSError *error))failedBlock{
    if (![HCKBeaconParser isUUIDString:uuid]) {
        [HCKBeaconParser operationParametersErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    commandString = [commandString stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self addTaskWithHeartBeat:HCKBeaconSetBeaconUUIDOperation
                characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.beaconUUID
                 commandString:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

/**
 设置major，特征UUID为FF02

 @param major major,0~65535
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setBeaconMajor:(NSInteger)major
              sucBlock:(void (^)(id returnData))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock{
    if (major < 0 || major > 65535) {
        [HCKBeaconParser operationParametersErrorBlock:failedBlock];
        return;
    }
    NSString *majorString = [NSString stringWithFormat:@"%1lx",(unsigned long)major];
    NSString *commandString = [HCKBeaconParser getHexStringWithLength:4 origString:majorString];
    [self addTaskWithHeartBeat:HCKBeaconSetBeaconMajorOperation
                characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.major
                 commandString:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

/**
 设置minor，特征UUID为FF03

 @param minor minor,0~65535
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setBeaconMinor:(NSInteger)minor
              sucBlock:(void (^)(id returnData))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock{
    if (minor < 0 || minor > 65535) {
        [HCKBeaconParser operationParametersErrorBlock:failedBlock];
        return;
    }
    NSString *minorString = [NSString stringWithFormat:@"%1lx",(unsigned long)minor];
    NSString *commandString = [HCKBeaconParser getHexStringWithLength:4 origString:minorString];
    [self addTaskWithHeartBeat:HCKBeaconSetBeaconMinorOperation
                characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.minor
                 commandString:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

/**
 设置校验距离，特征UUID为FF04

 @param measurePower -120dBm ~ 0dBm
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setBeaconMeasurePower:(NSInteger)measurePower
                     sucBlock:(void (^)(id returnData))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock{
    if (measurePower < -120 || measurePower > 0) {
        [HCKBeaconParser operationParametersErrorBlock:failedBlock];
        return;
    }
    NSString *hexString = [NSString stringWithFormat:@"%1lx",(unsigned long)labs(measurePower)];
    NSString *commandString = [HCKBeaconParser getHexStringWithLength:2 origString:hexString];
    [self addTaskWithHeartBeat:HCKBeaconSetBeaconMeasurePowerOperation
                characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.measurePower
                 commandString:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

/**
 设置广播功率，特征UUID为FF05

 @param transmission 广播功率
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setBeaconTransmission:(beaconTransmission)transmission
                     sucBlock:(void (^)(id returnData))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock{
    NSString *commandString = [self getBeaconTransmission:transmission];
    [self addTaskWithHeartBeat:HCKBeaconSetBeaconTransmissionOperation
                characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.transmission
                 commandString:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

/**
 设置密码，特征UUID为FF06.beacon返回00(非连接状态，连接成功)、01(密码错误)、02(修改密码成功，只有连接状态下才能修改密码)三种状态
 
 @param password 必须是8个字符
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setBeaconPassword:(NSString *)password
                 sucBlock:(void (^)(id returnData))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock{
    if (!password || password.length != 8 || ![HCKBeaconParser asciiString:password]) {
        [HCKBeaconParser operationParametersErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = @"";
    for (NSInteger i = 0; i < password.length; i ++) {
        int asciiCode = [password characterAtIndex:i];
        commandString = [commandString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    [self addTaskWithHeartBeat:HCKBeaconSetBeaconPasswordOperation
                characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.changePassword
                 commandString:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

/**
 设置beacon的广播周期，特征UUID为FF07

 @param broadcastInterval 广播周期,100ms为单位，broadcastInterval * 100ms就是最后的广播周期,1~100
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setBeaconBroadcastInterval:(NSInteger)broadcastInterval
                          sucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock{
    if (broadcastInterval < 1 || broadcastInterval > 100) {
        [HCKBeaconParser operationParametersErrorBlock:failedBlock];
        return;
    }
    NSString *hexString = [NSString stringWithFormat:@"%1lx",(unsigned long)broadcastInterval];
    NSString *commandString = [HCKBeaconParser getHexStringWithLength:2 origString:hexString];
    [self addTaskWithHeartBeat:HCKBeaconSetBeaconBroadcastIntervalOperation
                characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.broadcastInterval
                 commandString:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

/**
 设置beacon的device id,特征UUID为FF08

 @param deviceID device id,只能是数字，最大长度为5
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setBeaconDeviceID:(NSString *)deviceID
                 sucBlock:(void (^)(id returnData))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock{
    if (!HCKBeaconValidStr(deviceID) || deviceID.length > 5) {
        [HCKBeaconParser operationParametersErrorBlock:failedBlock];
        return;
    }
    for (NSInteger i = 0; i < deviceID.length; i ++) {
        NSString *temp = [deviceID substringWithRange:NSMakeRange(i, 1)];
        if (![HCKBeaconParser realNumbers:temp]) {
            [HCKBeaconParser operationParametersErrorBlock:failedBlock];
            return;
        }
    }
    NSString *commandString = @"";
    for (NSInteger i = 0; i < deviceID.length; i ++) {
        int asciiCode = [deviceID characterAtIndex:i];
        commandString = [commandString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    [self addTaskWithHeartBeat:HCKBeaconSetBeaconDeviceIDOperation
                characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.deviceID
                 commandString:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

/**
 设置beacon的名字，特征UUID为FF09

 @param beaconName beacon的名字,字符串，通用不带三轴数据的最大长度为10个，带三轴数据的最大长度为4个
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setBeaconName:(NSString *)beaconName
             sucBlock:(void (^)(id returnData))sucBlock
          failedBlock:(void (^)(NSError *error))failedBlock{
    if (!HCKBeaconValidStr(beaconName) || ![HCKBeaconParser asciiString:beaconName]) {
        [HCKBeaconParser operationParametersErrorBlock:failedBlock];
        return;
    }
    BOOL canNext = NO;
    if ([HCKBeaconCentralManager sharedInstance].deviceType == HCKBeaconDeviceTypeNormal && beaconName.length <= 10) {
        canNext = YES;
    }else if ([HCKBeaconCentralManager sharedInstance].deviceType == HCKBeaconDeviceTypeWithXYZData && beaconName.length <= 4){
        canNext = YES;
    }
    if (!canNext) {
        [HCKBeaconParser operationParametersErrorBlock:failedBlock];
        return;
    }
//    if (![HCKBeaconParser isBeaconName:beaconName]) {
//        [HCKBeaconParser operationParametersErrorBlock:failedBlock];
//        return;
//    }
    NSString *commandString = @"";
    for (NSInteger i = 0; i < beaconName.length; i ++) {
        int asciiCode = [beaconName characterAtIndex:i];
        commandString = [commandString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    [self addTaskWithHeartBeat:HCKBeaconSetBeaconNameOperation
                characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.beaconName
                 commandString:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

/**
 设置beacon的可连接状态,特征UUID为FF0E

 @param connectEnable YES可连接，NO不可连接
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setBeaconConnectStatus:(BOOL)connectEnable
                      sucBlock:(void (^)(id returnData))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock{
    NSString *commandString = (connectEnable ? @"00" : @"01");
    [self addTaskWithHeartBeat:HCKBeaconSetBeaconConnectModeOperation
                characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.connectMode
                 commandString:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

/**
 关机

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)powerOffDeviceWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea6d000100";
    [self addTaskWithHeartBeat:HCKBeaconSetBeaconPowerOffOperation
                characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.elapsedTime
                 commandString:commandString
                      sucBlock:^(id returnData) {
                          BOOL success = [returnData[@"result"][@"powerOffSuccess"] boolValue];
                          if (success) {
                              if (sucBlock) {
                                  NSDictionary *result = @{@"msg":@"success",
                                                           @"code":@"1",
                                                           @"result":@{},
                                                           };
                                  sucBlock(result);
                              }
                              return ;
                          }
                          NSError *error = [[NSError alloc] initWithDomain:@"com.moko.iBeaconBluetoothSDK"
                                                                      code:-999
                                                                  userInfo:@{@"errorInfo":@"Power off error!"}];
                          if (failedBlock) {
                              failedBlock(error);
                          }
                      } failedBlock:failedBlock];
}

#pragma mark - 电池服务180F,全部只读
/**
 获取iBeacon的电量

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconBatteryWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock{
    [self addReadTaskWithHeartBeat:HCKBeaconReadBatteryOperation
                    characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.battery
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
}

#pragma mark - 系统信息服务180A,全部只读

/**
 读取系统标示，特征UUID为2A23
 
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconSystemIDWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock{
    [self addReadTaskWithHeartBeat:HCKBeaconReadSystemIDOperation
                    characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.systemID
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
}

/**
 读取产品型号信息，特征UUID为2A24

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconModeIDWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock{
    [self addReadTaskWithHeartBeat:HCKBeaconReadModeIDOperation
                    characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.modeID
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
}

/**
 读取生产日期，特征UUID为2A25

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconProductionDateWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock{
    [self addReadTaskWithHeartBeat:HCKBeaconReadProductionDateOperation
                    characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.productionDate
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
}

/**
 读取beacon固件信息，特征UUID为2A26

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock{
    [self addReadTaskWithHeartBeat:HCKBeaconReadFirmwareOperation
                    characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.firmware
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
}

/**
 读取beacon硬件信息，特征UUID为2A27

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock{
    [self addReadTaskWithHeartBeat:HCKBeaconReadHardwareOperation
                    characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.hardware
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
}

/**
 读取beacon软件版本，特征UUID为2A28

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock{
    [self addReadTaskWithHeartBeat:HCKBeaconReadSoftwareOperation
                    characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.software
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
}

/**
 读取厂商信息，特征UUID为2A29
 
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconVendorWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock{
    [self addReadTaskWithHeartBeat:HCKBeaconReadVendorOperation
                    characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.vendor
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
}

/**
 读取IEEE标准，特征UUID为2A2A

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBeaconIEEEInfoWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock{
    [self addReadTaskWithHeartBeat:HCKBeaconReadIEEEInfoOperation
                    characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.IEEEInfo
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
}

#pragma mark - 心跳包

/**
 发送心跳包给beacon
 
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)sendHeartBeatToBeaconWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock{
    [[HCKBeaconCentralManager sharedInstance] addTaskWithTaskID:HCKBeaconHeartBeatOperation
                                                       resetNum:NO
                                                    commandData:@"01"
                                                 characteristic:[HCKBeaconCentralManager sharedInstance].peripheral.heartBeat
                                                   successBlock:sucBlock
                                                   failureBlock:failedBlock];
}

#pragma mark -
+ (void)addReadTaskWithHeartBeat:(HCKBeaconTaskOperationID)taskID
                  characteristic:(CBCharacteristic *)characteristic
                        sucBlock:(void (^)(id returnData))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock{
    [self sendHeartBeatToBeaconWithSucBlock:^(id returnData) {
        [[HCKBeaconCentralManager sharedInstance] addReadTaskWithTaskID:taskID
                                                               resetNum:NO
                                                         characteristic:characteristic
                                                           successBlock:sucBlock
                                                           failureBlock:failedBlock];
    } failedBlock:failedBlock];
}

+ (void)addTaskWithHeartBeat:(HCKBeaconTaskOperationID)taskID
              characteristic:(CBCharacteristic *)characteristic
               commandString:(NSString *)commandString
                    sucBlock:(void (^)(id returnData))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock{
    [self sendHeartBeatToBeaconWithSucBlock:^(id returnData) {
        [[HCKBeaconCentralManager sharedInstance] addTaskWithTaskID:taskID
                                                           resetNum:NO
                                                        commandData:commandString
                                                     characteristic:characteristic
                                                       successBlock:sucBlock
                                                       failureBlock:failedBlock];
    } failedBlock:failedBlock];
}

#pragma mark -
//允许用户输入的数值范围为 0 – 8 ，依次表示发射功率为:4, 0, -4, -8, -12,-16, -20, -30, -40，单位为-dBm
+ (NSString *)getBeaconTransmission:(beaconTransmission)transmission{
    switch (transmission) {
        case beaconTransmission4dBm:
            return @"00";
        case beaconTransmission0dBm:
            return @"01";
        case beaconTransmissionNeg4dBm:
            return @"02";
        case beaconTransmissionNeg8dBm:
            return @"03";
        case beaconTransmissionNeg12dBm:
            return @"04";
        case beaconTransmissionNeg16dBm:
            return @"05";
        case beaconTransmissionNeg20dBm:
            return @"06";
        case beaconTransmissionNeg30dBm:
            return @"07";
        case beaconTransmissionNeg40dBm:
            return @"08";
    }
}

@end
