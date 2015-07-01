//
//  DrawingView.m
//  Drawing
//
//  Created by Ryosuke Sasaki on 2013/05/19.
//  Copyright (c) 2013年 Ryosuke Sasaki. All rights reserved.
//

#import "DrawingView.h"
#import "DrawingObject.h"

@interface DrawingView()
@property(strong, nonatomic) NSMutableArray *drawingObjects;
@end

@implementation DrawingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _drawingObjects = [NSMutableArray array];
}

- (void)addDrawingObject:(DrawingObject *)drawingObject
{
    [drawingObject addObserver:self
                    forKeyPath:@"bounds"
                       options:NSKeyValueObservingOptionNew
                       context:nil];
    [self.drawingObjects addObject:drawingObject];
    [self setNeedsDisplay];
}

- (void)removeDrawingObject:(DrawingObject *)drawingObject
{
    NSUInteger index = [self.drawingObjects indexOfObject:drawingObject];
    if (index != NSNotFound) {
        [drawingObject removeObserver:self forKeyPath:@"bounds"];
        [self.drawingObjects removeObjectAtIndex:index];
        [self setNeedsDisplay];
    }
}

- (void)removeAllDrawingObjects
{
    for (id object in self.drawingObjects) {
        [object removeObserver:self forKeyPath:@"bounds"];
    }
    [self.drawingObjects removeAllObjects];
    [self setNeedsDisplay];
}

- (DrawingObject *)detectDrawingObjectAtPoint:(CGPoint)point
{
    for (DrawingObject *object in [self.drawingObjects reverseObjectEnumerator]) {
        if ([object containsPoint:point])
            return object;
    }
    
    return nil;
}

- (void)setSelectedObject:(DrawingObject *)selectedObject
{
    if (_selectedObject != selectedObject) {
        _selectedObject = selectedObject;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    [self drawObjects];
}

- (void)drawObjects
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    static BOOL isEven = NO;
    static int decimalIndex = 0;    // 10の桁の数
    
    // ループの開始時、終了条件を現在の10の桁の数に合わせて調整する
    for (int i=0; i < [self.drawingObjects count]; i++) {
    //for (DrawingObject *object in self.drawingObjects) {
    //    DrawingObject* object = [self.drawingObjects objectAtIndex:i];
        DrawingObject* object = self.drawingObjects[i];
        CGContextSaveGState(context);
/*
        if (isEven == YES) {
            if (i % 2 == 0) {
                [object draw];
            }
        } else {
            if (i % 2 == 1) {
                [object draw];
            }
        }
*/
        if (isEven == YES) {
            if (i % 10 == 0) {
                if (i % 2 == 0) {
                    [object draw];
                }
            }else if (i % 10 == 1) {
                if (i % 2 == 0) {
                    [object draw];
                }else if (i % 2 == 1) {
                    [object draw];
                }
            }
        } else {
            if (i % 10 == 1) {
                if (i % 2 == 0) {
                    [object draw];
                }
            }else if (i % 10 == 1) {
                if (i % 2 == 0) {
                    [object draw];
                }else if (i % 2 == 1) {
                    [object draw];
                }
            }
        }

        if (object == self.selectedObject)
            [object drawSelection];
        CGContextRestoreGState(context);
    }
    isEven ^= YES;
    NSLog(@"isEven:%d", isEven);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self setNeedsDisplay];
}

@end
