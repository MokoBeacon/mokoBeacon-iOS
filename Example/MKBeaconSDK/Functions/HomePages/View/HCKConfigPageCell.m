//
//  HCKConfigPageCell.m
//  HCKBeacon
//
//  Created by aa on 2017/10/31.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKConfigPageCell.h"

static NSString *const HCKConfigPageCellIdenty = @"HCKConfigPageCellIdenty";

@interface HCKConfigPageCell ()

@property (nonatomic, strong)UILabel *functionLabel;

@property (nonatomic, strong)UILabel *valueLabel;

@property (nonatomic, strong)UIImageView *rightIcon;

@end

@implementation HCKConfigPageCell

+ (HCKConfigPageCell *)initCellWithTableView:(UITableView *)tableView{
    HCKConfigPageCell *cell = [tableView dequeueReusableCellWithIdentifier:HCKConfigPageCellIdenty];
    if (!cell) {
        cell = [[HCKConfigPageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HCKConfigPageCellIdenty];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.functionLabel];
        [self.contentView addSubview:self.valueLabel];
        [self.contentView addSubview:self.rightIcon];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.functionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(145);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(HCKFont(14).lineHeight);
    }];
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.rightIcon.mas_left).mas_offset(-20);
        make.left.mas_equalTo(self.functionLabel.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(HCKFont(13).lineHeight);
    }];
    [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(8);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(13);
    }];
}

#pragma mark - Public method
- (void)setDataModel:(HCKConfigPageModel *)dataModel{
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    if (ValidStr(_dataModel.function)) {
        self.functionLabel.text = _dataModel.function;
    }
    [self.rightIcon setHidden:!_dataModel.clickEnable];
    if (!ValidStr(_dataModel.value)) {
        [self.valueLabel setHidden:YES];
        return;
    }
    [self.valueLabel setHidden:NO];
    self.valueLabel.text = _dataModel.value;
}

#pragma mark - setter & getter
- (UILabel *)functionLabel{
    if (!_functionLabel) {
        _functionLabel = [[UILabel alloc] init];
        _functionLabel.textColor = DEFAULT_TEXT_COLOR;
        _functionLabel.textAlignment = NSTextAlignmentLeft;
        _functionLabel.font = HCKFont(13);
    }
    return _functionLabel;
}

- (UILabel *)valueLabel{
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.textAlignment = NSTextAlignmentRight;
        _valueLabel.textColor = DEFAULT_TEXT_COLOR;
        _valueLabel.font = HCKFont(13);
    }
    return _valueLabel;
}

- (UIImageView *)rightIcon{
    if (!_rightIcon) {
        _rightIcon = [[UIImageView alloc] init];
        _rightIcon.image = LOADIMAGE(@"goto_next_button", @"png");
    }
    return _rightIcon;
}

@end
