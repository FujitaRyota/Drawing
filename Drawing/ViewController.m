//
//  ViewController.m
//  Drawing
//
//  Created by Ryosuke Sasaki on 2013/05/19.
//  Copyright (c) 2013年 Ryosuke Sasaki. All rights reserved.
//

#import "ViewController.h"
#import "DrawingView.h"
#import "DrawingObject.h"
#import "DrawingLine.h"
#import "DrawingCircle.h"
#import "DrawingRectangle.h"

typedef NS_ENUM(NSInteger, DrawingType) {
    kDrawingTypeLine,
    kDrawingTypeRectangle,
    kDrawingTypeCircle,
    kDrawingTypeNone,
};

typedef NS_ENUM(NSInteger, StrokeColor) {
    kStrokeColorBlack,
    kStrokeColorRed,
    kStrokeColorBlue,
    kStrokeColorGreen,
    kStrokeColorYellow,
};

@interface ViewController ()
@property (weak, nonatomic) IBOutlet DrawingView *drawingView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *colorControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *fillControl;
@property (weak, nonatomic) IBOutlet UISlider *strokeWidthSlider;
@property (strong, nonatomic) DrawingObject *currentObject;
@property (assign, nonatomic, getter = isDragging) BOOL dragging;
@end

@implementation ViewController

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.drawingView];
    
    if (CGRectContainsPoint(self.drawingView.bounds, point)) {
        
        Class drawingClass = [self drawingObjectClass];
        if (drawingClass) {
            DrawingObject *object = [[drawingClass alloc] initWithBeginPoint:point];
            
            object.strokeWidth = self.strokeWidthSlider.value;
            object.strokeColor = [self strokeColor];
            object.fillColor = [self fillColor];
            object.drawingStroke = (self.fillControl.selectedSegmentIndex == 0);
            object.drawingFill = (self.fillControl.selectedSegmentIndex == 1);
            
            [self.drawingView addDrawingObject:object];
            self.drawingView.selectedObject = nil;
            
            self.currentObject = object;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.drawingView];

    DrawingObject *selectedObject = self.drawingView.selectedObject;

    if ([self drawingObjectClass]) {
        [self.currentObject moveEndPoint:point];
    } else if (selectedObject && (self.isDragging || [selectedObject containsPoint:point])) {
        self.dragging = YES;
        CGPoint previousPoint = [touch previousLocationInView:self.drawingView];
        
        CGPoint beginPoint = selectedObject.beginPoint;
        beginPoint.x += point.x - previousPoint.x;
        beginPoint.y += point.y - previousPoint.y;
        selectedObject.beginPoint = beginPoint;
        
        CGPoint endPoint = selectedObject.endPoint;
        endPoint.x += point.x - previousPoint.x;
        endPoint.y += point.y - previousPoint.y;
        selectedObject.endPoint = endPoint;
        
        CGRect bounds = selectedObject.bounds;
        bounds.origin.x += point.x - previousPoint.x;
        bounds.origin.y += point.y - previousPoint.y;
        selectedObject.bounds = bounds;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self drawingObjectClass]) {
        self.drawingView.selectedObject = self.currentObject;
        self.currentObject = nil;
    } else {
        if (!self.isDragging) {
            UITouch *touch = [touches anyObject];
            CGPoint point = [touch locationInView:self.drawingView];
            self.drawingView.selectedObject = [self.drawingView detectDrawingObjectAtPoint:point];
        }
    }
    self.dragging = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.currentObject) {
        self.drawingView.selectedObject = self.currentObject;
        self.currentObject = nil;
    }
    self.dragging = NO;
}

- (Class)drawingObjectClass
{
    switch ((DrawingType)self.typeControl.selectedSegmentIndex) {
        case kDrawingTypeLine: return [DrawingLine class];
        case kDrawingTypeRectangle: return [DrawingRectangle class];
        case kDrawingTypeCircle: return [DrawingCircle class];
        case kDrawingTypeNone: return Nil;
    }
}

- (UIColor *)strokeColor
{
    switch ((StrokeColor)self.colorControl.selectedSegmentIndex) {
        case kStrokeColorBlack: return [UIColor blackColor];
        case kStrokeColorRed: return [UIColor redColor];
        case kStrokeColorBlue: return [UIColor blueColor];
        case kStrokeColorGreen: return [UIColor greenColor];
        case kStrokeColorYellow: return [UIColor yellowColor];
    }
}

- (UIColor *)fillColor
{
    return [self strokeColor];
}

- (IBAction)performSaveButtonAction:(id)sender
{
    DrawingObject *object = self.drawingView.selectedObject;
    self.drawingView.selectedObject = nil;
    
    UIGraphicsBeginImageContextWithOptions(self.drawingView.frame.size, NO, [[UIScreen mainScreen] scale]);
    [self.drawingView drawObjects];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.drawingView.selectedObject = object;
    
    self.view.userInteractionEnabled = NO;
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    self.view.userInteractionEnabled = YES;
    
    [[[UIAlertView alloc] initWithTitle:nil message:@"画像の保存が完了しました。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (IBAction)performDeleteButtonAction:(id)sender
{
    [self.drawingView removeDrawingObject:self.drawingView.selectedObject];
    self.drawingView.selectedObject = nil;
}

- (IBAction)performClearButtonAction:(id)sender
{
    [self.drawingView removeAllDrawingObjects];
}

@end
