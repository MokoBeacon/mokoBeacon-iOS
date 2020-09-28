//
//  HCKSetBeaconValueViewController.h
//  HCKBeacon
//
//  Created by aa on 2017/11/2.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKFucBaseController.h"

typedef NS_ENUM(NSInteger, HCKSetValueType) {
    HCKSetMajorValue,       //设置major
    HCKSetMinorValue,       //设置minor
};

@interface HCKSetBeaconValueViewController : HCKFucBaseController

@property (nonatomic, assign)HCKSetValueType valueType;

@end
