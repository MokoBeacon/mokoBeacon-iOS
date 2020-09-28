//
//  HCKRefreshGifHeader.m
//  FitPolo
//
//  Created by aa on 17/5/8.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKRefreshGifHeader.h"

@implementation HCKRefreshGifHeader

- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i <= 4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_loading_%zd", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages
           forState:MJRefreshStateIdle];
    
    [self setImages:idleImages
           forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:idleImages
           forState:MJRefreshStateRefreshing];
}


@end
