//
//  HCKSystemController.m
//  HCKBeacon
//
//  Created by aa on 2017/10/31.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKSystemController.h"
#import "HCKBaseTableView.h"
#import "HCKSystemCell.h"

@interface HCKSystemController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic ,strong)HCKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation HCKSystemController

#pragma mark - life circle
- (void)dealloc{
    NSLog(@"HCKSystemController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.rightButton setHidden:YES];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self initLocalDatas];
    [self getVendorDatas];
    // Do any additional setup after loading the view.
}

#pragma mark - 父类方法
- (NSString *)defaultTitle{
    return LS(@"HCKSystemController_title");
}

#pragma mark - 代理方法

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HCKSystemModel *model = self.dataList[indexPath.row];
    if (ValidStr(model.valueString)) {
        CGSize size = [NSString sizeWithText:model.valueString
                                     andFont:HCKFont(14.f)
                                  andMaxSize:CGSizeMake(kScreenWidth - 2 * 15.f - 120 - 40, MAXFLOAT)];
        return MAX(size.height + 20.f, 44);
    }
    
    return 44.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HCKSystemCell *cell = [HCKSystemCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - Private method
- (void)initLocalDatas{
    //制造商
    HCKSystemModel *manufacturersModel = [[HCKSystemModel alloc] init];
    manufacturersModel.titleString = LS(@"HCKSystemController_manufacturers");
    [self.dataList addObject:manufacturersModel];
    
    //beacon型号
    HCKSystemModel *modeModel = [[HCKSystemModel alloc] init];
    modeModel.titleString = LS(@"HCKSystemController_mode");
    [self.dataList addObject:modeModel];
    
    //生产日期
    HCKSystemModel *productionModel = [[HCKSystemModel alloc] init];
    productionModel.titleString = LS(@"HCKSystemController_production");
    [self.dataList addObject:productionModel];
    
    //mac地址
    HCKSystemModel *macModel = [[HCKSystemModel alloc] init];
    macModel.titleString = LS(@"HCKSystemController_mac");
    if ([HCKGlobalBeaconData share].macAddress) {
        macModel.valueString = [HCKGlobalBeaconData share].macAddress;
    }
    [self.dataList addObject:macModel];
    
    //芯片型号
    HCKSystemModel *hardwareModule = [[HCKSystemModel alloc] init];
    hardwareModule.titleString = LS(@"HCKSystemController_hardwareModule");
    if (ValidStr([HCKGlobalBeaconData share].hardwareModule)) {
        hardwareModule.valueString = [HCKGlobalBeaconData share].hardwareModule;
    }
    [self.dataList addObject:hardwareModule];
    
    //硬件版本
    HCKSystemModel *hardwareModel = [[HCKSystemModel alloc] init];
    hardwareModel.titleString = LS(@"HCKSystemController_hardware");
    if (ValidStr([HCKGlobalBeaconData share].hardwareVersion)) {
        hardwareModel.valueString = [HCKGlobalBeaconData share].hardwareVersion;
    }
    [self.dataList addObject:hardwareModel];
    
    //固件版本
    HCKSystemModel *firmwareModel = [[HCKSystemModel alloc] init];
    firmwareModel.titleString = LS(@"HCKSystemController_firmware");
    if (ValidStr([HCKGlobalBeaconData share].firmwareVersion)) {
        firmwareModel.valueString = [HCKGlobalBeaconData share].firmwareVersion;
    }
    [self.dataList addObject:firmwareModel];
    
    //软件版本
    HCKSystemModel *softwareModel = [[HCKSystemModel alloc] init];
    softwareModel.titleString = LS(@"HCKSystemController_softVersion");
    if (ValidStr([HCKGlobalBeaconData share].softVersion)) {
        softwareModel.valueString = [HCKGlobalBeaconData share].softVersion;
    }
    [self.dataList addObject:softwareModel];
    
    //从上电到目前为止运行了多长时间，单位为小时
    HCKSystemModel *elapsedTimeModel = [[HCKSystemModel alloc] init];
    elapsedTimeModel.titleString = LS(@"HCKSystemController_elapsedTime");
    if (ValidStr([HCKGlobalBeaconData share].elapsedTime)) {
        elapsedTimeModel.valueString = [HCKGlobalBeaconData share].elapsedTime;
    }
    [self.dataList addObject:elapsedTimeModel];
    
//    //上一次重启时间
//    HCKSystemModel *restartModel = [[HCKSystemModel alloc] init];
//    restartModel.titleString = @"重启时间";
//    if (ValidStr([HCKGlobalBeaconData share].restartTime)) {
//        restartModel.valueString = [HCKGlobalBeaconData share].restartTime;
//    }
//    [self.dataList addObject:restartModel];
    
//    //系统标示
//    HCKSystemModel *systemModel = [[HCKSystemModel alloc] init];
//    systemModel.titleString = LS(@"HCKSystemController_system");
//    if (ValidStr([HCKGlobalBeaconData share].systemID)) {
//        systemModel.valueString = [HCKGlobalBeaconData share].systemID;
//    }
//    [self.dataList addObject:systemModel];
//
//    //IEEE标准信息
//    HCKSystemModel *IEEEModel = [[HCKSystemModel alloc] init];
//    IEEEModel.titleString = LS(@"HCKSystemController_ieee");
//    if (ValidStr([HCKGlobalBeaconData share].IEEE)) {
//        IEEEModel.valueString = [HCKGlobalBeaconData share].IEEE;
//    }
//    [self.dataList addObject:IEEEModel];
    
    [self.tableView reloadData];
}

#pragma mark - 请求数据

/**
 获取制造商信息
 */
- (void)getVendorDatas{
    [[HCKHudManager share] showHUDWithTitle:@"Loading..."
                                     inView:self.view
                              isPenetration:NO];
    if ([HCKBeaconCentralManager sharedInstance].connectStatus != HCKBeaconConnectStatusConnected) {
        //外设处于非连接状态
        [[HCKHudManager share] hide];
        [self.tableView reloadData];
        return;
    }
    if (ValidStr([HCKGlobalBeaconData share].manufacturers)) {
        //
        HCKSystemModel *manufacturersModel = self.dataList[0];
        manufacturersModel.valueString = [HCKGlobalBeaconData share].manufacturers;
        [self getModeData];
        return;
    }
    WS(weakSelf);
    [HCKBeaconInterface readBeaconVendorWithSucBlock:^(id returnData) {
        NSString *vendor = returnData[@"result"][@"vendor"];
        if (ValidStr(vendor)) {
            [HCKGlobalBeaconData share].manufacturers = vendor;
            HCKSystemModel *manufacturersModel = weakSelf.dataList[0];
            manufacturersModel.valueString = [HCKGlobalBeaconData share].manufacturers;
        }
        [weakSelf getModeData];
    } failedBlock:^(NSError *error) {
        [weakSelf getModeData];
    }];
}

/**
 获取型号信息
 */
- (void)getModeData{
    if ([HCKBeaconCentralManager sharedInstance].connectStatus != HCKBeaconConnectStatusConnected) {
        //外设处于非连接状态
        [[HCKHudManager share] hide];
        [self.tableView reloadData];
        return;
    }
    if (ValidStr([HCKGlobalBeaconData share].model)) {
        HCKSystemModel *modeModel = self.dataList[1];
        modeModel.valueString = [HCKGlobalBeaconData share].model;
        [self getProductDateData];
        return;
    }
    WS(weakSelf);
    [HCKBeaconInterface readBeaconModeIDWithSucBlock:^(id returnData) {
        NSString *modeID = returnData[@"result"][@"modeID"];
        if (ValidStr(modeID)) {
            [HCKGlobalBeaconData share].model = modeID;
            HCKSystemModel *modeModel = weakSelf.dataList[1];
            modeModel.valueString = [HCKGlobalBeaconData share].model;
        }
        [weakSelf getProductDateData];
    } failedBlock:^(NSError *error) {
        [weakSelf getProductDateData];
    }];
}

/**
 获取生产日期
 */
- (void)getProductDateData{
    if ([HCKBeaconCentralManager sharedInstance].connectStatus != HCKBeaconConnectStatusConnected) {
        //外设处于非连接状态
        [[HCKHudManager share] hide];
        [self.tableView reloadData];
        return;
    }
    if (ValidStr([HCKGlobalBeaconData share].productionTime)) {
        //
        HCKSystemModel *productionModel = self.dataList[2];
        productionModel.valueString = [HCKGlobalBeaconData share].productionTime;
        [self readBeaconMacAddress];
        return;
    }
    WS(weakSelf);
    [HCKBeaconInterface readBeaconProductionDateWithSucBlock:^(id returnData) {
        NSString *productionDate = returnData[@"result"][@"productionDate"];
        if (ValidStr(productionDate)) {
            [HCKGlobalBeaconData share].productionTime = productionDate;
            HCKSystemModel *productionModel = weakSelf.dataList[2];
            productionModel.valueString = [HCKGlobalBeaconData share].productionTime;
        }
        [weakSelf readBeaconMacAddress];
    } failedBlock:^(NSError *error) {
        [weakSelf readBeaconMacAddress];
    }];
}

/**
 读取mac地址,没有做，后期补充
 */
- (void)readBeaconMacAddress{
    if ([HCKBeaconCentralManager sharedInstance].connectStatus != HCKBeaconConnectStatusConnected) {
        //外设处于非连接状态
        [[HCKHudManager share] hide];
        [self.tableView reloadData];
        return;
    }
    if (ValidStr([HCKGlobalBeaconData share].macAddress)) {
        HCKSystemModel *macModel = self.dataList[3];
        macModel.valueString = [HCKGlobalBeaconData share].macAddress;
        [self getHardwareModule];
        return;
    }
    WS(weakSelf);
    [HCKBeaconInterface readBeaconMacAddressWithSucBlock:^(id returnData) {
        [HCKGlobalBeaconData share].macAddress = returnData[@"result"][@"macAddress"];
        HCKSystemModel *macModel = weakSelf.dataList[3];
        macModel.valueString = [HCKGlobalBeaconData share].macAddress;
        [weakSelf getHardwareModule];
    } failedBlock:^(NSError *error) {
        [weakSelf getHardwareModule];
    }];
}

/**
 芯片硬件型号
 */
- (void)getHardwareModule{
    if ([HCKBeaconCentralManager sharedInstance].connectStatus != HCKBeaconConnectStatusConnected) {
        //外设处于非连接状态
        [[HCKHudManager share] hide];
        [self.tableView reloadData];
        return;
    }
    if (ValidStr([HCKGlobalBeaconData share].hardwareModule)) {
        HCKSystemModel *hardwareModule = self.dataList[4];
        hardwareModule.valueString = [HCKGlobalBeaconData share].hardwareModule;
        [self getHardwareData];
        return;
    }
    //请求硬件型号数据
    WS(weakSelf);
    [HCKBeaconInterface readBeaconHardwareModuleWithSucBlock:^(id returnData) {
        [HCKGlobalBeaconData share].hardwareModule = returnData[@"result"][@"hardwareModul"];
        HCKSystemModel *hardwareModule = weakSelf.dataList[4];
        hardwareModule.valueString = [HCKGlobalBeaconData share].hardwareModule;
        [weakSelf getHardwareData];
    } failedBlock:^(NSError *error) {
        [weakSelf getHardwareData];
    }];
}

/**
 获取硬件版本
 */
- (void)getHardwareData{
    if ([HCKBeaconCentralManager sharedInstance].connectStatus != HCKBeaconConnectStatusConnected) {
        //外设处于非连接状态
        [[HCKHudManager share] hide];
        [self.tableView reloadData];
        return;
    }
    if (ValidStr([HCKGlobalBeaconData share].hardwareVersion)) {
        HCKSystemModel *hardwareModel = self.dataList[5];
        hardwareModel.valueString = [HCKGlobalBeaconData share].hardwareVersion;
        [self getFirmwareData];
        return;
    }
    WS(weakSelf);
    [HCKBeaconInterface readBeaconHardwareWithSucBlock:^(id returnData) {
        NSString *hardware = returnData[@"result"][@"hardware"];
        if (ValidStr(hardware)) {
            [HCKGlobalBeaconData share].hardwareVersion = hardware;
            HCKSystemModel *hardwareModel = weakSelf.dataList[5];
            hardwareModel.valueString = [HCKGlobalBeaconData share].hardwareVersion;
        }
        [weakSelf getFirmwareData];
    } failedBlock:^(NSError *error) {
        [weakSelf getFirmwareData];
    }];
}

/**
 获取固件版本
 */
- (void)getFirmwareData{
    if ([HCKBeaconCentralManager sharedInstance].connectStatus != HCKBeaconConnectStatusConnected) {
        //外设处于非连接状态
        [[HCKHudManager share] hide];
        [self.tableView reloadData];
        return;
    }
    if (ValidStr([HCKGlobalBeaconData share].firmwareVersion)) {
        //
        HCKSystemModel *firmwareModel = self.dataList[6];
        firmwareModel.valueString = [HCKGlobalBeaconData share].firmwareVersion;
        [self getElapsedTime];
        return;
    }
    WS(weakSelf);
    [HCKBeaconInterface readBeaconFirmwareWithSucBlock:^(id returnData) {
        NSString *firmware = returnData[@"result"][@"firmware"];
        if (ValidStr(firmware)) {
            [HCKGlobalBeaconData share].firmwareVersion = firmware;
            HCKSystemModel *firmwareModel = weakSelf.dataList[6];
            firmwareModel.valueString = [HCKGlobalBeaconData share].firmwareVersion;
        }
        [weakSelf getSoftVersion];
    } failedBlock:^(NSError *error) {
        [weakSelf getSoftVersion];
    }];
}

- (void)getSoftVersion{
    if ([HCKBeaconCentralManager sharedInstance].connectStatus != HCKBeaconConnectStatusConnected) {
        //外设处于非连接状态
        [[HCKHudManager share] hide];
        [self.tableView reloadData];
        return;
    }
    WS(weakSelf);
    [HCKBeaconInterface readBeaconSoftwareWithSucBlock:^(id returnData) {
        [HCKGlobalBeaconData share].softVersion = returnData[@"result"][@"software"];
        HCKSystemModel *softVersion = weakSelf.dataList[7];
        softVersion.valueString = [HCKGlobalBeaconData share].softVersion;
        [weakSelf getElapsedTime];
    } failedBlock:^(NSError *error) {
        [weakSelf getElapsedTime];
    }];
}

/**
 beacon的运行时间
 */
- (void)getElapsedTime{
    if ([HCKBeaconCentralManager sharedInstance].connectStatus != HCKBeaconConnectStatusConnected) {
        //外设处于非连接状态
        [[HCKHudManager share] hide];
        [self.tableView reloadData];
        return;
    }
    WS(weakSelf);
    [HCKBeaconInterface readBeaconElapsedTimeWithSucBlock:^(id returnData) {
        [HCKGlobalBeaconData share].elapsedTime = returnData[@"result"][@"elapsedTime"];
        HCKSystemModel *elapsedTimeModel = weakSelf.dataList[8];
        elapsedTimeModel.valueString = [weakSelf getTimeWithSec:[HCKGlobalBeaconData share].elapsedTime];
        [[HCKHudManager share] hide];
        [weakSelf.tableView reloadData];
//        [weakSelf getSystemIDData];
    } failedBlock:^(NSError *error) {
//        [weakSelf getSystemIDData];
        [[HCKHudManager share] hide];
        [weakSelf.tableView reloadData];
    }];
}

///**
// beacon重启的时间
// */
//- (void)getrRestartTime{
//    if ([HCKBeaconCentralManager sharedInstance].connectStatus != HCKBeaconConnectStatusConnected) {
//        //外设处于非连接状态
//        [[HCKHudManager share] hide];
//        [self.tableView reloadData];
//        return;
//    }
//    if (!ValidStr([HCKGlobalBeaconData share].restartTime)) {
//        //
//        HCKSystemModel *restartModel = self.dataList[8];
//        restartModel.valueString = [HCKGlobalBeaconData share].restartTime;
//        [self getSystemIDData];
//        return;
//    }
//    
//}

///**
// 获取软件版本
// */
//- (void)getSoftwareData{
//    WS(weakSelf);
//    [HCKBluetoothPeripheralManager readBeaconSoftwareWithSuccessBlock:^(id returnData) {
//        NSString *software = returnData[@"result"][@"software"];
//        if (ValidStr(software)) {
//            HCKSystemModel *model = self.dataList[5];
//            model.valueString = software;
//        }
//        [weakSelf getSystemIDData];
//    } failedBlock:^(NSError *error) {
//        [weakSelf getSystemIDData];
//    }];
//}

/**
 获取系统标示
 */
- (void)getSystemIDData{
    if ([HCKBeaconCentralManager sharedInstance].connectStatus != HCKBeaconConnectStatusConnected) {
        //外设处于非连接状态
        [[HCKHudManager share] hide];
        [self.tableView reloadData];
        return;
    }
    if (ValidStr([HCKGlobalBeaconData share].systemID)) {
        HCKSystemModel *systemID = self.dataList[8];
        systemID.valueString = [HCKGlobalBeaconData share].systemID;
        [self getIEEEData];
        return;
    }
    WS(weakSelf);
    [HCKBeaconInterface readBeaconSystemIDWithSucBlock:^(id returnData) {
        NSString *systemID = returnData[@"result"][@"systemID"];
        if (ValidStr(systemID)) {
            [HCKGlobalBeaconData share].systemID = systemID;
            HCKSystemModel *systemID = weakSelf.dataList[8];
            systemID.valueString = [HCKGlobalBeaconData share].systemID;
        }
        [weakSelf getIEEEData];
    } failedBlock:^(NSError *error) {
        [weakSelf getIEEEData];
    }];
}

/**
 获取IEEE标准信息
 */
- (void)getIEEEData{
    if ([HCKBeaconCentralManager sharedInstance].connectStatus != HCKBeaconConnectStatusConnected) {
        //外设处于非连接状态
        [[HCKHudManager share] hide];
        [self.tableView reloadData];
        return;
    }
    if (ValidStr([HCKGlobalBeaconData share].IEEE)) {
        HCKSystemModel *ieeeMode = self.dataList[9];
        ieeeMode.valueString = [HCKGlobalBeaconData share].IEEE;
        [[HCKHudManager share] hide];
        [self.tableView reloadData];
        return;
    }
    WS(weakSelf);
    [HCKBeaconInterface readBeaconIEEEInfoWithSucBlock:^(id returnData) {
        NSString *IEEE = returnData[@"result"][@"IEEE"];
        if (ValidStr(IEEE)) {
            [HCKGlobalBeaconData share].IEEE = IEEE;
            HCKSystemModel *ieeeMode = weakSelf.dataList[9];
            ieeeMode.valueString = [HCKGlobalBeaconData share].IEEE;
        }
        [[HCKHudManager share] hide];
        [weakSelf.tableView reloadData];
    } failedBlock:^(NSError *error) {
        [[HCKHudManager share] hide];
        [weakSelf.tableView reloadData];
    }];
}

- (NSString *)getTimeWithSec:(NSString *)second{
    NSInteger minutes = floor([second integerValue] / 60);
    NSInteger sec = trunc([second integerValue] - minutes * 60);
    NSInteger hours1 = floor([second integerValue] / (60 * 60));
    minutes = minutes - hours1 * 60;
    NSInteger day = floor(hours1 / 24);
    hours1 = hours1 - 24 * day;
    NSString *time = [NSString stringWithFormat:@"%@D%@h%@m%@s",stringFromInteger(day),stringFromInteger(hours1),stringFromInteger(minutes),stringFromInteger(sec)];
    return time;
}

#pragma mark - setter & getter

- (HCKBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[HCKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
