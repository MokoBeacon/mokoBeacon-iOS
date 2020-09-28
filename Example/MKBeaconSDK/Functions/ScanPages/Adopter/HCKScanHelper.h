//
//  HCKScanHelper.h
//  HCKBeacon
//
//  Created by aa on 2018/5/14.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import "HCKBaseDataModel.h"

extern NSString *const sortWithRssi;
extern NSString *const sortWithMajor;
extern NSString *const sortWithMinor;

extern NSString *const filterNameKey;
extern NSString *const sortConditionKey;

@interface HCKScanHelper : HCKBaseDataModel<UITableViewDelegate, UITableViewDataSource>

- (void)startScan;

- (void)stopScan;

- (void)scanHelperReloadDataBlock:(void (^)(BOOL reloadAll, NSInteger section))reloadBlock
                    stopScanBlock:(void (^)(void))stopBlock
               needConnectedBlock:(void (^)(HCKBeaconBaseModel *model))connectedBlock;

- (void)updateSortCondition:(NSDictionary *)sortCondition;

- (void)connectBeaconWithModel:(HCKBeaconBaseModel *)beaconModel target:(UIViewController *)target;

- (void)showOpenBleAlert;

- (NSString *)getCurrentDeviceNumbers;

@end



