//
//  HCKBroadcastCycleCell.m
//  HCKBeacon
//
//  Created by aa on 2017/11/2.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBroadcastCycleCell.h"

@interface HCKBroadcastCycleCell ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UILabel *titleLabel;

@end

@implementation HCKBroadcastCycleCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.titleLabel];
        [self.contentView addTapAction:self selector:@selector(cellDidSelected)];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.backView);
    }];
}

#pragma mark - Private method
- (void)cellDidSelected{
    if (self.cellDidSelectedBlock) {
        self.cellDidSelectedBlock(self.indexPath);
    }
}

#pragma mark - Public method
- (void)setDataModel:(HCKBroadcastCycleModel *)dataModel{
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    self.titleLabel.text = _dataModel.title;
    self.backView.backgroundColor = (_dataModel.selected ? RGBCOLOR(86, 145, 252) : COLOR_WHITE_MACROS);
    self.titleLabel.textColor = (_dataModel.selected ? COLOR_WHITE_MACROS : RGBCOLOR(86, 145, 252));
}

#pragma mark - setter & getter
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.layer.masksToBounds = YES;
        _backView.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
        _backView.layer.borderWidth = CUTTING_LINE_HEIGHT;
        _backView.layer.cornerRadius = 17.f;
    }
    return _backView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = COLOR_CLEAR_MACROS;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = HCKFont(15.f);
    }
    return _titleLabel;
}

@end
