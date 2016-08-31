//
//  MSALocationHelper.h
//  MySchapp
//
//  Created by CK-Dev on 4/30/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MSALocationHelper : NSObject<CLLocationManagerDelegate>

@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *countryName;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSString *city;

+ (id)sharedInstance;
- (void)updateCurrentLocation;

@end
