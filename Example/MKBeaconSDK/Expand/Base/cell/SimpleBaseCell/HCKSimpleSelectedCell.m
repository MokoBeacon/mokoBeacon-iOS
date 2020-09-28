//
//  HCKSimpleSelectedCell.m
//  FitPolo
//
//  Created by aa on 17/5/8.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKSimpleSelectedCell.h"

/*
    左侧lable+右侧选中按钮
 */

@interface HCKSimpleSelectedCell ()

/**
 左侧lable
 */
@property (nonatomic, strong) UILabel *cellTextLabel;

/**
 右侧图标
 */
@property (nonatomic, strong) UIImageView *rightIcon;

/**
 浮层按钮
 */
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation HCKSimpleSelectedCell

+ (instancetype)initCellWithTableView:(UITableView *)tableView
                      reuseIdentifier:(NSString *)reuseIdentifier{
    HCKSimpleSelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[HCKSimpleSelectedCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.cellTextLabel];
        [self.contentView addSubview:self.rightIcon];
        [self.contentView addSubview:self.backButton];
    }
    return self;
}

#pragma mark - 覆盖父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.cellTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(HCKFont(16).lineHeight);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    [super layoutSubviews];
}

#pragma mark - Private Method
- (void)cellSelected{
    self.backButton.selected = !self.backButton.selected;
    if (self.cellSelectedBlock) {
        self.cellSelectedBlock(self.indexPath, self.backButton.selected);
    }
}
#pragma mark - setter && getter

- (void)setDataModel:(HCKSimpleSelectedModel *)dataModel{
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    if (ValidStr(dataModel.msgString)) {
        self.cellTextLabel.text = dataModel.msgString;
    }
    self.backButton.selected = dataModel.selected;
    if (dataModel.selected) {
        [self.rightIcon setHidden:NO];
    }else{
        [self.rightIcon setHidden:YES];
    }
}

- (UILabel *)cellTextLabel{
    if (!_cellTextLabel) {
        _cellTextLabel = [[UILabel alloc] init];
        _cellTextLabel.backgroundColor = COLOR_CLEAR_MACROS;
        _cellTextLabel.font = HCKFont(16);
        _cellTextLabel.textColor = DEFAULT_TEXT_COLOR;
        _cellTextLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _cellTextLabel;
}

- (UIImageView *)rightIcon{
    if (!_rightIcon) {
        _rightIcon = [[UIImageView alloc] init];
        _rightIcon.image = LOADIMAGE(@"cellRight_selected_pic", @"png");
        _rightIcon.backgroundColor = COLOR_CLEAR_MACROS;
    }
    return _rightIcon;
}

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.backgroundColor = COLOR_CLEAR_MACROS;
        [_backButton addTarget:self
                        action:@selector(cellSelected)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

@end
