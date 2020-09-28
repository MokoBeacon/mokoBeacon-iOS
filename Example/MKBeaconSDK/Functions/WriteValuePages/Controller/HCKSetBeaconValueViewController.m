//
//  HCKSetBeaconValueViewController.m
//  HCKBeacon
//
//  Created by aa on 2017/11/2.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKSetBeaconValueViewController.h"

@interface HCKSetBeaconValueViewController ()

@property (nonatomic, strong)UITextField *textField;

@property (nonatomic, strong)UILabel *decimalValueLabel;

@property (nonatomic, strong)UILabel *hexValueLabel;

@property (nonatomic, strong)UILabel *noteLabel;

@end

@implementation HCKSetBeaconValueViewController

#pragma mark - life circle
- (void)dealloc{
    NSLog(@"HCKSetBeaconValueViewController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.rightButton setImage:LOADIMAGE(@"setBeaconDataSaveIcon", @"png") forState:UIControlStateNormal];
    [self.view setBackgroundColor:RGBCOLOR(242, 242, 242)];
    [self loadSubViews];
    NSString *valueString = (self.valueType == HCKSetMajorValue ? [HCKGlobalBeaconData share].major : [HCKGlobalBeaconData share].minor);
    self.textField.text = valueString;
    self.decimalValueLabel.text = valueString;
    self.hexValueLabel.text = [NSString stringWithFormat:@"%1lx",(unsigned long)[valueString integerValue]];
    // Do any additional setup after loading the view.
}

#pragma mark - 父类方法
- (NSString *)defaultTitle{
    return (self.valueType == HCKSetMajorValue ? @"MAJOR" : @"MINOR");
}

- (void)rightButtonMethod{
    NSString *tempInputString = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!ValidStr(tempInputString)) {
        [self.view showCentralToast:LS(@"HCKSetBeaconValueViewController_error")];
        return;
    }
    if (![tempInputString isRealNumbers] || [tempInputString integerValue] < 0 || [tempInputString integerValue] > 65535) {
        [self.view showCentralToast:LS(@"HCKSetBeaconValueViewController_scopeError")];
        return;
    }
    [[HCKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    if (self.valueType == HCKSetMajorValue) {
        if ([[HCKGlobalBeaconData share].major isEqualToString:tempInputString]) {
            //没有修改
            [self leftButtonMethod];
            return;
        }
        //主值
        [HCKBeaconInterface setBeaconMajor:[tempInputString integerValue] sucBlock:^(id returnData) {
            [[HCKHudManager share] hide];
            [HCKGlobalBeaconData share].major = @"";
            [weakSelf.view showCentralToast:@"success"];
            [weakSelf performSelector:@selector(leftButtonMethod) withObject:nil afterDelay:0.5];
        } failedBlock:^(NSError *error) {
            [[HCKHudManager share] hide];
            [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
        }];
        return;
    }
    
    if ([[HCKGlobalBeaconData share].minor isEqualToString:tempInputString]) {
        //不需要修改
        [self leftButtonMethod];
        return;
    }
    [HCKBeaconInterface setBeaconMinor:[tempInputString integerValue] sucBlock:^(id returnData) {
        [[HCKHudManager share] hide];
        [HCKGlobalBeaconData share].minor = @"";
        [weakSelf.view showCentralToast:@"success"];
        [weakSelf performSelector:@selector(leftButtonMethod) withObject:nil afterDelay:0.5];
    } failedBlock:^(NSError *error) {
        [[HCKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - Private method
- (void)textValueChanged{
    NSString *tempInputString = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!ValidStr(tempInputString)) {
        self.textField.text = @"";
        self.hexValueLabel.attributedText = [HCKAttributedStringManager getAttributedString:@[LS(@"HCKSetBeaconValueViewController_hex2")]
                                                                                      fonts:@[HCKFont(14)]
                                                                                     colors:@[RGBCOLOR(217, 217, 217)]];
        self.decimalValueLabel.attributedText = [HCKAttributedStringManager getAttributedString:@[LS(@"HCKSetBeaconValueViewController_decimal")]
                                                                                          fonts:@[HCKFont(14)]
                                                                                         colors:@[RGBCOLOR(217, 217, 217)]];
        return;
    }
    NSString *newInput = [tempInputString substringWithRange:NSMakeRange(tempInputString.length - 1, 1)];
    //只能是字母、数字
    BOOL correct = [newInput isRealNumbers];
    NSString *sourceString = (correct ? tempInputString : [tempInputString substringWithRange:NSMakeRange(0, tempInputString.length - 1)]);
    if (!ValidStr(sourceString)) {
        self.textField.text = @"";
        self.hexValueLabel.attributedText = [HCKAttributedStringManager getAttributedString:@[LS(@"HCKSetBeaconValueViewController_hex2")]
                                                                                      fonts:@[HCKFont(14)]
                                                                                     colors:@[RGBCOLOR(217, 217, 217)]];
        self.decimalValueLabel.attributedText = [HCKAttributedStringManager getAttributedString:@[LS(@"HCKSetBeaconValueViewController_decimal")]
                                                                                          fonts:@[HCKFont(14)]
                                                                                         colors:@[RGBCOLOR(217, 217, 217)]];
        return;
    }
    //去掉最高位的0
    self.textField.text = stringFromInteger([sourceString integerValue]);
    self.decimalValueLabel.text = sourceString;
    self.hexValueLabel.text = [NSString stringWithFormat:@"%1lx",(unsigned long)[sourceString integerValue]];
}



- (void)loadSubViews{
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = COLOR_WHITE_MACROS;
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(170.f);
    }];
    
    [backView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(30);
    }];
    UILabel *noteDLabel = [[UILabel alloc] init];
    noteDLabel.textColor = RGBCOLOR(86, 145, 252);
    noteDLabel.textAlignment = NSTextAlignmentLeft;
    noteDLabel.font = HCKFont(15.f);
    noteDLabel.text = LS(@"HCKSetBeaconValueViewController_decimal");
    [backView addSubview:noteDLabel];
    [noteDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(120);
        make.top.mas_equalTo(self.textField.mas_bottom).mas_offset(30);
        make.height.mas_equalTo(HCKFont(15).lineHeight);
    }];
    [backView addSubview:self.decimalValueLabel];
    [self.decimalValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(noteDLabel.mas_right).mas_offset(20);
        make.centerY.mas_equalTo(noteDLabel.mas_centerY);
        make.height.mas_equalTo(HCKFont(14).lineHeight);
    }];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGBCOLOR(217, 217, 217);
    [backView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(noteDLabel.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(0.5);
    }];
    UILabel *noteHLabel = [[UILabel alloc] init];
    noteHLabel.textColor = RGBCOLOR(86, 145, 252);
    noteHLabel.textAlignment = NSTextAlignmentLeft;
    noteHLabel.font = HCKFont(15.f);
    noteHLabel.text = LS(@"HCKSetBeaconValueViewController_hex1");
    [backView addSubview:noteHLabel];
    [noteHLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(120);
        make.top.mas_equalTo(lineView.mas_bottom).mas_offset(25);
        make.height.mas_equalTo(HCKFont(15).lineHeight);
    }];
    [backView addSubview:self.hexValueLabel];
    [self.hexValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(noteHLabel).mas_offset(20);
        make.centerY.mas_equalTo(noteHLabel.mas_centerY);
        make.height.mas_equalTo(HCKFont(14).lineHeight);
    }];
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = RGBCOLOR(217, 217, 217);
    [backView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    [self.view addSubview:self.noteLabel];
    CGSize size = [NSString sizeWithText:self.noteLabel.text
                                 andFont:self.noteLabel.font
                              andMaxSize:CGSizeMake(kScreenWidth - 2 * 20, MAXFLOAT)];
    [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(backView.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(size.height);
    }];
}

#pragma mark - setter & getter

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.textColor = DEFAULT_TEXT_COLOR;
        _textField.font = HCKFont(14.f);
        _textField.backgroundColor = RGBCOLOR(230, 230, 230);
        [_textField addTarget:self action:@selector(textValueChanged) forControlEvents:UIControlEventEditingChanged];
        
        _textField.layer.masksToBounds = YES;
        _textField.layer.borderColor = COLOR_CLEAR_MACROS.CGColor;
        _textField.layer.borderWidth = 0.5f;
        _textField.layer.cornerRadius = 15.f;
    }
    return _textField;
}

