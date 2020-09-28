//
//  HCKSetMeasurePowerController.m
//  HCKBeacon
//
//  Created by aa on 2017/11/1.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKSetMeasurePowerController.h"

@interface HCKSetMeasurePowerController ()

@property (nonatomic, strong)UILabel *negativeNumLabel;

@property (nonatomic, strong)UILabel *unitLabel;

@end

@implementation HCKSetMeasurePowerController

#pragma mark - life circle
- (void)dealloc{
    NSLog(@"HCKSetMeasurePowerController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.negativeNumLabel];
    [self.view addSubview:self.unitLabel];
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(60);
        make.top.mas_equalTo(40);
        make.height.mas_equalTo(30);
    }];
    [self.negativeNumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.textField.mas_left).mas_offset(-5);
        make.width.mas_equalTo(10);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
        make.height.mas_equalTo(HCKFont(14).lineHeight);
    }];
    [self.unitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textField.mas_right).mas_offset(5);
        make.width.mas_equalTo(30);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
        make.height.mas_equalTo(HCKFont(14).lineHeight);
    }];
    [self.textField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.textField setText:[HCKGlobalBeaconData share].measurePower];
    [self.noteLabel setText:LS(@"HCKSetMeasurePowerController_note")];
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

#pragma mark - 父类方法
- (NSString *)defaultTitle{
    return LS(@"HCKSetMeasurePowerController_title");
}

- (void)textValueChanged{
    NSString *tempInputString = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!ValidStr(tempInputString)) {
        self.textField.text = @"";
        return;
    }
    NSString *newInput = [tempInputString substringWithRange:NSMakeRange(tempInputString.length - 1, 1)];
    //只能是字母、数字
    BOOL correct = [newInput isRealNumbers];
    NSString *sourceString = (correct ? tempInputString : [tempInputString substringWithRange:NSMakeRange(0, tempInputString.length - 1)]);
    self.textField.text = stringFromInteger([sourceString integerValue]);
}

-(void)rightButtonMethod{
    NSString *measurePower = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!ValidStr(measurePower)) {
        [self.view showCentralToast:LS(@"HCKSetMeasurePowerController_error1")];
        return;
    }
    if (![measurePower isRealNumbers] || [measurePower integerValue] > 120) {
        [self.view showCentralToast:LS(@"HCKSetMeasurePowerController_error")];
        return;
    }
    
    if ([[HCKGlobalBeaconData share].measurePower isEqualToString:measurePower]) {
        //不需要修改
        [self leftButtonMethod];
        return;
    }
    
    [[HCKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [HCKBeaconInterface setBeaconMeasurePower:([[@"-" stringByAppendingString:measurePower] integerValue]) sucBlock:^(id returnData) {
        [[HCKHudManager share] hide];
        [HCKGlobalBeaconData share].measurePower = @"";
        [weakSelf.view showCentralToast:@"success"];
        [weakSelf performSelector:@selector(leftButtonMethod)
                       withObject:nil
                       afterDelay:0.5];
    } failedBlock:^(NSError *error) {
        [[HCKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - setter & getter
- (UILabel *)negativeNumLabel{
    if (!_negativeNumLabel) {
        _negativeNumLabel = [[UILabel alloc] init];
        _negativeNumLabel.textColor = DEFAULT_TEXT_COLOR;
        _negativeNumLabel.textAlignment = NSTextAlignmentRight;
        _negativeNumLabel.font = HCKFont(14.f);
        _negativeNumLabel.text = @"-";
    }
    return _negativeNumLabel;
}

- (UILabel *)unitLabel{
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.textColor = DEFAULT_TEXT_COLOR;
        _unitLabel.textAlignment = NSTextAlignmentLeft;
        _unitLabel.font = HCKFont(14.f);
        _unitLabel.text = @"dBm";
    }
    return _unitLabel;
}

@end
