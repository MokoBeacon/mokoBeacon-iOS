//
//  HCKNomalBlockDefines.h
//  FitPolo
//
//  Created by aa on 17/5/8.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


#define HCKDispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
    block();\
} else {\
    dispatch_async(dispatch_get_main_queue(), block);\
}

/**
 cell点击事件block，需要知道cell的选中状态时候用的block
 
 @param path 被点击cell的NSIndexPath
 @param selected 是否被选中，YES选中，NO取消选中
 */
typedef void(^HCKBaseCellSelectedBlock)(NSIndexPath *path, BOOL selected);

/**
 cell点击事件block，不需要知道选中状态

 @param path 被点击cell的NSIndexPath
 */
typedef void(^HCKBaseCellSelectedWithNoStateBlock)(NSIndexPath *path);

/**
 操作数据库成功Block
 */
typedef void(^operationSuccessBlock)(void);

/**
 操作数据库失败Block

 @param error 错误内容
 */
typedef void(^operationFailedBlock)(NSError *error);

/**
 从数据库里面读取数据成功Block

 @param returnData 读回来的数据
 */
typedef void(^readDataFromDatabaseSuccessBlock)(id returnData);

/**
 从数据库里面读取数据失败Block

 @param error 错误详情
 */
typedef void(^readDataFromDatabaseFailedBlock)(NSError *error);

