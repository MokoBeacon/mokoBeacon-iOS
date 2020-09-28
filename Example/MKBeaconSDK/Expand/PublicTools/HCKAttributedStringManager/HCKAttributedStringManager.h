//
//  HCKAttributedStringManager.h
//  FitPolo
//
//  Created by aa on 17/5/17.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCKAttributedStringManager : NSObject

/**
 生成相应富文本，注意，strings、fonts、colors三个数组个数必须相等，否则返回nil
 
 @param strings 要合成富文本的字符串
 @param fonts 字符串大小数组
 @param colors 字符串颜色数组
 @return 生成符合要求的富文本
 */
+ (NSMutableAttributedString *)getAttributedString:(NSArray *)strings
                                             fonts:(NSArray *)fonts
                                            colors:(NSArray *)colors;

+ (NSAttributedString *)getTextStringWithString:(NSString *)string
                                    valueString:(NSString *)valueString;

@end
