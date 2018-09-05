//
//  HCKBeaconTaskOperation.h
//  testSDK
//
//  Created by aa on 2018/5/5.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "HCKBeaconTaskIDDefines.h"

/**
 发送命令回调
 */
typedef void(^communicationCommandBlock)(void);

/**
 任务完成回调
 
 @param error 是否产生了超时错误
 @param operationID 当前任务ID
 @param returnData 返回的数据
 */
typedef void(^communicationCompleteBlock)(NSError *error, HCKBeaconTaskOperationID operationID, id returnData);

extern NSString *const HCKBeaconAdditionalInformation;
extern NSString *const HCKBeaconDataInformation;
extern NSString *const HCKBeaconDataStatusLev;
@interface HCKBeaconTaskOperation : NSOperation<CBPeripheralDelegate>

/**
 初始化通信线程
 
 @param operationID 当前线程的任务ID
 @param resetNum 是否需要根据外设返回的数据总条数来修改任务需要接受的数据总条数，YES需要，NO不需要
 @param commandBlock 发送命令回调
 @param completeBlock 数据通信完成回调
 @return operation
 */
- (instancetype)initOperationWithID:(HCKBeaconTaskOperationID)operationID
                           resetNum:(BOOL)resetNum
                       commandBlock:(communicationCommandBlock)commandBlock
                      completeBlock:(communicationCompleteBlock)completeBlock;

@end
