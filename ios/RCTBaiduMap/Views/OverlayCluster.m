//
//  OverlayCluster.m
//  react-native-baidu-map
//
//  Created by lovebing on 2019/10/7.
//  Copyright © 2019年 lovebing.org. All rights reserved.
//

#import "OverlayCluster.h"
#import "FFMyLocationView.h"
#import "FFLoactionAnotation.h"
#import "ZKLoactionAnotation.h"

@implementation OverlayCluster

- (instancetype)init {
    _clusterManager = [[BMKClusterManager alloc] init];
    _clusters = [[NSMutableArray alloc] init];
    self = [super init];
    return self;
}

- (void)addToMap:(BMKMapView *)mapView {
    _mapView = mapView;
}

- (void)update {
}

- (void)removeFromMap:(BMKMapView *)mapView {
}

- (void)insertReactSubview:(id <RCTComponent>)subview atIndex:(NSInteger)atIndex {
    if ([subview isKindOfClass:[OverlayMarker class]]) {
        OverlayMarker *marker = (OverlayMarker *) subview;
        [_clusters addObject:marker];
    }
}

- (void)removeReactSubview:(id <RCTComponent>)subview {
    NSLog(@"removeReactSubview");
    if ([subview isKindOfClass:[OverlayMarker class]]) {
        OverlayMarker *marker = (OverlayMarker *) subview;
        [_clusters removeObject:marker];
    }
}

- (void)didUpdateReactSubviews {
    [_clusterManager clearClusterItems];
    for (int i = 0; i < [_clusters count]; i++) {
        OverlayMarker *marker = (OverlayMarker *) [_clusters objectAtIndex:i];
        [_clusterManager addClusterItem:[OverlayUtils getCoorFromOption:marker.location]];
    }
    NSInteger clusterZoom = (NSInteger) _mapView.zoomLevel;
    @synchronized(_clusterManager.clusterCaches) {
        NSMutableArray *clusters = [_clusterManager.clusterCaches objectAtIndex:(clusterZoom - 3)];
        if (clusters.count > 0) {
            [_mapView removeAnnotations:_mapView.annotations];
            [_mapView addAnnotations:clusters];
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                __block NSArray *array = [self.clusterManager getClusters:clusterZoom];
                dispatch_async(dispatch_get_main_queue(), ^{
//                    for (BMKCluster *item in array) {
//                        ClusterAnnotation *annotation = [[ClusterAnnotation alloc] init];
//                        annotation.coordinate = item.coordinate;
//                        annotation.size = item.size;
//                        annotation.title = [NSString stringWithFormat:@"我是%ld个", item.size];
//                        [clusters addObject:annotation];
//                    }
//                    [_mapView addAnnotations:clusters];
                    
                    
                    // 这里重写添加为新大头针的方法
                    NSMutableArray *annos = @[].mutableCopy;
                    for (int i = 0; i < [_clusters count]; i++) {
                        OverlayMarker *marker = (OverlayMarker *) [_clusters objectAtIndex:i];
                        
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
                        
                        [annos addObject:annotation];
                    }
                    
                    [_mapView addAnnotations:annos];
                });
            });
        }
    }
}

@end

