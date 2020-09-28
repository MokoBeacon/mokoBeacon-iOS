//
//  HCKRssiBackView.m
//  HCKBeacon
//
//  Created by aa on 2017/11/18.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKRssiBackView.h"
#import "HCKRssiCurveView.h"

static CGFloat const offset_X = 30.f;
static CGFloat const offset_Y = 20.f;

#define labelHeight HCKFont(12.f).lineHeight

@interface HCKRssiBackView ()

@property (nonatomic, strong)HCKRssiCurveView *rssiCurveView;

@end

@implementation HCKRssiBackView

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.rssiCurveView];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.rssiCurveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.top.mas_equalTo(offset_Y);
        make.bottom.mas_equalTo(-offset_Y);
    }];
    
    CGFloat space_Y = (self.frame.size.height - 2 * offset_Y) / 5;
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = CUTTING_LINE_COLOR;
    [self addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.top.mas_equalTo(offset_Y);
        make.height.mas_equalTo(1.f);
    }];
    
    UILabel *leftLabel1 = [self getLabelWithTextAlignment:NSTextAlignmentRight];
    leftLabel1.text = @"0";
    [self addSubview:leftLabel1];
    [leftLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(offset_X);
        make.centerY.mas_equalTo(line1.mas_centerY);
        make.height.mas_equalTo(labelHeight);
    }];
    UILabel *rightLabel1 = [self getLabelWithTextAlignment:NSTextAlignmentLeft];
    rightLabel1.text = @"0";
    [self addSubview:rightLabel1];
    [rightLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(offset_X);
        make.centerY.mas_equalTo(line1.mas_centerY);
        make.height.mas_equalTo(labelHeight);
    }];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = CUTTING_LINE_COLOR;
    [self addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.top.mas_equalTo(line1.mas_bottom).mas_offset(space_Y);
        make.height.mas_equalTo(1.f);
    }];
    
    UILabel *leftLabel2 = [self getLabelWithTextAlignment:NSTextAlignmentRight];
    leftLabel2.text = @"-30";
    [self addSubview:leftLabel2];
    [leftLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(offset_X);
        make.centerY.mas_equalTo(line2.mas_centerY);
        make.height.mas_equalTo(labelHeight);
    }];
    UILabel *rightLabel2 = [self getLabelWithTextAlignment:NSTextAlignmentLeft];
    rightLabel2.text = @"-30";
    [self addSubview:rightLabel2];
    [rightLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(offset_X);
        make.centerY.mas_equalTo(line2.mas_centerY);
        make.height.mas_equalTo(labelHeight);
    }];
    
    UIView *line3 = [[UIView alloc] init];
    line3.backgroundColor = CUTTING_LINE_COLOR;
    [self addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.top.mas_equalTo(line2.mas_bottom).mas_offset(space_Y);
        make.height.mas_equalTo(1.f);
    }];
    
    UILabel *leftLabel3 = [self getLabelWithTextAlignment:NSTextAlignmentRight];
    leftLabel3.text = @"-60";
    [self addSubview:leftLabel3];
    [leftLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(offset_X);
        make.centerY.mas_equalTo(line3.mas_centerY);
        make.height.mas_equalTo(labelHeight);
    }];
    UILabel *rightLabel3 = [self getLabelWithTextAlignment:NSTextAlignmentLeft];
    rightLabel3.text = @"-60";
    [self addSubview:rightLabel3];
    [rightLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(offset_X);
        make.centerY.mas_equalTo(line3.mas_centerY);
        make.height.mas_equalTo(labelHeight);
    }];
    
    UIView *line4 = [[UIView alloc] init];
    line4.backgroundColor = CUTTING_LINE_COLOR;
    [self addSubview:line4];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.top.mas_equalTo(line3.mas_bottom).mas_offset(space_Y);
        make.height.mas_equalTo(1.f);
    }];
    
    UILabel *leftLabel4 = [self getLabelWithTextAlignment:NSTextAlignmentRight];
    leftLabel4.text = @"-90";
    [self addSubview:leftLabel4];
    [leftLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(offset_X);
        make.centerY.mas_equalTo(line4.mas_centerY);
        make.height.mas_equalTo(labelHeight);
    }];
    UILabel *rightLabel4 = [self getLabelWithTextAlignment:NSTextAlignmentLeft];
    rightLabel4.text = @"-90";
    [self addSubview:rightLabel4];
    [rightLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(offset_X);
        make.centerY.mas_equalTo(line4.mas_centerY);
        make.height.mas_equalTo(labelHeight);
    }];
    
    UIView *line5 = [[UIView alloc] init];
    line5.backgroundColor = CUTTING_LINE_COLOR;
    [self addSubview:line5];
    [line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.top.mas_equalTo(line4.mas_bottom).mas_offset(space_Y);
        make.height.mas_equalTo(1.f);
    }];
    
    UILabel *leftLabel5 = [self getLabelWithTextAlignment:NSTextAlignmentRight];
    leftLabel5.text = @"-120";
    [self addSubview:leftLabel5];
    [leftLabel5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(offset_X);
        make.centerY.mas_equalTo(line5.mas_centerY);
        make.height.mas_equalTo(labelHeight);
    }];
    UILabel *rightLabel5 = [self getLabelWithTextAlignment:NSTextAlignmentLeft];
    rightLabel5.text = @"-120";
    [self addSubview:rightLabel5];
    [rightLabel5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(offset_X);
        make.centerY.mas_equalTo(line5.mas_centerY);
        make.height.mas_equalTo(labelHeight);
    }];
    
    UIView *line6 = [[UIView alloc] init];
    line6.backgroundColor = CUTTING_LINE_COLOR;
    [self addSubview:line6];
    [line6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.top.mas_equalTo(line5.mas_bottom).mas_offset(space_Y);
        make.height.mas_equalTo(1.f);
    }];
    
    UILabel *leftLabel6 = [self getLabelWithTextAlignment:NSTextAlignmentRight];
    leftLabel6.text = @"-150";
    [self addSubview:leftLabel6];
    [leftLabel6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(offset_X);
        make.centerY.mas_equalTo(line6.mas_centerY);
        make.height.mas_equalTo(labelHeight);
    }];
    UILabel *rightLabel6 = [self getLabelWithTextAlignment:NSTextAlignmentLeft];
    rightLabel6.text = @"-150";
    [self addSubview:rightLabel6];
    [rightLabel6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(offset_X);
        make.centerY.mas_equalTo(line6.mas_centerY);
        make.height.mas_equalTo(labelHeight);
    }];
    
    UIView *line7 = [[UIView alloc] init];
    line7.backgroundColor = CUTTING_LINE_COLOR;
    [self addSubview:line7];
    [line7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.width.mas_equalTo(1.f);
        make.top.mas_equalTo(offset_Y);
        make.bottom.mas_equalTo(line6.mas_top);
    }];
    
    UIView *line8 = [[UIView alloc] init];
    line8.backgroundColor = CUTTING_LINE_COLOR;
    [self addSubview:line8];
    [line8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-offset_X);
        make.width.mas_equalTo(1.f);
        make.top.mas_equalTo(offset_Y);
        make.bottom.mas_equalTo(line6.mas_top);
    }];
}

#pragma mark - Private method
- (UILabel *)getLabelWithTextAlignment:(NSTextAlignment )alignment{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = alignment;
    label.textColor = RGBCOLOR(71, 223, 222);
    label.font = HCKFont(12.f);
    return label;
}

#pragma mark - Public method
- (void)setRssiValues:(NSArray *)rssiValues{
    _rssiValues = nil;
    _rssiValues = rssiValues;
    if (!ValidArray(_rssiValues)) {
        return;
    }
    [self.rssiCurveView setRssiValues:self.rssiValues];
}

#pragma mark - setter & getter
- (HCKRssiCurveView *)rssiCurveView{
    if (!_rssiCurveView) {
        _rssiCurveView = [[HCKRssiCurveView alloc] init];
        _rssiCurveView.backgroundColor =COLOR_WHITE_MACROS;
    }
    return _rssiCurveView;
}

@end
