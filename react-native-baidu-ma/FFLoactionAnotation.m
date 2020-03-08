//
//  FFLoactionAnotation.m
//  feifanyouwo
//
//  Created by 韩志峰 on 2017/7/18.
//  Copyright © 2017年 zhuang chaoxiao. All rights reserved.
//

#import "FFLoactionAnotation.h"

@implementation FFLoactionAnotation

- (instancetype)initWithtitle:(NSString *)title latitude:(NSString *)latitude longtitude:(NSString *)longtitude{
    self = [super init];
    if (self) {
        self.coordinate = CLLocationCoordinate2DMake([latitude doubleValue], [longtitude doubleValue]);
        self.title = title;
    }
    return self;
    
}
@end
