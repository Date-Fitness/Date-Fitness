//
//  DateMapViewController.m
//  date-fitness
//
//  Created by Shen Guanpu on 15/6/15.
//  Copyright (c) 2015年 Shen Guanpu. All rights reserved.
//

#import "DateMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "CustomAnnotationView.h"
#import "EventCreateViewController.h"
#import "UserPointAnnotation.h"
#import "UIImage+JYExtention.h"
#import "CallOutDateView.h"

//amap key
#define APIKey @"25627fb1f7c265b6d7485ba590ca0569"

@interface DateMapViewController ()<MAMapViewDelegate,AMapSearchDelegate,
        UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>{
    MAMapView *mapView;
    UIButton *locationButton; //定位按钮样式
    AMapSearchAPI *search;
    CLLocation *location;
    UITableView *tableView;
    NSArray *pois;
    NSMutableSet *rowsSet ;
    NSMutableArray *annotations;
    UILongPressGestureRecognizer * longPressGesture;
    MAPointAnnotation *destinationPoint;
    NSArray *pathPolylines;
    UILabel *pathLengthLabel;
    UIImage* user_image;
    BOOL startOrder;
    UIButton *orderButton;
    NSTimer *timer;
            UIAlertController* alertController;

}

@property (nonatomic, strong, readwrite) CallOutDateView *calloutView;

@end

@implementation DateMapViewController


#pragma mark tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return pois.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    AMapPOI *poi = pois[indexPath.row];
    cell.textLabel.text = poi.name;
    cell.detailTextLabel.text = poi.address;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //作业： 避免重复添加
    if ([rowsSet containsObject:@(indexPath.row)]) {
        return;
    }else{
        [rowsSet addObject:@(indexPath.row)];
    }
    
    //为点击的poi点添加标注
    AMapPOI *poi = pois[indexPath.row];

    
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc]init];
    annotation.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
    NSLog(@"坐标为： %f, %f",poi.location.latitude, poi.location.longitude);
    annotation.title = poi.name;
    annotation.subtitle = poi.address;
    
    [annotations addObject:annotation];
    [mapView addAnnotation:annotation];
    
    //改变中心点位置为当前annotation
    [mapView setCenterCoordinate:annotation.coordinate animated:YES ];
    
    
}



#pragma mark - Init
-(void)initAttributes{
    annotations = [NSMutableArray array];
    pois = nil;
    rowsSet = [NSMutableSet setWithObjects: nil]; //必须设置 否则会出现添加无效 contains判断无效情况
    longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    longPressGesture.delegate = self;
    [mapView addGestureRecognizer:longPressGesture];
}

-(void)initSearch{
    search = [[AMapSearchAPI alloc] initWithSearchKey:APIKey Delegate:self];
}

