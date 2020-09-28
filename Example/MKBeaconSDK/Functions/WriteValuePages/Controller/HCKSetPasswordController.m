//
//  HCKSetPasswordController.m
//  HCKBeacon
//
//  Created by aa on 2017/11/2.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKSetPasswordController.h"

@interface HCKSetPasswordController ()

@property (nonatomic, strong)UILabel *inputPasswordLabel;

@property (nonatomic, strong)UILabel *confirmLabel;

@property (nonatomic, strong)UITextField *passwordTextField;

@property (nonatomic, strong)UITextField *confirmTextField;

@property (nonatomic, strong)UILabel *noteLabel;

@end

@implementation HCKSetPasswordController

#pragma mark - life circle
- (void)dealloc{
    NSLog(@"HCKSetPasswordController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.rightButton setImage:LOADIMAGE(@"setBeaconDataSaveIcon", @"png") forState:UIControlStateNormal];
    [self.view setBackgroundColor:RGBCOLOR(242, 242, 242)];
    [self loadSubViews];
    // Do any additional setup after loading the view.
}

#pragma mark - 父类方法
- (NSString *)defaultTitle{
    return LS(@"HCKSetPasswordController_title");
}

- (void)rightButtonMethod{
    NSString *password = self.passwordTextField.text;
    NSString *confirmpassword = self.confirmTextField.text;
    if (!ValidStr(password) || !ValidStr(confirmpassword) || ![password isEqualToString:confirmpassword] || password.length != 8 || confirmpassword.length != 8) {
        [self.view showCentralToast:@"param error"];
        return;
    }
    
    [[HCKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [HCKBeaconInterface setBeaconPassword:password sucBlock:^(id returnData) {
        [[HCKHudManager share] hide];
        [weakSelf setPasswordResult:returnData];
    } failedBlock:^(NSError *error) {
        [[HCKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)setPasswordResult:(id)returnData{
    if (!ValidDict(returnData)) {
        [self.view showCentralToast:@"Set password failed"];
        return;
    }
    NSString *result = returnData[@"result"][@"result"];
    if (!ValidStr(result) || ![result isEqualToString:@"02"]) {
        //只有返回了02才算是设置成功
        [self.view showCentralToast:@"Set password failed"];
        return;
    }
    [self.view showCentralToast:@"success"];
    [self performSelector:@selector(backAction)
               withObject:nil
               afterDelay:0.5];
}

#pragma mark - Private method

- (void)textValueChanged:(UITextField *)field{
    NSString *tempInputString = field.text;
    if (!ValidStr(tempInputString)) {
        field.text = @"";
        return;
    }
    NSString *newInput = [tempInputString substringWithRange:NSMakeRange(tempInputString.length - 1, 1)];
    BOOL correct = [newInput asciiIsValidate];
    NSString *sourceString = (correct ? tempInputString : [tempInputString substringWithRange:NSMakeRange(0, tempInputString.length - 1)]);
    field.text = (sourceString.length > 8 ? [sourceString substringToIndex:8] : sourceString);
}

- (void)backAction{
    //因为修改密码之后需要返回扫描列表页面，所以需要断开连接
    [[HCKBeaconCentralManager sharedInstance] disconnectConnectedPeripheral];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)loadSubViews{
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = COLOR_WHITE_MACROS;
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(200);
    }];
    [backView addSubview:self.inputPasswordLabel];
    [self.inputPasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(HCKFont(15).lineHeight);
    }];
    [backView addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.inputPasswordLabel.mas_bottom).mas_offset(18);
        make.height.mas_equalTo(30);
    }];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = CUTTING_LINE_COLOR;
    [backView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.passwordTextField.mas_bottom);
        make.height.mas_equalTo(CUTTING_LINE_HEIGHT);
    }];
    [backView addSubview:self.confirmLabel];
    [self.confirmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(lineView.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(HCKFont(15).lineHeight);
    }];
    [backView addSubview:self.confirmTextField];
    [self.confirmTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.confirmLabel.mas_bottom).mas_offset(18);
        make.height.mas_equalTo(30);
    }];
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = CUTTING_LINE_COLOR;
    [backView addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.confirmTextField.mas_bottom);
        make.height.mas_equalTo(CUTTING_LINE_HEIGHT);
    }];
    [self.view addSubview:self.noteLabel];
    CGSize size = [NSString sizeWithText:self.noteLabel.text
                                 andFont:self.noteLabel.font
                              andMaxSize:CGSizeMake(kScreenWidth - 2 * 15, MAXFLOAT)];
    [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(backView.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(size.height);
    }];
}

- (UILabel *)msgLabel{
    UILabel *msgLabel = [[UILabel alloc] init];
    msgLabel.textColor = RGBCOLOR(86, 145, 252);
    msgLabel.textAlignment = NSTextAlignmentLeft;
    msgLabel.font = HCKFont(15);
    return msgLabel;
}

- (UITextField *)textField{
    UITextField *textField = [[UITextField alloc] init];
    textField.borderStyle = UITextBorderStyleNone;
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.textColor = DEFAULT_TEXT_COLOR;
    textField.font = HCKFont(14.f);
    [textField addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];
    return textField;
}

#pragma mark - setter & getter
- (UILabel *)inputPasswordLabel{
    if (!_inputPasswordLabel) {
        _inputPasswordLabel = [self msgLabel];
        _inputPasswordLabel.text = LS(@"HCKSetPasswordController_msg1");
    }
    return _inputPasswordLabel;
}

- (UITextField *)passwordTextField{
    if (!_passwordTextField) {
        _passwordTextField = [self textField];
        _passwordTextField.attributedPlaceholder = [HCKAttributedStringManager getAttributedString:@[LS(@"HCKSetPasswordController_msg2")] fonts:@[HCKFont(15.f)] colors:@[RGBCOLOR(222, 222, 222)]];
    }
    return _passwordTextField;
}

- (UILabel *)confirmLabel{
    if (!_confirmLabel) {
        _confirmLabel = [self msgLabel];
        _confirmLabel.text = LS(@"HCKSetPasswordController_msg3");
    }
    return _confirmLabel;
}

- (UITextField *)confirmTextField{
    if (!_confirmTextField) {
        _confirmTextField = [self textField];
        _confirmTextField.attributedPlaceholder = [HCKAttributedStringManager getAttributedString:@[LS(@"HCKSetPasswordController_msg4")] fonts:@[HCKFont(15.f)] colors:@[RGBCOLOR(222, 222, 222)]];
    }
    return _confirmTextField;
}

- (UILabel *)noteLabel{
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.backgroundColor = COLOR_CLEAR_MACROS;
        _noteLabel.textAlignment = NSTextAlignmentLeft;
        _noteLabel.textColor = RGBCOLOR(115, 115, 115);
        _noteLabel.font = HCKFont(14);
        _noteLabel.numberOfLines = 0;
        _noteLabel.text = LS(@"HCKSetPasswordController_note");
    }
    return _noteLabel;
}

@end
