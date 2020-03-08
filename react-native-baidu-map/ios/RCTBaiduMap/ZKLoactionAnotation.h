//
//  ZKLoactionAnotation.h
//  RCTBaiduMap
//
//  Created by 杨继鹏 on 2017/10/23.
//  Copyright © 2017年 lovebing.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <CoreLocation/CoreLocation.h>

@interface ZKLoactionAnotation : NSObject<BMKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;

@end
