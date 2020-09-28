//
//  HCKScanDataSource.m
//  HCKBeacon
//
//  Created by aa on 2018/5/8.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import "HCKScanDataSource.h"

typedef NS_ENUM(NSInteger, beaconModelCompareResult) {
    beaconModelCompareResultDefault,
    beaconModelCompareResultInsert,
    beaconModelCompareResultAdd,
};

@implementation scanHelperDataModel
@end

@implementation HCKScanDataSource

+ (NSArray *)filterDataWithOriList:(NSArray *)oriList sortConditons:(dataSourceSortType)sortType{
    if (!ValidArray(oriList)) {
        return @[];
    }
    if (sortType == dataSourceSortTypeRssi) {
        //这里类似KVO的读取属性的方法，直接从字符串读取对象属性，注意不要写错
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"rssi" ascending:YES];
        return [oriList sortedArrayUsingDescriptors:@[sortDescriptor]];
    }
    if (sortType == dataSourceSortTypeMajor){
        return [oriList sortedArrayUsingComparator:^NSComparisonResult(HCKBeaconBaseModel *model1, HCKBeaconBaseModel *model2){
            return [@([model2.major integerValue]) compare:@([model1.major integerValue])];
        }];
        
    }
    if (sortType == dataSourceSortTypeMinor){
        return [oriList sortedArrayUsingComparator:^NSComparisonResult(HCKBeaconBaseModel *model1, HCKBeaconBaseModel *model2){
            return [@([model2.minor integerValue]) compare:@([model1.minor integerValue])];
        }];
    }
    return @[];
}

+ (void)updateBeaconData:(HCKBeaconBaseModel *)beaconModel
                dataList:(NSMutableArray *)dataList
                sortType:(dataSourceSortType)sortType
         filterCondition:(NSString *)filterCondition
                callback:(void (^)(tableViewReloadFunction reloadFunction, NSInteger section))callback{
    if (!beaconModel || !dataList) {
        return;
    }
    if (ValidStr(filterCondition)) {
        //如果有需要过滤的名字
        if (![beaconModel.peripheralName containsString:filterCondition]) {
            return;
        }
    }
    if (dataList.count == 0) {
        //没有数据，直接添加
        [dataList addObject:beaconModel];
        dispatch_main_async_safe(^{
            if (callback) {
                callback(tableViewReloadAllData,0);
            }
        });
        return;
    }
    BOOL contains = NO;
    NSMutableArray *tempList = [dataList mutableCopy];
    for (NSInteger i = 0; i < tempList.count; i ++) {
        HCKBeaconBaseModel *existModel = tempList[i];
        if (existModel.peripheral == beaconModel.peripheral) {
            //存在
            contains = YES;
            [dataList replaceObjectAtIndex:i withObject:beaconModel];
        }
    }
    if (contains) {
        //
        NSArray *sortList = [self filterDataWithOriList:dataList sortConditons:sortType];
        [dataList removeAllObjects];
        [dataList addObjectsFromArray:sortList];
        dispatch_main_async_safe(^{
            if (callback) {
                callback(tableViewReloadAllData,0);
            }
        });
        return;
    }
    //需要添加到数组
    //先与最大值和最小值作比较，如果不在该范围，则选择插入首部或者尾部,如果在该范围则需要遍历数组进行判断插入位置
    HCKBeaconBaseModel *maxModel = [tempList firstObject];
    HCKBeaconBaseModel *minModel = [tempList lastObject];
    beaconModelCompareResult result = beaconModelCompareResultDefault;
    if (sortType == dataSourceSortTypeRssi && [beaconModel.rssi integerValue] >= [maxModel.rssi integerValue]) {
        //rssi排序
        result = beaconModelCompareResultInsert;
    }else if (sortType == dataSourceSortTypeRssi && [beaconModel.rssi integerValue] <= [minModel.rssi integerValue]){
        //插入尾部
        result = beaconModelCompareResultAdd;
    }else if (sortType == dataSourceSortTypeMajor && [beaconModel.major integerValue] >= [maxModel.major integerValue]){
        //major排序
        //直接插入首部
        result = beaconModelCompareResultInsert;
    }else if (sortType == dataSourceSortTypeMajor && [beaconModel.major integerValue] <= [minModel.major integerValue]){
        //插入尾部
        result = beaconModelCompareResultAdd;
    }else if (sortType == dataSourceSortTypeMinor && [beaconModel.minor integerValue] >= [maxModel.minor integerValue]){
        //minor排序
        result = beaconModelCompareResultInsert;
    }else if (sortType == dataSourceSortTypeMinor && [beaconModel.minor integerValue] <= [minModel.minor integerValue]){
        //插入尾部
        result = beaconModelCompareResultAdd;
    }
    
    if (result == beaconModelCompareResultInsert) {
        //直接插入首部
        [dataList insertObject:beaconModel atIndex:0];
        dispatch_main_async_safe(^{
            if (callback) {
                callback(tableViewReloadInsertData,0);
            }
        });
        return;
    }else if (result == beaconModelCompareResultAdd){
        //添加到尾部
        [dataList addObject:beaconModel];
        dispatch_main_async_safe(^{
            if (callback) {
                callback(tableViewReloadAllData,0);
            }
        });
        return;
    }
    
    for (NSInteger i = 0; i < tempList.count; i ++) {
        HCKBeaconBaseModel *existModel = tempList[i];
        BOOL needInsert = NO;
        if (sortType == dataSourceSortTypeRssi && [existModel.rssi integerValue] < [beaconModel.rssi integerValue]) {
            needInsert = YES;
        }else if (sortType == dataSourceSortTypeMajor && [existModel.major integerValue] < [beaconModel.major integerValue]){
            needInsert = YES;
        }else if (sortType == dataSourceSortTypeMinor && [existModel.minor integerValue] < [beaconModel.minor integerValue]){
            needInsert = YES;
        }
        if (needInsert) {
            [dataList insertObject:beaconModel atIndex:i];
            dispatch_main_async_safe(^{
                if (callback) {
                    callback(tableViewReloadInsertData,i);
                }
            });
            return;
        }
    }
}

@end
