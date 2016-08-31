//
//  MSALocationListViewController.m
//  MySchapp
//
//  Created by CK-Dev on 14/07/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSALocationListViewController.h"
#import "MSAUtils.h"
#import "MSAAddNewLocationViewController.h"
#import "MSAConstants.h"

@interface MSALocationListViewController () {
    NSArray *locationsList;
}
@end

@implementation MSALocationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MSAUtils setNavigationBarAttributes:self.navigationController];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Locations";

    locationsList = @[@"Location1",@"Location2",@"Location3",@"Location4"];
    
    UIBarButtonItem* addNewLocation = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewLocation:)];
    
    self.navigationItem.rightBarButtonItem = addNewLocation;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return locationsList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;// = [self.tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    // Configure the cell...
    cell.textLabel.text = [locationsList objectAtIndex:indexPath.row];
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


-(void)addNewLocation:(id)sender {
    
    
    UIStoryboard *mainStoryboard = UISTORYBOARD;
    MSAAddNewLocationViewController *addLocation  = (MSAAddNewLocationViewController*)[mainStoryboard
                                                                                   instantiateViewControllerWithIdentifier:@"MSAAddNewLocationViewController"];
    [self.navigationController pushViewController:addLocation animated:YES];
    
}



@end
