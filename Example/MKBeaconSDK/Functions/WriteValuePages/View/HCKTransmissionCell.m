//
//  HCKTransmissionCell.m
//  HCKBeacon
//
//  Created by aa on 2017/11/2.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKTransmissionCell.h"

@interface HCKTransmissionCell ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UILabel *powerLabel;

@property (nonatomic, strong)UILabel *radiusLabel;

@end

@implementation HCKTransmissionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.titleLabel];
        [self.backView addSubview:self.powerLabel];
//        [self.backView addSubview:self.radiusLabel];
        [self.contentView addTapAction:self selector:@selector(cellDidSelected)];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(8);
        make.height.mas_equalTo(HCKFont(15).lineHeight);
    }];
    [self.powerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(9);
        make.height.mas_equalTo(HCKFont(12).lineHeight);
    }];
//    [self.radiusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.top.mas_equalTo(self.powerLabel.mas_bottom).mas_offset(5);
//        make.height.mas_equalTo(HCKFont(12).lineHeight);
//    }];
}

#pragma mark - Private method
- (void)cellDidSelected{
    if (self.cellDidSelectedBlock) {
        self.cellDidSelectedBlock(self.indexPath);
    }
}

#pragma mark - Public method
- (void)setDataModel:(HCKTransmissionModel *)dataModel{
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    self.titleLabel.text = _dataModel.title;
    self.powerLabel.text = _dataModel.power;
    self.radiusLabel.text = _dataModel.radius;
    self.backView.backgroundColor = (_dataModel.selected ? RGBCOLOR(86, 145, 252) : RGBCOLOR(242, 242, 242));
    self.titleLabel.textColor = (_dataModel.selected ? COLOR_WHITE_MACROS : RGBCOLOR(86, 145, 252));
    self.powerLabel.textColor = (_dataModel.selected ? COLOR_WHITE_MACROS : RGBCOLOR(166, 166, 166));
    self.radiusLabel.textColor = (_dataModel.selected ? COLOR_WHITE_MACROS : RGBCOLOR(166, 166, 166));
}

#pragma mark - setter & getter
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.layer.masksToBounds = YES;
        _backView.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
        _backView.layer.borderWidth = 0.5f;
        _backView.layer.cornerRadius = 5.f;
    }
    return _backView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = RGBCOLOR(86, 145, 252);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = HCKFont(15.f);
    }
    return _titleLabel;
}

- (UILabel *)powerLabel{
    if (!_powerLabel) {
        _powerLabel = [[UILabel alloc] init];
        _powerLabel.textColor = RGBCOLOR(166, 166, 166);
        _powerLabel.textAlignment = NSTextAlignmentCenter;
        _powerLabel.font = HCKFont(12.f);
    }
    return _powerLabel;
}

- (UILabel *)radiusLabel{
    if (!_radiusLabel) {
        _radiusLabel = [[UILabel alloc] init];
        _radiusLabel.textColor = RGBCOLOR(166, 166, 166);
        _radiusLabel.textAlignment = NSTextAlignmentCenter;
        _radiusLabel.font = HCKFont(12.f);
    }
    return _radiusLabel;
}

@end
