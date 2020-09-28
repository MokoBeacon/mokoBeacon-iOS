//
//  HCKRefreshHeader.m
//  FitPolo
//
//  Created by aa on 17/6/17.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKRefreshHeader.h"

@interface HCKRefreshHeader ()

@property (nonatomic, strong)UIImageView *refreshIcon;

@property (nonatomic, strong)UIImageView *errorIcon;

@property (nonatomic, strong)UILabel *contentLabel;

@property (nonatomic, assign)BOOL needIcon;

@end

@implementation HCKRefreshHeader

- (void)dealloc{
    NSLog(@"HCKRefreshHeader销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //注册这个通知是因为从后台切回前台的时候，原有动画失效了
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshIconAddAnimation)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        [self setBackgroundColor:RGBCOLOR(254, 221, 63)];
        [self addSubview:self.refreshIcon];
        [self addSubview:self.contentLabel];
        [self addSubview:self.errorIcon];
        [self addTapAction:self
                  selector:@selector(refreshHeaderTapAction)];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    if (!ValidStr(self.contentLabel.text)) {
        return;
    }
    CGSize contentSize = [NSString sizeWithText:self.contentLabel.text
                                        andFont:self.contentLabel.font
                                     andMaxSize:CGSizeMake(MAXFLOAT, HCKFont(15).lineHeight)];
    CGFloat width = (contentSize.width > 250 ? 250 : contentSize.width);
    if (self.needIcon) {
        //需要前面的icon，隐藏错误icon
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(width);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.mas_equalTo(HCKFont(15).lineHeight);
        }];
        [self.refreshIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentLabel.mas_left).mas_offset(-10);
            make.width.mas_equalTo(20);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.mas_equalTo(20);
        }];
        return;
    }
    //需要错误icon，隐藏前面的icon
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(width);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(HCKFont(15).lineHeight);
    }];
    [self.errorIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentLabel.mas_left).mas_offset(-10);
        make.width.mas_equalTo(20);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(20);
    }];
}

#pragma mark - Public Method

/**
 设置提示信息

 @param contentMsg 当前显示的提示信息
 @param need 是否需要前面的icon,出现错误提示的时候，不需要前面的icon，但是显示错误icon
 */
- (void)setContentMsg:(NSString *)contentMsg
             needIcon:(BOOL)need{
    if (!ValidStr(contentMsg)) {
        return;
    }
    self.contentLabel.text = contentMsg;
    self.needIcon = need;
    [self.refreshIcon setHidden:!self.needIcon];
    [self.errorIcon setHidden:self.needIcon];
    [self setNeedsLayout];
}

#pragma mark - Private Method
- (void)refreshIconAddAnimation{
    self.refreshIcon.animationImages = @[LoadImageByName(@"refreshIcon_1.png"),
                                         LoadImageByName(@"refreshIcon_2.png"),
                                         LoadImageByName(@"refreshIcon_3.png"),
                                         LoadImageByName(@"refreshIcon_4.png"),
                                         LoadImageByName(@"refreshIcon_5.png")];
    self.refreshIcon.animationDuration = 1.f;
    self.refreshIcon.animationRepeatCount = MAXFLOAT;
    [self.refreshIcon startAnimating];
}

- (void)refreshHeaderTapAction{
    if (self.pressedBlock) {
        self.pressedBlock();
    }
}

#pragma mark - setter & getter
- (UIImageView *)refreshIcon{
    if (!_refreshIcon) {
        _refreshIcon = [[UIImageView alloc] init];
        _refreshIcon.backgroundColor = COLOR_CLEAR_MACROS;
        [self refreshIconAddAnimation];
    }
    return _refreshIcon;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = DEFAULT_TEXT_COLOR;
        _contentLabel.font = HCKFont(15);
    }
    return _contentLabel;
}

- (UIImageView *)errorIcon{
    if (!_errorIcon) {
        _errorIcon = [[UIImageView alloc] init];
        _errorIcon.image = LOADIMAGE(@"refreshHeaderErrorIcon", @"png");
        _errorIcon.backgroundColor = COLOR_CLEAR_MACROS;
    }
    return _errorIcon;
}

@end
