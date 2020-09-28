//
//  NSString+HCKAdd.h
//  FitPolo
//
//  Created by aa on 17/5/10.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HCKAdd)

/**
 判断当前string是否是全数字
 
 @return YES:全数字，NO:不是全数字
 */
- (BOOL)isRealNumbers;

/**
 判断当前string是否是全汉字
 
 @return YES:全汉字，NO:不是全汉字
 */
- (BOOL)isChinese;

/**
 判断当前string是否是全字母
 
 @return YES:全字母，NO:不是全字母
 */
- (BOOL)isLetter;

/**
 判断当前string是否全部是数字和字母
 
 @return YES:全部是数字和字母，NO:不是全部是数字和字母
 */
- (BOOL)isLetterOrRealNumbers;

/**
 校验输入的字符是否合法，必须是数字或者A、B、C、D、E、F其中的一种
 
 @return NO不合法，YES合法
 */
- (BOOL)checkInputIsHexString;

/**
 手机上面是否安装了应用,目前能判断的是QQ、微信、WhatsApp、faceBook、TwitterApp、Skype、Snapchat
 
 @return YES安装，NO未安装
 */
- (BOOL)applicationInstall;

/**
 是否包含非ascii字符

 @return result
 */
-(BOOL)asciiIsValidate;

#pragma mark - 类方法
+ (CGSize)sizeWithLabel:(UILabel *)label;

+ (CGSize)sizeWithText:(NSString *)text andFont:(UIFont *)font andMaxSize:(CGSize)maxSize;

@end
