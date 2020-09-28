//
//  HCKWaveView.m
//  FitPolo
//
//  Created by aa on 17/5/17.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKWaveView.h"

@interface HCKWaveView ()

@property (weak, nonatomic) UIView *lowerView;
@property (assign, nonatomic) CGFloat waveWidth;
@property (assign, nonatomic) CGFloat waveHeight;
@property (assign, nonatomic) CGFloat offsetX;
@property (strong, nonatomic) CADisplayLink *waveDisplayLink;
@property (strong, nonatomic) CAShapeLayer *waveShapeLayer;
@property (strong, nonatomic) CAShapeLayer *deepWaveShapeLayer;

@end

@implementation HCKWaveView

#pragma mark - life circle

+ (instancetype)addToView:(UIView *)view withFrame:(CGRect)frame {
    HCKWaveView *waveView = [[self alloc] initWithFrame:frame];
    waveView.lowerView = view;
    [view addSubview:waveView];
    return waveView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self basicSetup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ([super initWithCoder:aDecoder]) {
        [self basicSetup];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews {
    if (!self.lowerView) {
        return;
    }
    self.waveWidth = CGRectGetWidth(self.lowerView.frame);
}

#pragma mark - Private Method

- (void)basicSetup {
    _waveHeight = self.frame.size.height / 2;
    _waveWidth = self.frame.size.width;
    _waveSpeed = 5.f;
    _waveAmplitude = 8.f;
    _waveTime = 1.f;
    _waveColor = COLOR_WHITE_MACROS;
}

- (void)getLightWaveLayer{
    self.offsetX += self.waveSpeed;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, self.waveHeight);
    
    CGFloat y = 0.f;
    for (float x = 0.f; x <= self.waveWidth ; x++) {
        y = self.waveAmplitude * sin((360 / self.waveWidth) * (x * M_PI / 180) - self.offsetX * M_PI / 180) + self.waveHeight;
        CGPathAddLineToPoint(path, NULL, x, y);
    }
    
    CGPathAddLineToPoint(path, NULL, self.waveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, NULL, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    
    self.waveShapeLayer.path = path;
    
    CGPathRelease(path);
}

- (void)getDeepWaveLayer{
    self.offsetX += self.waveSpeed;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, self.waveHeight);
    
    CGFloat y = 0.f;
    for (float x = 0.f; x <= self.waveWidth ; x++) {
        y = self.waveAmplitude * cos((360 / self.waveWidth) * (x * M_PI / 180) - self.offsetX * M_PI / 180) + self.frame.size.height / 8;
        CGPathAddLineToPoint(path, NULL, x, y);
    }
    
    CGPathAddLineToPoint(path, NULL, self.waveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, NULL, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    
    self.deepWaveShapeLayer.path = path;
    
    CGPathRelease(path);
}

- (void)getCurrentWave {
    [self getLightWaveLayer];
    [self getDeepWaveLayer];
}

#pragma mark - Public Method

- (void)wave {
    
    if (self.waveShapeLayer.path) {
        return;
    }
    self.waveShapeLayer = [CAShapeLayer layer];
    self.waveShapeLayer.fillColor = self.waveColor.CGColor;
    
    self.deepWaveShapeLayer = [CAShapeLayer layer];
    self.deepWaveShapeLayer.fillColor = RGBCOLOR(130, 240, 243).CGColor;
    [self.layer addSublayer:self.deepWaveShapeLayer];
    
    [self.layer addSublayer:self.waveShapeLayer];
    
    self.waveDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave)];
    [self.waveDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    if (self.waveTime <= 0.f) {
        return;
    }
}

- (void)stop {
    [UIView animateWithDuration:1.f animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.waveDisplayLink invalidate];
        self.waveDisplayLink = nil;
        self.waveShapeLayer.path = nil;
        self.alpha = 1.f;
    }];
    
}

@end
