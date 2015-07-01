//
//  DrawingLine.m
//  Drawing
//
//  Created by Ryosuke Sasaki on 2013/05/19.
//  Copyright (c) 2013年 Ryosuke Sasaki. All rights reserved.
//

#import "DrawingLine.h"

@implementation DrawingLine

- (UIBezierPath *)bezierPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.beginPoint]; // 始点
    int randomLoop = (arc4random() % 16) + 4; // 4〜20の乱数
    CGFloat xOffset = (self.beginPoint.x + self.endPoint.x) / randomLoop;
    CGFloat yOffset = (self.beginPoint.y + self.endPoint.y) / randomLoop;
    
    NSLog(@"OFFSET:%f, %f",xOffset,yOffset);
    // 線をrandomLoopの個数で分割した長さを算出
    CGFloat xStep = (self.endPoint.x-self.beginPoint.x)/randomLoop;
    CGFloat yStep = (self.endPoint.y-self.beginPoint.y)/randomLoop;
    
    for(int i=1 ; i<randomLoop ; i++ ){
        int randomOffset = arc4random() % 10;
        CGPoint midPoint; // 中間点の算出
        // ループ1回で分割数分のピクセルを進めていく
        midPoint = CGPointMake( (self.beginPoint.x + (xStep*i) + randomOffset),
                               (self.beginPoint.y + (yStep*i)) + randomOffset );
        
        NSLog(@"%d:%f,%f",i, midPoint.x, midPoint.y);
        [path addLineToPoint:midPoint]; // 中間点
        // 曲線にしたい場合はこっち。prevPointをどう作成すべきでしょうか。
        //[path addQuadCurveToPoint:midPoint controlPoint:prevPoint];
    }
    
    [path addLineToPoint:self.endPoint]; // 終点
    //[path closePath];
    return path;
}

- (BOOL)containsPoint:(CGPoint)point
{
    CGFloat acceptableDistance = 10.0f;
    
    CGRect acceptableBounds = CGRectInset(self.bounds, -acceptableDistance, -acceptableDistance);
    if (!CGRectContainsPoint(acceptableBounds, point))
        return NO;
    
    CGPoint beginPoint = self.beginPoint;
    CGPoint endPoint = self.endPoint;
    
    if (endPoint.x - beginPoint.x == 0.0f)
        return YES;
    
    CGFloat slope = (endPoint.y - beginPoint.y) / (endPoint.x - beginPoint.x);
    if (ABS(((point.x - beginPoint.x) * slope) - (point.y - beginPoint.y)) <= acceptableDistance)
        return YES;
    
    return NO;
}

- (void)draw
{
    UIBezierPath *path = [self bezierPath];
    path.lineWidth = self.strokeWidth;
    [self.strokeColor setStroke];
    [path stroke];
}

@end