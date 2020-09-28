//
//  HCKSetBeaconNameController.m
//  HCKBeacon
//
//  Created by aa on 2017/11/1.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKSetBeaconNameController.h"

@interface HCKSetBeaconNameController ()

@end

@implementation HCKSetBeaconNameController

#pragma mark - life circle
- (void)dealloc{
    NSLog(@"HCKSetBeaconNameController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.noteLabel setText:(!self.supportXYZData ? LS(@"HCKSetBeaconNameController_note") : LS(@"HCKSetBeaconNameController_xzyNot"))];
    CGSize size = [NSString sizeWithText:self.noteLabel.text
                                 andFont:self.noteLabel.font
                              andMaxSize:CGSizeMake(kScreenWidth - 2 * 25, MAXFLOAT)];
    [self.noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.top.mas_equalTo(self.textField.mas_bottom).mas_offset(21);
        make.height.mas_equalTo(size.height);
    }];
    [self.textField setText:[HCKGlobalBeaconData share].beaconName];
    // Do any additional setup after loading the view.
}

#pragma mark - 父类方法
- (NSString *)defaultTitle{
    return LS(@"HCKSetBeaconNameController_title");
}

- (void)textValueChanged{
    NSString *tempInputString = self.textField.text;
    if (!ValidStr(tempInputString)) {
        self.textField.text = @"";
        return;
    }
    NSString *newInput = [tempInputString substringWithRange:NSMakeRange(tempInputString.length - 1, 1)];
    //只能是ascii字符
    BOOL correct = [newInput asciiIsValidate];
    NSString *sourceString = (correct ? tempInputString : [tempInputString substringWithRange:NSMakeRange(0, tempInputString.length - 1)]);
    NSInteger maxLen = (!self.supportXYZData ? 10 : 4);
    self.textField.text = (sourceString.length > maxLen ? [sourceString substringToIndex:maxLen] : sourceString);
}

-(void)rightButtonMethod{
    if ([self.textField.text isEqualToString:[HCKGlobalBeaconData share].beaconName]) {
        [self leftButtonMethod];
        return;
    }
    [[HCKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [HCKBeaconInterface setBeaconName:self.textField.text sucBlock:^(id returnData) {
        [[HCKHudManager share] hide];
        [HCKGlobalBeaconData share].beaconName = @"";
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
