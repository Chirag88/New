//
//  MSAComparePlanViewController.h
//  MySchapp
//
//  Created by CK-Dev on 3/11/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSALabel.h"

@interface MSAComparePlanViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *featureList;
@property (nonatomic, strong) NSMutableArray *plansAvailable;
@property (nonatomic, strong) NSString *selectedCountryId;
@property (nonatomic, strong) NSString *selectedCountryName;
@property (nonatomic, strong) NSString *selectedCountryCode;

@property (nonatomic, weak) IBOutlet UIButton *plan1;
@property (nonatomic, weak) IBOutlet UIButton *plan2;
@property (weak, nonatomic) IBOutlet MSALabel *plan1Price;
@property (weak, nonatomic) IBOutlet MSALabel *plan2Price;
@property (weak, nonatomic) IBOutlet UIButton *selectPlan1;
@property (weak, nonatomic) IBOutlet UIButton *selectPlan2;
@property (weak, nonatomic) IBOutlet UIView *featureHeaderView;
@property (weak, nonatomic) IBOutlet UIView *choosePlanHeaderView;

- (IBAction)selectPlan1:(id)sender;
- (IBAction)selectPlan2:(id)sender;
- (IBAction)choosePlan:(id)sender;


@end
