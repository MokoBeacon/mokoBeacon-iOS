//
//  HCKBeaconScanCell.m
//  HCKBeacon
//
//  Created by aa on 2017/10/28.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBeaconScanCell.h"

static NSString *const HCKBeaconScanCellIdenty = @"HCKBeaconScanCellIdenty";

static CGFloat const offset_X = 15.f;
static CGFloat const batteryIconWidth = 30.f;
static CGFloat const batteryIconHeight = 15.f;
static CGFloat const msgLabelWidth = 75.f;

@interface HCKBeaconScanCell ()

/**
 电池电量
 */
@property (nonatomic, strong)UIImageView *batteryIcon;

/**
 名字
 */
@property (nonatomic, strong)UILabel *beaconNameLabel;

/**
 信号值强度
 */
@property (nonatomic, strong)UILabel *rssiLabel;

/**
 主值
 */
@property (nonatomic, strong)UILabel *majorLabel;

/**
 次值
 */
@property (nonatomic, strong)UILabel *minorLabel;

/**
 距离
 */
@property (nonatomic, strong)UILabel *distanceLabel;

/**
 远近
 */
@property (nonatomic, strong)UILabel *proximityLabel;

/**
 是否可连接
 */
@property (nonatomic, strong)UILabel *connectLabel;

/**
 发射功率
 */
@property (nonatomic, strong)UILabel *txPowerLabel;

/**
 三轴加速度
 */
@property (nonatomic, strong)UILabel *xyzDataLabel;

/**
 右侧箭头
 */
@property (nonatomic, strong)UIImageView *rightIcon;

@end

@implementation HCKBeaconScanCell

+ (HCKBeaconScanCell *)initCellWithTableView:(UITableView *)tableView{
    HCKBeaconScanCell *cell = [tableView dequeueReusableCellWithIdentifier:HCKBeaconScanCellIdenty];
    if (!cell) {
        cell = [[HCKBeaconScanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HCKBeaconScanCellIdenty];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.batteryIcon];
        [self.contentView addSubview:self.beaconNameLabel];
        [self.contentView addSubview:self.rssiLabel];
        [self.contentView addSubview:self.majorLabel];
        [self.contentView addSubview:self.minorLabel];
//        [self.contentView addSubview:self.distanceLabel];
        [self.contentView addSubview:self.proximityLabel];
        [self.contentView addSubview:self.connectLabel];
        [self.connectLabel addSubview:self.txPowerLabel];
        [self.contentView addSubview:self.rightIcon];
        [self.contentView addSubview:self.xyzDataLabel];
        [self.contentView addTapAction:self selector:@selector(cellDidSelected)];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.batteryIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-offset_X);
        make.width.mas_equalTo(batteryIconWidth);
        make.top.mas_equalTo(12.f);
        make.height.mas_equalTo(batteryIconHeight);
    }];
    [self.beaconNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(self.batteryIcon.mas_left).mas_offset(10.f);
        make.top.mas_equalTo(12.f);
        make.height.mas_equalTo(HCKFont(17.f).lineHeight);
    }];
    [self.rssiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(39.f);
        make.width.mas_equalTo(msgLabelWidth);
        make.top.mas_equalTo(self.batteryIcon.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(HCKFont(12.f).lineHeight);
    }];
    [self.majorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rssiLabel.mas_right).mas_offset(20.f);
        make.width.mas_equalTo(msgLabelWidth);
        make.centerY.mas_equalTo(self.rssiLabel.mas_centerY);
        make.height.mas_equalTo(self.rssiLabel.mas_height);
    }];
    [self.minorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.majorLabel.mas_right).mas_offset(20.f);
        make.width.mas_equalTo(msgLabelWidth);
        make.centerY.mas_equalTo(self.rssiLabel.mas_centerY);
        make.height.mas_equalTo(self.rssiLabel.mas_height);
    }];
//    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.rssiLabel.mas_centerX);
//        make.width.mas_equalTo(msgLabelWidth);
//        make.top.mas_equalTo(self.rssiLabel.mas_bottom).mas_offset(10);
//        make.height.mas_equalTo(HCKFont(12.f).lineHeight);
//    }];
    [self.proximityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.rssiLabel.mas_centerX);
        make.width.mas_equalTo(msgLabelWidth);
        make.top.mas_equalTo(self.rssiLabel.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(HCKFont(12.f).lineHeight);
    }];
    [self.connectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.majorLabel.mas_centerX);
        make.width.mas_equalTo(msgLabelWidth);
        make.centerY.mas_equalTo(self.proximityLabel.mas_centerY);
        make.height.mas_equalTo(HCKFont(12.f).lineHeight);
    }];
    [self.txPowerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.rssiLabel.mas_centerX);
        make.width.mas_equalTo(msgLabelWidth);
        make.top.mas_equalTo(self.proximityLabel.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(HCKFont(12.f).lineHeight);
    }];
    [self.xyzDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.txPowerLabel.mas_right).mas_offset(20.f);
        make.right.mas_equalTo(-10.f);
        make.centerY.mas_equalTo(self.txPowerLabel.mas_centerY);
        make.height.mas_equalTo(HCKFont(12.f).lineHeight);
    }];
    [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(8);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(14);
    }];
}

#pragma mark - Private method

- (void)cellDidSelected{
    if (self.selectedBlock) {
        self.selectedBlock(self.dataModel);
    }
}

