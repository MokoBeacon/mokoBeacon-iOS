//
//  HCKDataViewController.m
//  testSDK
//
//  Created by aa on 2018/5/7.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import "HCKDataViewController.h"
#import "HCKBeaconRegularsDefine.h"
#import "HCKBeaconSDK.h"

static NSString *const HCKDataViewControllerCellIdenty = @"HCKDataViewControllerCellIdenty";

@interface HCKDataViewController ()<UITableViewDelegate, UITableViewDataSource, HCKBeaconRssiValueChangedDelegate, HCKBeaconThreeAxisAccelerationDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation HCKDataViewController

- (void)dealloc{
    NSLog(@"HCKDataViewController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationItem setTitle:@"数据"];
    [self.view addSubview:self.tableView];
    [self loadDatas];
    [HCKBeaconCentralManager sharedInstance].rssiValueDelegate = self;
    [HCKBeaconCentralManager sharedInstance].xyzDelegate = self;
    // Do any additional setup after loading the view.
}

#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HCKDataViewControllerCellIdenty];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HCKDataViewControllerCellIdenty];
    }
    cell.textLabel.text = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self didSelectedRow:indexPath.row];
}

#pragma mark - HCKBeaconRssiValueChangedDelegate
- (void)HCKBeaconRssiValueChanged:(NSNumber *)rssi{
    NSLog(@"%@",rssi);
}

#pragma mark - HCKBeaconThreeAxisAccelerationDelegate
- (void)receiveThreeAxisAccelerationData:(NSDictionary *)dic{
    NSLog(@"%@",dic);
}

