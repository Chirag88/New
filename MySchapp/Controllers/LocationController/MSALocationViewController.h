//
//  MSALocationViewController.h
//  MySchapp
//
//  Created by M-Creative on 5/10/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSANetworkHandler.h"
#import "MSAProtocols.h"

@interface MSALocationViewController : UIViewController<MSANetworkDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate,UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<LocationChangeDelegate> delegate;

@end
