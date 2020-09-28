//
//  HCKBroadcastCycleFooterView.m
//  HCKBeacon
//
//  Created by aa on 2017/11/2.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBroadcastCycleFooterView.h"

static NSString *const HCKBroadcastCycleFooterViewIdenty = @"HCKBroadcastCycleFooterViewIdenty";

@interface HCKBroadcastCycleFooterView ()

@property (nonatomic, strong)UILabel *inputLabel;

@property (nonatomic, strong)UITextField *textField;

@property (nonatomic, strong)UILabel *unitLabel;

@property (nonatomic, strong)UILabel *noteLabel;

@end

@implementation HCKBroadcastCycleFooterView

/* 获取底部视图对象 */
+ (instancetype)footerViewWithCollectionView:(UICollectionView *)collectionView
                                forIndexPath:(NSIndexPath *)indexPath
{
    //从缓存池中寻找底部视图对象，如果没有，该方法自动调用alloc/initWithFrame创建一个新的底部视图返回
    HCKBroadcastCycleFooterView *footerView =
    [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                       withReuseIdentifier:HCKBroadcastCycleFooterViewIdenty
                                              forIndexPath:indexPath];
    return footerView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.inputLabel];
        [self addSubview:self.textField];
        [self addSubview:self.unitLabel];
        [self addSubview:self.noteLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(80);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(30);
    }];
    [self.inputLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.textField.mas_left).mas_offset(-8);
        make.width.mas_equalTo(80);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
        make.height.mas_equalTo(HCKFont(14).lineHeight);
    }];
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textField.mas_right).mas_offset(8);
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
        make.height.mas_equalTo(HCKFont(14).lineHeight);
    }];
    CGSize size = [NSString sizeWithText:self.noteLabel.text
                                 andFont:self.noteLabel.font
                              andMaxSize:CGSizeMake(kScreenWidth - 2 * 20, MAXFLOAT)];
    [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-5);
        make.height.mas_equalTo(size.height);
    }];
}

#pragma mark - Private method
- (void)textValueChanged{
    NSString *tempInputString = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!ValidStr(tempInputString)) {
        self.textField.text = @"";
        if (self.inputBroadcastCycleBlock) {
            self.inputBroadcastCycleBlock(@"");
        }
        return;
    }
    NSString *newInput = [tempInputString substringWithRange:NSMakeRange(tempInputString.length - 1, 1)];
    //只能是字母、数字
    BOOL correct = [newInput isRealNumbers];
    NSString *sourceString = (correct ? tempInputString : [tempInputString substringWithRange:NSMakeRange(0, tempInputString.length - 1)]);
    self.textField.text = stringFromInteger([sourceString integerValue]);
    if (self.inputBroadcastCycleBlock) {
        self.inputBroadcastCycleBlock(stringFromInteger([sourceString integerValue]));
    }
}

#pragma mark - Public method
- (void)setTextValue:(NSString *)textValue{
    _textValue = nil;
    _textValue = textValue;
    if (!ValidStr(_textValue)) {
        return;
    }
    self.textField.text = _textValue;
}

#pragma mark - setter & getter

- (UILabel *)inputLabel{
    if (!_inputLabel) {
        _inputLabel = [[UILabel alloc] init];
        _inputLabel.textAlignment = NSTextAlignmentRight;
        _inputLabel.textColor = RGBCOLOR(86, 145, 252);
        _inputLabel.font = HCKFont(14);
        _inputLabel.text = LS(@"HCKBroadcastCycleFooterView_msg1");
    }
    return _inputLabel;
}

-(UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.textColor = DEFAULT_TEXT_COLOR;
        _textField.font = HCKFont(14.f);
        _textField.backgroundColor = RGBCOLOR(230, 230, 230);
        _textField.attributedPlaceholder = [HCKAttributedStringManager getAttributedString:@[@"1~100"] fonts:@[HCKFont(15.f)] colors:@[RGBCOLOR(222, 222, 222)]];
        [_textField addTarget:self action:@selector(textValueChanged) forControlEvents:UIControlEventEditingChanged];
        _textField.text = [HCKGlobalBeaconData share].broadcastInterval;
        
        _textField.layer.masksToBounds = YES;
        _textField.layer.borderColor = COLOR_CLEAR_MACROS.CGColor;
        _textField.layer.borderWidth = 0.5f;
        _textField.layer.cornerRadius = 15.f;
    }
    return _textField;
}

- (UILabel *)unitLabel{
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.textAlignment = NSTextAlignmentLeft;
        _unitLabel.textColor = RGBCOLOR(115, 115, 115);
        _unitLabel.font = HCKFont(14);
        _unitLabel.text = LS(@"HCKBroadcastCycleFooterView_unit");
    }
    return _unitLabel;
}

- (UILabel *)noteLabel{
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.backgroundColor = COLOR_CLEAR_MACROS;
        _noteLabel.textAlignment = NSTextAlignmentLeft;
        _noteLabel.textColor = RGBCOLOR(115, 115, 115);
        _noteLabel.font = HCKFont(14.f);
        _noteLabel.numberOfLines = 0;
        _noteLabel.text = LS(@"HCKBroadcastCycleFooterView_note");
    }
    return _noteLabel;
}

@end