-(void)initControls{
    locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    locationButton.frame = CGRectMake(20, CGRectGetHeight(mapView.bounds)-100, 40, 40);
    locationButton.autoresizingMask =
        UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin;
    locationButton.backgroundColor = [UIColor colorWithRed:1 green:1 blue:0.9 alpha:0.8];
    locationButton.layer.cornerRadius = 5;
    [locationButton addTarget:self action:@selector(locateAction) forControlEvents:UIControlEventTouchUpInside];
    [locationButton setImage:[UIImage imageNamed:@"location_no"] forState:UIControlStateNormal];
    [mapView addSubview:locationButton];
//
//    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    searchButton.frame = CGRectMake(80, CGRectGetHeight(mapView.bounds)-80, 40, 40);
//    searchButton.autoresizingMask =
//    UIViewAutoresizingFlexibleRightMargin |
//    UIViewAutoresizingFlexibleTopMargin;
//    searchButton.backgroundColor = [UIColor greenColor];
//    [searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
//    [searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
//    [mapView addSubview:searchButton];
//    
//
//    
//    UIButton *pathButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    pathButton.frame = CGRectMake(140, CGRectGetHeight(mapView.bounds)-80, 40, 40);
//    pathButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin;
//     pathButton.backgroundColor = [UIColor greenColor];
//    [pathButton addTarget:self action:@selector(pathAction) forControlEvents:UIControlEventTouchUpInside];
//    [pathButton setImage:[UIImage imageNamed:@"path"] forState:UIControlStateNormal];
//    [mapView addSubview:pathButton];
//    
//    pathLengthLabel = [[UILabel alloc]init];
//    pathLengthLabel.frame = CGRectMake(0, CGRectGetHeight(mapView.bounds)-120, 300, 40);
//    pathLengthLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin;
//    pathLengthLabel.backgroundColor = [UIColor greenColor];
//    pathLengthLabel.text = @"";
    
    UIButton *newDateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    newDateButton.frame = CGRectMake(240, CGRectGetHeight(mapView.bounds)-100, 40, 40);
    newDateButton.autoresizingMask =
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin;
    [newDateButton addTarget:self action:@selector(newDateEventAction) forControlEvents:UIControlEventTouchUpInside];
    [newDateButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    [mapView addSubview:newDateButton];
    
    
    orderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    orderButton.frame = CGRectMake(120, CGRectGetHeight(mapView.bounds)-100, 80, 40);
    orderButton.autoresizingMask =
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin;
    [orderButton addTarget:self action:@selector(orderAction) forControlEvents:UIControlEventTouchUpInside];
    orderButton.backgroundColor =  [UIColor colorWithRed:1 green:1 blue:0.9 alpha:0.8];
    [orderButton setTitle:@"开始约健" forState:UIControlStateNormal];
    //[orderButton setImage:[UIImage imageNamed:@"order"] forState:UIControlStateNormal];
    [mapView addSubview:orderButton];
    
   

    

}

-(void) initTableView{
    CGFloat halfHeight = CGRectGetHeight(self.view.bounds) ;
    
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, halfHeight* 0.8,
                            CGRectGetWidth(self.view.bounds), halfHeight* 0.2  ) style:UITableViewStylePlain];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
}

-(void)initMapView{
    
    [MAMapServices sharedServices].apiKey = APIKey;
    mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
//   下部分为tableview     mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)* 0.8)];
    mapView.delegate = self;
    mapView.compassOrigin = CGPointMake(mapView.compassOrigin.x, 22);
    mapView.scaleOrigin = CGPointMake(mapView.scaleOrigin.x, 22);
    [self.view addSubview:mapView];
    mapView.showsUserLocation = YES;
    
    //add user info to the map
    UserPointAnnotation *annotation = [[UserPointAnnotation alloc]init];
    annotation.coordinate = CLLocationCoordinate2DMake(39.989799, 116.482109);
    [annotations addObject:annotation];
    [mapView addAnnotation:annotation];
    
    annotation = [[UserPointAnnotation alloc]init];
    annotation.coordinate = CLLocationCoordinate2DMake(39.979799, 116.482109);
    [annotations addObject:annotation];
    [mapView addAnnotation:annotation];
    
    annotation = [[UserPointAnnotation alloc]init];
    annotation._uid = @"abc";
    annotation.coordinate = CLLocationCoordinate2DMake(39.959799, 116.482109);
    [annotations addObject:annotation];
    [mapView addAnnotation:annotation];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //http://yuejian001.sinaapp.com/images/katong.jpg
    NSString* imageURL = @"http://yuejian001.sinaapp.com/images/katong.jpg";
    NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imageURL]];
    user_image = [[UIImage alloc] initWithData:imageData];
    user_image = [UIImage circleImage:user_image];
    
    [self initMapView];
    [self initSearch];
    [self initControls];
    [self initAttributes];
    //[self initTableView];
    
    // Do any additional setup after loading the view.
}




#pragma mark - action
-(void)searchAction{
    if(location == nil || search == nil){
        NSLog(@"search failed");
        return;
    }
    
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc]init];
    request.searchType = AMapSearchType_PlaceAround;
    request.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    request.keywords = @"健身";
    [search AMapPlaceSearch:request];
}

