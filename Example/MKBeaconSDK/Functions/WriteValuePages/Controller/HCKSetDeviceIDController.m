//
//  HCKSetDeviceIDController.m
//  HCKBeacon
//
//  Created by aa on 2017/11/1.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKSetDeviceIDController.h"

@interface HCKSetDeviceIDController ()

@end

@implementation HCKSetDeviceIDController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.textField setText:[HCKGlobalBeaconData share].deviceID];
    [self.noteLabel setText:LS(@"HCKSetDeviceIDController_note")];
    CGSize size = [NSString sizeWithText:self.noteLabel.text
                                 andFont:self.noteLabel.font
                              andMaxSize:CGSizeMake(kScreenWidth - 2 * 25, MAXFLOAT)];
    [self.noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.top.mas_equalTo(self.textField.mas_bottom).mas_offset(21);
        make.height.mas_equalTo(size.height);
    }];
    // Do any additional setup after loading the view.
}

- (NSString *)defaultTitle{
    return LS(@"HCKSetDeviceIDController_title");
}

- (void)textValueChanged{
    NSString *tempInputString = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!ValidStr(tempInputString)) {
        self.textField.text = @"";
        return;
    }
    
    NSString *newInput = [tempInputString substringWithRange:NSMakeRange(tempInputString.length - 1, 1)];
    //只能是数字
    BOOL correct = [newInput isRealNumbers];
    NSString *sourceString = (correct ? tempInputString : [tempInputString substringWithRange:NSMakeRange(0, tempInputString.length - 1)]);
    
    self.textField.text = (sourceString.length > 5 ? [sourceString substringToIndex:5] : sourceString);
}

-(void)rightButtonMethod{
    NSString *tempInputString = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!ValidStr(tempInputString)) {
        [self.view showCentralToast:LS(@"HCKSetDeviceIDController_error")];
        return;
    }
    if ([tempInputString isEqualToString:[HCKGlobalBeaconData share].deviceID]) {
        [self leftButtonMethod];
        return;
    }
    [[HCKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [HCKBeaconInterface setBeaconDeviceID:tempInputString sucBlock:^(id returnData) {
        [[HCKHudManager share] hide];
        [HCKGlobalBeaconData share].deviceID = @"";
        [weakSelf.view showCentralToast:@"success"];
        [weakSelf performSelector:@selector(leftButtonMethod)
                       withObject:nil
                       afterDelay:0.5];
    } failedBlock:^(NSError *error) {
        [[HCKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

@end
