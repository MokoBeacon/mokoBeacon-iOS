//
//  NSDate+HCK.m
//  FitPolo
//
//  Created by aa on 17/5/20.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "NSDate+HCK.h"
#import "HCKDateFormatter.h"

@implementation NSDate (HCK)

/**
 判断两个日期之间的时间间隔(天数)

 @param sourceDate 基准日期字符串，yyyy-MM-dd
 @param devDate 比较的日期字符串，yyyy-MM-dd
 @return devDate跟sourceDate之间的间隔
 */
+ (NSInteger)dateIntervalWithSourceDate:(NSString *)sourceDate
                                devDate:(NSString *)devDate{
    NSDate *source = [[HCKDateFormatter sharedDateFormatter] dateFromString:sourceDate];
    NSDate *dev = [[HCKDateFormatter sharedDateFormatter] dateFromString:devDate];
    NSTimeInterval time = [source timeIntervalSinceDate:dev];
    return ((NSInteger)time)/(3600*24);
}

/**
 根据传入的时间戳生成对应的日期

 @param timestamp 时间戳
 @return 日期
 */
+(NSDate *)getDateWithInterval:(long long)timestamp{
    return [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
}

/**
 根据日期生成时间戳

 @return 时间戳，ms级
 */
-(long long)getTimeIntervalSince1970Millisecond{
    long long timeInterval = (long long)[self timeIntervalSince1970];
    return timeInterval*1000;
}

/**
 将ms级转换成us级

 @param millisecond ms
 @return us
 */
-(long long)getSecondFromMillisecond:(long long)millisecond{
    return millisecond/1000;
}

/**
 根据传入的年-月-日来获取未来many天或者是过去many天的日期
 
 @param sourceDateString 源日期，必须是yyyy-MM-dd格式这种格式
 @param many 多少天
 @param next YES:下一天日期，NO:上一天日期
 @return 转换后的日期，yyyy-MM-dd格式
 */
+ (NSString *)getDateString:(NSString *)sourceDateString
                       many:(NSInteger)many
                 lastOrNext:(BOOL)next{
    NSString * timeStr = @"";
    NSInteger parameter = 1;
    if (!next) {
        parameter = -1;
    }
    NSTimeInterval time = parameter * many * 24*60*60;//many天
    HCKDateFormatter * dateFormatter = [HCKDateFormatter sharedDateFormatter];
    
    NSDate *lastDate = [dateFormatter dateFromString:sourceDateString];
    NSDate * nextDate = [lastDate dateByAddingTimeInterval:time];
    timeStr = [dateFormatter stringFromDate:nextDate];
    return timeStr;
}

/**
 根据传过来的日期，判断是周几
 
 @param dateString 时间格式必须是yyyy-MM-dd
 @return 返回对应的星期几
 */
+ (NSInteger)getWeekInfoWithDateString:(NSString *)dateString{
    if (!ValidStr(dateString)) {
        return 0;
    }
    NSArray * dateArr = [dateString componentsSeparatedByString:@"-"];
    
    if (!ValidArray(dateArr)
        || dateArr.count != 3) {
        return 0;
    }
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:[dateArr[2] integerValue]];
    [comps setMonth:[dateArr[1] integerValue]];
    [comps setYear:[dateArr[0] integerValue]];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorian dateFromComponents:comps];
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday
                                                       fromDate:date];
    NSInteger weekday = [weekdayComponents weekday];
    NSInteger week = 0;
    switch (weekday) {
        case 1:
            week = 7;
            break;
        case 2:
            week = 1;
            break;
        case 3:
            week = 2;
            break;
        case 4:
            week = 3;
            break;
        case 5:
            week = 4;
            break;
        case 6:
            week = 5;
            break;
        case 7:
            week = 6;
            break;
        default: week = 0;
            break;
    }
    
    return week;
}

/**
 获取dateString所在月的所有日期
 
 @param dateString 目标日期
 @param type 日期类型
 @return 整月包含的日期信息
 */
+ (NSArray *)getMonthBeginAndEndWithDateString:(NSString *)dateString
                                NSCalendarUnit:(NSCalendarUnit)type{
    
    if (!ValidStr(dateString)) {
        return nil;
    }
    
    NSDate *lastDate = [[HCKDateFormatter sharedDateFormatter] dateFromString:dateString];
    
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:type
                          startDate:&beginDate
                           interval:&interval
                            forDate:lastDate];
    //分别修改为 NSDayCalendarUnit NSMonthCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return nil;
    }
    NSString *beginString = [[HCKDateFormatter sharedDateFormatter] stringFromDate:beginDate];
    NSString *endString = [[HCKDateFormatter sharedDateFormatter] stringFromDate:endDate];
    
    
    NSMutableArray * dateArr = [[NSMutableArray alloc] init];
    [dateArr addObject:beginString];
    
    NSInteger tempCount = 0;
    if (type == NSCalendarUnitWeekOfMonth) {
        tempCount = 6;
    }
    else if (type == NSCalendarUnitMonth){
        NSArray * beginDateArr = [beginString componentsSeparatedByString:@"-"];
        NSArray * endDateArr = [endString componentsSeparatedByString:@"-"];
        tempCount = [[endDateArr objectAtIndex:2] integerValue] - [[beginDateArr objectAtIndex:2] integerValue];
    }
    
    for (NSInteger i = 0; i < tempCount; i ++) {
        beginString = [NSDate getDateString:beginString
                                       many:1
                                 lastOrNext:YES];
        [dateArr addObject:beginString];
    }
    
    return [dateArr copy];
    
}

/**
 * @brief 生成当天的某个点（返回的是伦敦时间，可直接与当前时间[NSDate date]比较）
 * @param hour 如hour为“8”，就是上午8:00（本地时间）
 */
+ (NSDate *)getCustomDateWithHour:(NSInteger)hour
                        andMinute:(NSInteger)minute{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSCalendarUnitYear
                        | NSCalendarUnitMonth
                        | NSCalendarUnitDay
                        | NSCalendarUnitWeekday
                        | NSCalendarUnitHour
                        | NSCalendarUnitMinute
                        | NSCalendarUnitSecond;
    
    currentComps = [currentCalendar components:unitFlags
                                      fromDate:currentDate];
    
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    [resultComps setMinute:minute];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [resultCalendar dateFromComponents:resultComps];
}

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
                 toMinute:(NSInteger)toMin{
    NSDate *date8 = [self getCustomDateWithHour:fromHour
                                      andMinute:fromMin];
    NSDate *date23 = [self getCustomDateWithHour:toHour
                                       andMinute:toMin];
    
    NSDate *currentDate = [NSDate date];
    
    if ([currentDate compare:date8]==NSOrderedDescending
        && [currentDate compare:date23]==NSOrderedAscending)
        {
        return YES;
        }
    return NO;
}

/**
 根据formatter类型比较两个日期

 @param date1 date1
 @param date2 date2
 @return -1:date2 > date1,0:date1 = date2,1:date1 > date2
 */
+ (NSInteger )compareDate:(NSDate *)date1
                 withDate:(NSDate *)date2{
    if (![date1 isKindOfClass:[NSDate class]]
        || ![date2 isKindOfClass:[NSDate class]]) {
        return 0;
    }
    
    NSComparisonResult compareResult = [date1 compare:date2];
    if (compareResult == NSOrderedAscending) {
        //date2 > date1
        return -1;
    }else if (compareResult == NSOrderedDescending){
        //date1 > date2
        return 1;
    }else if (compareResult == NSOrderedSame){
        //date1 = date2
        return 0;
    }
    return 0;
}

@end
