//
//  NSData+HCKAdd.m
//  FitPolo
//
//  Created by aa on 17/7/27.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "NSData+HCKAdd.h"

@implementation NSData (HCKAdd)

/**
 NSData->uint8_t
 
 @param fData 需要转换的NSData数据
 @return 转换后的uint8_t数据
 */
+ (uint8_t)uint8FromBytes:(NSData *)fData{
    //    NSAssert(fData.length == 1, @"uint8FromBytes: (data length != 1)");
    NSData *data = fData;
    uint8_t val = 0;
    [data getBytes:&val length:1];
    return val;
}

/**
 对NSData进行CRC16的校验
 
 @return CRC16校验码
 */
- (NSData *)getCrc16VerifyCode{
    if (!ValidData(self)) {
        return nil;
    }
    NSInteger crcWord = 0xffff;
    Byte *dataArray = (Byte *)[self bytes];
    for (NSInteger i = 0; i < self.length; i ++) {
        Byte byte = dataArray[i];
        crcWord ^= (NSInteger)byte & 0x00ff;
        for (NSInteger j = 0; j < 8; j ++) {
            if ((crcWord & 0x0001) == 1) {
                crcWord = crcWord >> 1;
                crcWord = crcWord ^ 0xA001;
            }else{
                crcWord = (crcWord >> 1);
            }
        }
    }
    
    Byte crcL = (Byte)0xff & (crcWord >> 8);
    Byte crcH = (Byte)0xff & (crcWord);
    Byte arrayCrc[] = {crcH, crcL};
    NSData *dataCrc = [NSData dataWithBytes:arrayCrc length:sizeof(arrayCrc)];
    return dataCrc;
}

@end
