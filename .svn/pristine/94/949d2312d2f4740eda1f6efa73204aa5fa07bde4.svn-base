//
//  MSAPlanDetailTableViewCell.m
//  MySchapp
//
//  Created by CK-Dev on 24/03/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSAPlanDetailTableViewCell.h"
#import "MSAConstants.h"
#import "MSALabel.h"

@implementation MSAPlanDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.featureNameLbl adjustFontSizeAccToScreenWidth:kPlanFeatureFont];
    
    self.featureValueView.backgroundColor = [UIColor clearColor];
    
    UIImageView *availabilityInPlan1 = [[UIImageView alloc] init];
    availabilityInPlan1.backgroundColor = [UIColor clearColor];
    availabilityInPlan1.contentMode = UIViewContentModeScaleAspectFit;
    [self.featureValueView addSubview:availabilityInPlan1];
    availabilityInPlan1.translatesAutoresizingMaskIntoConstraints = NO;
    [self.featureValueView addConstraint:[NSLayoutConstraint constraintWithItem:availabilityInPlan1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:24]];
    [self.featureValueView addConstraint:[NSLayoutConstraint constraintWithItem:availabilityInPlan1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:24]];
    [self.featureValueView addConstraint:[NSLayoutConstraint constraintWithItem:availabilityInPlan1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.featureValueView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.featureValueView addConstraint:[NSLayoutConstraint constraintWithItem:availabilityInPlan1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.featureValueView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    
    MSALabel *plan1Value = [[MSALabel alloc] init];
    plan1Value.translatesAutoresizingMaskIntoConstraints = NO;
    plan1Value.font = kPlanFeatureFont;
    [plan1Value adjustFontSizeAccToScreenWidth:kPlanFeatureFont];
    plan1Value.backgroundColor = [UIColor clearColor];
    plan1Value.textAlignment = NSTextAlignmentCenter;
    [self.featureValueView addSubview:plan1Value];
    [self.featureValueView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[avlPlan1]|" options:0 metrics:nil views:@{@"avlPlan1":plan1Value}]];
    [self.featureValueView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[avlPlan1]|" options:0 metrics:nil views:@{@"avlPlan1":plan1Value}]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
