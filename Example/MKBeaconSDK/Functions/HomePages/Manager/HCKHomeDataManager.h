//
//  HCKHomeDataManager.h
//  HCKBeacon
//
//  Created by aa on 2017/10/31.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBaseDataModel.h"

typedef void(^readBeaconDatasCompleteBlock)(void);
typedef void(^readBeaconDatasFailedBlock)(NSError *error);

@interface HCKHomeDataManager : HCKBaseDataModel

/**
 开启读取数据流程
 
 @param completeBlock 成功回调
 @param failedBlock 失败回调
 */
- (void)startReadDataWithCompleteBlock:(readBeaconDatasCompleteBlock)completeBlock
                           failedBlock:(readBeaconDatasFailedBlock)failedBlock;

@end
