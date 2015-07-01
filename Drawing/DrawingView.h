//
//  DrawingView.h
//  Drawing
//
//  Created by Ryosuke Sasaki on 2013/05/19.
//  Copyright (c) 2013年 Ryosuke Sasaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DrawingObject;

@interface DrawingView : UIView
@property(weak, nonatomic) DrawingObject *selectedObject;

- (void)addDrawingObject:(DrawingObject *)drawingObject;
- (void)removeDrawingObject:(DrawingObject *)drawingObject;
- (void)removeAllDrawingObjects;

- (DrawingObject *)detectDrawingObjectAtPoint:(CGPoint)point;

- (void)drawObjects;

@end
