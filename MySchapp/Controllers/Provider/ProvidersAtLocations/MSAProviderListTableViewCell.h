//
//  MSAProviderListTableViewCell.h
//  MySchapp
//
//  Created by M-Creative on 8/6/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSALabel.h"

@interface MSAProviderListTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet MSALabel *location;
@property (nonatomic, strong) IBOutlet MSALabel *providers;
@property (nonatomic, strong) IBOutlet MSALabel *specialities;

@end
