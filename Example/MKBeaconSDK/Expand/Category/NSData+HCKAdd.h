//
//  NSData+HCKAdd.h
//  FitPolo
//
//  Created by aa on 17/7/27.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (HCKAdd)

/**
 NSData->uint8_t
 
 @param fData 需要转换的NSData数据
 @return 转换后的uint8_t数据
 */
+ (uint8_t)uint8FromBytes:(NSData *)fData;

/**
 对NSData进行CRC16的校验
 
 @return CRC16校验码
 */
- (NSData *)getCrc16VerifyCode;

@end
