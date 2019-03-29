//
//  HCKBeaconParser.m
//  testSDK
//
//  Created by aa on 2018/5/3.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import "HCKBeaconParser.h"
#import "HCKBeaconRegularsDefine.h"
#import "HCKBeaconService.h"
#import "HCKBeaconBaseModel.h"

NSString * const HCKCustomErrorDomain = @"com.moko.iBeaconBluetoothSDK";

@implementation HCKBeaconParser

#pragma mark - blocks
+ (NSError *)getErrorWithCode:(HCKBeaconCustomErrorCode)code message:(NSString *)message{
    NSError *error = [[NSError alloc] initWithDomain:HCKCustomErrorDomain code:code userInfo:@{@"errorInfo":message}];
    return error;
}

+ (void)operationParametersErrorBlock:(void (^)(NSError *))block{
    iBeacon_main_safe(^{
        if (block) {
            block([self getErrorWithCode:HCKBeaconParamsError message:@"input parameter error"]);
        }
    });
}

+ (void)operationCentralBlePowerOffErrorBlock:(void (^)(NSError *))block{
    iBeacon_main_safe(^{
        if (block) {
            block([self getErrorWithCode:HCKBeaconBlueDisable message:@"mobile phone bluetooth is currently unavailable"]);
        }
    });
}

+ (void)operationPasswordErrorBlock:(void (^)(NSError *))block{
    iBeacon_main_safe(^{
        if (block) {
            block([self getErrorWithCode:HCKBeaconPasswordError message:@"password error"]);
        }
    });
}

+ (void)operationDisconnectErrorBlock:(void (^)(NSError *))block{
    iBeacon_main_safe(^{
        if (block) {
            block([self getErrorWithCode:HCKBeaconPeripheralDisconnected
                                 message:@"The current connection device is in disconnect"]);
        }
    });
}

+ (void)operationCharacterErrorBlock:(void (^)(NSError *))block{
    iBeacon_main_safe(^{
        if (block) {
            block([self getErrorWithCode:HCKBeaconCharacteristicError message:@"characteristic error"]);
        }
    });
}

+ (void)operationRequestDataErrorBlock:(void (^)(NSError *))block{
    iBeacon_main_safe(^{
        if (block) {
            block([self getErrorWithCode:HCKBeaconRequestPeripheralDataError message:@"Request iBeacon data error"]);
        }
    });
}

+ (void)operationConnectDeviceFailedBlock:(void (^)(NSError *))block{
    iBeacon_main_safe(^{
        if (block) {
            block([self getErrorWithCode:HCKBeaconConnectedFailed message:@"Connected Failed"]);
        }
    });
}

+ (void)operationConnectDeviceSuccessBlock:(void (^)(CBPeripheral *))block peripheral:(CBPeripheral *)peripheral{
    iBeacon_main_safe(^{
        if (block) {
            block(peripheral);
        }
    });
}

+ (void)operationDeviceTypeErrorBlock:(void (^)(NSError *))block{
    iBeacon_main_safe(^{
        if (block) {
            block([self getErrorWithCode:HCKBeaconParamsError message:@"The current device does not support this command"]);
        }
    });
}

#pragma mark - parser

+ (NSInteger)getDecimalWithHex:(NSString *)content range:(NSRange)range{
    if (!HCKBeaconValidStr(content)) {
        return 0;
    }
    if (range.location > content.length - 1 || range.length > content.length || (range.location + range.length > content.length)) {
        return 0;
    }
    return strtoul([[content substringWithRange:range] UTF8String],0,16);
}
+ (NSString *)getDecimalStringWithHex:(NSString *)content range:(NSRange)range{
    if (!HCKBeaconValidStr(content)) {
        return @"";
    }
    if (range.location > content.length - 1 || range.length > content.length || (range.location + range.length > content.length)) {
        return @"";
    }
    NSInteger decimalValue = strtoul([[content substringWithRange:range] UTF8String],0,16);
    return [NSString stringWithFormat:@"%ld",(long)decimalValue];
}

