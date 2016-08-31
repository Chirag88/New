//
//  MSACountrySelectViewController.h
//  MySchapp
//
//  Created by CK-Dev on 10/03/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSAProtocols.h"

@interface MSACountrySelectViewController : UIViewController<LoginDecisionDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong)NSArray *countryList;

@end
