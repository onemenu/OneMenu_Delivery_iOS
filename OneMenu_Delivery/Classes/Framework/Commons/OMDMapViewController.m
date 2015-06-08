//
//  OMDMapViewController.m
//  OneMenu_Delivery
//
//  Created by simmyoung on 15/6/4.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import "OMDMapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "OMDLocationManager.h"

@interface OMDMapViewController ()
<MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) UIButton *naviButton;

@property (nonatomic) CLLocationCoordinate2D currentCoor;
@property (nonatomic) CLLocationCoordinate2D destinationCoor;

@end

@implementation OMDMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)setupViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    self.naviButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.naviButton addTarget:self action:@selector(naviAction:) forControlEvents:UIControlEventTouchUpInside];
    self.naviButton.frame = CGRectMake(self.mapView.frame.size.width-20-44, self.mapView.frame.size.height-20-44, 44, 44);
    [self.naviButton setTitle:@"Navg" forState:UIControlStateNormal];
    [self.naviButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.naviButton setBackgroundColor:[UIColor whiteColor]];
    self.naviButton.layer.cornerRadius = self.naviButton.frame.size.width/2;
    [self.mapView addSubview:self.naviButton];
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicatorView.frame = CGRectMake(0, 0, 50, 50);
    self.indicatorView.center = self.view.center;
    [self.view addSubview:self.indicatorView];
    [self translateToLocation];
}

- (void)naviAction:(UIButton *)sender
{
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:_destinationCoor addressDictionary:nil]];
    toLocation.name = self.addressStr;
    
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
}

- (void)translateToLocation
{
    [self.indicatorView startAnimating];
    NSString *esc_addr =  [self.addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    
    NSString *jsonString = [NSString stringWithContentsOfURL: [NSURL URLWithString: req] encoding: NSUTF8StringEncoding error: NULL];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *googleResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    // get the results dictionary
    NSDictionary *resultsDict = [googleResponse valueForKey:@"results"];
    // geometry dictionary within the  results dictionary
    NSDictionary *geometryDict = [resultsDict valueForKey:@"geometry"];
    // location dictionary within the geometry dictionary
    NSDictionary *locationDict = [geometryDict valueForKey:@"location"];
    
    NSArray *latArray = [locationDict valueForKey:@"lat"];
    // (one element) array entries provided by the json parser
    NSString *latString = [latArray lastObject];
    
    NSArray *lngArray = [locationDict valueForKey:@"lng"];
    // (one element) array entries provided by the json parser
    NSString *lngString = [lngArray lastObject];
    
    _currentCoor.latitude = [[[OMDLocationManager sharedInstance] latitude] floatValue];
    _currentCoor.longitude = [[[OMDLocationManager sharedInstance] longitude] floatValue];
    
    _destinationCoor.latitude = [latString doubleValue];    // latitude;
    _destinationCoor.longitude = [lngString doubleValue];
    
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    request.source = [MKMapItem mapItemForCurrentLocation];
    
    request.destination = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:_destinationCoor addressDictionary:nil]];
    request.requestsAlternateRoutes = YES;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             // Handle Error
         } else {
             [self showRoute:response];
         }
     }];
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.1;
    span.longitudeDelta = 0.1;
    
    region.span = span;
    region.center = _currentCoor;
    
    [self.mapView setRegion:region animated:YES];
}

-(void)showRoute:(MKDirectionsResponse *)response
{
    for (MKRoute *route in response.routes)
    {
        [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
    }
    MKPointAnnotation *annTo = [[MKPointAnnotation alloc] init];
    annTo.title = @"Destination";
    annTo.subtitle = self.addressStr;
    [annTo setCoordinate:_destinationCoor];
    [self.mapView addAnnotation:annTo];
    
    MKPointAnnotation *annFrom = [[MKPointAnnotation alloc] init];
    annFrom.title = @"Me";
    [annFrom setCoordinate:_currentCoor];
    [self.mapView addAnnotation:annFrom];
    [self.mapView selectAnnotation:annTo animated:YES];
    [self.mapView setShowsUserLocation:YES];
    [self.indicatorView stopAnimating];
    [self.indicatorView removeFromSuperview];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *routeLineRender = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    srand(NSTimeIntervalSince1970);
    NSInteger random = arc4random()%3;
    if (random == 0) {
        routeLineRender.fillColor = [UIColor redColor];
        routeLineRender.strokeColor = [UIColor redColor];
    }
    else if (1 == random) {
        routeLineRender.fillColor = [UIColor blueColor];
        routeLineRender.strokeColor = [UIColor blueColor];
    }
    else {
        routeLineRender.fillColor = [UIColor greenColor];
        routeLineRender.strokeColor = [UIColor greenColor];
    }
    
    routeLineRender.lineWidth = 3.0;
    return routeLineRender;
}

- (void)mapView:(MKMapView *)theMapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
//    [theMapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
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
