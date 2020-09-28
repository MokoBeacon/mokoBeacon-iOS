//
//  HCKScanDataSource.h
//  HCKBeacon
//
//  Created by aa on 2018/5/8.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import "HCKBaseDataModel.h"

typedef NS_ENUM(NSInteger, dataSourceSortType) {
    dataSourceSortTypeRssi,                 //当前列表按照rssi排序，从大到小
    dataSourceSortTypeMajor,                //当前列表按照主值排序，从大到小
    dataSourceSortTypeMinor,                //当前列表按照次值排序，从大到小
};

typedef NS_ENUM(NSInteger, tableViewReloadFunction) {
    tableViewReloadAllData,         //刷新整个tableView
    tableViewReloadInsertData,      //插入某一行刷新
};

@interface scanHelperDataModel : NSObject

@property (nonatomic, strong)HCKBeaconBaseModel *dataModel;

@property (nonatomic, copy)NSString *identifier;

@property (nonatomic, assign)NSInteger index;

@end

@interface HCKScanDataSource : HCKBaseDataModel

+ (NSArray *)filterDataWithOriList:(NSArray *)oriList sortConditons:(dataSourceSortType)sortType;

+ (void)updateBeaconData:(HCKBeaconBaseModel *)beaconModel
                dataList:(NSMutableArray *)dataList
                sortType:(dataSourceSortType)sortType
         filterCondition:(NSString *)filterCondition
                callback:(void (^)(tableViewReloadFunction reloadFunction, NSInteger section))callback;

@end