- (void)didSelectedRow:(NSInteger)row{
    HCKBeaconWS(weakSelf);
    if (row == 0) {
        [HCKBeaconInterface readBeaconBatteryWithSucBlock:^(id returnData) {
            [weakSelf showAlertWithMsg:returnData[@"result"][@"battery"]];
        } failedBlock:^(NSError *error) {
            [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
        }];
    }else if (row == 1){
        [HCKBeaconInterface readBeaconVendorWithSucBlock:^(id returnData) {
            [weakSelf showAlertWithMsg:returnData[@"result"][@"vendor"]];
        } failedBlock:^(NSError *error) {
            [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
        }];
    }else if (row == 2){
        [HCKBeaconInterface readBeaconModeIDWithSucBlock:^(id returnData) {
            [weakSelf showAlertWithMsg:returnData[@"result"][@"modeID"]];
        } failedBlock:^(NSError *error) {
            [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
        }];
    }else if (row == 3){
        [HCKBeaconInterface readBeaconProductionDateWithSucBlock:^(id returnData) {
            [weakSelf showAlertWithMsg:returnData[@"result"][@"productionDate"]];
        } failedBlock:^(NSError *error) {
            [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
        }];
    }else if (row == 4){
        [HCKBeaconInterface readBeaconFirmwareWithSucBlock:^(id returnData) {
            [weakSelf showAlertWithMsg:returnData[@"result"][@"firmware"]];
        } failedBlock:^(NSError *error) {
            [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
        }];
    }else if (row == 5){
        [HCKBeaconInterface readBeaconHardwareWithSucBlock:^(id returnData) {
            [weakSelf showAlertWithMsg:returnData[@"result"][@"hardware"]];
        } failedBlock:^(NSError *error) {
            [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
        }];
    }else if (row == 6){
        [HCKBeaconInterface readBeaconSoftwareWithSucBlock:^(id returnData) {
            [weakSelf showAlertWithMsg:returnData[@"result"][@"software"]];
        } failedBlock:^(NSError *error) {
            [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
        }];
    }else if (row == 7){
        [HCKBeaconInterface readBeaconSystemIDWithSucBlock:^(id returnData) {
            [weakSelf showAlertWithMsg:returnData[@"result"][@"systemID"]];
        } failedBlock:^(NSError *error) {
            [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
        }];
    }else if (row == 8){
        [HCKBeaconInterface readBeaconIEEEInfoWithSucBlock:^(id returnData) {
            [weakSelf showAlertWithMsg:returnData[@"result"][@"IEEE"]];
        } failedBlock:^(NSError *error) {
            [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
        }];
    }else if (row == 9){
        [HCKBeaconInterface readBeaconUUIDWithSucBlock:^(id returnData) {
            [weakSelf showAlertWithMsg:returnData[@"result"][@"uuid"]];
        } failedBlock:^(NSError *error) {
            [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
        }];
    }else if (row == 10){
        [HCKBeaconInterface readBeaconMajorWithSucBlock:^(id returnData) {
            [weakSelf showAlertWithMsg:returnData[@"result"][@"major"]];
        } failedBlock:^(NSError *error) {
            [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
        }];
    }else if (row == 11){
        [HCKBeaconInterface readBeaconMinorWithSucBlock:^(id returnData) {
            [weakSelf showAlertWithMsg:returnData[@"result"][@"minor"]];
        } failedBlock:^(NSError *error) {
            [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
        }];
    }else if (row == 12){
        [HCKBeaconInterface readBeaconMeasurePowerWithSucBlock:^(id returnData) {
            [weakSelf showAlertWithMsg:returnData[@"result"][@"measurePower"]];
        } failedBlock:^(NSError *error) {
            [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
        }];
    }else if (row == 13){
        [HCKBeaconInterface readBeaconTransmissionWithSucBlock:^(id returnData) {
            [weakSelf showAlertWithMsg:returnData[@"result"][@"transmission"]];
        } failedBlock:^(NSError *error) {
            [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
        }];
    }else if (row == 14){
        [HCKBeaconInterface readBeaconBroadcastIntervalWithSucBlock:^(id returnData) {
            [weakSelf showAlertWithMsg:returnData[@"result"][@"broadcastInterval"]];
        } failedBlock:^(NSError *error) {
            [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
        }];
    }else if (row == 15){
        [HCKBeaconInterface readBeaconDeviceIDWithSucBlock:^(id returnData) {
            [weakSelf showAlertWithMsg:returnData[@"result"][@"deviceID"]];
        } failedBlock:^(NSError *error) {
            [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
        }];
    }else if (row == 16){
        [HCKBeaconInterface readBeaconNameWithSucBlock:^(id returnData) {
            [weakSelf showAlertWithMsg:returnData[@"result"][@"beaconName"]];
        } failedBlock:^(NSError *error) {
            [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
        }];
    }else if (row == 17){
        [HCKBeaconInterface readBeaconMacAddressWithSucBlock:^(id returnData) {
            [weakSelf showAlertWithMsg:returnData[@"result"][@"macAddress"]];
        } failedBlock:^(NSError *error) {
            [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
        }];
    }else if (row == 18){
        [HCKBeaconInterface readBeaconConnectStatusWithSucBlock:^(id returnData) {
            NSString *msg = ([returnData[@"result"][@"connectStatus"] boolValue] ? @"可连接" : @"不可连接");
            [weakSelf showAlertWithMsg:msg];
        } failedBlock:^(NSError *error) {
            [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
        }];
    }else if (row == 19){
        [HCKBeaconInterface readBeaconElapsedTimeWithSucBlock:^(id returnData) {
            [weakSelf showAlertWithMsg:returnData[@"result"][@"elapsedTime"]];
        } failedBlock:^(NSError *error) {
            [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
        }];
    }else if (row == 20){
        [HCKBeaconInterface readBeaconHardwareModuleWithSucBlock:^(id returnData) {
            [weakSelf showAlertWithMsg:returnData[@"result"][@"hardwareModul"]];
        } failedBlock:^(NSError *error) {
            [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
        }];
    }else if (row == 21){
        [HCKBeaconInterface startReadXYZDataWithSucBlock:^(id returnData) {
            [weakSelf showAlertWithMsg:@"开启"];
        } failedBlock:^(NSError *error) {
            [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
        }];
    }else if (row == 22){
        [HCKBeaconInterface stopReadXYZDataWithSucBlock:^(id returnData) {
            [weakSelf showAlertWithMsg:@"停止"];
        } failedBlock:^(NSError *error) {
            [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
        }];
    }else if (row == 23){
        [HCKBeaconInterface setBeaconUUID:@"11111111-1111-1111-1111-111111111111" sucBlock:^(id returnData) {
            [weakSelf showAlertWithMsg:@"Success"];
        } failedBlock:^(NSError *error) {
            [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
        }];
    }else if (row == 24){
        [HCKBeaconInterface setBeaconMajor:222 sucBlock:^(id returnData) {
            [weakSelf showAlertWithMsg:@"Success"];
        } failedBlock:^(NSError *error) {
            [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
        }];
    }else if (row == 25){
        [HCKBeaconInterface setBeaconMinor:111 sucBlock:^(id returnData) {
            [weakSelf showAlertWithMsg:@"Success"];
        } failedBlock:^(NSError *error) {
            [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
        }];
    }else if (row == 26){
        [HCKBeaconInterface setBeaconMeasurePower:-10 sucBlock:^(id returnData) {
            [weakSelf showAlertWithMsg:@"Success"];
        } failedBlock:^(NSError *error) {
            [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
        }];
    }else if (row == 27){
        [HCKBeaconInterface setBeaconTransmission:beaconTransmissionNeg4dBm sucBlock:^(id returnData) {
            [weakSelf showAlertWithMsg:@"Success"];
        } failedBlock:^(NSError *error) {
            [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
        }];
    }else if (row == 28){
        [HCKBeaconInterface setBeaconBroadcastInterval:10 sucBlock:^(id returnData) {
            [weakSelf showAlertWithMsg:@"Success"];
        } failedBlock:^(NSError *error) {
            [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
        }];
    }else if (row == 29){
        [HCKBeaconInterface setBeaconDeviceID:@"66666" sucBlock:^(id returnData) {
            [weakSelf showAlertWithMsg:@"Success"];
        } failedBlock:^(NSError *error) {
            [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
        }];
    }
}

- (void)showAlertWithMsg:(NSString *)msg{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Dismiss"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:moreAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//29-37
- (UILabel *)getLabel{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor blueColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:15.f];
    return label;
}

- (void)loadDatas{
    [self.dataList addObject:@"读取电量"];
    [self.dataList addObject:@"读取厂商信息"];
    [self.dataList addObject:@"读取产品型号"];
    [self.dataList addObject:@"读取生产日期"];
    [self.dataList addObject:@"读取固件版本"];
    [self.dataList addObject:@"读取硬件版本"];
    [self.dataList addObject:@"读取软件版本"];
    [self.dataList addObject:@"读取系统标示"];
    [self.dataList addObject:@"读取IEEE标准"];
    [self.dataList addObject:@"读取UUID"];
    [self.dataList addObject:@"读取major"];
    [self.dataList addObject:@"读取minor"];
    [self.dataList addObject:@"读取measurePower"];
    [self.dataList addObject:@"读取transmission"];
    [self.dataList addObject:@"读取广播周期"];
    [self.dataList addObject:@"读取设备ID"];
    [self.dataList addObject:@"读取设备名称"];
    [self.dataList addObject:@"读取MacAddress"];
    [self.dataList addObject:@"读取可连接状态"];
    [self.dataList addObject:@"读取运行时间"];
    [self.dataList addObject:@"读取芯片类型"];
    [self.dataList addObject:@"开始读取三轴"];
    [self.dataList addObject:@"停止读取三轴"];
    [self.dataList addObject:@"设置UUID"];
    [self.dataList addObject:@"设置major"];
    [self.dataList addObject:@"设置minor"];
    [self.dataList addObject:@"设置measurePower"];
    [self.dataList addObject:@"设置Transmission"];
    [self.dataList addObject:@"设置BroadcastInterval"];
    [self.dataList addObject:@"设置device id"];
    
    [self.tableView reloadData];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 70.f, self.view.frame.size.width - 2 * 15, 400.f) style:UITableViewStylePlain];
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
