//
//  MSAProviderListViewController.h
//  MySchapp
//
//  Created by M-Creative on 8/6/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSAProviderListTableViewCell.h"

@interface MSAProviderListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *providerListView;

- (IBAction)continueBtnClicked:(id)sender;

@end
