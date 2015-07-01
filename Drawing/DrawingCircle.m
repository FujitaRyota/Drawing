//
//  DrawingCircle.m
//  Drawing
//
//  Created by Ryosuke Sasaki on 2013/05/19.
//  Copyright (c) 2013年 Ryosuke Sasaki. All rights reserved.
//

#import "DrawingCircle.h"

@implementation DrawingCircle

- (UIBezierPath *)bezierPath
{
    return [UIBezierPath bezierPathWithOvalInRect:self.bounds];
}

@end
