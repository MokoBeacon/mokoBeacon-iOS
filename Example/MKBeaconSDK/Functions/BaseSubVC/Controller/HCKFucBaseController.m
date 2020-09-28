/*
    所有从设备信息页面推出的下一级页面的父类，方便监控
 */

#import "HCKFucBaseController.h"

@interface HCKFucBaseController ()

@end

@implementation HCKFucBaseController

#pragma mark - life circle
- (void)dealloc{
    NSLog(@"HCKFucBaseController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:peripheralConnectStateChangedNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peripheralConnecteStatusChanged)
                                                 name:peripheralConnectStateChangedNotification
                                               object:nil];
    // Do any additional setup after loading the view.
}

#pragma mark - Private method
- (void)peripheralConnecteStatusChanged{
    if ([HCKBeaconCentralManager sharedInstance].connectStatus != HCKBeaconConnectStatusConnected) {
        //非连接状态，直接返回上一级页面
        [self.view showCentralToast:LS(@"HCKConfigurationPageController_disconnect")];
        [self performSelector:@selector(backToConfigVC) withObject:nil afterDelay:0.5];
    }
}

- (void)backToConfigVC{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"HCKConfigurationPageController")]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}

@end
