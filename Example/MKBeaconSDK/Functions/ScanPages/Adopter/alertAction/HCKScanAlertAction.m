//
//  HCKScanAlertAction.m
//  HCKBeacon
//
//  Created by aa on 2018/5/9.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import "HCKScanAlertAction.h"

@interface HCKScanAlertAction()

@property (nonatomic, copy)NSString *password;

@end

@implementation HCKScanAlertAction

- (void)showOpenBleAlert{
    if (kSystemVersion <= 11.0 && [HCKBeaconCentralManager sharedInstance].managerState == HCKBeaconCentralManagerStateUnable) {
        //对于iOS11以上的系统，打开app的时候，如果蓝牙未打开，弹窗提示，后面系统蓝牙状态再发生改变就不需要弹窗了
        NSString *msg = @"The current system of bluetooth is not available!";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Dismiss"
                                                                                 message:msg
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertController addAction:okAction];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)showPasswordAlertTarget:(UIViewController *)targetVC completeCallback:(void (^)(NSString *password))callback{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LS(@"HCKScanViewController_alertTitle")
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"8 characters";
        if (ValidStr(self.localPassword)) {
            textField.text = self.localPassword;
            self.password = self.localPassword;
        }
        [textField addTarget:self action:@selector(passwordChanged:) forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LS(@"HCKScanViewController_cancel") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    WS(weakSelf);
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:LS(@"HCKScanViewController_ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (!ValidStr(weakSelf.password)) {
            [targetVC.view showCentralToast:LS(@"HCKScanViewController_errorMsg")];
            return ;
        }
        if (weakSelf.password.length != 8) {
            [targetVC.view showCentralToast:LS(@"HCKScanViewController_passwordError")];
            return ;
        }
        if (callback) {
            callback(weakSelf.password);
        }
    }];
    [alertController addAction:moreAction];
    [targetVC presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -
- (void)passwordChanged:(UITextField *)textField{
    NSString *password = textField.text;
    if (!ValidStr(password)) {
        textField.text = @"";
        self.password = @"";
        return;
    }
    NSString *newInput = [password substringWithRange:NSMakeRange(password.length - 1, 1)];
    //只能是字母、数字
    BOOL correct = [newInput asciiIsValidate];
    NSString *sourceString = (correct ? password : [password substringWithRange:NSMakeRange(0, password.length - 1)]);
    textField.text = (sourceString.length > 8 ? [sourceString substringToIndex:8] : sourceString);
    self.password = textField.text;
}

@end
