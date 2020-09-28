//
//  HCKBroadcastCycleHeaderView.m
//  HCKBeacon
//
//  Created by aa on 2017/11/2.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBroadcastCycleHeaderView.h"

static NSString *const HCKBroadcastCycleHeaderViewIdenty = @"HCKBroadcastCycleHeaderViewIdenty";

@interface HCKBroadcastCycleHeaderView ()

@property (nonatomic, strong)UILabel *titleLabel;

@end

@implementation HCKBroadcastCycleHeaderView

/* 获取顶部视图对象 */
+ (instancetype)headerViewWithCollectionView:(UICollectionView *)collectionView
                                forIndexPath:(NSIndexPath *)indexPath
{
    //从缓存池中寻找顶部视图对象，如果没有，该方法自动调用alloc/initWithFrame创建一个新的顶部视图返回
    HCKBroadcastCycleHeaderView *headerView =
    [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                       withReuseIdentifier:HCKBroadcastCycleHeaderViewIdenty
                                              forIndexPath:indexPath];
    return headerView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(HCKFont(14).lineHeight);
    }];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = DEFAULT_TEXT_COLOR;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = HCKFont(14);
        _titleLabel.text = LS(@"HCKCollectionHeaderView_msg");
    }
    return _titleLabel;
}

@end
