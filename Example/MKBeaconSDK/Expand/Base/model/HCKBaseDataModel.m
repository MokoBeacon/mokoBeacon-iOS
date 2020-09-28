//
//  HCKBaseDataModel.m
//  FitPolo
//
//  Created by aa on 17/5/7.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBaseDataModel.h"
#import <objc/runtime.h>

@implementation HCKBaseDataModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self emptyAllValue];
        [self setAttributes:dic];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return [self modelCopy];
}

- (NSUInteger)hash {
    return [self modelHash];
}

- (BOOL)isEqual:(id)object {
    return [self modelIsEqual:object];
}

- (NSString *)description {
    return [self modelDescription];
}

- (void)emptyAllValue{
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);//获取属性名字
        const char * attributes = property_getAttributes(property);//获取属性类型
        NSString *attributesStr = [NSString stringWithCString:attributes
                                                     encoding:NSUTF8StringEncoding];
        NSArray *stringArray = [attributesStr componentsSeparatedByString:@"\""];
        if (stringArray.count>=2) {
            NSString *propertyType = [stringArray objectAtIndex:1];
            if ([propertyType isEqualToString:@"NSString"]) {
                NSString *nameStr = [NSString stringWithCString:name
                                                       encoding:NSUTF8StringEncoding];
                SEL sel = [self getSetterSelWithAttibuteName:nameStr];
                [self performSelectorOnMainThread:sel
                                       withObject:@""
                                    waitUntilDone:[NSThread isMainThread]];
            }
        }
    }
    free(properties);
}

- (NSDictionary *)attributeMapDictionary
{
    return nil;
}

- (void)setAttributes:(NSDictionary *)dataDic
{
    if (!dataDic || [dataDic isKindOfClass:[NSNull class]]) {
        return;
    }
    NSMutableDictionary *attrMapDic = [NSMutableDictionary dictionaryWithCapacity:[dataDic count]];
    for (NSString *key in dataDic) {
        [attrMapDic setObject:key forKey:key];
    }
    [[self attributeMapDictionary] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [attrMapDic setObject:obj forKey:key];
    }];
    
    NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
    id attributeName;
    while ((attributeName = [keyEnum nextObject]))
        {
        SEL sel = [self getSetterSelWithAttibuteName:attributeName];
        if ([self respondsToSelector:sel]) {
            NSString *dataDicKey = [attrMapDic objectForKey:attributeName];
            id attributeValue = [dataDic objectForKey:dataDicKey];
            
            if ([self isType:@"NSString" value:attributeName]) {
                if ([attributeValue isKindOfClass:[NSNumber class]]) {
                    NSString *temp = [attributeValue stringValue];
                    attributeValue = temp;
                }
                else{
                    attributeValue = [self filterWithString:attributeValue];
                }
            }
            else if(![attributeValue isKindOfClass:NSClassFromString([self classOfAttributeName:attributeName])])
                {
                attributeValue = nil;
                }
            [self performSelectorOnMainThread:sel
                                   withObject:attributeValue
                                waitUntilDone:[NSThread isMainThread]];
        }
        }
}

- (NSString *)classOfAttributeName:(id)attributeName
{
    objc_property_t property = class_getProperty([self class], [attributeName UTF8String]);
    const char * attributes = property_getAttributes(property);
    
    NSString *attributesStr = [NSString stringWithCString:attributes
                                                 encoding:NSUTF8StringEncoding];
    
    NSArray *stringArray = [attributesStr componentsSeparatedByString:@"\""];
    if (stringArray.count>=2) {
        return [stringArray objectAtIndex:1];
    }
    return  nil;
}

- (BOOL)isType:(NSString *)type value:(NSString *)propertyName
{
    objc_property_t property = class_getProperty([self class], [propertyName UTF8String]);
    const char * attributes = property_getAttributes(property);
    
    NSString *attributesStr = [NSString stringWithCString:attributes
                                                 encoding:NSUTF8StringEncoding];
    
    NSArray *stringArray = [attributesStr componentsSeparatedByString:@"\""];
    if (stringArray.count>=2) {
        NSString *propertyType = [stringArray objectAtIndex:1];
        if ([propertyType isEqualToString:type]) {
            return YES;
        }
    }
    
    return NO;
}

- (SEL)getSetterSelWithAttibuteName:(NSString *)attributeName
{
    if (![attributeName isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSString *capital = [[attributeName substringToIndex:1] uppercaseString];
    NSString *setterSelStr = [NSString stringWithFormat:@"set%@%@:", capital, [attributeName substringFromIndex:1]];
    return NSSelectorFromString(setterSelStr);
}

- (NSString *)filterWithString:(NSString *)str{
    if ([str isKindOfClass:[NSNull class]]) {
        str = @"";
    }
    else if (str == nil) {
        str = @"";
    }
    else if ([str isEqualToString:@"null"]) {
        str = @"";
    }
    else if ([str isEqualToString:@"(null)"]) {
        str = @"";
    }
    else if ([str isEqualToString:@"<null>"]) {
        str = @"";
    }
    return str;
}

@end
