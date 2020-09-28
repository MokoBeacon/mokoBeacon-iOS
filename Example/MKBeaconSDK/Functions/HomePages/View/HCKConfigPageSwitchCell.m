//
//  HCKConfigPageSwitchCell.m
//  HCKBeacon
//
//  Created by aa on 2019/3/19.
//  Copyright © 2019 HCK. All rights reserved.
//

#import "HCKConfigPageSwitchCell.h"

static NSString *const HCKConfigPageSwitchCellIdenty = @"HCKConfigPageSwitchCellIdenty";

@implementation HCKConfigPageSwitchCellModel

@end

@interface HCKConfigPageSwitchCell ()

@property (nonatomic, strong)UILabel *functionLabel;

@property (nonatomic, strong)UISwitch *switchView;

@property (nonatomic, strong)UIView *clearView;

@end

@implementation HCKConfigPageSwitchCell

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:peripheralConnectStateChangedNotification object:nil];
}

+ (HCKConfigPageSwitchCell *)initCellWithTableView:(UITableView *)tableView {
    HCKConfigPageSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:HCKConfigPageSwitchCellIdenty];
    if (!cell) {
        cell = [[HCKConfigPageSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HCKConfigPageSwitchCellIdenty];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.functionLabel];
        [self.contentView addSubview:self.switchView];
        [self.contentView addSubview:self.clearView];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(peripheralConnectStatusChanged)
                                                     name:peripheralConnectStateChangedNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - super method
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.functionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(130);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(HCKFont(14).lineHeight);
    }];
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
    [self.clearView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
}

#pragma mark - event method
- (void)switchViewValueChanged{
    if ([self.delegate respondsToSelector:@selector(switchStateChanged:row:)]) {
        [self.delegate switchStateChanged:self.switchView.isOn row:self.indexPath.row];
    }
}

- (void)peripheralConnectStatusChanged {
    if ([HCKBeaconCentralManager sharedInstance].connectStatus != HCKBeaconConnectStatusConnected) {
        self.clearView.hidden = NO;
    }else {
        self.clearView.hidden = YES;
    }
}

#pragma mark -
- (void)setDataModel:(HCKConfigPageSwitchCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    self.functionLabel.text = _dataModel.function;
    [self.switchView setOn:_dataModel.isOn animated:YES];
    if ([HCKBeaconCentralManager sharedInstance].connectStatus != HCKBeaconConnectStatusConnected) {
        self.clearView.hidden = NO;
    }else {
        self.clearView.hidden = YES;
    }
}

#pragma mark - setter & getter
- (UILabel *)functionLabel{
    if (!_functionLabel) {
        _functionLabel = [[UILabel alloc] init];
        _functionLabel.textColor = DEFAULT_TEXT_COLOR;
        _functionLabel.textAlignment = NSTextAlignmentLeft;
        _functionLabel.font = HCKFont(13);
    }
    return _functionLabel;
}

- (UISwitch *)switchView {
    if (!_switchView) {
        _switchView = [[UISwitch alloc] init];
        _switchView.backgroundColor = COLOR_WHITE_MACROS;
        [_switchView addTarget:self
                        action:@selector(switchViewValueChanged)
              forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

- (UIView *)clearView {
    if (!_clearView) {
        _clearView = [[UIView alloc] init];
        _clearView.backgroundColor = COLOR_CLEAR_MACROS;
    }
    return _clearView;
}

@end
