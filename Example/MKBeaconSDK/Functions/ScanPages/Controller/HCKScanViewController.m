//
//  HCKScanViewController.m
//  HCKBeacon
//
//  Created by aa on 2017/10/27.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKScanViewController.h"
#import "HCKBaseTableView.h"
#import "HCKBeaconScanCell.h"
#import "HCKConfigurationPageController.h"
#import "HCKAboutController.h"
#import "HCKScanHelper.h"

static NSString *const HCKLeftButtonAnimationKey = @"HCKLeftButtonAnimationKey";

static CGFloat const buttonWidth = 50.f;
static CGFloat const buttonHeight = 30.f;


@interface HCKScanViewController ()<UITextFieldDelegate>

/**
 顶部搜索视图
 */
@property (nonatomic, strong)UIView *searchView;

/**
 搜索框
 */
@property (nonatomic, strong)UITextField *textField;

/**
 筛选按钮所在视图
 */
@property (nonatomic, strong)UIView *topView;

/**
 信号值强度筛选按钮
 */
@property (nonatomic, strong)UIButton *rssiButton;

/**
 主值筛选按钮
 */
@property (nonatomic, strong)UIButton *majorButton;

/**
 次值筛选按钮
 */
@property (nonatomic, strong)UIButton *minorButton;

@property (nonatomic, strong)UIImageView *circleIcon;

/**
 设备列表
 */
@property (nonatomic, strong)HCKBaseTableView *tableView;

@property (nonatomic, strong)HCKScanHelper *scanHelper;

@property (nonatomic, copy)NSString *sortString;

@end

@implementation HCKScanViewController

#pragma mark - life circle

- (void)dealloc{
    NSLog(@"HCKScanViewController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:centralManagerStateChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ScanPageNeedRefreshNotification" object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([HCKBeaconCentralManager sharedInstance].managerState == HCKBeaconCentralManagerStateEnable) {
        [self updateRefreshButtonStatus:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.leftButton.selected = NO;
    [self.circleIcon.layer removeAnimationForKey:HCKLeftButtonAnimationKey];
    [self.scanHelper stopScan];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    self.sortString = sortWithRssi;
    [self updateSortConditions];
    [self scanCallback];
    [self performSelector:@selector(showCentralStatus) withObject:nil afterDelay:0.5];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateCentralManagerState)
                                                 name:centralManagerStateChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(needRereshDatas)
                                                 name:@"ScanPageNeedRefreshNotification"
                                               object:nil];
    // Do any additional setup after loading the view.
}

#pragma mark - 父类方法
- (NSString *)defaultTitle{
    return LS(@"HCKScanViewController_title");
}

- (void)rightButtonMethod{
    HCKAboutController *vc = [[HCKAboutController alloc] initWithNavigationType:GYNaviTypeShow];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)leftButtonMethod{
    [self updateRefreshButtonStatus:!self.leftButton.selected];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self updateSortConditions];
    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}

#pragma mark - event method

/**
 根据信号值强度对设备进行排序
 */
- (void)rssiButtonPressed{
    [self.textField resignFirstResponder];
    if (self.sortString == sortWithRssi) {
        return;
    }
    self.sortString = sortWithRssi;
    //按照rssi排序
    [self.rssiButton setImage:LOADIMAGE(@"scanRssiSelected", @"png") forState:UIControlStateNormal];
    [self.majorButton setImage:LOADIMAGE(@"scanMajorUnselected", @"png") forState:UIControlStateNormal];
    [self.minorButton setImage:LOADIMAGE(@"scanMinorUnselected", @"png") forState:UIControlStateNormal];
    [self updateSortConditions];
}

/**
 根据主值对设备进行排序
 */
- (void)majorButtonPressed{
    [self.textField resignFirstResponder];
    if (self.sortString == sortWithMajor) {
        return;
    }
    self.sortString = sortWithMajor;
    //按照主值排序
    [self.rssiButton setImage:LOADIMAGE(@"scanRssiUnselected", @"png") forState:UIControlStateNormal];
    [self.majorButton setImage:LOADIMAGE(@"scanMajorSelected", @"png") forState:UIControlStateNormal];
    [self.minorButton setImage:LOADIMAGE(@"scanMinorUnselected", @"png") forState:UIControlStateNormal];
    [self updateSortConditions];
}

/**
 根据次值对设备进行排序
 */
