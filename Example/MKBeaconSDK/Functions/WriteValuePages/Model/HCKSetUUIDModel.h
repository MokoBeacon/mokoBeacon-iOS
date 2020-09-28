//
//  HCKSetUUIDModel.h
//  HCKBeacon
//
//  Created by aa on 2017/11/1.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBaseDataModel.h"

@interface HCKSetUUIDModel : HCKBaseDataModel

@property (nonatomic, copy)NSString *titleString;

@property (nonatomic, copy)NSString *uuid;

@property (nonatomic, assign)BOOL selected;

@end