+ (NSData *)stringToData:(NSString *)dataString{
    if (!HCKBeaconValidStr(dataString)) {
        return nil;
    }
    if (!(dataString.length % 2 == 0)) {
        //必须是偶数个字符才是合法的
        return nil;
    }
    Byte bytes[255] = {0};
    NSInteger count = 0;
    for (int i =0; i < dataString.length; i+=2) {
        NSString *strByte = [dataString substringWithRange:NSMakeRange(i,2)];
        unsigned long red = strtoul([strByte UTF8String],0,16);
        Byte b =  (Byte) ((0xff & red) );//( Byte) 0xff&iByte;
        bytes[i/2+0] = b;
        count ++;
    }
    NSData * data = [NSData dataWithBytes:bytes length:count];
    return data;
}

+ (NSString *)hexStringFromData:(NSData *)sourceData{
    if (!HCKBeaconValidData(sourceData)) {
        return nil;
    }
    Byte *bytes = (Byte *)[sourceData bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[sourceData length];i++){
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

+ (BOOL)realNumbers:(NSString *)content{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^(0|[1-9][0-9]*)$"];
    return [pred evaluateWithObject:content];
}

+ (BOOL)isPassword:(NSString *)content{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[a-zA-Z0-9]{8}$"];
    return [pred evaluateWithObject:content];
}

+ (BOOL)isBeaconName:(NSString *)content{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[a-zA-Z0-9_]+$"];
    return [pred evaluateWithObject:content];
}

+ (BOOL)asciiString:(NSString *)content {
    NSInteger strlen = content.length;
    NSInteger datalen = [[content dataUsingEncoding:NSUTF8StringEncoding] length];
    if (strlen != datalen) {
        return NO;
    }
    return YES;
}

+ (BOOL)isUUIDString:(NSString *)uuid{
    if (!HCKBeaconValidStr(uuid)) {
        return NO;
    }
    NSString *uuidPatternString = @"^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:uuidPatternString
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSInteger numberOfMatches = [regex numberOfMatchesInString:uuid
                                                       options:kNilOptions
                                                         range:NSMakeRange(0, uuid.length)];
    return (numberOfMatches > 0);
}

/**
 判断字符串是否是16进制数据
 
 @return YES:字符串是16进制数据，NO:不是
 */
+ (BOOL)isHexString:(NSString *)content{
    if (!HCKBeaconValidStr(content) || content.length != 2) {
        return NO;
    }
    NSString *lowSourceString = [content lowercaseString];
    NSArray *hexInfoArray = @[@"a",@"b",@"c",@"d",@"e",@"f"];
    NSString *highString = [lowSourceString substringWithRange:NSMakeRange(0, 1)];
    NSString *lowString = [lowSourceString substringWithRange:NSMakeRange(1, 1)];
    BOOL highHexFlag = NO;
    if ([self realNumbers:highString] || [hexInfoArray containsObject:highString]) {
        highHexFlag = YES;
    }
    if (!highHexFlag) {
        return NO;
    }
    BOOL lowHexFlag = NO;
    if ([self realNumbers:lowString] || [hexInfoArray containsObject:lowString]) {
        lowHexFlag = YES;
    }
    if (highHexFlag && lowHexFlag) {
        return YES;
    }
    return NO;
}

+ (BOOL)isThreeAxisAccelerationData:(CBCharacteristic *)characteristic{
    if (!characteristic) {
        return NO;
    }
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconElapsedTime]]) {
        return NO;
    }
    NSData *readData = characteristic.value;
    if (!HCKBeaconValidData(readData) || readData.length != 10) {
        return NO;
    }
    NSData *subData = [readData subdataWithRange:NSMakeRange(0, 2)];
    return [subData isEqualToData:[self stringToData:@"eb6c"]];
}

+ (NSDictionary *)getThreeAxisAccelerationData:(CBCharacteristic *)characteristic{
    if (!characteristic) {
        return @{};
    }
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconElapsedTime]]) {
        return @{};
    }
    NSData *readData = characteristic.value;
    if (!HCKBeaconValidData(readData) || readData.length != 10) {
        return @{};
    }
    NSData *xData = [readData subdataWithRange:NSMakeRange(4, 2)];
    NSData *yData = [readData subdataWithRange:NSMakeRange(6, 2)];
    NSData *zData = [readData subdataWithRange:NSMakeRange(8, 2)];
    return @{
             @"x":[self hexStringFromData:xData],
             @"y":[self hexStringFromData:yData],
             @"z":[self hexStringFromData:zData],
             };
}

