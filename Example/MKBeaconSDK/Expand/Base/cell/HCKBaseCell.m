//
//  HCKBaseCell.m
//  FitPolo
//
//  Created by aa on 17/5/7.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBaseCell.h"

@interface HCKBaseCell ()

@property (nonatomic, strong)UIView *lineView;

@end

@implementation HCKBaseCell

#pragma mark - life circle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = COLOR_WHITE_MACROS;
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

#pragma mark - 覆盖父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(CUTTING_LINE_HEIGHT);
        make.bottom.mas_equalTo(0);
    }];
    [super layoutSubviews];
}

#pragma mark - setter & getter
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = CUTTING_LINE_COLOR;
    }
    return _lineView;
}

+ (CGFloat)getCellHeight{
    return 44.0f;
}

@end
