//
//  HCKBeaconConnectTimer.h
//  testSDK
//
//  Created by aa on 2018/5/4.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCKBeaconConnectTimer : NSObject

- (instancetype)initWithTimeout:(NSTimeInterval)timeout timeoutCallback:(void (^)(void))callback;

- (void)resume;

- (void)cancel;

@end
