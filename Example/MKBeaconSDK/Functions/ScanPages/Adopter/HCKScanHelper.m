//
//  HCKScanHelper.m
//  HCKBeacon
//
//  Created by aa on 2018/5/14.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import "HCKScanHelper.h"
#import "HCKBeaconScanCell.h"
#import "HCKScanDataSource.h"
#import "HCKScanAlertAction.h"
#import "HCKConfigurationPageController.h"

NSString *const sortWithRssi = @"sortWithRssi";
NSString *const sortWithMajor = @"sortWithMajor";
NSString *const sortWithMinor = @"sortWithMinor";

NSString *const filterNameKey = @"filterNameKey";
NSString *const sortConditionKey = @"sortConditionKey";

@interface HCKScanHelper()<HCKCentralScanDelegate>

@property (nonatomic, strong)dispatch_source_t scanTimer;

@property (nonatomic, copy)void (^reloadTableViewBlock)(BOOL reloadAll, NSInteger section);

@property (nonatomic, copy)void (^stopScanBlock)(void);

@property (nonatomic, copy)void (^connectBlock)(HCKBeaconBaseModel *model);

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, copy)NSString *filterName;

@property (nonatomic, assign)dataSourceSortType sortType;

@property (nonatomic, strong)HCKScanAlertAction *alertAction;

@end

@implementation HCKScanHelper

