//
//  HCKMainViewController.m
//  testSDK
//
//  Created by aa on 2018/3/20.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import "HCKMainViewController.h"
#import "HCKBeaconSDK.h"
#import "HCKBeaconRegularsDefine.h"
#import "HCKDataViewController.h"

static NSString *const mainCellIdenty = @"mainCellIdenty";

@interface HCKMainViewController ()<UITableViewDelegate, UITableViewDataSource, HCKCentralScanDelegate>

@property (nonatomic, strong)UIButton *button;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)UIImageView *imageView;

@property (nonatomic, strong)UIActivityIndicatorView *indicatorView;

@end

@implementation HCKMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationItem setTitle:@"测试"];
    [self.view addSubview:self.button];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.indicatorView];
    [HCKBeaconCentralManager sharedInstance].scanDelegate = self;
    [self.view addSubview:self.imageView];
}

#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mainCellIdenty];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mainCellIdenty];
    }
    HCKBeaconBaseModel *model = self.dataList[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@-%@-%@",model.peripheralName,model.major,model.minor,model.rssi];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self didSelectedRow:indexPath.row];
}

#pragma mark - HCKBeaconScanDelegate
/**
 扫描到新的设备
 
 @param beaconModel 设备model
 */
- (void)centralManagerScanNewDeviceModel:(HCKBeaconBaseModel *)beaconModel manager:(HCKBeaconCentralManager *)manager{
    [self.dataList addObject:beaconModel];
    [self.tableView reloadData];
}

- (void)centralManagerStartScan:(HCKBeaconCentralManager *)manager{
    NSLog(@"开始扫描");
}

- (void)centralManagerStopScan:(HCKBeaconCentralManager *)manager{
    NSLog(@"停止扫描");
}

- (void)buttonPressed{
    [[HCKBeaconCentralManager sharedInstance] startScaniBeacons];
}

- (void)didSelectedRow:(NSInteger)row{
    [self.indicatorView startAnimating];
    HCKBeaconBaseModel *model = self.dataList[row];
    HCKBeaconWS(weakSelf);
    [[HCKBeaconCentralManager sharedInstance] connectDevice:model.peripheral deviceType:model.deviceType password:@"Moko4321" connectSucBlock:^(CBPeripheral *peripheral) {
        [self.indicatorView stopAnimating];
        HCKDataViewController *vc = [[HCKDataViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } connectFailedBlock:^(NSError *error) {
        [self.indicatorView stopAnimating];
        [weakSelf showAlertWithMsg:error.userInfo[@"errorInfo"]];
    }];
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

- (void)testInterface:(BOOL (^)(NSDictionary *params))block{
    if (block) {
        block(@{@"params":@"asfss"});
    }
}

//29-37
- (UILabel *)getLabel{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor blueColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:15.f];
    return label;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 70.f, self.view.frame.size.width - 2 * 15, 400.f) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setFrame:CGRectMake(15.f, self.view.frame.size.height - 40.f - 35.f, self.view.frame.size.width - 2 * 15, 40.f)];
        [_button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_button setTitle:@"button" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, self.view.frame.size.height - 40.f, 40, 40)];
    }
    return _imageView;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 50, 50)];
        _indicatorView.hidesWhenStopped = YES;
        _indicatorView.color = [UIColor blueColor];
    }
    return _indicatorView;
}

@end
