//
//  MSASpecialitiesTableViewController.h
//  MySchapp
//
//  Created by CK-Dev on 25/08/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSAProtocols.h"

@interface MSASpecialitiesTableViewController : UITableViewController
@property (nonatomic,strong)NSArray *savedSpecialitiesArray;
@property (nonatomic,weak) id<SpecialityDoneCancelDelegate> delegate;
@end
