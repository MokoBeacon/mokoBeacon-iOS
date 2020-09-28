//
//  HCKSystemCell.m
//  HCKBeacon
//
//  Created by aa on 2017/10/31.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKSystemCell.h"

static NSString *const HCKSystemCellIdenty = @"HCKSystemCellIdenty";

@interface HCKSystemCell ()

@property (nonatomic, strong)UILabel *leftLabel;

@property (nonatomic, strong)UILabel *valueLabel;

@end

@implementation HCKSystemCell

+ (HCKSystemCell *)initCellWithTableView:(UITableView *)tableView{
    HCKSystemCell *cell = [tableView dequeueReusableCellWithIdentifier:HCKSystemCellIdenty];
    if (!cell) {
        cell = [[HCKSystemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HCKSystemCellIdenty];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.leftLabel];
        [self.contentView addSubview:self.valueLabel];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.leftLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(120);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(HCKFont(14).lineHeight);
    }];
    
    CGSize size = [NSString sizeWithText:self.valueLabel.text
                                 andFont:self.valueLabel.font
                              andMaxSize:CGSizeMake(kScreenWidth - 2 * 15.f - 120 - 40, MAXFLOAT)];
    [self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.left.mas_equalTo(self.leftLabel.mas_right).mas_offset(40);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(size.height);
    }];
}

#pragma mark - Public method
- (void)setDataModel:(HCKSystemModel *)dataModel{
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    if (!ValidStr(_dataModel.titleString)) {
        return;
    }
    self.leftLabel.text = _dataModel.titleString;
    self.valueLabel.text = _dataModel.valueString;
    [self setNeedsLayout];
}

#pragma mark - setter & getter

- (UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.textColor = DEFAULT_TEXT_COLOR;
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.font = HCKFont(14.f);
    }
    return _leftLabel;
}

- (UILabel *)valueLabel{
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.textAlignment = NSTextAlignmentRight;
        _valueLabel.textColor = DEFAULT_TEXT_COLOR;
        _valueLabel.font = HCKFont(14.f);
        _valueLabel.numberOfLines = 0;
    }
    return _valueLabel;
}

@end
