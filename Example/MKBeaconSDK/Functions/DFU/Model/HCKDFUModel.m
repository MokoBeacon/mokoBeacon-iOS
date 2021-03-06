//
//  HCKDFUModel.m
//
//
//  Created by aa on 2018/5/2.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import "HCKDFUModel.h"
@import iOSDFULibrary;

static NSString *const dfuUpdateDomain = @"com.moko.dfuUpdateDomain";

@interface HCKDFUModel()<LoggerDelegate, DFUServiceDelegate, DFUProgressDelegate>

@property (nonatomic, copy)void (^updateProgressBlock)(CGFloat progress);

@property (nonatomic, copy)void (^updateSucBlock)(void);

@property (nonatomic, copy)void (^updateFailedBlock)(NSError *error);

@property (nonatomic, strong)DFUServiceController *dfuController;

@end

@implementation HCKDFUModel

- (void)dealloc{
    NSLog(@"DFUmodel销毁");
}

#pragma mark - DFUServiceDelegate

/**
 dfu升级,目前正常升级可以，异常情况存在bug，官方提供的sdk会存在无法销毁的情况
 
 @param url 固件url
 @param progressBlock 升级进度
 @param sucBlock 升级成功回调
 @param failedBlock 升级失败回调
 */
- (void)dfuUpdateWithFileUrl:(NSString *)url
               progressBlock:(void (^)(CGFloat progress))progressBlock
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock{
    if (!ValidStr(url)) {
        dispatch_main_async_safe(^{
            if (failedBlock) {
                NSError *error = [[NSError alloc] initWithDomain:dfuUpdateDomain
                                                            code:-999
                                                        userInfo:@{@"errorInfo":@"The url is invalid"}];
                failedBlock(error);
            }
        });
        return;
    }
    self.updateProgressBlock = nil;
    self.updateProgressBlock = progressBlock;
    self.updateSucBlock = nil;
    self.updateSucBlock = sucBlock;
    self.updateFailedBlock = nil;
    self.updateFailedBlock = failedBlock;
    NSURL *fileURL = [[NSURL alloc] initWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    if (!fileURL) {
        [self updateFailed:@"URL error"];
        return;
    }
    DFUFirmware *selectedFirmware = [[DFUFirmware alloc] initWithUrlToZipFile:fileURL];// or
    //Use the DFUServiceInitializer to initialize the DFU process.
    if (!selectedFirmware) {
        [self updateFailed:@"Firmware error"];
        return;
    }
    //Use the DFUServiceInitializer to initialize the DFU process.
    DFUServiceInitiator *initiator = [[DFUServiceInitiator alloc] initWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) progressQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) loggerQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    initiator = [initiator withFirmware:selectedFirmware];
    // Optional:
    // initiator.forceDfu = YES/NO; // default NO
    // initiator.packetReceiptNotificationParameter = N; // default is 12
    initiator.logger = self; // - to get log info
    initiator.delegate = self; // - to be informed about current state and errors
    initiator.progressDelegate = self; // - to show progress bar
    // initiator.peripheralSelector = ... // the default selector is used
    //    self.dfuController = [[initiator withFirmware:selectedFirmware] startWithTarget:[MKBeaconCentralManager sharedInstance].peripheral];
    self.dfuController = [initiator startWithTarget:[HCKBeaconCentralManager sharedInstance].peripheral];
}

- (void)dfuStateDidChangeTo:(enum DFUState)state{
    NSLog(@"DFUState state%ld",state);
    //升级完成
    if (state==DFUStateCompleted) {
        dispatch_main_async_safe(^{
            if (self.updateSucBlock) {
                self.updateSucBlock();
            }
        });
    }
    if (state == DFUStateUploading) {
        [HCKBeaconCentralManager attempDealloc];
    }
}

- (void)dfuError:(enum DFUError)error didOccurWithMessage:(NSString *)message{
    [self updateFailed:message];
    NSLog(@"Error %ld: %@", (long) error, message);
}

#pragma mark - DFUProgressDelegate
- (void)dfuProgressDidChangeFor:(NSInteger)part outOf:(NSInteger)totalParts to:(NSInteger)progress currentSpeedBytesPerSecond:(double)currentSpeedBytesPerSecond avgSpeedBytesPerSecond:(double)avgSpeedBytesPerSecond{
    float currentProgress = (float) progress /totalParts;
    dispatch_main_async_safe(^{
        if (self.updateProgressBlock) {
            self.updateProgressBlock(currentProgress);
        }
    });
}

#pragma mark - LoggerDelegate
- (void)logWith:(enum LogLevel)level message:(NSString *)message{
    NSLog(@"%logWith ld: %@", (long) level, message);
}

#pragma mark -
- (void)updateFailed:(NSString *)msg{
    dispatch_main_async_safe(^{
        if (self.updateFailedBlock) {
            self.updateFailedBlock([HCKErrorAdopter getErrorWithDomain:dfuUpdateDomain code:-999 message:msg]);
        }
    });
}

@end

