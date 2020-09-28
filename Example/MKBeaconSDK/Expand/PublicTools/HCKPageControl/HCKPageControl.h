//
//  HCKPageControl.h
//  FitPolo
//
//  Created by aa on 17/6/13.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCKPageControl : UIPageControl

/**
 选中白点
 */
@property (nonatomic, strong)UIImage * activeImage;

/**
 未选中白点
 */
@property (nonatomic, strong)UIImage * inactiveImage;

@end
