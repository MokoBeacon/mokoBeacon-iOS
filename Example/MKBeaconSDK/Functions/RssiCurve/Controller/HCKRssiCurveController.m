//
//  HCKRssiCurveController.m
//  HCKBeacon
//
//  Created by aa on 2017/11/17.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKRssiCurveController.h"
#import "HCKRssiBackView.h"
#import "HCKRssiValueTableView.h"

static NSInteger const maxDisplayPoint = 60;

@interface HCKRssiCurveController ()<HCKBeaconRssiValueChangedDelegate>

@property (nonatomic, strong)HCKRssiBackView *rssiCurveView;

@property (nonatomic, strong)UILabel *nameLabel;

@property (nonatomic, strong)NSMutableArray *rssiList;

@property (nonatomic, strong)HCKRssiValueTableView *tableView;

@end

@implementation HCKRssiCurveController

#pragma mark - life circle
- (void)dealloc{
    NSLog(@"HCKRssiCurveController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self sendHeartBit];
    [HCKBeaconCentralManager sharedInstance].rssiValueDelegate = self;
    // Do any additional setup after loading the view.
}

#pragma mark - 父类方法
- (NSString *)defaultTitle{
    return @"RSSI";
}

- (void)rightButtonMethod{
    if (self.tableView.alpha == 1.f) {
        return;
    }
    [UIView animateWithDuration:0.2f animations:^{
        self.tableView.alpha = 1.f;
    } completion:^(BOOL finished) {
        [self.tableView setRssiList:self.rssiList];
    }];
}

#pragma mark - 代理方法
#pragma mark - HCKBeaconRssiValueChangedDelegate
/**
 当前已经连接的外设rssi值改变
 
 @param rssi 当前rssi
 */
- (void)HCKBeaconRssiValueChanged:(NSNumber *)rssi{
    [self.rssiList addObject:rssi];
    NSUInteger loc = (self.rssiList.count > maxDisplayPoint ? (self.rssiList.count - maxDisplayPoint) : 0);
    NSArray *list = [self.rssiList subarrayWithRange:NSMakeRange(loc, MIN(maxDisplayPoint, self.rssiList.count))];
    [self.rssiCurveView setRssiValues:list];
    if (self.tableView.alpha == 1.f) {
        [self.tableView setRssiList:self.rssiList];
    }
}

#pragma mark - Private method
- (void)sendHeartBit{
    WS(weakSelf);
    [[HCKHudManager share] showHUDWithTitle:@"Reading"
                                     inView:self.view
                              isPenetration:NO];
    [HCKBeaconInterface sendHeartBeatToBeaconWithSucBlock:^(id returnData) {
        [[HCKHudManager share] hide];
        [weakSelf startReadRssi];
    } failedBlock:^(NSError *error) {
        [[HCKHudManager share] hide];
        [weakSelf startReadRssi];
    }];
}

- (void)startReadRssi{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0));
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if ([HCKBeaconCentralManager sharedInstance].connectStatus != HCKBeaconConnectStatusConnected) {
            //断开连接就销毁定时器
            dispatch_cancel(timer);
        }
        [[HCKBeaconCentralManager sharedInstance] readCurrentRssiValue];
    });
    dispatch_resume(timer);
}

- (void)loadSubViews{
    [self.rightButton setTitle:@"Details" forState:UIControlStateNormal];
    [self updateRightBtnWith:60.f];
    [self.view addSubview:self.rssiCurveView];
    [self.rssiCurveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-60.f);
    }];
    CGSize size = [NSString sizeWithText:self.nameLabel.text
                                 andFont:self.nameLabel.font
                              andMaxSize:CGSizeMake(MAXFLOAT, HCKFont(14.f).lineHeight)];
    [self.view addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30.f);
        make.width.mas_equalTo(size.width);
        make.top.mas_equalTo(self.rssiCurveView.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(HCKFont(14).lineHeight);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.tableView setAlpha:0.f];
}

#pragma mark - Public method

#pragma mark - setter & getter

- (HCKRssiBackView *)rssiCurveView{
    if (!_rssiCurveView) {
        _rssiCurveView = [[HCKRssiBackView alloc] init];
        _rssiCurveView.backgroundColor = COLOR_WHITE_MACROS;
    }
    return _rssiCurveView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = DEFAULT_TEXT_COLOR;
        _nameLabel.font = HCKFont(14.f);
        _nameLabel.text = [NSString stringWithFormat:@"Device name:%@%@",[HCKGlobalBeaconData share].beaconName,[HCKGlobalBeaconData share].deviceID];
    }
    return _nameLabel;
}

- (HCKRssiValueTableView *)tableView{
    if (!_tableView) {
        _tableView = [[HCKRssiValueTableView alloc] init];
        WS(weakSelf);
        _tableView.hiddenBlock = ^{
            [weakSelf.tableView setAlpha:0.f];
        };
    }
    return _tableView;
}

- (NSMutableArray *)rssiList{
    if (!_rssiList) {
        _rssiList = [NSMutableArray array];
    }
    return _rssiList;
}

@end
