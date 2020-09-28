//
//  HCKConfigPageModel.h
//  HCKBeacon
//
//  Created by aa on 2017/10/31.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBaseDataModel.h"

@interface HCKConfigPageModel : HCKBaseDataModel

@property (nonatomic, copy)NSString *function;

@property (nonatomic, copy)NSString *value;

@property (nonatomic, assign)Class devClass;

/**
 是否可点击
 */
@property (nonatomic, assign)BOOL clickEnable;

@end
