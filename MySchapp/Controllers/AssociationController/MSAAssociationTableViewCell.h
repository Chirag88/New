//
//  MSAAssociationTableViewCell.h
//  MySchapp
//
//  Created by CK-Dev on 04/30/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSAProtocols.h"
#import "MSALabel.h"

@interface MSAAssociationTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet MSALabel *fromLabel;
@property (nonatomic, weak) IBOutlet MSALabel *typeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *radioImage;
@property (nonatomic, strong) NSString *regID;
@property (nonatomic, weak) id<AssociationSelectionDelegate> delegate;


@end
