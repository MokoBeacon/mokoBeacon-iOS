//
//  HCKBeaconParser.h
//  testSDK
//
//  Created by aa on 2018/5/3.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

/*
 自定义的错误码
 */
typedef NS_ENUM(NSInteger, HCKBeaconCustomErrorCode){
    HCKBeaconBlueDisable = -10000,                                     //当前手机蓝牙不可用
    HCKBeaconConnectedFailed = -10001,                                 //连接外设失败
    HCKBeaconPeripheralDisconnected = -10002,                          //当前外部连接的设备处于断开状态
    HCKBeaconCharacteristicError = -10003,                             //特征为空
    HCKBeaconParamsError = -10004,                                     //输入的参数有误
    HCKBeaconCommunicationTimeout = -10005,                            //任务超时
    HCKBeaconRequestPeripheralDataError = -10006,                      //请求数据出错
    HCKBeaconPasswordError = -10007,                                   //连接密码错误
};

extern NSString * const HCKCustomErrorDomain;

@class HCKBeaconBaseModel;
@interface HCKBeaconParser : NSObject

+ (NSError *)getErrorWithCode:(HCKBeaconCustomErrorCode)code message:(NSString *)message;
+ (void)operationParametersErrorBlock:(void (^)(NSError *))block;
+ (void)operationCentralBlePowerOffErrorBlock:(void (^)(NSError *))block;
+ (void)operationPasswordErrorBlock:(void (^)(NSError *))block;
+ (void)operationDisconnectErrorBlock:(void (^)(NSError *))block;
+ (void)operationCharacterErrorBlock:(void (^)(NSError *))block;
+ (void)operationRequestDataErrorBlock:(void (^)(NSError *))block;
+ (void)operationConnectDeviceFailedBlock:(void (^)(NSError *))block;
+ (void)operationConnectDeviceSuccessBlock:(void (^)(CBPeripheral *))block peripheral:(CBPeripheral *)peripheral;
+ (void)operationDeviceTypeErrorBlock:(void (^)(NSError *))block;

+ (NSInteger)getDecimalWithHex:(NSString *)content range:(NSRange)range;
+ (NSString *)getDecimalStringWithHex:(NSString *)content range:(NSRange)range;
+ (NSData *)stringToData:(NSString *)dataString;
+ (NSString *)hexStringFromData:(NSData *)sourceData;
+ (BOOL)isPassword:(NSString *)content;
+ (BOOL)realNumbers:(NSString *)content;
+ (BOOL)isUUIDString:(NSString *)uuid;
+ (BOOL)isBeaconName:(NSString *)content;
+ (BOOL)getiBeaconConnectable:(NSString *)content;
+ (NSString *)calcDistByRSSI:(int)rssi measurePower:(NSInteger)measurePower;
+ (NSString *)getHexStringWithLength:(NSInteger)len origString:(NSString *)oriString;
+ (HCKBeaconBaseModel *)getiBeaconScanModelWithAdvDic:(NSDictionary *)advDic rssi:(NSInteger)rssi;
+ (BOOL)isThreeAxisAccelerationData:(CBCharacteristic *)characteristic;
+ (NSDictionary *)getThreeAxisAccelerationData:(CBCharacteristic *)characteristic;

@end
