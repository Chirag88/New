//
//  MSAPlanTableViewCell.m
//  MySchapp
//
//  Created by CK-Dev on 11/03/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSAPlanTableViewCell.h"
#import "MSAConstants.h"
@interface MSAPlanTableViewCell() {
    
    __weak IBOutlet UIView *cellContentView;
}
- (IBAction)selectPlan:(id)sender;
- (IBAction)viewDetails:(id)sender;
@end

@implementation MSAPlanTableViewCell


- (void)awakeFromNib {

    cellContentView.backgroundColor = kPlanCellBackGroundColor;
    cellContentView.layer.cornerRadius = 5;
    self.planName.textColor = kPlanNameColor;
    [self.planName adjustFontSizeAccToScreenWidth:kPlanNameFont];
    self.planDescription.textColor = kPlanDescColor;
    [self.planDescription adjustFontSizeAccToScreenWidth:kPlanDescFont];
    self.planFees.textColor = kPlanDescColor;
    [self.planFees adjustFontSizeAccToScreenWidth:kPlanPriceFont];
    
}


- (IBAction)selectPlan:(id)sender {
    
    [self.delegate selectedPlan:self.planId andPlanName:self.planName.text];
}

- (IBAction)viewDetails:(id)sender {
    [self.delegate viewPlanDetail:self];
}
@end

