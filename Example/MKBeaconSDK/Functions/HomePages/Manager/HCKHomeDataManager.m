//
//  HCKHomeDataManager.m
//  HCKBeacon
//
//  Created by aa on 2017/10/31.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKHomeDataManager.h"

@interface HCKHomeDataManager ()

@property (nonatomic, strong)dispatch_queue_t readDataQueue;

@end

@implementation HCKHomeDataManager

#pragma mark - Public method
- (instancetype)init {
    if (self = [super init]) {
        _readDataQueue = dispatch_queue_create("moko.com.readHomeDataQueue", 0);
    }
    return self;
}

/**
 开启读取数据流程

 @param completeBlock 成功回调
 @param failedBlock 失败回调
 */
- (void)startReadDataWithCompleteBlock:(readBeaconDatasCompleteBlock)completeBlock
                           failedBlock:(readBeaconDatasFailedBlock)failedBlock{
    if ([HCKBeaconCentralManager sharedInstance].connectStatus != HCKBeaconConnectStatusConnected) {
        //外设处于非连接状态
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failedBlock) {
                failedBlock([HCKErrorAdopter getConnectError]);
            }
        });
        return;
    }
    dispatch_async(_readDataQueue, ^{
        if (!ValidStr([HCKGlobalBeaconData share].battery)) {
            [HCKGlobalBeaconData share].battery = [self battery];
        }
        sleep(0.5f);
        NSLog(@"111111111111111111111111");
        if (!ValidStr([HCKGlobalBeaconData share].UUID)) {
            [HCKGlobalBeaconData share].UUID = [self beaconUUID];
        }
        sleep(0.5f);
        NSLog(@"222222222222222222222222");
        if (!ValidStr([HCKGlobalBeaconData share].major)) {
            [HCKGlobalBeaconData share].major = [self major];
        }
        sleep(0.5f);
        NSLog(@"3333333333333333333333333");
        if (!ValidStr([HCKGlobalBeaconData share].minor)) {
            [HCKGlobalBeaconData share].minor = [self minor];
        }
        sleep(0.5f);
        if (!ValidStr([HCKGlobalBeaconData share].measurePower)) {
            [HCKGlobalBeaconData share].measurePower = [self measurePower];
        }
        sleep(0.5f);
        if (!ValidStr([HCKGlobalBeaconData share].transmission)) {
            [HCKGlobalBeaconData share].transmission = [self transmission];
        }
        sleep(0.5f);
        if (!ValidStr([HCKGlobalBeaconData share].broadcastInterval)) {
            [HCKGlobalBeaconData share].broadcastInterval = [self broadcastInterval];
        }
        sleep(0.5f);
        if (!ValidStr([HCKGlobalBeaconData share].deviceID)) {
            [HCKGlobalBeaconData share].deviceID = [self deviceID];
        }
        sleep(0.5f);
        if (!ValidStr([HCKGlobalBeaconData share].macAddress)) {
            [HCKGlobalBeaconData share].macAddress = [self macAddress];
        }
        sleep(0.5f);
        if (!ValidStr([HCKGlobalBeaconData share].beaconName)) {
            [HCKGlobalBeaconData share].beaconName = [self beaconName];
        }
        sleep(0.5f);
        [HCKGlobalBeaconData share].connectEnable = [self connectStatus];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completeBlock) {
                completeBlock();
            }
        });
    });
}

#pragma mark - Private method

- (NSString *)battery {
    __block NSString *battery = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [HCKBeaconInterface readBeaconBatteryWithSucBlock:^(id returnData) {
        battery = returnData[@"result"][@"battery"];
        dispatch_semaphore_signal(semaphore);
    } failedBlock:^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return battery;
}

- (NSString *)beaconUUID {
    __block NSString *uuid = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [HCKBeaconInterface readBeaconUUIDWithSucBlock:^(id returnData) {
        uuid = returnData[@"result"][@"uuid"];
        dispatch_semaphore_signal(semaphore);
    } failedBlock:^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return uuid;
}

- (NSString *)major {
    __block NSString *major = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [HCKBeaconInterface readBeaconMajorWithSucBlock:^(id returnData) {
        major = returnData[@"result"][@"major"];
        dispatch_semaphore_signal(semaphore);
    } failedBlock:^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return major;
}

- (NSString *)minor {
    __block NSString *minor = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [HCKBeaconInterface readBeaconMinorWithSucBlock:^(id returnData) {
        minor = returnData[@"result"][@"minor"];
        dispatch_semaphore_signal(semaphore);
    } failedBlock:^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return minor;
}

- (NSString *)measurePower {
    __block NSString *measurePower = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [HCKBeaconInterface readBeaconMeasurePowerWithSucBlock:^(id returnData) {
        measurePower = returnData[@"result"][@"measurePower"];
        dispatch_semaphore_signal(semaphore);
    } failedBlock:^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return measurePower;
}

- (NSString *)transmission {
    __block NSString *transmission = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [HCKBeaconInterface readBeaconTransmissionWithSucBlock:^(id returnData) {
        transmission = returnData[@"result"][@"transmission"];
        dispatch_semaphore_signal(semaphore);
    } failedBlock:^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return transmission;
}

- (NSString *)broadcastInterval {
    __block NSString *broadcastInterval = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [HCKBeaconInterface readBeaconBroadcastIntervalWithSucBlock:^(id returnData) {
        broadcastInterval = returnData[@"result"][@"broadcastInterval"];
        dispatch_semaphore_signal(semaphore);
    } failedBlock:^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return broadcastInterval;
}

- (NSString *)deviceID {
    __block NSString *deviceID = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [HCKBeaconInterface readBeaconDeviceIDWithSucBlock:^(id returnData) {
        deviceID = returnData[@"result"][@"deviceID"];
        dispatch_semaphore_signal(semaphore);
    } failedBlock:^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return deviceID;
}

- (NSString *)macAddress {
    __block NSString *macAddress = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [HCKBeaconInterface readBeaconMacAddressWithSucBlock:^(id returnData) {
        macAddress = returnData[@"result"][@"macAddress"];
        dispatch_semaphore_signal(semaphore);
    } failedBlock:^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return macAddress;
}

- (NSString *)beaconName {
    __block NSString *beaconName = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [HCKBeaconInterface readBeaconNameWithSucBlock:^(id returnData) {
        beaconName = returnData[@"result"][@"beaconName"];
        dispatch_semaphore_signal(semaphore);
    } failedBlock:^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return beaconName;
}

- (BOOL)connectStatus {
    __block BOOL connectStatus = NO;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [HCKBeaconInterface readBeaconConnectStatusWithSucBlock:^(id returnData) {
        connectStatus = [returnData[@"result"][@"connectStatus"] boolValue];
        dispatch_semaphore_signal(semaphore);
    } failedBlock:^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return connectStatus;
}

@end
