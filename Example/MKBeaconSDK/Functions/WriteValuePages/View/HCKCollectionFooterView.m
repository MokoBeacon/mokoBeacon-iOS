//
//  HCKCollectionFooterView.m
//  HCKBeacon
//
//  Created by aa on 2017/11/2.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKCollectionFooterView.h"

static NSString *const HCKCollectionFooterViewIdenty = @"HCKCollectionFooterViewIdenty";

@interface HCKCollectionFooterView ()

@property (nonatomic, strong)UILabel *noteLabel;

@end

@implementation HCKCollectionFooterView

/* 获取底部视图对象 */
+ (instancetype)footerViewWithCollectionView:(UICollectionView *)collectionView
                                forIndexPath:(NSIndexPath *)indexPath
{
    //从缓存池中寻找底部视图对象，如果没有，该方法自动调用alloc/initWithFrame创建一个新的底部视图返回
    HCKCollectionFooterView *footerView =
    [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                       withReuseIdentifier:HCKCollectionFooterViewIdenty
                                              forIndexPath:indexPath];
    return footerView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.noteLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = [NSString sizeWithText:self.noteLabel.text
                                 andFont:self.noteLabel.font
                              andMaxSize:CGSizeMake(self.frame.size.width, MAXFLOAT)];
    [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(size.height);
    }];
}

- (UILabel *)noteLabel{
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.backgroundColor = COLOR_CLEAR_MACROS;
        _noteLabel.textAlignment = NSTextAlignmentLeft;
        _noteLabel.textColor = RGBCOLOR(115, 115, 115);
        _noteLabel.font = HCKFont(14.f);
        _noteLabel.numberOfLines = 0;
        _noteLabel.text = LS(@"HCKCollectionFooterView_msg");
    }
    return _noteLabel;
}

@end
