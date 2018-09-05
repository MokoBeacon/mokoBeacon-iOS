//
//  HCKBeaconCentralManager.h
//  testSDK
//
//  Created by aa on 2018/5/2.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "HCKBeaconProtocol.h"
#import "HCKBeaconTaskIDDefines.h"
#import "HCKBeaconBaseModel.h"

@interface HCKBeaconCentralManager : NSObject

/**
 当前蓝牙中心
 */
@property (nonatomic, strong, readonly)CBCentralManager *centralManager;

@property (nonatomic, strong, readonly)CBPeripheral *peripheral;

/**
 当前设备类型
 */
@property (nonatomic, assign, readonly)HCKBeaconDeviceType deviceType;

/**
 当前外设的连接状态
 */
@property (nonatomic, assign, readonly)HCKBeaconConnectStatus connectStatus;

/**
 当前中心蓝牙状态
 */
@property (nonatomic, assign, readonly)HCKBeaconCentralManagerState managerState;

/**
 中心扫描代理
 */
@property (nonatomic, weak)id <HCKCentralScanDelegate>scanDelegate;

/**
 三轴加速度值代理，只有当前iBeacon设备支持三轴加速度数据才会有效。需要调用[HCKBeaconInterface startReadXYZDataWithSucBlock:failedBlock:]方法来开启读取三轴加速度数据，可以调用[HCKBeaconInterface stopReadXYZDataWithSucBlock:failedBlock:]来停止读取加速度数据。另外跟外设断开连接的时候，外设会关闭传输加速度数据，想要再次开启，调用[HCKBeaconInterface startReadXYZDataWithSucBlock:failedBlock:]方法
 */
@property (nonatomic, weak)id <HCKBeaconThreeAxisAccelerationDelegate>xyzDelegate;

/**
 当前外设rssi改变代理，需要让当前连接的外设调用readCurrentRssiValue方法。
 */
@property (nonatomic, weak)id <HCKBeaconRssiValueChangedDelegate>rssiValueDelegate;

@property (nonatomic, weak)id <HCKCentralStatesChangedDelegate>stateDelegate;

+ (HCKBeaconCentralManager *)sharedInstance;

/**
 销毁当前中心单例
 */
+ (void)attempDealloc;

/**
 开始扫描设备
 */
- (void)startScaniBeacons;

/**
 停止扫描
 */
- (void)stopScaniBeacon;

/**
 连接设备。连接设备的时候，会停止扫描，如果当前处于扫描状态，则需要先调用stopScaniBeacon方法来停止扫描，以便拿到停止扫描的回调。
 
 @param device 目标设备
 @param deviceType 设备类型，普通iBeacon设备、带三轴加速度数据iBeacon设备
 @param password 设备连接密码
 @param sucBlock 连接成功回调
 @param failBlock 连接失败回调
 */
- (void)connectDevice:(CBPeripheral *)device
           deviceType:(HCKBeaconDeviceType)deviceType
             password:(NSString *)password
      connectSucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
   connectFailedBlock:(void (^)(NSError *error))failBlock;

/**
 断开当前已经连接或者正在连接的设备
 */
- (void)disconnectConnectedPeripheral;

/**
 获取当前已连接设备的rssi值
 */
- (void)readCurrentRssiValue;

/**
 添加一个设置任务(app-->peripheral)到队列
 
 @param operationID 任务ID
 @param resetNum 是否需要由外设返回通信数据总条数
 @param commandData 通信数据
 @param characteristic 通信所使用的特征
 @param successBlock 通信成功回调
 @param failureBlock 通信失败回调
 */
- (void)addTaskWithTaskID:(HCKBeaconTaskOperationID)operationID
                 resetNum:(BOOL)resetNum
              commandData:(NSString *)commandData
           characteristic:(CBCharacteristic *)characteristic
             successBlock:(void (^)(id returnData))successBlock
             failureBlock:(void (^)(NSError *error))failureBlock;

/**
 添加一个读取任务(app-->peripheral)到队列
 
 @param operationID 任务ID
 @param resetNum 是否需要由外设返回通信数据总条数
 @param characteristic 通信所使用的特征
 @param successBlock 通信成功回调
 @param failureBlock 通信失败回调
 */
- (void)addReadTaskWithTaskID:(HCKBeaconTaskOperationID)operationID
                     resetNum:(BOOL)resetNum
               characteristic:(CBCharacteristic *)characteristic
                 successBlock:(void (^)(id returnData))successBlock
                 failureBlock:(void (^)(NSError *error))failureBlock;

@end
