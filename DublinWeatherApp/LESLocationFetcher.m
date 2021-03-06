//
//  LESLocationFetcher.m
//  DublinWeatherApp
//
//  Created by Kieran Buckley on 16/09/2016.
//  Copyright © 2016 LesApps. All rights reserved.
//

@import CoreLocation;

#import "LESLocationFetcher.h"

@interface LESLocationFetcher() <CLLocationManagerDelegate>

@property (nonatomic,strong)CLLocationManager *locationManager;
@end

@implementation LESLocationFetcher

-(instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        [self findCurrentLocation];
    }
    return self;
}

#pragma mark - Location updating calls

-(void)findCurrentLocation{
    
    NSLog(@"In findCurrentLocation...");
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    
    if([CLLocationManager locationServicesEnabled] == NO){
        NSLog(@"Location Services Not Enabled ");
    }else if(authorizationStatus == kCLAuthorizationStatusAuthorizedAlways){
            
            [self.locationManager startUpdatingLocation];
            
    }else{
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager startUpdatingLocation];
    }
    
    [self.locationManager startUpdatingLocation];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    NSLog(@"In didUpdateLocation...");
    
    CLLocation *location = [locations lastObject];
    
    if (location.horizontalAccuracy > 0) {
        [self.locationManager stopUpdatingLocation];
    }
    
    [self.delegate updateWithLocation:location];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"Error while getting core location : %@",[error localizedFailureReason]);
    if ([error code] == kCLErrorDenied) {
        //you had denied
    }
    [manager stopUpdatingLocation];
}



@end
