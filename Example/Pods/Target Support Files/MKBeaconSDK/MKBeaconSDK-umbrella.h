#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CBPeripheral+HCKCharacters.h"
#import "HCKBeaconBaseModel.h"
#import "HCKBeaconCentralManager.h"
#import "HCKBeaconConnectTimer.h"
#import "HCKBeaconDataParser.h"
#import "HCKBeaconInterface.h"
#import "HCKBeaconParser.h"
#import "HCKBeaconProtocol.h"
#import "HCKBeaconRegularsDefine.h"
#import "HCKBeaconSDK.h"
#import "HCKBeaconService.h"
#import "HCKBeaconTaskIDDefines.h"
#import "HCKBeaconTaskOperation.h"

FOUNDATION_EXPORT double MKBeaconSDKVersionNumber;
FOUNDATION_EXPORT const unsigned char MKBeaconSDKVersionString[];

