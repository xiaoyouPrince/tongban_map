//
//  ZKLoactionAnotation.m
//  RCTBaiduMap
//
//  Created by 杨继鹏 on 2017/10/23.
//  Copyright © 2017年 lovebing.org. All rights reserved.
//

#import "ZKLoactionAnotation.h"

@implementation ZKLoactionAnotation

- (instancetype)initWithtitle:(NSString *)title latitude:(NSString *)latitude longtitude:(NSString *)longtitude{
    self = [super init];
    if (self) {
        self.coordinate = CLLocationCoordinate2DMake([latitude doubleValue], [longtitude doubleValue]);
        self.title = title;
    }
    return self;
    
}

@end
