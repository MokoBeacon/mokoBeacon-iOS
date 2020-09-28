/*
    主要处理富文本方面的东西
 */

#import "HCKAttributedStringManager.h"

@implementation HCKAttributedStringManager


/**
 生成相应富文本，注意，strings、fonts、colors三个数组个数必须相等，否则返回nil

 @param strings 要合成富文本的字符串
 @param fonts 字符串大小数组
 @param colors 字符串颜色数组
 @return 生成符合要求的富文本
 */
+ (NSMutableAttributedString *)getAttributedString:(NSArray *)strings
                                             fonts:(NSArray *)fonts
                                            colors:(NSArray *)colors{
    if (!ValidArray(strings)
        || !ValidArray(fonts)
        || !ValidArray(colors)
        || strings.count != fonts.count
        || fonts.count != colors.count) {
        return nil;
    }
    for (id str in strings) {
        if (![str isKindOfClass:[NSString class]]) {
            return nil;
        }
    }
    for (id font in fonts) {
        if (![font isKindOfClass:[UIFont class]]) {
            return nil;
        }
    }
    for (id color in colors) {
        if (![color isKindOfClass:[UIColor class]]) {
            return nil;
        }
    }
    NSString *sourceString = @"";
    for (NSString *str in strings) {
        sourceString = [sourceString stringByAppendingString:str];
    }
    if (!ValidStr(sourceString)) {
        return nil;
    }
    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithString:sourceString];
    CGFloat originPostion = 0;
    for (NSInteger i = 0; i < [strings count]; i ++) {
        NSString *tempString = strings[i];
        //颜色
        [resultString addAttribute:NSForegroundColorAttributeName
                             value:(id)colors[i]
                             range:NSMakeRange(originPostion, tempString.length)];
        //字体大小
        [resultString addAttribute:NSFontAttributeName
                             value:(id)fonts[i]
                             range:NSMakeRange(originPostion, tempString.length)];
        originPostion += tempString.length;
    }
    return resultString;
}



+ (NSAttributedString *)getTextStringWithString:(NSString *)string
                                    valueString:(NSString *)valueString{
    if (!ValidStr(string) || !ValidStr(valueString)) {
        return nil;
    }
    NSAttributedString *attributedString = [HCKAttributedStringManager getAttributedString:@[string,valueString]
                                                                                     fonts:@[HCKFont(15),HCKFont(15)]
                                                                                    colors:@[DEFAULT_TEXT_COLOR,[UIColor redColor]]];
    return attributedString;
}

@end
