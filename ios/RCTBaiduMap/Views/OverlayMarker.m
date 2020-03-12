//
//  OverlayMarker.m
//  react-native-baidu-map
//
//  Created by lovebing on 2019/10/7.
//  Copyright © 2019年 lovebing.org. All rights reserved.
//

#import "OverlayMarker.h"
#import "FFLoactionAnotation.h"
#import "ZKLoactionAnotation.h"

@implementation OverlayMarker

- (NSString *)getType {
    return @"marker";
}

- (NSDictionary *)icon
{
    return _content;
}

- (void)addToMap:(BMKMapView *)mapView {
    [mapView addAnnotation:[self getAnnotation]];
}

- (void)update {
    [self updateAnnotation:[self getAnnotation]];
}

- (void)removeFromMap:(BMKMapView *)mapView {
    [mapView removeAnnotation:[self getAnnotation]];
}

- (BMKPointAnnotation *)getAnnotation {
    
    // 先处理自己的marker
    if (self.content || self.icon) {
        OverlayMarker *marker = self;
        NSString *uri = [marker.icon valueForKey:@"uri"];
        NSArray *uriComponent = [uri componentsSeparatedByString:@"_"];
        // 这里处理地理位置的类型
        // 1. 只有三个分段的是 正常地图页面的公司图标
        // 2. 最后面包含 _location 是”我的位置“
        // 3. 最后包含 _guideLocation 是从职位进入的可以导航的位置
        
        id<BMKAnnotation> annotation;
        if ([uri containsString:@"_location"]) {
            FFLoactionAnotation *realAnno = [[FFLoactionAnotation alloc] initWithtitle:@"my_location" latitude:marker.location[@"latitude"] longtitude:marker.location[@"longitude"]];
            realAnno.uri = uri;
            annotation = realAnno;
        }else if ([uri containsString:@"_guideLocation"]) {
            
            double lat = [RCTConvert double:marker.location[@"latitude"]];
            double lng = [RCTConvert double:marker.location[@"longitude"]];
            CLLocationCoordinate2D coor;
            coor.latitude = lat;
            coor.longitude = lng;
            
            // 配置
            ZKLoactionAnotation *realAnno = [ZKLoactionAnotation new];
            realAnno.coordinate = coor;
            realAnno.title = uriComponent.firstObject;
            annotation = realAnno;
        }else
        {
            FFLoactionAnotation *realAnno = [[FFLoactionAnotation alloc] initWithtitle:@"my_location" latitude:marker.location[@"latitude"] longtitude:marker.location[@"longitude"]];
            realAnno.title = uriComponent.firstObject;
            realAnno.companyId = uriComponent[1];
            realAnno.uri = uri;
            annotation = realAnno;
        }
        
        return annotation;
    }
    
    // 最后处理默认的
    if (_annotation == nil) {
        _annotation = [[BMKPointAnnotation alloc] init];
        [self updateAnnotation:_annotation];
    }

    return _annotation;
}

- (void)updateAnnotation:(BMKPointAnnotation *)annotation {
    CLLocationCoordinate2D coor = [OverlayUtils getCoorFromOption:_location];
    if(_title.length == 0) {
        annotation.title = nil;
    } else {
        annotation.title = _title;
    }
    annotation.coordinate = coor;
}

@end
