//
//  HCKSetUUIDCell.m
//  HCKBeacon
//
//  Created by aa on 2017/11/1.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKSetUUIDCell.h"

static CGFloat const selectedIconWidth = 20.f;
static CGFloat const selectedIconHeight = 20.f;

static NSString *const HCKSetUUIDCellIdenty = @"HCKSetUUIDCellIdenty";

@interface HCKSetUUIDCell ()

@property (nonatomic, strong)UILabel *topLabel;

@property (nonatomic, strong)UILabel *uuidLabel;

@property (nonatomic, strong)UIImageView *selectedIcon;

@end

@implementation HCKSetUUIDCell

+ (HCKSetUUIDCell *)initCellWithTableView:(UITableView *)tableView{
    HCKSetUUIDCell *cell = [tableView dequeueReusableCellWithIdentifier:HCKSetUUIDCellIdenty];
    if (!cell) {
        cell = [[HCKSetUUIDCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HCKSetUUIDCellIdenty];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.topLabel];
        [self.contentView addSubview:self.uuidLabel];
        [self.contentView addSubview:self.selectedIcon];
        [self.contentView addTapAction:self selector:@selector(cellTapAction)];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.selectedIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(selectedIconWidth);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(selectedIconHeight);
    }];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.selectedIcon.mas_left).mas_offset(-10);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(HCKFont(15).lineHeight);
    }];
    [self.uuidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.selectedIcon.mas_left).mas_offset(-10);
        make.top.mas_equalTo(self.topLabel.mas_bottom).mas_offset(8);
        make.height.mas_equalTo(HCKFont(12).lineHeight);
    }];
}

#pragma mark - Private method
- (void)cellTapAction{
    if (self.setUUIDBlock) {
        self.setUUIDBlock(self.indexPath);
    }
}

#pragma mark - Public method
- (void)setDataModel:(HCKSetUUIDModel *)dataModel{
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    self.topLabel.text = _dataModel.titleString;
    self.uuidLabel.text = _dataModel.uuid;
    self.selectedIcon.hidden = !_dataModel.selected;
}

#pragma mark - setter & getter
- (UILabel *)topLabel{
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] init];
        _topLabel.textColor = RGBCOLOR(86, 145, 252);
        _topLabel.textAlignment = NSTextAlignmentLeft;
        _topLabel.font = HCKFont(15.f);
    }
    return _topLabel;
}

- (UILabel *)uuidLabel{
    if (!_uuidLabel) {
        _uuidLabel = [[UILabel alloc] init];
        _uuidLabel.textColor = DEFAULT_TEXT_COLOR;
        _uuidLabel.textAlignment = NSTextAlignmentLeft;
        _uuidLabel.font = HCKFont(12.f);
    }
    return _uuidLabel;
}

- (UIImageView *)selectedIcon{
    if (!_selectedIcon) {
        _selectedIcon = [[UIImageView alloc] init];
        _selectedIcon.image = LOADIMAGE(@"cellRight_selected_pic", @"png");
    }
    return _selectedIcon;
}

@end
