//
//  FFLoactionAnotation.h
//  feifanyouwo
//
//  Created by 韩志峰 on 2017/7/18.
//  Copyright © 2017年 zhuang chaoxiao. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapView.h>
#import <CoreLocation/CoreLocation.h>

@interface FFLoactionAnotation : NSObject<BMKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *uri;

@property (nonatomic, assign) BOOL selected;

- (instancetype)initWithtitle:(NSString *)title latitude:(NSString *)latitude longtitude:(NSString *)longtitude;

@end
