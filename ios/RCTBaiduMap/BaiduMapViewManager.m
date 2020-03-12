//
//  RCTBaiduMapViewManager.m
//  RCTBaiduMap
//
//  Created by lovebing on Aug 6, 2016.
//  Copyright © 2016 lovebing.org. All rights reserved.
//

#import "BaiduMapViewManager.h"
@interface BaiduMapViewManager ()<customAnnotationViewDelegate>
@property (nonatomic, strong) NSMutableArray *annotions;
@property (nonatomic,strong) BaiduMapView *mapView;
@end
@implementation BaiduMapViewManager;


static NSString *markerIdentifier = @"markerIdentifier";
static NSString *clusterIdentifier = @"clusterIdentifier";

RCT_EXPORT_MODULE(BaiduMapView)

RCT_EXPORT_VIEW_PROPERTY(mapType, int)
RCT_EXPORT_VIEW_PROPERTY(zoom, float)
RCT_EXPORT_VIEW_PROPERTY(showsUserLocation, BOOL);
RCT_EXPORT_VIEW_PROPERTY(scrollGesturesEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(zoomGesturesEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(trafficEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(baiduHeatMapEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(clusterEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(markers, NSArray*)
RCT_EXPORT_VIEW_PROPERTY(locationData, NSDictionary*)
RCT_EXPORT_VIEW_PROPERTY(onChange, RCTBubblingEventBlock)

RCT_CUSTOM_VIEW_PROPERTY(center, CLLocationCoordinate2D, BaiduMapView) {
    [view setCenterCoordinate:json ? [RCTConvert CLLocationCoordinate2D:json] : defaultView.centerCoordinate];
}

+ (void)initSDK:(NSString*)key {
    BMKMapManager* _mapManager = [[BMKMapManager alloc]init];
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:key authDelegate:nil];
    BOOL ret = [_mapManager start:key  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

- (UIView *)view {
    BaiduMapView* mapView = [[BaiduMapView alloc] init];
    mapView.delegate = self;
    _mapView = mapView;
    return mapView;
}

- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate {
    NSLog(@"onDoubleClick");
    NSDictionary* event = @{
                            @"type": @"onMapDoubleClick",
                            @"params": @{
                                    @"latitude": @(coordinate.latitude),
                                    @"longitude": @(coordinate.longitude)
                                    }
                            };
    [self sendEvent:mapView params:event];
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    NSLog(@"onClickedMapBlank");
    NSDictionary* event = @{
                            @"type": @"onMapClick",
                            @"params": @{
                                    @"latitude": @(coordinate.latitude),
                                    @"longitude": @(coordinate.longitude)
                                    }
                            };
    [self sendEvent:mapView params:event];

}

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    NSDictionary* event = @{
                            @"type": @"onMapLoaded",
                            @"params": @{}
                            };
    [self sendEvent:mapView params:event];
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    
    if ([view isKindOfClass:[FFCustomAnnotationView class]]) {
        FFCustomAnnotationView *fView = (FFCustomAnnotationView *)view;
        [fView upDateWithSelectState:YES];
        
        FFLoactionAnotation *ann = (FFLoactionAnotation *)fView.annotation;
        NSDictionary* event = @{
                                @"type": @"onMarkerClick",
                                @"params": @{
                                        @"title": ann.uri,
//                                        @"companyId":ann.companyId,
//                                        @"address":ann.address,
                                        @"position": @{
                                                @"latitude": @([[view annotation] coordinate].latitude),
                                                @"longitude": @([[view annotation] coordinate].longitude)
                                                }
                                        }
                                };
        
        [self sendEvent:mapView params:event];
        return;
    }
    
    NSDictionary* event = @{
                            @"type": @"onMarkerClick",
                            @"params": @{
                                    @"title": [[view annotation] title],
                                    @"position": @{
                                            @"latitude": @([[view annotation] coordinate].latitude),
                                            @"longitude": @([[view annotation] coordinate].longitude)
                                            }
                                    }
                            };
    [self sendEvent:mapView params:event];
}

- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi *)mapPoi {
    NSLog(@"onClickedMapPoi");
    NSDictionary* event = @{
                            @"type": @"onMapPoiClick",
                            @"params": @{
                                    @"name": mapPoi.text,
                                    @"uid": mapPoi.uid,
                                    @"latitude": @(mapPoi.pt.latitude),
                                    @"longitude": @(mapPoi.pt.longitude)
                                    }
                            };
    [self sendEvent:mapView params:event];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    NSLog(@"viewForAnnotation");
//    if ([annotation isKindOfClass:[ClusterAnnotation class]]) {
//        ClusterAnnotation *cluster = (ClusterAnnotation*)annotation;
//        BMKPinAnnotationView *annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:clusterIdentifier];
//        UILabel *annotationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
//        annotationLabel.textColor = [UIColor whiteColor];
//        annotationLabel.font = [UIFont systemFontOfSize:11];
//        annotationLabel.textAlignment = NSTextAlignmentCenter;
//        annotationLabel.hidden = NO;
//        annotationLabel.text = [NSString stringWithFormat:@"%ld", cluster.size];
//        annotationLabel.backgroundColor = [UIColor greenColor];
//        annotationView.alpha = 0.8;
//        [annotationView addSubview:annotationLabel];
//
//        if (cluster.size == 1) {
//            annotationLabel.hidden = YES;
//            annotationView.pinColor = BMKPinAnnotationColorRed;
//        }
//        if (cluster.size > 20) {
//            annotationLabel.backgroundColor = [UIColor redColor];
//        } else if (cluster.size > 10) {
//            annotationLabel.backgroundColor = [UIColor purpleColor];
//        } else if (cluster.size > 5) {
//            annotationLabel.backgroundColor = [UIColor blueColor];
//        } else {
//            annotationLabel.backgroundColor = [UIColor greenColor];
//        }
//        [annotationView setBounds:CGRectMake(0, 0, 22, 22)];
//        annotationView.draggable = YES;
//        annotationView.annotation = annotation;
//        return annotationView;
//    } else if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
//        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:markerIdentifier];
//        newAnnotationView.pinColor = BMKPinAnnotationColorGreen;
//        newAnnotationView.animatesDrop = YES;
//        return newAnnotationView;
//    }
//    return nil;
    
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
//        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:markerIdentifier];
//        newAnnotationView.pinColor = BMKPinAnnotationColorGreen;
//        newAnnotationView.animatesDrop = YES;
//        return newAnnotationView;
        
        if([annotation isKindOfClass:BMKUserLocation.class]){

            // 这里是创建用户自己的大头针
            NSLog(@" -------- 这里是创建用户自己的大头针");
        }



        ZKLoactionAnotation *zkAnn = [ZKLoactionAnotation new];
        zkAnn.coordinate = annotation.coordinate;
        zkAnn.title = @"自定义的随叫随到就静安寺个";

        ZKCustomAnnotationView *cusView = [[ZKCustomAnnotationView alloc] initWithAnnotation:zkAnn reuseIdentifier:@"zkAnnotation"];
        cusView.paopaoView = nil;
        cusView.canShowCallout = 0;

        return cusView;
    }
    
    
    if ([annotation isKindOfClass:[FFLoactionAnotation class]])
    {
        FFLoactionAnotation *locationAnotaion = (FFLoactionAnotation *)annotation;

        if ([locationAnotaion.title isEqualToString:@"my_location"]) {
            NSString *reuseIndetifier = @"mylocation";
            FFMyLocationView *myLoc = [[FFMyLocationView alloc] initWithAnnotation:locationAnotaion reuseIdentifier:reuseIndetifier];

            myLoc.canShowCallout = 0;
            return myLoc;
        }

        NSString *reuseIndetifier = @"annotation";
        FFCustomAnnotationView *annotationView = [[FFCustomAnnotationView alloc] initWithAnnotation:locationAnotaion reuseIdentifier:reuseIndetifier];
        annotationView.paopaoView = nil;
        annotationView.canShowCallout = 0;
        annotationView.delegate = self;
        [annotationView updateCustomAnnotationView:locationAnotaion];
        return annotationView;
    }

    if ([annotation isKindOfClass:[ZKLoactionAnotation class]]) {
        ZKLoactionAnotation *zkAnn = (ZKLoactionAnotation *)annotation;

        ZKCustomAnnotationView *cusView = [[ZKCustomAnnotationView alloc] initWithAnnotation:zkAnn reuseIdentifier:@"zkAnnotation"];
        cusView.paopaoView = nil;
        cusView.canShowCallout = 0;

        return cusView;
    }

    return nil;
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    NSLog(@"viewForOverlay");
    BaiduMapView *baidumMapView = (BaiduMapView *) mapView;
    OverlayView *overlayView = [baidumMapView findOverlayView:overlay];
    if (overlayView == nil) {
        return nil;
    }
    if ([overlay isKindOfClass:[BMKArcline class]]) {
        BMKArclineView *arclineView = [[BMKArclineView alloc] initWithArcline:overlay];
        arclineView.strokeColor = [UIColor blueColor];
        arclineView.lineDash = YES;
        arclineView.lineWidth = 6.0;
        return arclineView;
    } else if([overlay isKindOfClass:[BMKCircle class]]) {
        BMKCircleView *circleView = [[BMKCircleView alloc] initWithCircle:overlay];
        return circleView;
    } else if([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithPolyline:overlay];
        polylineView.strokeColor = [OverlayUtils getColor:overlayView.strokeColor];
        polylineView.lineWidth = overlayView.lineWidth;
        return polylineView;
    }
    return nil;
}

#pragma mark -FFCustomAnnotationView Delegate
- (void)customViewDidSelected:(id<BMKAnnotation>)anntation annotationView:(FFCustomAnnotationView *)annotationView{
    if ([anntation isKindOfClass:[FFLoactionAnotation class]]) {
        FFLoactionAnotation *locationAnotion = (FFLoactionAnotation *)anntation;
        NSMutableArray *newArray = [NSMutableArray new];
        for (FFLoactionAnotation *oldAnotation in self.annotions) {
            BOOL ifEqual = [oldAnotation.title isEqualToString:locationAnotion.title];
            oldAnotation.selected = ifEqual ? YES : NO;
            [newArray addObject:oldAnotation];
        }
        [_mapView removeAnnotations:self.annotions];
        [self.annotions removeAllObjects];
        self.annotions = newArray;
        [_mapView addAnnotations:self.annotions];
    }
}

- (void)mapStatusDidChanged: (BMKMapView *)mapView {
    CLLocationCoordinate2D targetGeoPt = [mapView getMapStatus].targetGeoPt;
    
    NSDictionary* event = @{
                            @"type": @"onMapStatusChange",
                            @"params": @{
                                    @"target": @{
                                            @"latitude": @(targetGeoPt.latitude),
                                            @"longitude": @(targetGeoPt.longitude)
                                            },
                                    @"zoom": @"",
                                    @"overlook": @""
                                    }
                            };
    [self sendEvent:mapView params:event];
}

- (void)sendEvent:(BaiduMapView *)mapView params:(NSDictionary *)params {
    if (!mapView.onChange) {
        return;
    }
    mapView.onChange(params);
}

@end
