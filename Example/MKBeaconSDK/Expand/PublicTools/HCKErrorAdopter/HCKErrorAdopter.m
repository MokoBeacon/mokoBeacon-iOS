//
//  HCKErrorAdopter.m
//  HCKBeacon
//
//  Created by aa on 2018/5/10.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import "HCKErrorAdopter.h"

@implementation HCKErrorAdopter

+ (NSError *)getErrorWithDomain:(NSString *)domain code:(NSInteger)code message:(NSString *)message{
    NSError *error = [[NSError alloc] initWithDomain:SafeStr(domain) code:code userInfo:@{@"errorInfo":SafeStr(message)}];
    return error;
}

+ (NSError *)getConnectError{
    return [self getErrorWithDomain:@"com.moko.readData" code:-999 message:LS(@"HCKHomeDataManager_error")];
}

@end
