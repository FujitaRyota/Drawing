//
//  DrawingRectangle.m
//  Drawing
//
//  Created by Ryosuke Sasaki on 2013/05/19.
//  Copyright (c) 2013年 Ryosuke Sasaki. All rights reserved.
//

#import "DrawingRectangle.h"

@implementation DrawingRectangle

- (UIBezierPath *)bezierPath
{
    return [UIBezierPath bezierPathWithRect:self.bounds];
}

@end
