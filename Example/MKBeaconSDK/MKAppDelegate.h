//
//  MKAppDelegate.h
//  MKBeaconSDK
//
//  Created by aadyx2007@163.com on 09/28/2020.
//  Copyright (c) 2020 aadyx2007@163.com. All rights reserved.
//

@import UIKit;
#import "HCKBeaconProtocol.h"

extern NSString *const centralManagerStateChangedNotification;
extern NSString *const peripheralConnectStateChangedNotification;

@interface MKAppDelegate : UIResponder <UIApplicationDelegate, HCKCentralStatesChangedDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
