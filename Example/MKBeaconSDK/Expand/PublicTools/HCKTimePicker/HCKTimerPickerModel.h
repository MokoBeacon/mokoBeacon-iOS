//
//  HCKTimerPickerModel.h
//  FitPolo
//
//  Created by aa on 17/6/12.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBaseDataModel.h"

@interface HCKTimerPickerModel : HCKBaseDataModel

/**
 要展示的时间格式
 */
@property (nonatomic, copy)NSString *dateFormat;

/**
 时间选择器当前显示的时间,格式必须跟dateFormat一致，否则出错
 */
@property (nonatomic, copy)NSString *time;

/**
 时间选择器的类型
 */
@property (nonatomic, assign)UIDatePickerMode datePickerMode;

/**
 日期选择器最小的日期，yyyy-MM-dd
 */
@property (nonatomic, copy)NSString *maxTime;

/**
 日期选择器最大的日期,yyyy-MM-dd
 */
@property (nonatomic, copy)NSString *minTime;

@end
