//
//  DrawingObject.h
//  Drawing
//
//  Created by Ryosuke Sasaki on 2013/05/19.
//  Copyright (c) 2013年 Ryosuke Sasaki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrawingObject : NSObject

@property(assign, nonatomic) CGPoint beginPoint;
@property(assign, nonatomic) CGPoint endPoint;
@property(assign, nonatomic) CGRect bounds;
@property(assign, nonatomic, getter = isDrawingStroke) BOOL drawingStroke;
@property(assign, nonatomic) CGFloat strokeWidth;
@property(strong, nonatomic) UIColor *strokeColor;
@property(assign, nonatomic, getter = isDrawingFill) BOOL drawingFill;
@property(strong, nonatomic) UIColor *fillColor;

- (id)initWithBeginPoint:(CGPoint)beginPoint;
- (void)moveEndPoint:(CGPoint)endPoint;

- (UIBezierPath *)bezierPath;
- (void)draw;
- (void)drawSelection;

- (BOOL)containsPoint:(CGPoint)point;

@end
