//
//  Line.m
//  Comic Reader
//
//  Created by administrator on 2/8/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "Line.h"

@implementation Line

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) drawRect:(CGRect)rect{
    
    UIColor *customColor = [[UIColor alloc] initWithRed:0.2 green:0.3 blue:0.4 alpha:0.5];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(context, [[UIColor blueColor] CGColor]);
    CGContextSetLineWidth(context, 3.0);
    CGContextBeginPath(context);
    [[UIColor redColor] setFill];
    CGContextMoveToPoint(context, 100, 20);
    CGContextAddLineToPoint(context, 160, 150);
    CGContextAddLineToPoint(context, 10, 150);
    CGContextClosePath(context);
    
//    CGContextSetFillColorWithColor(context, [[UIColor greenColor] CGColor]);
    [customColor setFill];
    [customColor setStroke];
    CGContextDrawPath(context, kCGPathFillStroke);
}
@end
