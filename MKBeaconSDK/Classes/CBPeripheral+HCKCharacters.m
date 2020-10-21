//
//  CBPeripheral+HCKCharacters.m
//  testSDK
//
//  Created by aa on 2018/8/3.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import "CBPeripheral+HCKCharacters.h"
#import <objc/runtime.h>
#import "HCKBeaconService.h"
//Characteristic
static const char *uuid = "uuid";
static const char *major = "major";
static const char *minor = "minor";
static const char *measurePower = "measurePower";
static const char *transmission = "transmission";
static const char *changePassword = "changePassword";
static const char *broadcastInterval = "broadcastInterval";
static const char *deviceID = "deviceID";
static const char *beaconName = "beaconName";
static const char *macAddress = "macAddress";
static const char *connectMode = "connectMode";
static const char *softReboot = "softReboot";
static const char *heartBeat = "heartBeat";
static const char *elapsedTime = "elapsedTime";
static const char *battery = "battery";
static const char *vendor = "vendor";
static const char *modeID = "modeID";
static const char *hardware = "hardware";
static const char *firmware = "firmware";
static const char *software = "software";
static const char *systemID = "systemID";
static const char *IEEEInfo = "IEEEInfo";
static const char *productionDate = "productionDate";
static const char *dfu = "dfu";

@implementation CBPeripheral (HCKCharacters)

#pragma mark - public method
- (void)updateCharacterWithService:(CBService *)service{
    if ([service.UUID isEqual:[CBUUID UUIDWithString:normalConfigService]]) {
        //通用的服务
        [self setNormalCharacteristic:service];
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:batteryService]]){
        //电池服务
        [self setBatteryCharacteristic:service];
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:systemService]]){
        //系统信息(软件版本、硬件版本等)
        [self setDeviceInfoCharacteristic:service];
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:dfuService]]){
        //DFU功能
        [self setDFUCharacteristic:service];
        return;
    }
}

- (void)setNil{
    objc_setAssociatedObject(self, &uuid, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &major, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &minor, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &measurePower, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &transmission, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &changePassword, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &broadcastInterval, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &deviceID, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &beaconName, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &macAddress, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &connectMode, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &softReboot, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &heartBeat, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &elapsedTime, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &battery, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &vendor, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &modeID, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &hardware, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &firmware, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &software, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &systemID, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &IEEEInfo, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &productionDate, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &dfu, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)getAllCharacteristics{
    if (![self normalServiceSuccess] || ![self deviceInfoServiceSuccess]
        || ![self batteryServiceSuccess] || ![self dfuServiceSuccess]) {
        return NO;
    }
    return YES;
}

#pragma mark - getter
- (CBCharacteristic *)beaconUUID{
    return objc_getAssociatedObject(self, &uuid);
}

- (CBCharacteristic *)major{
    return objc_getAssociatedObject(self, &major);
}

- (CBCharacteristic *)minor{
    return objc_getAssociatedObject(self, &minor);
}

- (CBCharacteristic *)measurePower{
    return objc_getAssociatedObject(self, &measurePower);
}

- (CBCharacteristic *)transmission{
    return objc_getAssociatedObject(self, &transmission);
}

- (CBCharacteristic *)changePassword{
    return objc_getAssociatedObject(self, &changePassword);
}

- (CBCharacteristic *)broadcastInterval{
    return objc_getAssociatedObject(self, &broadcastInterval);
}

- (CBCharacteristic *)deviceID{
    return objc_getAssociatedObject(self, &deviceID);
}

- (CBCharacteristic *)beaconName{
    return objc_getAssociatedObject(self, &beaconName);
}

- (CBCharacteristic *)macAddress{
    return objc_getAssociatedObject(self, &macAddress);
}

- (CBCharacteristic *)connectMode{
    return objc_getAssociatedObject(self, &connectMode);
}

- (CBCharacteristic *)softReboot{
    return objc_getAssociatedObject(self, &softReboot);
}

- (CBCharacteristic *)heartBeat{
    return objc_getAssociatedObject(self, &heartBeat);
}

- (CBCharacteristic *)elapsedTime{
    return objc_getAssociatedObject(self, &elapsedTime);
}

- (CBCharacteristic *)vendor{
    return objc_getAssociatedObject(self, &vendor);
}

- (CBCharacteristic *)modeID{
    return objc_getAssociatedObject(self, &modeID);
}

- (CBCharacteristic *)hardware{
    return objc_getAssociatedObject(self, &hardware);
}

- (CBCharacteristic *)firmware{
    return objc_getAssociatedObject(self, &firmware);
}

- (CBCharacteristic *)software{
    return objc_getAssociatedObject(self, &software);
}

- (CBCharacteristic *)systemID{
    return objc_getAssociatedObject(self, &systemID);
}

- (CBCharacteristic *)IEEEInfo{
    return objc_getAssociatedObject(self, &IEEEInfo);
}

- (CBCharacteristic *)productionDate{
    return objc_getAssociatedObject(self, &productionDate);
}

- (CBCharacteristic *)battery{
    return objc_getAssociatedObject(self, &battery);
}

- (CBCharacteristic *)dfu{
    return objc_getAssociatedObject(self, &dfu);
}

#pragma mark - private method

- (void)setBatteryCharacteristic:(CBService *)service{
    if (!service) {
        return;
    }
    NSArray *charactList = [service.characteristics mutableCopy];
    for (CBCharacteristic *characteristic in charactList) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconBattery]]) {
            objc_setAssociatedObject(self, &battery, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            break;
        }
    }
}

