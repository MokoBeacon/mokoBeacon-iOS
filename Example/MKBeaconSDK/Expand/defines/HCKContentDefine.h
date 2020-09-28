//
//  HCKContentDefine.h
//  FitPolo
//
//  Created by aa on 17/5/7.
//  Copyright © 2017年 HCK. All rights reserved.
//

/**
 头文件说明：
 1、常用方法声明
 */

#pragma mark - **************************  字体相关  *********************************
#define HCKBoldFont(a)                  [UIFont boldSystemFontOfSize:a]
#define HCKFont(a)                      [UIFont systemFontOfSize:a]

#pragma mark - **************************  国际化相关  *********************************
#define LS(a)                           NSLocalizedString(a, nil)

//线的高度
#define CUTTING_LINE_HEIGHT             ([[UIScreen mainScreen] scale] == 2.f ? 0.5 : 0.34)

#pragma mark - ************************** 图片加载 *********************************
//图片的宏定义
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%@",file,iPhone6Plus ? @"@3x" : @"@2x"] ofType:ext]]

#define LoadImageByName(imgName)  [UIImage imageNamed:imgName] //加载图片

#pragma mark -

#if (!defined(DEBUG) && !defined (SD_VERBOSE)) || defined(SD_LOG_NONE)
#define NSLog(...)
#endif

// 当在debug模式时打印详细日志，在release模式时不打印详细日志
#ifdef DEBUG
# define DLog(format, ...) NSLog((@"[文件名:%s]" "[函数名:%s]" "[行号:%d]" format), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define DLog(...);
#endif



//获取系统时间戳
#define  kSystemTimeStamp [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]


//将NSInteger转换成相应的NSString
#define stringFromInteger(value) [NSString stringWithFormat:@"%ld",(long)value]

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
    block();\
} else {\
    dispatch_async(dispatch_get_main_queue(), block);\
}