- (void)minorButtonPressed{
    [self.textField resignFirstResponder];
    if (self.sortString == sortWithMinor) {
        return;
    }
    self.sortString = sortWithMinor;
    //按照次值排序
    [self.rssiButton setImage:LOADIMAGE(@"scanRssiUnselected", @"png") forState:UIControlStateNormal];
    [self.majorButton setImage:LOADIMAGE(@"scanMajorUnselected", @"png") forState:UIControlStateNormal];
    [self.minorButton setImage:LOADIMAGE(@"scanMinorSelected", @"png") forState:UIControlStateNormal];
    [self updateSortConditions];
}

- (void)textValueChanged{
    [self updateSortConditions];
}

#pragma mark - Private method

- (void)needRereshDatas {
    [self updateRefreshButtonStatus:YES];
}

- (void)showCentralStatus{
    [self.scanHelper showOpenBleAlert];
}

- (void)scanCallback{
    WS(weakSelf);
    [self.scanHelper scanHelperReloadDataBlock:^(BOOL reloadAll, NSInteger section) {
        [weakSelf.titleLabel setText:[NSString stringWithFormat:@"%@(%@)",LS(@"HCKScanViewController_title"),[weakSelf.scanHelper getCurrentDeviceNumbers]]];
        if (reloadAll) {
            [weakSelf.tableView reloadData];
            return ;
        }
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:section];
        [UIView performWithoutAnimation:^{
            [weakSelf.tableView insertSections:set withRowAnimation:UITableViewRowAnimationNone];
        }];
    } stopScanBlock:^{
        [weakSelf updateRefreshButtonStatus:NO];
    } needConnectedBlock:^(HCKBeaconBaseModel *model) {
        [weakSelf.scanHelper connectBeaconWithModel:model target:weakSelf];
    }];
}

/**
 监听蓝牙状态
 */
- (void)updateCentralManagerState{
    if (![HCKBaseViewController isCurrentViewControllerVisible:self]) {
        return ;
    }
    if ([HCKBeaconCentralManager sharedInstance].managerState != HCKBeaconCentralManagerStateEnable) {
        [self.view showCentralToast:@"The current system of bluetooth is not available"];
        self.leftButton.selected = NO;
        [self.circleIcon.layer removeAnimationForKey:HCKLeftButtonAnimationKey];
        return;
    }
    [self updateRefreshButtonStatus:YES];
    
}

- (void)updateSortConditions{
    NSDictionary *dic = @{
                          filterNameKey:[self.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""],
                          sortConditionKey:self.sortString,
                          };
    [self.scanHelper updateSortCondition:dic];
    [self updateRefreshButtonStatus:YES];
}

- (void)updateRefreshButtonStatus:(BOOL)selected{
    if ([HCKBeaconCentralManager sharedInstance].managerState != HCKBeaconCentralManagerStateEnable) {
        [self.view showCentralToast:@"The current system of bluetooth is not available!"];
        return;
    }
    self.leftButton.selected = selected;
    [self.circleIcon.layer removeAnimationForKey:HCKLeftButtonAnimationKey];
    if (!self.leftButton.isSelected) {
        //停止扫描
        [self.scanHelper stopScan];
        return;
    }
    [self.titleLabel setText:[NSString stringWithFormat:@"%@(0)",LS(@"HCKScanViewController_title")]];
    [self.circleIcon.layer addAnimation:[self circleLayerAnimation] forKey:HCKLeftButtonAnimationKey];
    [self.scanHelper startScan];
}

- (CABasicAnimation *)circleLayerAnimation{
    CABasicAnimation *transformAnima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    transformAnima.duration = 2.f;
    transformAnima.fromValue = @(0);
    transformAnima.toValue = @(2 * M_PI);
    transformAnima.autoreverses = NO;
    transformAnima.repeatCount = MAXFLOAT;
    transformAnima.removedOnCompletion = NO;
    return transformAnima;
}

#pragma mark -

