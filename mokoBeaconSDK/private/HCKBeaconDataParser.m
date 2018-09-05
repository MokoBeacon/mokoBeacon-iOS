//
//  HCKBeaconDataParser.m
//  testSDK
//
//  Created by aa on 2018/5/5.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import "HCKBeaconDataParser.h"
#import "HCKBeaconService.h"
#import "HCKBeaconRegularsDefine.h"
#import "HCKBeaconParser.h"
#import "HCKBeaconTaskIDDefines.h"

NSString *const HCKBeaconCommunicationDataNum = @"HCKBeaconCommunicationDataNum";

@implementation HCKBeaconDataParser

#pragma mark - Public method
+ (NSDictionary *)parseReadDataFromCharacteristic:(CBCharacteristic *)characteristic{
    if (!characteristic) {
        return nil;
    }
    NSData *readData = characteristic.value;
    if (!HCKBeaconValidData(readData)) {
        return nil;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconUUID]]){
        //读取beacon的UUID
        return [self parseUUIDData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconMajor]]){
        //读取beacon的主值
        return [self parseMajorData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconMinor]]){
        //读取beacon的次值
        return [self parseMinorData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconMeasurePower]]){
        //读取beacon的校验距离
        return [self parseMeasurePowerData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconTransmission]]){
        //读取beacon的广播功率
        return [self parseTransmissionData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconChangePassword]]){
        //beacon的重启密码
        return [self parseSetPassword:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconBroadcastInterval]]){
        //读取beacon的广播周期
        return [self parseBroadcastIntervalData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconDeviceID]]){
        //读取beacon的设备ID
        return [self parseDeviceIDData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconDeviceName]]){
        //读取beacon的名字
        return [self parseDeviceNameData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconMacAddress]]){
        //读取beacon的mac地址
        return [self parseMacAddressData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconConnectMode]]){
        //读取beacon的可连接状态
        return [self parseConnectStatus:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconElapsedTime]]){
        //读取beacon的运行时间和芯片类型
        return [self parseBeaconElapsedTimeCharactersValue:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconBattery]]){
        //电池电量
        return [self parseBatteryData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconSystemID]]){
        //系统标示
        return [self parseSystemIDData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconModeID]]){
        //产品型号信息
        return [self parseModeIDData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconProductionDate]]){
        //读取beacon的生产日期
        return [self parseProductionDateData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconFirmware]]){
        //固件信息
        return [self parseFirmwareData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconHardware]]){
        //硬件信息
        return [self parseHardwareData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconSoftware]]){
        //软件版本
        return [self parseSoftwareData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconVendor]]){
        //厂商信息
        return [self parseVendorData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconIEEEInfo]]){
        //IEEE标准
        return [self parseIEEEInfoData:readData];
    }
    return nil;
}

+ (NSDictionary *)parseWriteDataFromCharacteristic:(CBCharacteristic *)characteristic{
    if (!characteristic) {
        return nil;
    }
    HCKBeaconTaskOperationID operationID = HCKBeaconTaskDefaultOperation;
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconUUID]]){
        //UUID
        operationID = HCKBeaconSetBeaconUUIDOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconMajor]]){
        //beacon的主值
        operationID = HCKBeaconSetBeaconMajorOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconMinor]]){
        //beacon的次值
        operationID = HCKBeaconSetBeaconMinorOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconMeasurePower]]){
        //beacon的校验距离
        operationID = HCKBeaconSetBeaconMeasurePowerOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconTransmission]]){
        //beacon的广播功率
        operationID = HCKBeaconSetBeaconTransmissionOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconBroadcastInterval]]){
        //beacon的广播周期
        operationID = HCKBeaconSetBeaconBroadcastIntervalOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconDeviceID]]){
        //beacon的设备ID
        operationID = HCKBeaconSetBeaconDeviceIDOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconDeviceName]]){
        //beacon的名字
        operationID = HCKBeaconSetBeaconNameOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconConnectMode]]){
        //beacon的可连接状态
        operationID = HCKBeaconSetBeaconConnectModeOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconSoftReboot]]){
        //beacon重启
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconHeartBeat]]){
        //beacon的心跳
        operationID = HCKBeaconHeartBeatOperation;
    }
    return [self dataParserGetDataSuccess:@{} operationID:operationID];
}

#pragma mark - Private method
+ (NSDictionary *)dataParserGetDataSuccess:(NSDictionary *)returnData operationID:(HCKBeaconTaskOperationID)operationID{
    if (!returnData) {
        return nil;
    }
    return @{@"returnData":returnData,@"operationID":@(operationID)};
}

