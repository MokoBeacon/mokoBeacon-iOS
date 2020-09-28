//
//  HCKGlobalBeaconData.m
//  HCKBeacon
//
//  Created by aa on 2018/5/9.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import "HCKGlobalBeaconData.h"

static HCKGlobalBeaconData *beaconData = nil;
static dispatch_once_t onceToken;

@implementation HCKGlobalBeaconData

- (instancetype)init{
    if (self = [super init]) {
        [self loadEmptyModels];
    }
    return self;
}

+ (HCKGlobalBeaconData *)share{
    dispatch_once(&onceToken, ^{
        if (!beaconData) {
            beaconData = [[HCKGlobalBeaconData alloc] init];
        }
    });
    return beaconData;
}

#pragma mark - Public method

/**
 清空所有数据
 */
- (void)loadEmptyModels{
    self.battery = @"";
    self.UUID = @"";
    self.major = @"";
    self.minor = @"";
    self.measurePower = @"";
    self.transmission = @"";
    self.broadcastInterval = @"";
    self.deviceID = @"";
    self.password = @"";
    self.macAddress = @"";
    self.beaconName = @"";
    self.manufacturers = @"";
    self.model = @"";
    self.productionTime = @"";
    self.hardwareModule = @"";
    self.hardwareVersion = @"";
    self.firmwareVersion = @"";
    self.softVersion = @"";
    self.elapsedTime = @"";
    self.restartTime = @"";
    self.systemID = @"";
    self.IEEE = @"";
}

@end
