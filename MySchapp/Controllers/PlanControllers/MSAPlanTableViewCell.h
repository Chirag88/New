//
//  MSAPlanTableViewCell.h
//  MySchapp
//
//  Created by CK-Dev on 11/03/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSAProtocols.h"
#import "MSALabel.h"

@interface MSAPlanTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet MSALabel *planName;
@property (nonatomic, weak) IBOutlet MSALabel *planFees;
@property (nonatomic, weak) IBOutlet MSALabel *planDescription;
@property (nonatomic, strong) NSMutableArray *features;
@property (nonatomic, weak) id<PlanSelectionDelegate> delegate;
@property (nonatomic, strong) NSString* planId;

@end
