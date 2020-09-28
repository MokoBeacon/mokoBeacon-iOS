//
//  HCKRssiCurveView.m
//  HCKBeacon
//
//  Created by aa on 2017/11/17.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKRssiCurveView.h"

#define POINT(_INDEX_) [(NSValue *)[points objectAtIndex:_INDEX_] CGPointValue]

#define curveViewHeight (self.frame.size.height - 40.f)

@interface HCKRssiCurveView ()


@end

@implementation HCKRssiCurveView

#pragma mark - 父类方法

- (void)drawRect:(CGRect)rect{
    [self drawRssiCurve];
}

#pragma mark - Private method

- (void)drawRssiCurve{
    if (!ValidArray(self.rssiValues) || self.rssiValues.count <= 1) {
        return;
    }
    NSMutableArray *pointsList = [NSMutableArray array];
    CGFloat space = self.frame.size.width / (self.rssiValues.count - 1);
    for (NSInteger i = 0; i < self.rssiValues.count; i ++) {
        NSNumber *rssi = self.rssiValues[i];
        CGPoint point = CGPointMake(i * space, ((CGFloat)abs([rssi intValue]) / 150) * curveViewHeight);
        [pointsList addObject:[NSValue valueWithCGPoint:point]];
    }
    [self smoothedPathWithPoints:pointsList andGranularity:10];
}

- (void)smoothedPathWithPoints:(NSArray *) pointsArray andGranularity:(NSInteger)granularity {
    
    NSMutableArray *points = [pointsArray mutableCopy];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetStrokeColorWithColor(context, RGBCOLOR(71, 223, 222).CGColor);
    CGContextSetLineWidth(context, 2.f);
    
    UIBezierPath *smoothedPath = [UIBezierPath bezierPath];
    
    // Add control points to make the math make sense
    [points insertObject:[points objectAtIndex:0] atIndex:0];
    [points addObject:[points lastObject]];
    [smoothedPath moveToPoint:POINT(0)];
    
    for (NSUInteger index = 1; index < points.count - 2; index++) {
        CGPoint p0 = POINT(index - 1);
        CGPoint p1 = POINT(index);
        CGPoint p2 = POINT(index + 1);
        CGPoint p3 = POINT(index + 2);
        
        // now add n points starting at p1 + dx/dy up until p2 using Catmull-Rom splines
        for (int i = 1; i < granularity; i++) {
            
            float t = (float) i * (1.0f / (float) granularity);
            float tt = t * t;
            float ttt = tt * t;
            
            CGPoint pi; // intermediate point
            pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
            pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
            [smoothedPath addLineToPoint:pi];
        }
        
        // Now add p2
        [smoothedPath addLineToPoint:p2];
    }
    
    // finish by adding the last point
    [smoothedPath addLineToPoint:POINT(points.count - 1)];
    
    CGContextAddPath(context, smoothedPath.CGPath);
    CGContextDrawPath(context, kCGPathStroke);
}

#pragma mark - Public method
- (void)setRssiValues:(NSArray *)rssiValues{
    _rssiValues = nil;
    _rssiValues = rssiValues;
    if (!ValidArray(_rssiValues)) {
        return;
    }
    [self setNeedsDisplay];
}

#pragma mark - setter & getter

@end
