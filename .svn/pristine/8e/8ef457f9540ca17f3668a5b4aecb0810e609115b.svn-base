//
//  MSALocationHelper.m
//  MySchapp
//
//  Created by CK-Dev on 4/30/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSALocationHelper.h"
#import "MSAUtils.h"

static MSALocationHelper *sharedObject = nil;
static dispatch_once_t dispatchToken;

@interface MSALocationHelper()
{
    CLLocationManager *locationManager;
}

@end

@implementation MSALocationHelper

+ (id)sharedInstance
{
    dispatch_once(&dispatchToken, ^{
        sharedObject = [[self alloc] init];
    });
    
    return sharedObject;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        locationManager = [[CLLocationManager alloc] init];
        
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter=kCLDistanceFilterNone;
        [locationManager requestWhenInUseAuthorization];
        [locationManager startMonitoringSignificantLocationChanges];
        [locationManager startUpdatingLocation];
    }
    return self;
}

- (void)updateCurrentLocation
{
    [locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        self.longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        self.latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    // Stop Location Manager
    [locationManager stopUpdatingLocation];
    
    NSString *addressURL = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@&sensor=true",self.latitude,self.longitude];
    NSURL *requestUrl =[[NSURL alloc]initWithString:[addressURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestUrl];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSError* error;
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONWritingPrettyPrinted error:&error];
        NSDictionary *jsonDict = (NSDictionary *)jsonObject;
        NSString *cur_address = [[[jsonDict objectForKey:@"results"] objectAtIndex:0] valueForKey:@"formatted_address"];
        NSLog(@"ADDRESS : %@",cur_address);
        self.address = cur_address;
        //locationLabel.text = [NSString stringWithFormat:@"of %@",address];
    }];
    
    CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
    [reverseGeocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *myPlacemark = [placemarks objectAtIndex:0];
        NSString *countryCode = myPlacemark.ISOcountryCode;
        NSString *countryName = myPlacemark.country;
        NSString *cityName= myPlacemark.subAdministrativeArea;
        NSLog(@"My country code: %@ and countryName: %@ MyCity: %@", countryCode, countryName, cityName);
        self.countryName = countryName;
        self.countryCode = countryCode;
        self.city = cityName;
    }];
}

@end