- (void)loadSubViews{
    [self.leftButton setImage:nil forState:UIControlStateNormal];
    [self.titleLabel setText:[NSString stringWithFormat:@"%@(0)",LS(@"HCKScanViewController_title")]];
    [self.leftButton addSubview:self.circleIcon];
    self.leftButton.selected = NO;
    [self.circleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.leftButton.mas_centerX);
        make.width.mas_equalTo(22.f);
        make.centerY.mas_equalTo(self.leftButton.mas_centerY);
        make.height.mas_equalTo(22.f);
    }];
    [self.rightButton setImage:LOADIMAGE(@"scanRightAboutIcon", @"png") forState:UIControlStateNormal];
    [self.view addSubview:self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(48.f);
    }];
    [self.searchView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
        make.centerY.mas_equalTo(self.searchView.mas_centerY);
        make.height.mas_equalTo(39.f);
    }];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.searchView.mas_bottom);
        make.height.mas_equalTo(50.f);
    }];
    CGFloat space = (kScreenWidth - 3 * buttonWidth) / 4;
    [self.topView addSubview:self.rssiButton];
    [self.topView addSubview:self.majorButton];
    [self.topView addSubview:self.minorButton];
    [self.rssiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(space);
        make.width.mas_equalTo(buttonWidth);
        make.centerY.mas_equalTo(self.topView.mas_centerY);
        make.height.mas_equalTo(buttonHeight);
    }];
    [self.majorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rssiButton.mas_right).mas_offset(space);
        make.width.mas_equalTo(buttonWidth);
        make.centerY.mas_equalTo(self.topView.mas_centerY);
        make.height.mas_equalTo(buttonHeight);
    }];
    [self.minorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.majorButton.mas_right).mas_offset(space);
        make.width.mas_equalTo(buttonWidth);
        make.centerY.mas_equalTo(self.topView.mas_centerY);
        make.height.mas_equalTo(buttonHeight);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - setter & getter

- (UIView *)searchView{
    if (!_searchView) {
        _searchView = [[UIView alloc] init];
        _searchView.backgroundColor = RGBCOLOR(89, 148, 249);
    }
    return _searchView;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.keyboardType = UIKeyboardTypeASCIICapable;
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.textColor = DEFAULT_TEXT_COLOR;
        _textField.font = HCKFont(18.f);
        _textField.backgroundColor = COLOR_WHITE_MACROS;
        _textField.attributedPlaceholder = [HCKAttributedStringManager getAttributedString:@[LS(@"HCKScanViewController_placeHolder")] fonts:@[HCKFont(15.f)] colors:@[RGBCOLOR(222, 222, 222)]];
        _textField.returnKeyType = UIReturnKeySearch;
        [_textField addTarget:self action:@selector(textValueChanged) forControlEvents:UIControlEventEditingChanged];
        _textField.delegate = self;
        
        _textField.layer.masksToBounds = YES;
        _textField.layer.borderColor = COLOR_CLEAR_MACROS.CGColor;
        _textField.layer.borderWidth = 0.5f;
        _textField.layer.cornerRadius = 4.f;
    }
    return _textField;
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = COLOR_WHITE_MACROS;
    }
    return _topView;
}

- (UIButton *)rssiButton{
    if (!_rssiButton) {
        _rssiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rssiButton setTitle:@"rssi" forState:UIControlStateNormal];
        [_rssiButton setImage:LOADIMAGE(@"scanRssiSelected", @"png") forState:UIControlStateNormal];
        [_rssiButton addTapAction:self selector:@selector(rssiButtonPressed)];
    }
    return _rssiButton;
}

- (UIButton *)majorButton{
    if (!_majorButton) {
        _majorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_majorButton setTitle:@"major" forState:UIControlStateNormal];
        [_majorButton setImage:LOADIMAGE(@"scanMajorUnselected", @"png") forState:UIControlStateNormal];
        [_majorButton addTapAction:self selector:@selector(majorButtonPressed)];
    }
    return _majorButton;
}

- (UIButton *)minorButton{
    if (!_minorButton) {
        _minorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_minorButton setImage:LOADIMAGE(@"scanMinorUnselected", @"png") forState:UIControlStateNormal];
        [_minorButton setTitle:@"minor" forState:UIControlStateNormal];
        [_minorButton addTapAction:self selector:@selector(minorButtonPressed)];
    }
    return _minorButton;
}

- (HCKBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[HCKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self.scanHelper;
        _tableView.dataSource = self.scanHelper;
        _tableView.backgroundColor = RGBCOLOR(235, 235, 235);
    }
    return _tableView;
}

- (UIImageView *)circleIcon{
    if (!_circleIcon) {
        _circleIcon = [[UIImageView alloc] init];
        _circleIcon.image = LOADIMAGE(@"scanRefresh", @"png");
    }
    return _circleIcon;
}

- (HCKScanHelper *)scanHelper{
    if (!_scanHelper) {
        _scanHelper = [[HCKScanHelper alloc] init];
    }
    return _scanHelper;
}

@end