#pragma mark - data parse
+ (NSDictionary *)parseUUIDData:(NSData *)readData{
    if (!HCKBeaconValidData(readData) || readData.length != 16) {
        return nil;
    }
    NSString *content = [HCKBeaconParser hexStringFromData:readData];
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:5];
    [list addObject:[content substringWithRange:NSMakeRange(0, 8)]];
    [list addObject:[content substringWithRange:NSMakeRange(8, 4)]];
    [list addObject:[content substringWithRange:NSMakeRange(12, 4)]];
    [list addObject:[content substringWithRange:NSMakeRange(16,4)]];
    [list addObject:[content substringWithRange:NSMakeRange(20, 12)]];
    [list insertObject:@"-" atIndex:1];
    [list insertObject:@"-" atIndex:3];
    [list insertObject:@"-" atIndex:5];
    [list insertObject:@"-" atIndex:7];
    NSString *uuid = @"";
    for (NSString *string in list) {
        uuid = [uuid stringByAppendingString:string];
    }
    return [self dataParserGetDataSuccess:@{@"uuid":[uuid uppercaseString]} operationID:HCKBeaconReadUUIDOperation];
}

+ (NSDictionary *)parseMajorData:(NSData *)readData{
    NSString *content = [HCKBeaconParser hexStringFromData:readData];
    if (!HCKBeaconValidStr(content)) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                     @"major":[HCKBeaconParser getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
                                     }
                              operationID:HCKBeaconReadMajorOperation];
}

+ (NSDictionary *)parseMinorData:(NSData *)readData{
    NSString *content = [HCKBeaconParser hexStringFromData:readData];
    if (!HCKBeaconValidStr(content)) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                            @"minor":[HCKBeaconParser getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
                                            }
                              operationID:HCKBeaconReadMinorOperation];
}

+ (NSDictionary *)parseMeasurePowerData:(NSData *)readData{
    NSString *content = [HCKBeaconParser hexStringFromData:readData];
    if (!HCKBeaconValidStr(content)) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                            @"measurePower":[HCKBeaconParser getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
                                            }
                              operationID:HCKBeaconReadMeasurePowerOperation];
}

+ (NSDictionary *)parseTransmissionData:(NSData *)readData{
    NSString *content = [HCKBeaconParser hexStringFromData:readData];
    if (!HCKBeaconValidStr(content)) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                            @"transmission":[HCKBeaconParser getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
                                            }
                              operationID:HCKBeaconReadTransmissionOperation];
}

+ (NSDictionary *)parseBroadcastIntervalData:(NSData *)readData{
    NSString *content = [HCKBeaconParser hexStringFromData:readData];
    if (!HCKBeaconValidStr(content)) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                            @"broadcastInterval":[HCKBeaconParser getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
                                            }
                              operationID:HCKBeaconReadBroadcastIntervalOperation];
}

+ (NSDictionary *)parseDeviceIDData:(NSData *)readData{
    NSString *deviceID = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    if (!HCKBeaconValidStr(deviceID)) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                            @"deviceID":deviceID,
                                            }
                              operationID:HCKBeaconReadDeviceIDOperation];
}

+ (NSDictionary *)parseDeviceNameData:(NSData *)readData{
    NSString *deviceName = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    if (!HCKBeaconValidStr(deviceName)) {
        return nil;
    }
    deviceName = [deviceName stringByReplacingOccurrencesOfString:@"\0" withString:@""];
    if (!HCKBeaconValidStr(deviceName)) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                            @"beaconName":deviceName,
                                            }
                              operationID:HCKBeaconReadDeviceNameOperation];
}

+ (NSDictionary *)parseMacAddressData:(NSData *)readData{
    NSString *content = [HCKBeaconParser hexStringFromData:readData];
    if (!HCKBeaconValidStr(content) || content.length != 12) {
        return nil;
    }
    NSString *macAddress = @"";
    for (NSInteger i = 0; i < 6; i ++) {
        NSString *tempStr = [content substringWithRange:NSMakeRange(i * 2, 2)];
        if (i != 0) {
            tempStr = [@":" stringByAppendingString:tempStr];
        }
        macAddress = [macAddress stringByAppendingString:tempStr];
    }
    return [self dataParserGetDataSuccess:@{
                                            @"macAddress":[macAddress uppercaseString],
                                            }
                              operationID:HCKBeaconReadMacAddressOperation];
}

+ (NSDictionary *)parseConnectStatus:(NSData *)readData{
    NSString *content = [HCKBeaconParser hexStringFromData:readData];
    if (!HCKBeaconValidStr(content) || content.length != 2) {
        return nil;
    }
    BOOL connectStatus = [content isEqualToString:@"00"];
    return [self dataParserGetDataSuccess:@{
                                            @"connectStatus":@(connectStatus),
                                            }
                              operationID:HCKBeaconReadConnectStatusOperation];
}

