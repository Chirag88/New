//
//  MSAAssociationViewController.h
//  MySchapp
//
//  Created by CK-Dev on 20/03/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSAAssociationViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *associationList;
@property (nonatomic, weak) IBOutlet UITableView *associationTable;

- (IBAction)continueClicked:(id)sender;
- (IBAction)declineClicked:(id)sender;

@end
