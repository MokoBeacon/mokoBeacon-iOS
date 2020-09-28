//
//  HCKAccelerationDataController.m
//  HCKBeacon
//
//  Created by aa on 2018/1/15.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import "HCKAccelerationDataController.h"
#import "HCKBaseTableView.h"

@interface HCKAccelerationDataController ()<HCKBeaconThreeAxisAccelerationDelegate>

@property (nonatomic, strong)NSDateFormatter *dateFormatter;

@property (nonatomic, strong)UITextView *textView;

@end

@implementation HCKAccelerationDataController

#pragma mark - life circle
- (void)dealloc{
    NSLog(@"HCKAccelerationDataController销毁");
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [HCKBeaconCentralManager sharedInstance].xyzDelegate = self;
    [self startReadXYZData];
    // Do any additional setup after loading the view.
}

#pragma mark - 父类方法
- (NSString *)defaultTitle{
    return LS(@"HCKConfigurationPageController_xyz");
}

- (void)rightButtonMethod{
    if ([self.rightButton isSelected]) {
        //stop
        [self stopReadXYZData:NO];
        return;
    }
    [self startReadXYZData];
}

- (void)leftButtonMethod{
    [self stopReadXYZData:YES];
}

#pragma mark - Delegate

#pragma mark - HCKBeaconThreeAxisAccelerationDelegate
- (void)receiveThreeAxisAccelerationData:(NSDictionary *)dic{
    if (!ValidDict(dic)) {
        return;
    }
    NSString *datestr = [[self dateFormatter] stringFromDate:[NSDate date]];
    NSString *sourceInfo = [NSString stringWithFormat:@"X:%@;Y:%@;Z:%@",dic[@"x"],dic[@"y"],dic[@"z"]];
    self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@  %@",datestr,sourceInfo]];
    [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 1)];
}

#pragma mark - Private method
- (void)startReadXYZData{
    [[HCKHudManager share] showHUDWithTitle:@"Starting..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [HCKBeaconInterface startReadXYZDataWithSucBlock:^(id returnData) {
        [[HCKHudManager share] hide];
        weakSelf.rightButton.selected = YES;
        [weakSelf.rightButton setTitle:@"Stop" forState:UIControlStateNormal];
    } failedBlock:^(NSError *error) {
        [[HCKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

/**
 停止读取三轴数据

 @param goback YES:需要返回上一级页面，NO:在本页面操作
 */
- (void)stopReadXYZData:(BOOL)goback{
    [[HCKHudManager share] showHUDWithTitle:@"Stoping..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [HCKBeaconInterface stopReadXYZDataWithSucBlock:^(id returnData) {
        [[HCKHudManager share] hide];
        if (goback) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            return ;
        }
        weakSelf.rightButton.selected = NO;
        [weakSelf.rightButton setTitle:@"Start" forState:UIControlStateNormal];
    } failedBlock:^(NSError *error) {
        [[HCKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)loadSubViews{
    [self.rightButton setTitle:@"Start" forState:UIControlStateNormal];
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}


#pragma mark - setter & getter

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.textColor = DEFAULT_TEXT_COLOR;
        _textView.font = HCKFont(13.f);
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.layoutManager.allowsNonContiguousLayout = NO;
        _textView.editable = NO;
    }
    return _textView;
}

- (NSDateFormatter *)dateFormatter{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return _dateFormatter;
}

@end
