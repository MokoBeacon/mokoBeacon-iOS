//
//  HCKConfigurationPageController.m
//  HCKBeacon
//
//  Created by aa on 2017/10/31.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKConfigurationPageController.h"
#import "HCKBaseTableView.h"
#import "HCKConfigPageCell.h"
#import "HCKHomeDataManager.h"
#import "HCKSetBeaconValueViewController.h"
#import "HCKDFUModel.h"
#import "HCKSetBeaconNameController.h"
#import "HCKConfigPageSwitchCell.h"

@interface HCKConfigurationPageController ()<UITableViewDelegate, UITableViewDataSource, HCKConfigSwitchCellDelegate>

@property (nonatomic, strong)HCKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)NSMutableArray *switchDataList;

@property (nonatomic, strong)HCKHomeDataManager *dataManager;

@end

@implementation HCKConfigurationPageController

#pragma mark - life circle
- (void)dealloc{
    NSLog(@"HCKConfigurationPageController销毁");
    [[HCKBeaconCentralManager sharedInstance] disconnectConnectedPeripheral];
    [[HCKGlobalBeaconData share] loadEmptyModels];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:peripheralConnectStateChangedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //开启右划退出手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //本页面禁止右划退出手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self startReadBeaconDatas];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.rightButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
    [self.rightButton.titleLabel setFont:HCKFont(12)];
    [self.rightButton setTitle:@"DISCONNECT" forState:UIControlStateNormal];
    [self updateRightBtnWith:70.f];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peripheralConnectStatusChanged)
                                                 name:peripheralConnectStateChangedNotification
                                               object:nil];
    // Do any additional setup after loading the view.
}

#pragma mark - 父类方法
- (NSString *)defaultTitle{
    return LS(@"HCKConfigurationPageController_title");
}

