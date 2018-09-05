//
//  HCKBeaconConnectTimer.m
//  testSDK
//
//  Created by aa on 2018/5/4.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import "HCKBeaconConnectTimer.h"
#import "HCKBeaconRegularsDefine.h"

@interface HCKBeaconConnectTimer()

/**
 连接定时器，超过指定时间将会视为连接失败
 */
@property (nonatomic, strong)dispatch_source_t connectTimer;

@end

@implementation HCKBeaconConnectTimer

- (void)dealloc{
    NSLog(@"HCKBeaconConnectTimer销毁");
}

- (instancetype)initWithTimeout:(NSTimeInterval)timeout timeoutCallback:(void (^)(void))callback{
    self = [super init];
    if (self) {
        [self initConnectTimer:timeout timeoutCallback:callback];
    }
    return self;
}

#pragma mark - Public method
- (void)resume{
    if (!self.connectTimer) {
        return;
    }
    dispatch_resume(self.connectTimer);
}

- (void)cancel{
    if (!self.connectTimer) {
        return;
    }
    dispatch_cancel(self.connectTimer);
}

#pragma mark - Private method
- (void)initConnectTimer:(NSTimeInterval)timeout timeoutCallback:(void (^)(void))callback{
    dispatch_queue_t connectQueue = dispatch_queue_create("connectPeripheralQueue", DISPATCH_QUEUE_CONCURRENT);
    self.connectTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,connectQueue);
    //开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 20 * NSEC_PER_SEC);
    //间隔时间
    uint64_t interval = 20 * NSEC_PER_SEC;
    dispatch_source_set_timer(self.connectTimer, start, interval, 0);
    HCKBeaconWS(weakSelf);
    dispatch_source_set_event_handler(self.connectTimer, ^{
        [weakSelf cancel];
        if (callback) {
            callback();
        }
    });
}

@end
