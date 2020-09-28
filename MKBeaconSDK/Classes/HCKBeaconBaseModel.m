//
//  HCKBeaconBaseModel.m
//  HCKBeacon
//
//  Created by aa on 2018/1/15.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import "HCKBeaconBaseModel.h"
#import "HCKBeaconParser.h"
#import "HCKBeaconRegularsDefine.h"

@implementation HCKBeaconBaseModel

- (HCKBeaconBaseModel *)initWithAdvertiseData:(NSData *)advertiseData additionalDic:(NSDictionary *)additionalDic{
    self = [super init];
    if (self) {
        NSAssert1(!(advertiseData.length != 7), @"Invalid advertiseData:%@", advertiseData);
        self.deviceType = HCKBeaconDeviceTypeNormal;
        self.rssi = [NSString stringWithFormat:@"%ld",(long)[additionalDic[@"rssi"] integerValue]];
        NSString *temp = [HCKBeaconParser hexStringFromData:advertiseData];
        self.battery = [HCKBeaconParser getDecimalStringWithHex:temp range:NSMakeRange(0, 2)];
        self.major = [HCKBeaconParser getDecimalStringWithHex:temp range:NSMakeRange(2, 4)];
        self.minor = [HCKBeaconParser getDecimalStringWithHex:temp range:NSMakeRange(6, 4)];
        self.measurePower = [HCKBeaconParser getDecimalStringWithHex:temp range:NSMakeRange(10, 2)];
        self.connectEnble = [HCKBeaconParser getiBeaconConnectable:[temp substringWithRange:NSMakeRange(12, 2)]];
        NSInteger measurePower = (HCKBeaconValidStr(self.measurePower) ? [self.measurePower integerValue] : 59);
        self.distance = [HCKBeaconParser calcDistByRSSI:[self.rssi intValue] measurePower:measurePower];
        self.proximity = @"Unknown";
        if ([self.distance doubleValue] <= 0.1) {
            self.proximity = @"Immediate";
        }else if ([self.distance doubleValue] > 0.1 && [self.distance doubleValue] <= 1.f){
            self.proximity = @"Near";
        }else if ([self.distance doubleValue] > 1.f){
            self.proximity = @"Far";
        }
        self.peripheralName = additionalDic[@"peripheralName"];
        self.txPower = additionalDic[@"txPower"];
    }
    return self;
}

@end

@implementation HCKXYZBeaconModel

- (HCKXYZBeaconModel *)initWithAdvertiseData:(NSData *)advertiseData additionalDic:(NSDictionary *)additionalDic{
    self = [super initWithAdvertiseData:[advertiseData subdataWithRange:NSMakeRange(0, 7)] additionalDic:additionalDic];
    if (self) {
        NSAssert1(!(advertiseData.length != 13), @"Invalid advertiseData:%@", advertiseData);
        self.deviceType = HCKBeaconDeviceTypeWithXYZData;
        NSString *temp = [HCKBeaconParser hexStringFromData:advertiseData];
        self.xData = [temp substringWithRange:NSMakeRange(14, 4)];
        self.yData = [temp substringWithRange:NSMakeRange(18, 4)];
        self.zData = [temp substringWithRange:NSMakeRange(22, 4)];
    }
    return self;
}

@end
