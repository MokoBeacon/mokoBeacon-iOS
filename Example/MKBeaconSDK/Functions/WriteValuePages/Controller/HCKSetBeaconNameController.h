//
//  HCKSetBeaconNameController.h
//  HCKBeacon
//
//  Created by aa on 2017/11/1.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBaseSimpleTextFieldController.h"

@interface HCKSetBeaconNameController : HCKBaseSimpleTextFieldController

/**
 是否支持三轴加速度
 */
@property (nonatomic, assign)BOOL supportXYZData;

@end
