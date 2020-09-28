//
//  HCKErrorAdopter.h
//  HCKBeacon
//
//  Created by aa on 2018/5/10.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCKErrorAdopter : NSObject

+ (NSError *)getErrorWithDomain:(NSString *)domain code:(NSInteger)code message:(NSString *)message;

+ (NSError *)getConnectError;

@end
