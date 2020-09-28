//
//  HCKDateFormatter.m
//  FitPolo
//
//  Created by aa on 17/5/17.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKDateFormatter.h"

static HCKDateFormatter *dateManager = nil;

@implementation HCKDateFormatter

+ (HCKDateFormatter *)sharedDateFormatter
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        dateManager = [[HCKDateFormatter alloc] init];
        [dateManager setDateFormat:@"yyyy-MM-dd"];
    });
    return dateManager;
}

@end
