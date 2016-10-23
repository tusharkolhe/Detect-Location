//
//  ViewController.h
//  TKDetectLocation
//
//  Created by Felix ITs 04 on 23/10/16.
//  Copyright © 2016 Tushar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}

@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property (weak, nonatomic) IBOutlet UILabel *labelLatitude;


@property (weak, nonatomic) IBOutlet UILabel *labelLongitude;


- (IBAction)getLocationbutton:(id)sender;

@end