- (UILabel *)decimalValueLabel{
    if (!_decimalValueLabel) {
        _decimalValueLabel = [[UILabel alloc] init];
        _decimalValueLabel.textAlignment = NSTextAlignmentRight;
        _decimalValueLabel.textColor = RGBCOLOR(86, 145, 252);
        _decimalValueLabel.font = HCKFont(14.f);
        _decimalValueLabel.attributedText = [HCKAttributedStringManager getAttributedString:@[LS(@"HCKSetBeaconValueViewController_decimal")]
                                                                                      fonts:@[HCKFont(14)]
                                                                                     colors:@[RGBCOLOR(217, 217, 217)]];
    }
    return _decimalValueLabel;
}

- (UILabel *)hexValueLabel{
    if (!_hexValueLabel) {
        _hexValueLabel = [[UILabel alloc] init];
        _hexValueLabel.textAlignment = NSTextAlignmentRight;
        _hexValueLabel.textColor = RGBCOLOR(86, 145, 252);
        _hexValueLabel.font = HCKFont(14.f);
        _hexValueLabel.attributedText = [HCKAttributedStringManager getAttributedString:@[LS(@"HCKSetBeaconValueViewController_hex2")]
                                                                                  fonts:@[HCKFont(14)]
                                                                                 colors:@[RGBCOLOR(217, 217, 217)]];
    }
    return _hexValueLabel;
}

- (UILabel *)noteLabel{
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.backgroundColor = COLOR_CLEAR_MACROS;
        _noteLabel.textAlignment = NSTextAlignmentLeft;
        _noteLabel.textColor = RGBCOLOR(115, 115, 115);
        _noteLabel.font = HCKFont(14.f);
        _noteLabel.numberOfLines = 0;
        _noteLabel.text = LS(@"HCKSetBeaconValueViewController_note");
    }
    return _noteLabel;
}

@end
