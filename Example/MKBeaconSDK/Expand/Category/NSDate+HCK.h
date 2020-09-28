//
//  NSDate+HCK.h
//  FitPolo
//
//  Created by aa on 17/5/20.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HCK)

/**
 判断两个日期之间的时间间隔(天数)
 
 @param sourceDate 基准日期字符串，yyyy-MM-dd
 @param devDate 比较的日期字符串，yyyy-MM-dd
 @return devDate跟sourceDate之间的间隔
 */
+ (NSInteger)dateIntervalWithSourceDate:(NSString *)sourceDate
                                devDate:(NSString *)devDate;

/**
 根据传入的时间戳生成对应的日期
 
 @param timestamp 时间戳
 @return 日期
 */
+(NSDate *)getDateWithInterval:(long long)timestamp;

/**
 根据日期生成时间戳
 
 @return 时间戳，ms级
 */
-(long long)getTimeIntervalSince1970Millisecond;

/**
 将ms级转换成us级
 
 @param millisecond ms
 @return us
 */
-(long long)getSecondFromMillisecond:(long long)millisecond;

/**
 根据传入的年-月-日来获取未来many天或者是过去many天的日期
 
 @param sourceDateString 源日期，必须是yyyy-MM-dd格式这种格式
 @param many 多少天
 @param next YES:下一天日期，NO:上一天日期
 @return 转换后的日期，yyyy-MM-dd格式
 */
+ (NSString *)getDateString:(NSString *)sourceDateString
                       many:(NSInteger)many
                 lastOrNext:(BOOL)next;

/**
 根据传过来的日期，判断是周几
 
 @param dateString 时间格式必须是yyyy-MM-dd
 @return 返回对应的星期几
 */
+ (NSInteger)getWeekInfoWithDateString:(NSString *)dateString;

/**
 获取dateString所在月的所有日期
 
 @param dateString 目标日期
 @param type 日期类型
 @return 整月包含的日期信息
 */
+ (NSArray *)getMonthBeginAndEndWithDateString:(NSString *)dateString
                                NSCalendarUnit:(NSCalendarUnit)type;

/**
 * @brief 生成当天的某个点（返回的是伦敦时间，可直接与当前时间[NSDate date]比较）
 * @param hour 如hour为“8”，就是上午8:00（本地时间）
 */
+ (NSDate *)getCustomDateWithHour:(NSInteger)hour
                        andMinute:(NSInteger)minute;

/**
 判断当前时间是否在fromHour和toHour之间。如，fromHour=8，toHour=23时，即为判断当前时间是否在8:00-23:00之间
 
 @param fromHour 开始时
 @param fromMin 开始分
 @param toHour 结束时
 @param toMin 结束分
 @return YES当前时间在fromHour和toHour之间，NO不在
 */
+ (BOOL)isBetweenFromHour:(NSInteger)fromHour
               FromMinute:(NSInteger)fromMin
                   toHour:(NSInteger)toHour
                 toMinute:(NSInteger)toMin;

/**
 根据formatter类型比较两个日期
 
 @param date1 date1
 @param date2 date2
 @return -1:date2 > date1,0:date1 = date2,1:date1 > date2
 */
+ (NSInteger )compareDate:(NSDate *)date1
                 withDate:(NSDate *)date2;

@end
