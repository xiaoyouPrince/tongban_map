//
//  FFCustomAnnotationView.h
//  feifanyouwo
//
//  Created by 韩志峰 on 2017/7/17.
//  Copyright © 2017年 zhuang chaoxiao. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapView.h>
#import "CallOutView.h"
@class FFLoactionAnotation;
@class FFCustomAnnotationView;
@protocol customAnnotationViewDelegate <NSObject>
- (void)customViewDidSelected:(id <BMKAnnotation>)anntation annotationView:(FFCustomAnnotationView *)annotationView;
@end

@class FFCallOutView;
@interface FFCustomAnnotationView : BMKAnnotationView
@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) CallOutView  *callOutView;
@property (nonatomic, strong) UIImageView  *imageView;
@property (nonatomic, weak) id <customAnnotationViewDelegate> delegate;
- (void)updateCustomAnnotationView:(FFLoactionAnotation *)annotation;
- (void)upDateWithSelectState:(BOOL)isSelect;
@end
