//
//  FFMyLocationView.m
//  RCTBaiduMap
//
//  Created by 杨继鹏 on 2017/10/19.
//  Copyright © 2017年 lovebing.org. All rights reserved.
//

#import "FFMyLocationView.h"

@implementation FFMyLocationView

- (instancetype)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.bounds = CGRectMake(0, 0, 26, 26);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
        imageView.image = [UIImage imageNamed:@"my_location"];
        imageView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        imageView.layer.cornerRadius = 13;
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];
    }
    return self;
}

@end
