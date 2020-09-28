//
//  HCKBaseDataModel.h
//  FitPolo
//
//  Created by aa on 17/5/7.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+YYModel.h"

@interface HCKBaseDataModel : NSObject<NSCopying,NSCoding>

- (instancetype)initWithDictionary:(NSDictionary *)dic;

- (void)setAttributes:(NSDictionary *)dataDic;

- (void)emptyAllValue;

/**
 *  如果属性名与字典中的key不一致时，子类需重写此方法，参照下面写法，userID是你本地定义参数名称，id是服务端返回名称
 */
//- (NSDictionary *)attributeMapDictionary
//{
//    NSDictionary *mapAtt = @{@"userID": @"id",};
//    return mapAtt;
//}
- (NSDictionary *)attributeMapDictionary;

@end
