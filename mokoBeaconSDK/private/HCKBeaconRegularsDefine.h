#pragma mark - 字符串、字典、数组等类的验证宏定义
//*************************************字符串、字典、数组等类的验证宏定义******************************************************

#define HCKBeaconValidStr(f)         (f!=nil && [f isKindOfClass:[NSString class]] && ![f isEqualToString:@""])
#define HCKBeaconValidDict(f)        (f!=nil && [f isKindOfClass:[NSDictionary class]] && [f count]>0)
#define HCKBeaconValidArray(f)       (f!=nil && [f isKindOfClass:[NSArray class]] && [f count]>0)
#define HCKBeaconValidData(f)        (f!=nil && [f isKindOfClass:[NSData class]])

//*************************************字符串、字典、数组等类的验证宏定义******************************************************

//===================弱引用对象=====================================//
#define HCKBeaconWS(weakSelf)          __weak __typeof(&*self)weakSelf = self;

#ifndef iBeacon_main_safe
#define iBeacon_main_safe(block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
    block();\
} else {\
    dispatch_async(dispatch_get_main_queue(), block);\
}
#endif
