//
//  MSALandingPageViewController.h
//  MySchapp
//
//  Created by CK-Dev on 23/02/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "MSAProtocols.h"
#import "MSASearchViewController.h"

@interface MSALandingPageViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate, iCarouselDataSource, iCarouselDelegate, SubCategoryDelegate, SearchResultCallbackDelegate, MenuButtonDelegate, LocationChangeDelegate>

@property BOOL showLoginSignup;

@end
