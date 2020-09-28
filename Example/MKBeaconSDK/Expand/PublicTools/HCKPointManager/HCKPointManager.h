//
//  HCKPointManager.h
//  FitPolo
//
//  Created by aa on 2017/9/11.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCKPointManager : NSObject

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
                           p4:(CGPoint)p4;

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
                       v2:(CGPoint)v2;

+ (NSValue *)intersectionOfLineFrom:(CGPoint)p1 to:(CGPoint)p2 withLineFrom:(CGPoint)p3 to:(CGPoint)p4;

@end