#pragma mark - life circle
- (void)dealloc{
    NSLog(@"HCKScanAction销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HCKBeaconCentralDeallocNotification object:nil];
}

- (instancetype)init{
    if (self = [super init]) {
        [self iBeaconCentralSetDelegate];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(iBeaconCentralSetDelegate)
                                                     name:HCKBeaconCentralDeallocNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = RGBCOLOR(217, 217, 217);
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HCKBeaconScanCell *cell = [HCKBeaconScanCell initCellWithTableView:tableView];
    if (indexPath.row < self.dataList.count) {
        cell.indexPath = indexPath;
        cell.dataModel = self.dataList[indexPath.section];
        WS(weakSelf);
        cell.selectedBlock = ^(HCKBeaconBaseModel *model){
            if (weakSelf.connectBlock) {
                weakSelf.connectBlock(model);
            }
        };
    }
    return cell;
}

#pragma mark - HCKCentralScanDelegate
- (void)centralManagerStartScan:(HCKBeaconCentralManager *)manager{
    @synchronized(self.dataList){
        [self.dataList removeAllObjects];
    }
}

- (void)centralManagerScanNewDeviceModel:(HCKBeaconBaseModel *)beaconModel manager:(HCKBeaconCentralManager *)manager{
    WS(weakSelf);
    @synchronized(self.dataList){
        [HCKScanDataSource updateBeaconData:beaconModel dataList:self.dataList sortType:self.sortType filterCondition:self.filterName callback:^(tableViewReloadFunction reloadFunction, NSInteger section) {
            if (weakSelf.reloadTableViewBlock) {
                weakSelf.reloadTableViewBlock((reloadFunction == tableViewReloadAllData),section);
            }
        }];
    }
}

#pragma mark - Public method

- (void)scanHelperReloadDataBlock:(void (^)(BOOL reloadAll, NSInteger section))reloadBlock
                    stopScanBlock:(void (^)(void))stopBlock
               needConnectedBlock:(void (^)(HCKBeaconBaseModel *model))connectedBlock{
    self.reloadTableViewBlock = nil;
    self.reloadTableViewBlock = reloadBlock;
    self.stopScanBlock = nil;
    self.stopScanBlock = stopBlock;
    self.connectBlock = nil;
    self.connectBlock = connectedBlock;
}

- (void)startScan{
    if (self.scanTimer) {
        dispatch_cancel(self.scanTimer);
    }
    [[HCKBeaconCentralManager sharedInstance] startScaniBeacons];
    [self initScanTimer];
}

- (void)stopScan{
    if (self.scanTimer) {
        dispatch_cancel(self.scanTimer);
    }
    [[HCKBeaconCentralManager sharedInstance] stopScaniBeacon];
}

- (void)updateSortCondition:(NSDictionary *)sortCondition{
    if (!ValidDict(sortCondition)) {
        return;
    }
    self.filterName = sortCondition[filterNameKey];
    self.sortType = [self getSourceType:sortCondition[sortConditionKey]];
    @synchronized(self.dataList){
        if (ValidStr(self.filterName)) {
            NSPredicate *filter = [NSPredicate predicateWithFormat:@"peripheralName CONTAINS[cd] %@", self.filterName];
            NSArray *filterArray = [self.dataList filteredArrayUsingPredicate:filter];
            NSArray *list = [HCKScanDataSource filterDataWithOriList:filterArray
                                                       sortConditons:self.sortType];
            [self.dataList removeAllObjects];
            [self.dataList addObjectsFromArray:list];
        }
        dispatch_main_async_safe(^{
            if (self.reloadTableViewBlock) {
                self.reloadTableViewBlock(YES,0);
            }
        });
    }
}

- (void)showOpenBleAlert{
    [self.alertAction showOpenBleAlert];
}

- (void)connectBeaconWithModel:(HCKBeaconBaseModel *)beaconModel target:(UIViewController *)target{
    if (!beaconModel || !target) {
        return;
    }
    WS(weakSelf);
    [self.alertAction showPasswordAlertTarget:target completeCallback:^(NSString *password) {
        [weakSelf stopScan];
        [weakSelf connectPeripheral:beaconModel.peripheral deviceType:beaconModel.deviceType password:password target:target];
    }];
}

- (NSString *)getCurrentDeviceNumbers{
    return [NSString stringWithFormat:@"%ld",(long)self.dataList.count];
}

#pragma mark - event method
/**
 dfu升级之后，会吧SDK中心销毁，这里需要重新设置代理
 */
- (void)iBeaconCentralSetDelegate{
    [HCKBeaconCentralManager sharedInstance].scanDelegate = self;
    [HCKBeaconCentralManager sharedInstance].stateDelegate = (MKAppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark - private method
- (void)connectPeripheral:(CBPeripheral *)peripheral
               deviceType:(HCKBeaconDeviceType)deviceType
                 password:(NSString *)password
                   target:(UIViewController *)controller{
    WS(weakSelf);
    [[HCKHudManager share] showHUDWithTitle:@"Connecting..." inView:controller.view isPenetration:NO];
    [[HCKBeaconCentralManager sharedInstance] connectDevice:peripheral deviceType:deviceType password:password connectSucBlock:^(CBPeripheral *peripheral) {
        weakSelf.alertAction.localPassword = password;
        [[HCKHudManager share] hide];
        HCKConfigurationPageController *vc = [[HCKConfigurationPageController alloc] initWithNavigationType:GYNaviTypeShow];
        vc.peripheral = peripheral;
        vc.password = password;
        vc.deviceType = deviceType;
        [controller.navigationController pushViewController:vc animated:YES];
    } connectFailedBlock:^(NSError *error) {
        [[HCKHudManager share] hide];
        [controller.view showCentralToast:error.userInfo[@"errorInfo"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ScanPageNeedRefreshNotification" object:nil];
    }];
}

- (void)initScanTimer{
    dispatch_queue_t scanQueue = dispatch_queue_create("homePageScanQueue", DISPATCH_QUEUE_CONCURRENT);
    self.scanTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,scanQueue);
    //开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 60 * NSEC_PER_SEC);
    //间隔时间
    uint64_t interval = 60 * NSEC_PER_SEC;
    dispatch_source_set_timer(self.scanTimer, start, interval, 0);
    WS(weakSelf);
    dispatch_source_set_event_handler(self.scanTimer, ^{
        dispatch_main_async_safe(^{
            if (weakSelf.stopScanBlock) {
                weakSelf.stopScanBlock();
            }
        });
    });
    dispatch_resume(self.scanTimer);
}

- (dataSourceSortType)getSourceType:(NSString *)typeInfo{
    if ([typeInfo isEqualToString:sortWithMajor]) {
        return dataSourceSortTypeMajor;
    }
    if ([typeInfo isEqualToString:sortWithMinor]) {
        return dataSourceSortTypeMinor;
    }
    return dataSourceSortTypeRssi;
}

#pragma mark - setter & getter
- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (HCKScanAlertAction *)alertAction{
    if (!_alertAction) {
        _alertAction = [[HCKScanAlertAction alloc] init];
    }
    return _alertAction;
}

@end
