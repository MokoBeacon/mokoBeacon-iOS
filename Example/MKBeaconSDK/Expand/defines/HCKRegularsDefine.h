/**
 头文件说明：
 1、所有正则表达式字符串宏
 2、所有校验相关的宏定义
 */

#pragma mark - 判断手机号是否合法的正则表达式
//*************************************判断手机号是否合法的正则表达式******************************************************
#define REG_STRING_PHONE                @"^1[34578][0-9]{9}$"
#define REG_STRING_COMMPANY             @"^[a-zA-Z\\(\\（\\)\\）\\_\\.\\,\\-\\－\\&\u4e00-\u9fa5]{2,30}$"
#define REG_STRING_USER_NAME            @"^[a-zA-Z0-9\u4e00-\u9fa5]{2,20}$"
#define REG_STRING_COMMPANY_NAME        @"^[a-zA-Z0-9\u4e00-\u9fa5]{2,30}$"
#define REG_STRING_COMMPANY_ADDRESS     @"^[a-zA-Z0-9\u4E00-\u9FA5]{1,60}$"
#define REG_STRING_BANK_NUM             @"[0-9]{16,19}"
#define REG_STRING_ID                   @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$"
#define REG_STRING_PASSWORD             @"^[0-9]*$"
//*************************************判断手机号是否合法的正则表达式******************************************************


#pragma mark - 字符串、字典、数组等类的验证宏定义
//*************************************字符串、字典、数组等类的验证宏定义******************************************************

#define Str(s) ([s isKindOfClass:[NSNull class]] || s==nil || ![s isKindOfClass:[NSString class]] || [s isEqualToString:@"(null)"] || [s isEqualToString:@"null"] || [s isEqualToString:@"<null>"] ? @"" : s)
#define StrDate(s)          (s==nil ? [NSDate date] : s)
#define StrNull(f)          (f==nil || ![f isKindOfClass:[NSString class]] || ([f isKindOfClass:[NSString class]] && [f isEqualToString:@""]))
#define StrValid(f)         (f!=nil && [f isKindOfClass:[NSString class]] && ![f isEqualToString:@""])
#define SafeStr(f)          (StrValid(Str(f)) ? f:@"")
#define SafeStrByZero(f)        (StrValid(f) ? f : @"0")
#define SafeStrByDefault(f)     (StrValid(f) ? f : @"")
#define SafeStrByDefaultText(f) (StrValid(f) ? f : @"暂无数据")  //2016年08月30日 add by 胡仕君：数据不存在，则显示暂无数据
#define HasString(str,key)  ([str rangeOfString:key].location!=NSNotFound)
#define IdToStr(f)          ([NSString stringWithFormat:@"%@",f]) //将id类型强制转换为字符串，如服务器网络返回的字典数据

#define ValidStr(f)         StrValid(f)
#define ValidDict(f)        (f!=nil && [f isKindOfClass:[NSDictionary class]] && [f count]>0)
#define ValidArray(f)       (f!=nil && [f isKindOfClass:[NSArray class]] && [f count]>0)
#define ValidNum(f)         (f!=nil && [f isKindOfClass:[NSNumber class]])
#define ValidClass(f,cls)   (f!=nil && [f isKindOfClass:[cls class]])
#define ValidData(f)        (f!=nil && [f isKindOfClass:[NSData class]])

#define DataStr(str)        [str dataUsingEncoding:NSUTF8StringEncoding]
#define StrMerge(str1,str2) [NSString stringWithFormat:@"%@%@",str1,str2] //字符串合并
#define StrMergeThree(str1,str2,str3) [NSString stringWithFormat:@"%@%@%@",str1,str2,str3] //字符串合并:3个参数的合并
#define StrMergeFour(str1,str2,str3,str4) [NSString stringWithFormat:@"%@%@%@%@",str1,str2,str3,str4] //字符串合并:4个参数的合并
//*************************************字符串、字典、数组等类的验证宏定义******************************************************

