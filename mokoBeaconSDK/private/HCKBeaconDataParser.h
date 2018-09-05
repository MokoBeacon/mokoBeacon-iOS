//
//  HCKBeaconDataParser.h
//  testSDK
//
//  Created by aa on 2018/5/5.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

extern NSString *const HCKBeaconCommunicationDataNum;

@interface HCKBeaconDataParser : NSObject

+ (NSDictionary *)parseReadDataFromCharacteristic:(CBCharacteristic *)characteristic;

+ (NSDictionary *)parseWriteDataFromCharacteristic:(CBCharacteristic *)characteristic;

@end
