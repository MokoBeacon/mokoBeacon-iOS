/*
    下面标签上面输入框
 */

#import "HCKBaseSimpleTextFieldController.h"

@interface HCKBaseSimpleTextFieldController ()

@end

@implementation HCKBaseSimpleTextFieldController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.rightButton setImage:LOADIMAGE(@"setBeaconDataSaveIcon", @"png") forState:UIControlStateNormal];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.noteLabel];
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.top.mas_equalTo(40);
        make.height.mas_equalTo(30.f);
    }];
    [self.noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.top.mas_equalTo(self.textField.mas_bottom).mas_offset(21);
        make.bottom.mas_equalTo(-40);
    }];
    // Do any additional setup after loading the view.
}

#pragma mark - Private method
- (void)textValueChanged{
    
}

#pragma mark - setter & getter
- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.keyboardType = UIKeyboardTypeASCIICapable;
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

- (UILabel *)noteLabel{
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.textAlignment = NSTextAlignmentLeft;
        _noteLabel.textColor = RGBCOLOR(115, 115, 115);
        _noteLabel.font = HCKFont(14.f);
        _noteLabel.numberOfLines = 0;
    }
    return _noteLabel;
}

@end