-(void)locateAction{
    if(mapView.userTrackingMode == MAUserTrackingModeNone){
        [mapView setUserTrackingMode:MAUserTrackingModeFollowWithHeading animated:YES];
    }else if(mapView.userTrackingMode == MAUserTrackingModeFollowWithHeading ){
        [mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    }else{
        [mapView setUserTrackingMode:MAUserTrackingModeNone animated:YES];;
    }
    
}

-(void)orderAction{
    if (startOrder ==NO) {
        startOrder = YES;
        
        [self showEvents];

        
        [orderButton setTitle:@"停止约健" forState:UIControlStateNormal];
        timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(showEvents) userInfo:nil repeats:YES];
    }else{
        startOrder = NO;
        [orderButton setTitle:@"开始约健" forState:UIControlStateNormal];
        [timer invalidate];
    }
}

- (void)showEvents{
    
//    alertController = [UIAlertController alertControllerWithTitle:@"我要约健" message:@"九点去跑奥森" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"约约约" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        EventCreateViewController *controller = [[EventCreateViewController alloc]initWithNibName:@"EventCreateViewController" bundle:nil];
//        
//        [self presentViewController:controller animated:YES completion:nil];
//    }];
//    
//    [yesAction setValue:[UIImage imageNamed:@"katong"] forKey:@"image"];
//    [alertController addAction:yesAction];
//    [self presentViewController:alertController animated:YES completion:nil];
//    //直接NSThread sleep 会继续执行
//    [self performSelector:@selector(perform) withObject:orderButton afterDelay:3.0];
    
    


#define kCalloutWidth 300.0
#define kCalloutHeight 320.0
    self.calloutView = [[CallOutDateView alloc]initWithFrame:
                        CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
    self.calloutView.center = CGPointMake(CGRectGetWidth(mapView.bounds)/2.f ,
                                          CGRectGetHeight(mapView.bounds)/3.f);

    self.calloutView.image = [UIImage imageNamed:@"katong"];//[UIImage imageNamed:@"katong"];
    self.calloutView.title = @"我要约健";
    self.calloutView.subtitle = @"九点去跑奥森";
    

    [mapView addSubview:self.calloutView];
    [self performSelector:@selector(perform) withObject:orderButton afterDelay:3.0];
    


}

-(void)perform{
    [self.calloutView removeFromSuperview];
    // [mapView delete:self.calloutView];
    // [alertController  dismissViewControllerAnimated:YES completion:nil];
    //alertController = nil;
}


-(void)newDateEventAction{
     [self performSegueWithIdentifier:@"new_event" sender:self];

//    EventCreateViewController *controller = [[EventCreateViewController alloc]init];
//  
//    [self presentViewController:controller animated:YES completion:nil];
//
//    self.view.window.rootViewController = controller;
//    
//    [self.view.window sendSubviewToBack:self.view];
//    NSLog(@"set new event window;");
    
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CLLocationCoordinate2D coordinate = [mapView convertPoint:[gesture locationInView:mapView] toCoordinateFromView:mapView];
        if (destinationPoint != nil) {
            [mapView removeAnnotation:destinationPoint];
            destinationPoint = nil;
        }
        destinationPoint = [[MAPointAnnotation alloc]init];
        destinationPoint.coordinate = coordinate;
        destinationPoint.title = @"Destination";
        [mapView addAnnotation:destinationPoint];

    }
}

- (CLLocationCoordinate2D *)coordinatesForString:(NSString *)string
                                 coordinateCount:(NSUInteger *)coordinateCount
                                      parseToken:(NSString *)token
{
    if (string == nil)
    {
        return NULL;
    }
    
    if (token == nil)
    {
        token = @",";
    }
    
    NSString *str = @"";
    if (![token isEqualToString:@","])
    {
        str = [string stringByReplacingOccurrencesOfString:token withString:@","];
    }
    
    else
    {
        str = [NSString stringWithString:string];
    }
    
    NSArray *components = [str componentsSeparatedByString:@","];
    NSUInteger count = [components count] / 2;
    if (coordinateCount != NULL)
    {
        *coordinateCount = count;
    }
    CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D*)malloc(count * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < count; i++)
    {
        coordinates[i].longitude = [[components objectAtIndex:2 * i]     doubleValue];
        coordinates[i].latitude  = [[components objectAtIndex:2 * i + 1] doubleValue];
    }
    
    return coordinates;
}


