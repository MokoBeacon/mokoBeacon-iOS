//
//  NSString+HCKAdd.m
//  FitPolo
//
//  Created by aa on 17/5/10.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "NSString+HCKAdd.h"
#import <math.h>

@implementation NSString (HCKAdd)

/**
 判断当前string是否是全数字
 
 @return YES:全数字，NO:不是全数字
 */
- (BOOL)isRealNumbers{
    NSString *regex = @"^(0|[1-9][0-9]*)$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:self];
}

/**
 判断当前string是否是全汉字
 
 @return YES:全汉字，NO:不是全汉字
 */
- (BOOL)isChinese{
    if (self.length == 0) return NO;
    NSString *regex = @"[\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:self];
}

/**
 判断当前string是否是全字母
 
 @return YES:全字母，NO:不是全字母
 */
- (BOOL)isLetter{
    if (self.length == 0) return NO;
    NSString *regex =@"[a-zA-Z]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:self];
}

/**
 判断当前string是否全部是数字和字母
 
 @return YES:全部是数字和字母，NO:不是全部是数字和字母
 */
- (BOOL)isLetterOrRealNumbers{
    if (self.length == 0) return NO;
    NSString *regex =@"[a-zA-Z0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:self];
}

/**
 手机上面是否安装了应用,目前能判断的是QQ、微信、WhatsApp、faceBook、TwitterApp、Skype、Snapchat

 @return YES安装，NO未安装
 */
- (BOOL)applicationInstall{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self]]){
        return YES;
    }else{
        return NO;
    }
}

-(BOOL)asciiIsValidate{
    NSInteger strlen = self.length;
    NSInteger datalen = [[self dataUsingEncoding:NSUTF8StringEncoding] length];
    if (strlen != datalen) {
        return NO;
    }
    return YES;
}

/**
 校验输入的字符是否合法，必须是数字或者A、B、C、D、E、F其中的一种
 
 @return NO不合法，YES合法
 */
- (BOOL)checkInputIsHexString{
    if ([self isRealNumbers]) {
        return YES;
    }
    if ([self isEqualToString:@"A"]
        || [self isEqualToString:@"B"]
        || [self isEqualToString:@"C"]
        || [self isEqualToString:@"D"]
        || [self isEqualToString:@"E"]
        || [self isEqualToString:@"F"]) {
        return YES;
    }
    return NO;
}

#pragma mark - ===============类方法====================

+ (CGSize)sizeWithLabel:(UILabel *)label
{
    NSString *text = label.text;
    if (text == nil)
        text = @"字体";
    return [NSString sizeWithText:text andFont:label.font andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
}

+ (CGSize)sizeWithText:(NSString *)text andFont:(UIFont *)font
{
    return [NSString sizeWithText:text andFont:font andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
}

+ (CGSize)sizeWithText:(NSString *)text andFont:(UIFont *)font andMaxSize:(CGSize)maxSize
{
    CGSize expectedLabelSize = CGSizeZero;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    [paragraphStyle setLineSpacing:0];
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    expectedLabelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    
    return CGSizeMake(ceil(expectedLabelSize.width), ceil(expectedLabelSize.height));
}


@end
