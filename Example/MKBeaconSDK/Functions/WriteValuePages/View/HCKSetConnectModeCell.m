//
//  HCKSetConnectModeCell.m
//  HCKBeacon
//
//  Created by aa on 2017/11/2.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKSetConnectModeCell.h"

static CGFloat const rightIconWidth = 15.f;
static CGFloat const rightIconHeigth = 15.f;

static NSString *const HCKSetConnectModeCellIdenty = @"HCKSetConnectModeCellIdenty";

@interface HCKSetConnectModeCell ()

@property (nonatomic ,strong)UILabel *msgLabel;

@property (nonatomic, strong)UIImageView *rightIcon;

@end

@implementation HCKSetConnectModeCell

+ (HCKSetConnectModeCell *)initCellWithTableView:(UITableView *)tableView{
    HCKSetConnectModeCell *cell = [tableView dequeueReusableCellWithIdentifier:HCKSetConnectModeCellIdenty];
    if (!cell) {
        cell = [[HCKSetConnectModeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HCKSetConnectModeCellIdenty];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.rightIcon];
        [self.contentView addTapAction:self selector:@selector(setConnectModeTap)];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(60);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(HCKFont(18).lineHeight);
    }];
    [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(rightIconWidth);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(rightIconHeigth);
    }];
}

#pragma mark - Private method
- (void)setConnectModeTap{
    if (self.connectModeSelectedBlock) {
        self.connectModeSelectedBlock(self.indexPath);
    }
}

#pragma mark - Public method
- (void)setDataModel:(HCKSimpleSelectedModel *)dataModel{
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    self.msgLabel.text = _dataModel.msgString;
    NSString *icon = (_dataModel.selected ? @"rightIconSelectedCircle" : @"rightIconUnselectedCircle");
    [self.rightIcon setImage:LOADIMAGE(icon, @"png")];
}

#pragma mark setter & getter
- (UILabel *)msgLabel{
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = HCKFont(18.f);
    }
    return _msgLabel;
}

- (UIImageView *)rightIcon{
    if (!_rightIcon) {
        _rightIcon = [[UIImageView alloc] init];
    }
    return _rightIcon;
}

@end