- (void)setNormalCharacteristic:(CBService *)service{
    if (!service) {
        return;
    }
    NSArray *charactList = [service.characteristics mutableCopy];
    for (CBCharacteristic *characteristic in charactList) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconUUID]]) {
            //beacon的uuid
            objc_setAssociatedObject(self, &uuid, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconMajor]]){
            //beacon的主值
            objc_setAssociatedObject(self, &major, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconMinor]]){
            //beacon的次值
            objc_setAssociatedObject(self, &minor, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconMeasurePower]]){
            //校验距离
            objc_setAssociatedObject(self, &measurePower, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconTransmission]]){
            //广播功率
            objc_setAssociatedObject(self, &transmission, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconChangePassword]]){
            //重启密码
            objc_setAssociatedObject(self, &changePassword, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [self setNotifyValue:YES forCharacteristic:characteristic];
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconBroadcastInterval]]){
            //广播周期
            objc_setAssociatedObject(self, &broadcastInterval, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconDeviceID]]){
            //设备编号
            objc_setAssociatedObject(self, &deviceID, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconDeviceName]]){
            //beacon名称
            objc_setAssociatedObject(self, &beaconName, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconMacAddress]]){
            //读取mac地址
            objc_setAssociatedObject(self, &macAddress, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconConnectMode]]){
            //可连接状态
            objc_setAssociatedObject(self, &connectMode, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconSoftReboot]]){
            //重启
            objc_setAssociatedObject(self, &softReboot, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconHeartBeat]]){
            //心跳包
            objc_setAssociatedObject(self, &heartBeat, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconElapsedTime]]){
            //运行时间,可监听
            objc_setAssociatedObject(self, &elapsedTime, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [self setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}

- (void)setDeviceInfoCharacteristic:(CBService *)service{
    if (!service) {
        return;
    }
    NSArray *charactList = [service.characteristics mutableCopy];
    for (CBCharacteristic *characteristic in charactList) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconVendor]]) {
            //厂商自定义
            objc_setAssociatedObject(self, &vendor, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconModeID]]){
            //产品型号
            objc_setAssociatedObject(self, &modeID, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconHardware]]){
            //硬件版本
            objc_setAssociatedObject(self, &hardware, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconFirmware]]){
            //固件版本
            objc_setAssociatedObject(self, &firmware, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconSoftware]]){
            //软件版本
            objc_setAssociatedObject(self, &software, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconSystemID]]){
            //系统标示
            objc_setAssociatedObject(self, &systemID, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconIEEEInfo]]){
            //IEEE标准信息
            objc_setAssociatedObject(self, &IEEEInfo, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconProductionDate]]){
            //生产日期
            objc_setAssociatedObject(self, &productionDate, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}

- (void)setDFUCharacteristic:(CBService *)service{
    if (!service) {
        return;
    }
    NSArray *charactList = [service.characteristics mutableCopy];
    for (CBCharacteristic *characteristic in charactList) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconDFU]]) {
            objc_setAssociatedObject(self, &dfu, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            break;
        }
    }
}

- (BOOL)normalServiceSuccess{
    if (!self.beaconUUID || !self.major || !self.minor || !self.measurePower || !self.transmission || !self.changePassword
        || !self.broadcastInterval || !self.deviceID || !self.beaconName || !self.macAddress || !self.connectMode
        || !self.softReboot || !self.heartBeat || !self.elapsedTime) {
        return NO;
    }
    return YES;
}

- (BOOL)deviceInfoServiceSuccess{
    if (!self.vendor || !self.modeID || !self.hardware || !self.firmware || !self.software
        || !self.systemID || !self.IEEEInfo || !self.productionDate) {
        return NO;
    }
    return YES;
}

- (BOOL)batteryServiceSuccess{
    if (!self.battery) {
        return NO;
    }
    return YES;
}

- (BOOL)dfuServiceSuccess{
    if (!self.dfu) {
        return NO;
    }
    return YES;
}

@end
