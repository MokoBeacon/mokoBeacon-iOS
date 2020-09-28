//
//  HCKPageControl.m
//  FitPolo
//
//  Created by aa on 17/6/13.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKPageControl.h"

@implementation HCKPageControl

- (void)updateDots{
    for (NSInteger i = 0; i < [self.subviews count]; i ++) {
        UIView * dot = [self.subviews objectAtIndex:i];
        for (UIView * view in dot.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                [view removeFromSuperview];
            }
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:dot.bounds];
        if (self.currentPage == i) {
            if (self.activeImage) {
                imageView.image = self.activeImage;
            }
        }
        else{
            if (self.inactiveImage) {
                imageView.image = self.inactiveImage;
            }
        }
        [dot addSubview:imageView];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage{
    [super setCurrentPage:currentPage];
    [self updateDots];
}

@end
