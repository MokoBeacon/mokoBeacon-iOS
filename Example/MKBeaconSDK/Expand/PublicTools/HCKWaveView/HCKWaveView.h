//
//  HCKWaveView.h
//  FitPolo
//
//  Created by aa on 17/5/17.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCKWaveView : UIView

@property (assign, nonatomic) CGFloat waveSpeed;
@property (assign, nonatomic) CGFloat waveAmplitude;
@property (assign, nonatomic) NSTimeInterval waveTime;
@property (strong, nonatomic) UIColor *waveColor;

+ (instancetype)addToView:(UIView *)view withFrame:(CGRect)frame;

- (void)wave;
- (void)stop;

@end
