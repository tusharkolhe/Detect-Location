//
//  ViewController.m
//  TKDetectLocation
//
//  Created by Felix ITs 04 on 23/10/16.
//  Copyright © 2016 Tushar. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UILongPressGestureRecognizer *longpress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    longpress.minimumPressDuration=2;
    
    [self.myMapView addGestureRecognizer:longpress];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startLoading
{
    locationManager =[[CLLocationManager alloc]init];
    locationManager.delegate=self;
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gesture
{
    
    CLLocationCoordinate2D pressedCoordinate;
    
    if(gesture.state==UIGestureRecognizerStateBegan)
    {
        CGPoint pressLocation=[gesture locationInView:gesture.view];
        pressedCoordinate=[self.myMapView convertPoint:pressLocation toCoordinateFromView:gesture.view];
        
        //Annotation
        MKPointAnnotation *myAnnotation=[[MKPointAnnotation alloc]init];
        myAnnotation.coordinate=pressedCoordinate;
        
        CLGeocoder *geocoder=[[CLGeocoder alloc]init];
        
        CLLocation *location=[[CLLocation alloc]initWithLatitude:pressedCoordinate.latitude longitude:pressedCoordinate.longitude];
        
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@",error.localizedDescription);
                myAnnotation.title = @"Unknown place";
                [self.myMapView addAnnotation:myAnnotation];
            }
            else{
                if (placemarks.count>0) {
                    CLPlacemark *myPlacemark =placemarks.lastObject;
                    NSString *title = [myPlacemark.subThoroughfare stringByAppendingString:myPlacemark.thoroughfare];
                    NSString *subTitle =myPlacemark.locality;
                    myAnnotation.title = title;
                    myAnnotation.subtitle = subTitle;
                    [self.myMapView addAnnotation:myAnnotation];
                    
                }
                else {
                    myAnnotation.title = @"Unknown Place";
                    [self.myMapView addAnnotation:myAnnotation];
                    
                }
            }
            
        }];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *currentLocation=locations.lastObject;
    NSLog(@"%f",currentLocation.coordinate.latitude);
    self.labelLatitude.text=[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    
    NSLog(@"%f", currentLocation.coordinate.longitude);
    self.labelLongitude.text=[NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    MKCoordinateSpan mySpan=MKCoordinateSpanMake(0.001, 0.001);
    MKCoordinateRegion myRegion=MKCoordinateRegionMake(currentLocation.coordinate,mySpan);
    [self.myMapView setRegion:myRegion animated:YES];
    
    if(currentLocation != nil)
    {
        [locationManager stopUpdatingLocation];
    }
    
}

-(void) mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"%@",error.localizedDescription);
}



- (IBAction)getLocationbutton:(id)sender {
    [self startLoading];
    
}
@end
