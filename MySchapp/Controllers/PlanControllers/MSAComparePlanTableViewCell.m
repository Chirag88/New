//
//  MSAComparePlanTableViewCell.m
//  MySchapp
//
//  Created by CK-Dev on 3/30/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSAComparePlanTableViewCell.h"
#import "MSAConstants.h"
#import "MSALabel.h"

@implementation MSAComparePlanTableViewCell

- (void)awakeFromNib {
    // Initialization code
    // Plan 1
    [self.feature adjustFontSizeAccToScreenWidth:kPlanFeatureFont];
    UIImageView *availabilityInPlan1 = [[UIImageView alloc] init];
    availabilityInPlan1.backgroundColor = [UIColor clearColor];
    availabilityInPlan1.contentMode = UIViewContentModeScaleAspectFit;
    [self.plan1 addSubview:availabilityInPlan1];
    availabilityInPlan1.translatesAutoresizingMaskIntoConstraints = NO;
    [self.plan1 addConstraint:[NSLayoutConstraint constraintWithItem:availabilityInPlan1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:24]];
    [self.plan1 addConstraint:[NSLayoutConstraint constraintWithItem:availabilityInPlan1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:24]];
    [self.plan1 addConstraint:[NSLayoutConstraint constraintWithItem:availabilityInPlan1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.plan1 attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.plan1 addConstraint:[NSLayoutConstraint constraintWithItem:availabilityInPlan1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.plan1 attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    
    MSALabel *plan1Value = [[MSALabel alloc] init];
    plan1Value.translatesAutoresizingMaskIntoConstraints = NO;
    plan1Value.font = kPlanFeatureFont;
    [plan1Value adjustFontSizeAccToScreenWidth:kPlanFeatureFont];
    plan1Value.backgroundColor = [UIColor clearColor];
    plan1Value.textAlignment = NSTextAlignmentCenter;
    [self.plan1 addSubview:plan1Value];
    [self.plan1 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[avlPlan1]|" options:0 metrics:nil views:@{@"avlPlan1":plan1Value}]];
    [self.plan1 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[avlPlan1]|" options:0 metrics:nil views:@{@"avlPlan1":plan1Value}]];
    
    
    // Plan 2
    UIImageView *availabilityInPlan2 = [[UIImageView alloc] init];
    availabilityInPlan2.backgroundColor = [UIColor clearColor];
    availabilityInPlan2.contentMode = UIViewContentModeScaleAspectFit;
    [self.plan2 addSubview:availabilityInPlan2];
    availabilityInPlan2.translatesAutoresizingMaskIntoConstraints = NO;
    [self.plan2 addConstraint:[NSLayoutConstraint constraintWithItem:availabilityInPlan2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:24]];
    [self.plan2 addConstraint:[NSLayoutConstraint constraintWithItem:availabilityInPlan2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:24]];
    [self.plan2 addConstraint:[NSLayoutConstraint constraintWithItem:availabilityInPlan2 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.plan2 attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.plan2 addConstraint:[NSLayoutConstraint constraintWithItem:availabilityInPlan2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.plan2 attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    
    MSALabel *plan2Value = [[MSALabel alloc] init];
    plan2Value.translatesAutoresizingMaskIntoConstraints = NO;
    [self.plan2 addSubview:plan2Value];
    plan2Value.font = kPlanFeatureFont;
    [plan2Value adjustFontSizeAccToScreenWidth:kPlanFeatureFont];
    plan2Value.backgroundColor = [UIColor clearColor];
    plan2Value.textAlignment = NSTextAlignmentCenter;
    [self.plan2 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[avlPlan2]|" options:0 metrics:nil views:@{@"avlPlan2":plan2Value}]];
    [self.plan2 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[avlPlan2]|" options:0 metrics:nil views:@{@"avlPlan2":plan2Value}]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
