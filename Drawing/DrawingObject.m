//
//  DrawingObject.m
//  Drawing
//
//  Created by Ryosuke Sasaki on 2013/05/19.
//  Copyright (c) 2013年 Ryosuke Sasaki. All rights reserved.
//

#import "DrawingObject.h"

@implementation DrawingObject

- (id)initWithBeginPoint:(CGPoint)beginPoint
{
    self = [super init];
    if (self) {
        _beginPoint = beginPoint;
        _endPoint = beginPoint;
        _strokeColor = [UIColor blackColor];
        _strokeWidth = 1.0f;
        _bounds = CGRectMake(beginPoint.x, beginPoint.y, 0, 0);
    }
    return self;
}

- (void)moveEndPoint:(CGPoint)endPoint
{
    self.endPoint = endPoint;

    CGFloat x, y, width, height;
    CGPoint beginPoint = self.beginPoint;
    
    x = (beginPoint.x < endPoint.x) ? beginPoint.x : endPoint.x;
    y = (beginPoint.y < endPoint.y) ? beginPoint.y : endPoint.y;
    width = ABS(beginPoint.x - endPoint.x);
    height = ABS(beginPoint.y - endPoint.y);
    
    self.bounds = CGRectMake(x, y, width, height);
}

- (UIBezierPath *)bezierPath
{
    return nil;
}

- (void)draw
{
    UIBezierPath *path = [self bezierPath];
    
    if (path) {
        if (self.isDrawingStroke) {
            path.lineWidth = self.strokeWidth;
            [self.strokeColor setStroke];
            [path stroke];
        }
        
        if (self.isDrawingFill) {
            [self.fillColor setFill];
            [path fill];
        }
    }
}

- (void)drawSelection
{
    [[UIColor grayColor] setStroke];
    
    CGRect rect = CGRectInset(self.bounds, -3, -3);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    
    CGFloat dashes[] = {1.0};
    [path setLineDash:dashes count:1 phase:0];
    
    [path setLineWidth:1];
    
    [path stroke];
}

- (BOOL)containsPoint:(CGPoint)point
{
    return [[self bezierPath] containsPoint:point];
}

@end