+ (BOOL)getiBeaconConnectable:(NSString *)content{
    if (!HCKBeaconValidStr(content)) {
        return NO;
    }
    NSString *conn = [self getBinaryByhex:content];
    if (!HCKBeaconValidStr(conn)) {
        return NO;
    }
    return [[conn substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"1"];
}

+ (NSString *)calcDistByRSSI:(int)rssi measurePower:(NSInteger)measurePower{
    int iRssi = abs(rssi);
    float power = (iRssi - measurePower) / (10 * 2.0);
    return [NSString stringWithFormat:@"%.2fm",pow(10, power)];
}

+ (NSString *)getHexStringWithLength:(NSInteger)len origString:(NSString *)oriString{
    if (!HCKBeaconValidStr(oriString)) {
        return @"";
    }
    if (len <= oriString.length) {
        return oriString;
    }
    NSString *string = oriString;
    for (NSInteger i = 0; i < len - oriString.length; i ++) {
        string = [@"0" stringByAppendingString:string];
    }
    return string;
}

+ (HCKBeaconBaseModel *)getiBeaconScanModelWithAdvDic:(NSDictionary *)advertisementData rssi:(NSInteger)rssi{
    if (!HCKBeaconValidDict(advertisementData) || rssi == 127) {
        return nil;
    }
    NSDictionary *advDic = advertisementData[CBAdvertisementDataServiceDataKey];
    //通用的和带三轴加速度广播数据不能并存
    NSData *normalData = advDic[[CBUUID UUIDWithString:normalScanService]];
    NSDictionary *additionalDic = @{
                                    @"peripheralName":[self safeString:advertisementData[CBAdvertisementDataLocalNameKey]],
                                    @"txPower":[NSString stringWithFormat:@"%ld",(long)[advertisementData[CBAdvertisementDataTxPowerLevelKey] integerValue]],
                                    @"rssi":@(rssi),
                                    };
    if (HCKBeaconValidData(normalData) && normalData.length == 7) {
        //通用设备
        return [[HCKBeaconBaseModel alloc] initWithAdvertiseData:normalData additionalDic:additionalDic];
    }
    NSData *xyzData = advDic[[CBUUID UUIDWithString:xyzDataScanService]];
    if (HCKBeaconValidData(xyzData) && xyzData.length == 13) {
        //带三轴设备
        return [[HCKXYZBeaconModel alloc] initWithAdvertiseData:xyzData additionalDic:additionalDic];
    }
    return nil;
}

#pragma mark - Private method
/**
 将一个字节的16进制数据转成8位2进制
 
 @param hex 需要转换的16进制数据
 @return 转换后的8位2进制数据
 */
+ (NSString *)getBinaryByhex:(NSString *)hex{
    if (!HCKBeaconValidStr(hex) || hex.length != 2 || ![self isHexString:hex]) {
        return @"";
    }
    NSDictionary *hexDic = @{
                             @"0":@"0000",@"1":@"0001",@"2":@"0010",
                             @"3":@"0011",@"4":@"0100",@"5":@"0101",
                             @"6":@"0110",@"7":@"0111",@"8":@"1000",
                             @"9":@"1001",@"A":@"1010",@"a":@"1010",
                             @"B":@"1011",@"b":@"1011",@"C":@"1100",
                             @"c":@"1100",@"D":@"1101",@"d":@"1101",
                             @"E":@"1110",@"e":@"1110",@"F":@"1111",
                             @"f":@"1111",
                             };
    NSString *binaryString = @"";
    for (int i=0; i<[hex length]; i++) {
        NSRange rage;
        rage.length = 1;
        rage.location = i;
        NSString *key = [hex substringWithRange:rage];
        binaryString = [NSString stringWithFormat:@"%@%@",binaryString,
                        [NSString stringWithFormat:@"%@",[hexDic objectForKey:key]]];
        
    }
    
    return binaryString;
}

+ (NSString *)safeString:(NSString *)string{
    if (!HCKBeaconValidStr(string)) {
        return @"";
    }
    return string;
}


@end
