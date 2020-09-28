//
//  HCKScanAlertAction.h
//  HCKBeacon
//
//  Created by aa on 2018/5/9.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import "HCKBaseDataModel.h"

@interface HCKScanAlertAction : HCKBaseDataModel

@property (nonatomic, copy)NSString *localPassword;

- (void)showOpenBleAlert;

- (void)showPasswordAlertTarget:(UIViewController *)targetVC completeCallback:(void (^)(NSString *password))callback;

@end
