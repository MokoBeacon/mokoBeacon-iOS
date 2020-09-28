//
//  HCKSimpleBaseCell.m
//  FitPolo
//
//  Created by aa on 17/5/7.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKSimpleBaseCell.h"

@interface HCKSimpleBaseCell ()

/**
 左侧lable
 */
@property (nonatomic, strong) UILabel *cellTextLabel;

/**
 右侧lable
 */
@property (nonatomic, strong) UILabel *cellDetailLabel;

/**
 右侧图标
 */
@property (nonatomic, strong) UIImageView *rightIcon;

/**
 点击cell
 */
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation HCKSimpleBaseCell

+ (instancetype)initCellWithTableView:(UITableView *)tableView
                      reuseIdentifier:(NSString *)reuseIdentifier{
    HCKSimpleBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[HCKSimpleBaseCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.cellDetailLabel];
        [self.contentView addSubview:self.cellTextLabel];
        [self.contentView addSubview:self.rightIcon];
        [self.contentView addSubview:self.backButton];
    }
    return self;
}

#pragma mark - 覆盖父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (!self.dataModel) {
        return;
    }
    
    if (ValidStr(self.dataModel.textStr)) {
        self.cellTextLabel.text = self.dataModel.textStr;
    }
    if (ValidStr(self.dataModel.detailStr)) {
        self.cellDetailLabel.text = self.dataModel.detailStr;
    }
    if (!ValidStr(self.dataModel.iconName)) {
        self.dataModel.iconName = @"";
    }
    self.rightIcon.image = LoadImageByName(self.dataModel.iconName);
        
    UIImage *image = LoadImageByName(self.dataModel.iconName);
    CGSize imageSize = image.size;
    CGFloat defaultLabelWidth = ((self.contentView.frame.size.width - 40 - 10 - 5 - imageSize.width) / 2);
    [self.cellTextLabel setFrame:CGRectMake(20,
                                            (self.contentView.frame.size.height - HCKFont(16).lineHeight) / 2,
                                            defaultLabelWidth,
                                            HCKFont(16).lineHeight)];
    [self.rightIcon setFrame:CGRectMake(self.contentView.frame.size.width - 10 - imageSize.width,
                                        (self.contentView.frame.size.height - imageSize.height) / 2,
                                        imageSize.width,
                                        imageSize.height)];
    [self.cellDetailLabel setFrame:CGRectMake(10 + defaultLabelWidth + 20,
                                              (self.contentView.frame.size.height - HCKFont(15).lineHeight) / 2,
                                              defaultLabelWidth,
                                              HCKFont(16).lineHeight)];
    [self.backButton setFrame:self.contentView.bounds];
}

#pragma mark - Private Method
- (void)cellSelected{
    _backButton.selected = !_backButton.selected;
    if (self.cellSelectedBlock) {
        self.cellSelectedBlock(self.indexPath,_backButton.selected);
    }
}

#pragma mark - setter && getter

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

- (UILabel *)cellDetailLabel{
    if (!_cellDetailLabel) {
        _cellDetailLabel = [[UILabel alloc] init];
        _cellDetailLabel.backgroundColor = COLOR_CLEAR_MACROS;
        _cellDetailLabel.font = HCKFont(15);
        _cellDetailLabel.textColor = DEFAULT_TEXT_COLOR;
        _cellDetailLabel.textAlignment = NSTextAlignmentRight;
    }
    return _cellDetailLabel;
}

- (UIImageView *)rightIcon{
    if (!_rightIcon) {
        _rightIcon = [[UIImageView alloc] init];
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