-(NSArray *)polylinesForPath:(AMapPath *)path{
    if (path == nil || path.steps.count==0) {
        return nil;
    }
    
    pathLengthLabel.text =  [NSString stringWithFormat:@"距离为 :%f 公里", path.distance/1000.0];
    [mapView addSubview:pathLengthLabel];
    
    NSMutableArray *polylines = [NSMutableArray array];
    [path.steps enumerateObjectsUsingBlock:^(AMapStep *step, NSUInteger idex, BOOL *stop){
        NSInteger count = 0;
        CLLocationCoordinate2D *coordinates = [self coordinatesForString:step.polyline
                                                         coordinateCount:&count
                                                              parseToken:@";"];
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:count];
        [polylines addObject:polyline];
        free(coordinates),coordinates = NULL;
    }];
    return polylines;
}

#pragma mark - search delegate

-(void)reGeoAction{
    if(location){
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc]init];
        request.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
        [search AMapReGoecodeSearch:request];
    }
    
}

-(MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay{
    if([overlay isKindOfClass:[MAPolyline class]]){
        MAPolylineView *polylineView = [[MAPolylineView alloc]initWithPolyline:overlay];
        
        polylineView.lineWidth = 4;
        polylineView.strokeColor = [UIColor magentaColor];
        return polylineView;
    }
    return nil;
}


//路线规划的request发起后，在代理中处理结果
-(void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request response:(AMapNavigationSearchResponse *)response{
    if (response.count > 0) {
        [mapView removeOverlays:pathPolylines];
        pathPolylines = nil;
        pathPolylines = [self polylinesForPath:response.route.paths[0]];
        [mapView addOverlays:pathPolylines];
        [mapView showAnnotations:@[destinationPoint, mapView.userLocation] animated:YES];
        

        
        
    }
}


//search 回调
-(void)searchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"request :%@, error :%@", request, error);
}

//search 回调 正常
-(void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request
                    response:(AMapReGeocodeSearchResponse *)response{
    NSLog(@"response: %@", response);
    
    NSString *title = response.regeocode.addressComponent.city;
    if(title.length == 0){
        title = response.regeocode.addressComponent.province;
    }
    
    mapView.userLocation.title = title;
    mapView.userLocation.subtitle = response.regeocode.formattedAddress;
    
}

-(void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response{
    NSLog(@"request: %@", request);
    NSLog(@"response: %@", response);
    
    if(response.pois.count>0){
        pois = response.pois;
        [tableView reloadData];
        [mapView removeAnnotations:annotations];
        [annotations removeAllObjects];
        [rowsSet removeAllObjects];
    }
}





-(void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated{
    if(mode == MAUserTrackingModeNone){
        [locationButton setImage:[UIImage imageNamed:@"location_no"]
                        forState:UIControlStateNormal];
    } else if(mode == MAUserTrackingModeFollowWithHeading){
        [locationButton setImage:[UIImage imageNamed:@"location_yes"]
                        forState:UIControlStateNormal];
    }else {
        [locationButton setImage:[UIImage imageNamed:@"location_normal"]
                        forState:UIControlStateNormal];
    }
}


-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    NSLog(@"userlocation : %@" , userLocation.location);
    location = [userLocation.location copy];
}

-(void)mapView:(MAMapView *)mapVi didSelectAnnotationView:(MAAnnotationView *)view{
    if([view.annotation isKindOfClass:[MAUserLocation class]]){
        [self reGeoAction];
    }
    
}

-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if(annotation == destinationPoint){
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)
        [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        return annotationView;
        
    }
//    if([annotation isKindOfClass:[MAPointAnnotation class]]){
//        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
//        CustomAnnotationView *annotationView = (CustomAnnotationView*)
//                        [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
//        if (annotationView == nil) {
//            annotationView = [[CustomAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
//        }
//        annotationView.image = [UIImage imageNamed:@"gym"];
//        annotationView.canShowCallout = NO;
//        return annotationView;
//        
//    }
    
    if([annotation isKindOfClass:[UserPointAnnotation class]]){
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView*)
        [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[CustomAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        
        annotationView.image = user_image;//[UIImage imageNamed:@"location_normal"];
        annotationView.canShowCallout = NO;
        return annotationView;
        
    }
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
