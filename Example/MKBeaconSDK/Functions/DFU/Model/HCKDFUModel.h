//
//  HCKDFUModel.h
//  HCKBeacon
//
//  Created by aa on 2018/5/2.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import "HCKBaseDataModel.h"

@interface HCKDFUModel : HCKBaseDataModel

/**
 dfu升级
 
 @param url 固件url
 @param progressBlock 升级进度
 @param sucBlock 升级成功回调
 @param failedBlock 升级失败回调
 */
- (void)dfuUpdateWithFileUrl:(NSString *)url
               progressBlock:(void (^)(CGFloat progress))progressBlock
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

@end
