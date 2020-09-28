//
//  HCKPointManager.m
//  FitPolo
//
//  Created by aa on 2017/9/11.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKPointManager.h"

@implementation HCKPointManager


/**
 判断两条直线是否相交

 @param p1 第一条直线v1的一个点
 @param p2 第一条直线v1的另一个点
 @param p3 第二条直线v2的一个点
 @param p4 第二条直线v2的另一个点
 @return YES v1和v2相交，NO不相交
 */
+ (BOOL)checkLineIntersection:(CGPoint)p1
                           p2:(CGPoint)p2
                           p3:(CGPoint)p3
                           p4:(CGPoint)p4{
    
    CGFloat denominator = (p4.y - p3.y) * (p2.x - p1.x) - (p4.x - p3.x) * (p2.y - p1.y);
    if (denominator == 0.0f) {
        
        return NO;
    }
    CGFloat ua = ((p4.x - p3.x) * (p1.y - p3.y) - (p4.y - p3.y) * (p1.x - p3.x))/denominator;
    CGFloat ub = ((p2.x - p1.x) * (p1.y - p3.y) - (p2.y - p1.y) * (p1.x - p3.x))/denominator;
    if (ua >= 0.0f && ua <= 1.0f && ub >= 0.0f && ub <= 1.0f) {
        
        return YES;
    }
    return NO;
}

+ (NSValue *)intersectionOfLineFrom:(CGPoint)p1 to:(CGPoint)p2 withLineFrom:(CGPoint)p3 to:(CGPoint)p4
{
    CGFloat d = (p2.x - p1.x)*(p4.y - p3.y) - (p2.y - p1.y)*(p4.x - p3.x);
    if (d == 0)
        return nil; // parallel lines
    CGFloat u = ((p3.x - p1.x)*(p4.y - p3.y) - (p3.y - p1.y)*(p4.x - p3.x))/d;
    CGFloat v = ((p3.x - p1.x)*(p2.y - p1.y) - (p3.y - p1.y)*(p2.x - p1.x))/d;
    if (u < 0.0 || u > 1.0)
        return nil; // intersection point not between p1 and p2
    if (v < 0.0 || v > 1.0)
        return nil; // intersection point not between p3 and p4
    CGPoint intersection;
    intersection.x = p1.x + u * (p2.x - p1.x);
    intersection.y = p1.y + u * (p2.y - p1.y);
    
    return [NSValue valueWithCGPoint:intersection];
}


/**
 两条直线要是相交 求出相交点

 @param u1 第一条直线的一个点
 @param u2 第一条直线的另一个点
 @param v1 第二条直线的一个点
 @param v2 第二条直线的另一个点
 @return 交点
 */
+ (CGPoint)intersectionU1:(CGPoint)u1
                       u2:(CGPoint)u2
                       v1:(CGPoint)v1
                       v2:(CGPoint)v2{
    
    CGPoint ret = u1;
    double t = ((u1.x - v1.x) * (v1.y - v2.y) - (u1.y - v1.y) * (v1.x - v2.x))/((u1.x-u2.x) * (v1.y - v2.y) - (u1.y - u2.y) * (v1.x - v2.x));
    ret.x += (u2.x - u1.x) * t;
    ret.y += (u2.y - u1.y) * t;
    return ret;
}

@end
