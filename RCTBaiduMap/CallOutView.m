//
//  CallOutView.m
//  ClipRect
//
//  Created by 韩志峰 on 2017/7/28.
//  Copyright © 2017年 韩志峰. All rights reserved.
//

#import "CallOutView.h"

#define leftPading 15
#define topPading 0

@implementation CallOutView

- (void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, leftPading, topPading);
    CGContextAddLineToPoint(context, self.frame.size.width - leftPading, topPading);
    CGContextAddArc(context, self.frame.size.width - leftPading, leftPading, leftPading, -M_PI_2, M_PI_2, NO);
    CGContextAddLineToPoint(context, self.frame.size.width * 0.5 + 2.5, 2 *leftPading);
    CGContextAddLineToPoint(context, self.frame.size.width * 0.5, 2 * leftPading + 4);
    CGContextAddLineToPoint(context, self.frame.size.width * 0.5 - 2.5, 2 *leftPading);
    CGContextAddLineToPoint(context, leftPading, 2 *leftPading);
    CGContextAddArc(context, leftPading, leftPading, leftPading, M_PI_2, -M_PI_2, NO);
    CGContextSetLineWidth(context, 1);
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    if (self.click) {
        UIColor *notSelectColor =  [UIColor blueColor];//[UIColor colorWithHexString:@"00b06f"];
        [notSelectColor set];
    }else{
        UIColor *notSelectColor =  [UIColor greenColor];//[UIColor colorWithHexString:@"fd784c"];
        [notSelectColor set];
    }
    CGContextFillPath(context);
}
@end