- (void)leftButtonMethod{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)rightButtonMethod{
    if ([HCKBeaconCentralManager sharedInstance].connectStatus == HCKBeaconConnectStatusConnected) {
        //连接的时候直接断开连接
        [[HCKBeaconCentralManager sharedInstance] disconnectConnectedPeripheral];
        return;
    }
    if (!self.peripheral) {
        [self.view showCentralToast:@"To connect the equipment cannot be empty."];
        return;
    }
    if (!ValidStr(self.password) || self.password.length != 8) {
        [self.view showCentralToast:@"password error"];
        return;
    }
    [[HCKHudManager share] showHUDWithTitle:@"Connecting..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [[HCKBeaconCentralManager sharedInstance] connectDevice:self.peripheral deviceType:self.deviceType password:self.password connectSucBlock:^(CBPeripheral *peripheral) {
        [[HCKHudManager share] hide];
        [weakSelf.view showCentralToast:@"Connect success"];
    } connectFailedBlock:^(NSError *error) {
        [[HCKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 代理方法
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([HCKBeaconCentralManager sharedInstance].connectStatus != HCKBeaconConnectStatusConnected) {
        [self.view showCentralToast:LS(@"HCKConfigurationPageController_disconnected")];
        return;
    }
    if (indexPath.section == 0) {
        [self configParams:indexPath];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.dataList.count;
    }
    return self.switchDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HCKConfigPageCell *cell = [HCKConfigPageCell initCellWithTableView:tableView];
        cell.dataModel = self.dataList[indexPath.row];
        return cell;
    }
    HCKConfigPageSwitchCell *cell = [HCKConfigPageSwitchCell initCellWithTableView:tableView];
    cell.indexPath = indexPath;
    cell.dataModel = self.switchDataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - HCKConfigSwitchCellDelegate
- (void)switchStateChanged:(BOOL)isOn row:(NSInteger)row {
    if (row == 0) {
        //可连接状态
        [self setConnectEnable:isOn];
        return;
    }
    if (row == 1) {
        //关机
        [self powerOff];
        return;
    }
}

#pragma mark -
- (void)peripheralConnectStatusChanged{
    if ([HCKBeaconCentralManager sharedInstance].connectStatus != HCKBeaconConnectStatusConnected) {
        [self.rightButton setTitle:@"CONNECT" forState:UIControlStateNormal];
        return ;
    }
    [self.rightButton setTitle:@"DISCONNECT" forState:UIControlStateNormal];
}

#pragma mark - Private method

- (void)startReadBeaconDatas{
    [[HCKHudManager share] showHUDWithTitle:@"Loading..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [self.dataManager startReadDataWithCompleteBlock:^{
        [[HCKHudManager share] hide];
        [weakSelf getTableDataSource];
        [weakSelf.tableView reloadData];
    } failedBlock:^(NSError *error) {
        [[HCKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
    
}

- (void)configParams:(NSIndexPath *)path{
    if (path.row > self.dataList.count) {
        return;
    }
    if (path.row == 0) {
        [self.view showCentralToast:LS(@"HCKConfigurationPageController_disable")];
        return;
    }
    if (path.row == 2) {
        //主值
        HCKSetBeaconValueViewController *vc = [[HCKSetBeaconValueViewController alloc] initWithNavigationType:GYNaviTypeShow];
        vc.valueType = HCKSetMajorValue;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (path.row == 3) {
        //次值
        HCKSetBeaconValueViewController *vc = [[HCKSetBeaconValueViewController alloc] initWithNavigationType:GYNaviTypeShow];
        vc.valueType = HCKSetMinorValue;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (path.row == 8) {
        //读取mac地址
        [self.view showCentralToast:LS(@"HCKConfigurationPageController_disable")];
        return;
    }
    if (path.row == 9) {
        HCKSetBeaconNameController *vc = [[HCKSetBeaconNameController alloc] initWithNavigationType:GYNaviTypeShow];
        vc.supportXYZData = (self.deviceType == HCKBeaconDeviceTypeWithXYZData);
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    HCKConfigPageModel *model = self.dataList[path.row];
    id vc = [[model.devClass alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 设置可连接状态
- (void)setConnectEnable:(BOOL)connect{
    NSString *msg = (connect ? LS(@"HCKConfigurationPageController_connectEnableMsg") : LS(@"HCKConfigurationPageController_connectDisableMsg"));
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LS(@"HCKConfigurationPageController_watchout")
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    WS(weakSelf);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LS(@"HCKConfigurationPageController_cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf setCellSwitchStatus:!connect row:0];
    }];
    [alertController addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:LS(@"HCKConfigurationPageController_confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf setConnectStatusToDevice:connect];
    }];
    [alertController addAction:moreAction];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)setConnectStatusToDevice:(BOOL)connect{
    [[HCKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [HCKBeaconInterface setBeaconConnectStatus:connect sucBlock:^(id returnData) {
        [[HCKHudManager share] hide];
        [self.view showCentralToast:@"Success!"];
        HCKConfigPageSwitchCellModel *connectStatusModel = self.switchDataList[0];
        connectStatusModel.isOn = connect;
        if (!connect) {
            [self performSelector:@selector(leftButtonMethod) withObject:nil afterDelay:0.5f];
        }
    } failedBlock:^(NSError *error) {
        [[HCKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self setCellSwitchStatus:!connect row:0];
    }];
}

- (void)setCellSwitchStatus:(BOOL)isOn row:(NSInteger)row{
    NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:1];
    HCKConfigPageSwitchCell *cell = [self.tableView cellForRowAtIndexPath:path];
    if (!cell || ![cell isKindOfClass:[HCKConfigPageSwitchCell class]]) {
        return;
    }
    HCKConfigPageSwitchCellModel *connectModel = self.switchDataList[0];
    connectModel.isOn = isOn;
    [cell setDataModel:connectModel];
}

#pragma mark - 开关机
- (void)powerOff{
    NSString *msg = LS(@"HCKConfigurationPageController_powerOffNote");
    NSString *title = LS(@"HCKConfigurationPageController_watchout");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    WS(weakSelf);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LS(@"HCKConfigurationPageController_cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf setCellSwitchStatus:YES row:1];
    }];
    [alertController addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:LS(@"HCKConfigurationPageController_confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf commandPowerOff];
    }];
    [alertController addAction:moreAction];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)commandPowerOff{
    [[HCKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [HCKBeaconInterface powerOffDeviceWithSucBlock:^(id returnData) {
        [[HCKHudManager share] hide];
        [self.view showCentralToast:@"Power off successfully!"];
        [self performSelector:@selector(leftButtonMethod) withObject:nil afterDelay:0.5f];
    } failedBlock:^(NSError *error) {
        [[HCKHudManager share] hide];
        [self.view showCentralToast:@"Power off failed"];
        [self setCellSwitchStatus:YES row:1];
    }];
}

- (void)getTableDataSource{
    [self.dataList removeAllObjects];
    [self.switchDataList removeAllObjects];
    //电池电量
    HCKConfigPageModel *batteryModel = [[HCKConfigPageModel alloc] init];
    batteryModel.function = LS(@"HCKConfigurationPageController_battery");
    if (ValidStr([HCKGlobalBeaconData share].battery)) {
        batteryModel.value = [HCKGlobalBeaconData share].battery;
    }
    batteryModel.clickEnable = NO;
    [self.dataList addObject:batteryModel];
    
    //UUID
    HCKConfigPageModel *uuidModel = [[HCKConfigPageModel alloc] init];
    uuidModel.function = LS(@"HCKConfigurationPageController_uuid");
    if (ValidStr([HCKGlobalBeaconData share].UUID)) {
        uuidModel.value = [HCKGlobalBeaconData share].UUID;
    }
    uuidModel.devClass = NSClassFromString(@"HCKSetUUIDController");
    uuidModel.clickEnable = YES;
    [self.dataList addObject:uuidModel];
    
    //Major
    HCKConfigPageModel *majorModel = [[HCKConfigPageModel alloc] init];
    majorModel.function = LS(@"HCKConfigurationPageController_major");
    if (ValidStr([HCKGlobalBeaconData share].major)) {
        majorModel.value = [HCKGlobalBeaconData share].major;
    }
    majorModel.devClass = NSClassFromString(@"HCKSetBeaconValueViewController");
    majorModel.clickEnable = YES;
    [self.dataList addObject:majorModel];
    
    //Minor
    HCKConfigPageModel *minorModel = [[HCKConfigPageModel alloc] init];
    minorModel.function = LS(@"HCKConfigurationPageController_minor");
    if (ValidStr([HCKGlobalBeaconData share].minor)) {
        minorModel.value = [HCKGlobalBeaconData share].minor;
    }
    minorModel.devClass = NSClassFromString(@"HCKSetBeaconValueViewController");
    minorModel.clickEnable = YES;
    [self.dataList addObject:minorModel];
    
    //校验距离
    HCKConfigPageModel *measureModel = [[HCKConfigPageModel alloc] init];
    measureModel.function = LS(@"HCKConfigurationPageController_measure");
    if ([HCKGlobalBeaconData share].measurePower) {
        measureModel.value = [NSString stringWithFormat:@"-%@%@",[HCKGlobalBeaconData share].measurePower,@"dBm"];
    }
    measureModel.devClass = NSClassFromString(@"HCKSetMeasurePowerController");
    measureModel.clickEnable = YES;
    [self.dataList addObject:measureModel];
    
    //广播功率
    HCKConfigPageModel *transmissionModel = [[HCKConfigPageModel alloc] init];
    transmissionModel.function = LS(@"HCKConfigurationPageController_transmission");
    if (ValidStr([HCKGlobalBeaconData share].transmission)) {
        transmissionModel.value = ([[HCKGlobalBeaconData share].transmission isEqualToString:@"8"] ? @"7" : [HCKGlobalBeaconData share].transmission);
    }
    transmissionModel.devClass = NSClassFromString(@"HCKSetTransmissionController");
    transmissionModel.clickEnable = YES;
    [self.dataList addObject:transmissionModel];
    
    //广播周期
    HCKConfigPageModel *broadcastIntervalModel = [[HCKConfigPageModel alloc] init];
    broadcastIntervalModel.function = LS(@"HCKConfigurationPageController_broadcastInterval");
    if (ValidStr([HCKGlobalBeaconData share].broadcastInterval)) {
        broadcastIntervalModel.value = [HCKGlobalBeaconData share].broadcastInterval;
    }
    broadcastIntervalModel.devClass = NSClassFromString(@"HCKSetBroadcastCycleController");
    broadcastIntervalModel.clickEnable = YES;
    [self.dataList addObject:broadcastIntervalModel];
    
    //device ID
    HCKConfigPageModel *deviceIDModel = [[HCKConfigPageModel alloc] init];
    deviceIDModel.function = LS(@"HCKConfigurationPageController_deviceID");
    if (ValidStr([HCKGlobalBeaconData share].deviceID)) {
        deviceIDModel.value = [HCKGlobalBeaconData share].deviceID;
    }
    deviceIDModel.devClass = NSClassFromString(@"HCKSetDeviceIDController");
    deviceIDModel.clickEnable = YES;
    [self.dataList addObject:deviceIDModel];
    
    //MAC地址
    HCKConfigPageModel *macModel = [[HCKConfigPageModel alloc] init];
    macModel.function = LS(@"HCKConfigurationPageController_mac");
    if (ValidStr([HCKGlobalBeaconData share].macAddress)) {
        macModel.value = [HCKGlobalBeaconData share].macAddress;
    }else{
        macModel.value = @"1X";
    }
    macModel.clickEnable = NO;
    [self.dataList addObject:macModel];
    
    //设备名称
    HCKConfigPageModel *beaconNameModel = [[HCKConfigPageModel alloc] init];
    beaconNameModel.function = LS(@"HCKConfigurationPageController_beaconName");
    if (ValidStr([HCKGlobalBeaconData share].beaconName)) {
        beaconNameModel.value = [HCKGlobalBeaconData share].beaconName;
    }
    beaconNameModel.devClass = NSClassFromString(@"HCKSetBeaconNameController");
    beaconNameModel.clickEnable = YES;
    [self.dataList addObject:beaconNameModel];
    
//    //重启Beacon
//    HCKConfigPageModel *reBootModel = [[HCKConfigPageModel alloc] init];
//    reBootModel.function = @"重启Beacon";
//    [self.dataList addObject:reBootModel];
    
    //修改重启密码
    HCKConfigPageModel *changePasswordModel = [[HCKConfigPageModel alloc] init];
    changePasswordModel.function = LS(@"HCKConfigurationPageController_changePassword");
    changePasswordModel.devClass = NSClassFromString(@"HCKSetPasswordController");
    changePasswordModel.clickEnable = YES;
    [self.dataList addObject:changePasswordModel];
    
    //系统信息
    HCKConfigPageModel *systemModel = [[HCKConfigPageModel alloc] init];
    systemModel.function = LS(@"HCKConfigurationPageController_system");
    systemModel.devClass = NSClassFromString(@"HCKSystemController");
    systemModel.clickEnable = YES;
    [self.dataList addObject:systemModel];
    
    //rssi
    HCKConfigPageModel *rssiModel = [[HCKConfigPageModel alloc] init];
    rssiModel.function = LS(@"HCKConfigurationPageController_rssi");
    rssiModel.devClass = NSClassFromString(@"HCKRssiCurveController");
    rssiModel.clickEnable = YES;
    [self.dataList addObject:rssiModel];
    //dfu
    HCKConfigPageModel *dfuModel = [[HCKConfigPageModel alloc] init];
    dfuModel.function = @"DFU";
    dfuModel.devClass = NSClassFromString(@"HCKDfuController");
    [self.dataList addObject:dfuModel];
    
    if (self.deviceType == HCKBeaconDeviceTypeWithXYZData) {
        //如果是支持三轴加速度的
        HCKConfigPageModel *xyzModel = [[HCKConfigPageModel alloc] init];
        xyzModel.function = LS(@"HCKConfigurationPageController_xyz");
        xyzModel.devClass = NSClassFromString(@"HCKAccelerationDataController");
        xyzModel.clickEnable = YES;
        [self.dataList addObject:xyzModel];
    }
    
    //连接模式
    HCKConfigPageSwitchCellModel *connectStatusModel = [[HCKConfigPageSwitchCellModel alloc] init];
    connectStatusModel.function = LS(@"HCKConfigurationPageController_connectStatus");
    connectStatusModel.isOn = [HCKGlobalBeaconData share].connectEnable;
    [self.switchDataList addObject:connectStatusModel];
    
    //关机
    HCKConfigPageSwitchCellModel *powerOffModel = [[HCKConfigPageSwitchCellModel alloc] init];
    powerOffModel.function = LS(@"HCKConfigurationPageController_powerOff");
    powerOffModel.isOn = YES;
    [self.switchDataList addObject:powerOffModel];
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

- (NSMutableArray *)switchDataList {
    if (!_switchDataList) {
        _switchDataList = [NSMutableArray array];
    }
    return _switchDataList;
}

- (HCKHomeDataManager *)dataManager{
    if (!_dataManager) {
        _dataManager = [HCKHomeDataManager new];
    }
    return _dataManager;
}

@end