+ (NSDictionary *)parseBeaconElapsedTimeCharactersValue:(NSData *)readData{
    NSString *content = [HCKBeaconParser hexStringFromData:readData];
    if (!HCKBeaconValidStr(content) || content.length < 4) {
        return nil;
    }
    NSString *header = [content substringToIndex:2];
    if (![header isEqualToString:@"eb"]) {
        return nil;
    }
    NSInteger len = strtoul([[content substringWithRange:NSMakeRange(6, 2)] UTF8String],0,16);
    if (content.length != (8 + 2 * len)) {
        return nil;
    }
    NSString *function = [content substringWithRange:NSMakeRange(2, 2)];
    NSDictionary *returnData = nil;
    HCKBeaconTaskOperationID operationID = HCKBeaconTaskDefaultOperation;
    if ([function isEqualToString:@"59"]) {
        //运行时间
        returnData = @{
                       @"elapsedTime":[HCKBeaconParser getDecimalStringWithHex:content range:NSMakeRange(8, 2 * len)],
                       };
        operationID = HCKBeaconReadElapsedTimeOperation;
    }else if ([function isEqualToString:@"5b"]){
        NSData *subData = [readData subdataWithRange:NSMakeRange(4, len)];
        NSString *hardwareModul = [[NSString alloc] initWithData:subData encoding:NSUTF8StringEncoding];
        if (!HCKBeaconValidStr(hardwareModul)) {
            return nil;
        }
        returnData = @{
                       @"hardwareModul":hardwareModul,
                       };
        operationID = HCKBeaconReadHardwareModuleOperation;
    }else if ([function isEqualToString:@"6c"]){
        NSString *string = [content substringWithRange:NSMakeRange(8, 2)];
        if ([string isEqualToString:@"00"]) {
            returnData = @{};
            operationID = HCKBeaconStartReadXYZDataOperation;
        }else if ([string isEqualToString:@"01"]){
            returnData = @{};
            operationID = HCKBeaconStopReadXYZDataOperation;
        }
    }
    return [self dataParserGetDataSuccess:returnData operationID:operationID];
}

+ (NSDictionary *)parseBatteryData:(NSData *)readData{
    NSString *content = [HCKBeaconParser hexStringFromData:readData];
    if (!HCKBeaconValidStr(content) || content.length != 2) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                            @"battery":[HCKBeaconParser getDecimalStringWithHex:content range:NSMakeRange(0, 2)],
                                            }
                              operationID:HCKBeaconReadBatteryOperation];
}

+ (NSDictionary *)parseSystemIDData:(NSData *)readData{
    NSString *systemID = [HCKBeaconParser hexStringFromData:readData];
    if (!HCKBeaconValidStr(systemID)) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                     @"systemID":systemID,
                                     }
                              operationID:HCKBeaconReadSystemIDOperation];
}

+ (NSDictionary *)parseVendorData:(NSData *)readData{
    NSString *vendorData = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    if (!HCKBeaconValidStr(vendorData)) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                            @"vendor":vendorData,
                                            }
                              operationID:HCKBeaconReadVendorOperation];
}

+ (NSDictionary *)parseModeIDData:(NSData *)readData{
    NSString *modeID = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    if (!HCKBeaconValidStr(modeID)) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                            @"modeID":modeID,
                                            }
                              operationID:HCKBeaconReadModeIDOperation];
}

+ (NSDictionary *)parseProductionDateData:(NSData *)readData{
    NSString *productionDate = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    if (!HCKBeaconValidStr(productionDate)) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                            @"productionDate":productionDate,
                                            }
                              operationID:HCKBeaconReadProductionDateOperation];
}

+ (NSDictionary *)parseFirmwareData:(NSData *)readData{
    NSString *firmware = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    if (!HCKBeaconValidStr(firmware)) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                            @"firmware":firmware,
                                            }
                              operationID:HCKBeaconReadFirmwareOperation];
}

+ (NSDictionary *)parseHardwareData:(NSData *)readData{
    NSString *hardware = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    if (!HCKBeaconValidStr(hardware)) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                            @"hardware":hardware,
                                            }
                              operationID:HCKBeaconReadHardwareOperation];
}

+ (NSDictionary *)parseSoftwareData:(NSData *)readData{
    NSString *software = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    if (!HCKBeaconValidStr(software)) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                            @"software":software,
                                            }
                              operationID:HCKBeaconReadSoftwareOperation];
}

+ (NSDictionary *)parseIEEEInfoData:(NSData *)readData{
    NSString *ieeeInfo = [HCKBeaconParser hexStringFromData:readData];
    if (!HCKBeaconValidStr(ieeeInfo)) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                            @"IEEE":ieeeInfo,
                                            }
                              operationID:HCKBeaconReadIEEEInfoOperation];
}

+ (NSDictionary *)parseSetPassword:(NSData *)readData{
    NSString *content = [HCKBeaconParser hexStringFromData:readData];
    if (!HCKBeaconValidStr(content) || content.length != 2) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                            @"result":content,
                                            }
                              operationID:HCKBeaconSetBeaconPasswordOperation];
}

@end
