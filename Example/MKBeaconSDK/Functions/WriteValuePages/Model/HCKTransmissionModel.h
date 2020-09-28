//
//  HCKTransmissionModel.h
//  HCKBeacon
//
//  Created by aa on 2017/11/2.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBaseDataModel.h"

@interface HCKTransmissionModel : HCKBaseDataModel

@property (nonatomic, copy)NSString *title;

@property (nonatomic, copy)NSString *power;

@property (nonatomic, copy)NSString *radius;

@property (nonatomic, assign)BOOL selected;

@end
