//
//  MSAEducationTableViewCell.h
//  MySchapp
//
//  Created by CK-Dev on 08/04/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSAProtocols.h"
#import "MSALabel.h"

@interface MSAEducationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet MSALabel *qualificationLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;
- (IBAction)qualificationDelete:(id)sender;
@property(nonatomic, weak) id<DeleteEducationFromListDelegate> delegate;

@end