- (UILabel *)msgLabel{
    UILabel *msgLabel = [[UILabel alloc] init];
    msgLabel.textAlignment = NSTextAlignmentLeft;;
    msgLabel.textColor = DEFAULT_TEXT_COLOR;
    msgLabel.font = HCKFont(12.f);
    return msgLabel;
}

#pragma mark - Public method

- (void)setDataModel:(HCKBeaconBaseModel *)dataModel{
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || !_dataModel.peripheral) {
        return;
    }
    if (ValidStr(_dataModel.peripheralName)) {
        //名称
        self.beaconNameLabel.text = _dataModel.peripheralName;
    }
    if (ValidStr(_dataModel.battery)) {
        //设置电池
        NSInteger battery = [[_dataModel battery] integerValue];
        if (battery >=0
            && battery <= 25) {
            //最低电量
            self.batteryIcon.image = LOADIMAGE(@"scanBatteryLowest", @"png");
        }else if (battery > 25
                  && battery <= 50){
            //低电量
            self.batteryIcon.image = LOADIMAGE(@"scanBatteryLow", @"png");
        }else if (battery > 50
                  && battery <= 75){
            //高电量
            self.batteryIcon.image = LOADIMAGE(@"scanBatteryHigh", @"png");
        }else if (battery > 75
                  && battery <= 100){
            //最高电量
            self.batteryIcon.image = LOADIMAGE(@"scanBatteryHighest", @"png");
        }
    }
    if (ValidStr(_dataModel.rssi)) {
        //信号值强度
        self.rssiLabel.text = [@"Rssi:" stringByAppendingString:_dataModel.rssi];
    }
    if (ValidStr(_dataModel.major)) {
        //主值
        self.majorLabel.text = [@"Major:" stringByAppendingString:_dataModel.major];
    }
    if (ValidStr(_dataModel.minor)) {
        //次值
        self.minorLabel.text = [@"Minor:" stringByAppendingString:_dataModel.minor];
    }
//    if (ValidStr(_dataModel.distance)) {
//        //距离
//        self.distanceLabel.text = _dataModel.distance;
//    }
    if (ValidStr(_dataModel.proximity)) {
        //远近信息
        self.proximityLabel.text = _dataModel.proximity;
    }
    //是否可连接
    self.connectLabel.text = [@"CONN:" stringByAppendingString:_dataModel.connectEnble ? @"YES":@"NO"];
    if (ValidStr(_dataModel.txPower)) {
        //发射功率
        self.txPowerLabel.text = [NSString stringWithFormat:@"%@%@%@",@"Tx:",_dataModel.txPower,@"dBm"];
    }
    if (_dataModel.deviceType == HCKBeaconDeviceTypeNormal) {
        //通用iBeacon，没有三轴加速度
        [self.xyzDataLabel setHidden:YES];
        return;
    }
    HCKXYZBeaconModel *tempModel = (HCKXYZBeaconModel *)_dataModel;
    [self.xyzDataLabel setHidden:NO];
    NSString *xzyString = [NSString stringWithFormat:@"X:%@;Y:%@;Z:%@",tempModel.xData,tempModel.yData,tempModel.zData];
    NSString *string = [@"3-Axis:" stringByAppendingString:xzyString];
    [self.xyzDataLabel setText:string];
}

#pragma mark - setter & getter
- (UIImageView *)batteryIcon{
    if (!_batteryIcon) {
        _batteryIcon = [[UIImageView alloc] init];
    }
    return _batteryIcon;
}

- (UILabel *)beaconNameLabel{
    if (!_beaconNameLabel) {
        _beaconNameLabel = [[UILabel alloc] init];
        _beaconNameLabel.textColor = RGBCOLOR(86, 145, 252);
        _beaconNameLabel.textAlignment = NSTextAlignmentLeft;
        _beaconNameLabel.font = HCKFont(15.f);
        _beaconNameLabel.text = @"N/A";
    }
    return _beaconNameLabel;
}

- (UILabel *)rssiLabel{
    if (!_rssiLabel) {
        _rssiLabel = [self msgLabel];
    }
    return _rssiLabel;
}

- (UILabel *)majorLabel{
    if (!_majorLabel) {
        _majorLabel = [self msgLabel];
    }
    return _majorLabel;
}

- (UILabel *)minorLabel{
    if (!_minorLabel) {
        _minorLabel = [self msgLabel];
    }
    return _minorLabel;
}

- (UILabel *)distanceLabel{
    if (!_distanceLabel) {
        _distanceLabel = [self msgLabel];
    }
    return _distanceLabel;
}

- (UILabel *)proximityLabel{
    if (!_proximityLabel) {
        _proximityLabel = [self msgLabel];
    }
    return _proximityLabel;
}

- (UILabel *)connectLabel{
    if (!_connectLabel) {
        _connectLabel = [self msgLabel];
    }
    return _connectLabel;
}

- (UILabel *)txPowerLabel{
    if (!_txPowerLabel) {
        _txPowerLabel = [self msgLabel];
    }
    return _txPowerLabel;
}

- (UILabel *)xyzDataLabel{
    if (!_xyzDataLabel) {
        _xyzDataLabel = [self msgLabel];
    }
    return _xyzDataLabel;
}

- (UIImageView *)rightIcon{
    if (!_rightIcon) {
        _rightIcon = [[UIImageView alloc] init];
        _rightIcon.image = LOADIMAGE(@"goto_next_button", @"png");
    }
    return _rightIcon;
}

@end
