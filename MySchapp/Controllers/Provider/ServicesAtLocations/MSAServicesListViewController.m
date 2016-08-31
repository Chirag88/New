//
//  MSAProviderListViewController.m
//  MySchapp
//
//  Created by M-Creative on 8/6/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSAProviderListViewController.h"
#import "MSAProviderProfileViewController.h"
#import "MSAConstants.h"

@interface MSAProviderListViewController ()

@end

@implementation MSAProviderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)continueBtnClicked:(id)sender
{
    UIStoryboard *mainStoryboard = UISTORYBOARD;
    MSAProviderProfileViewController *providerVC  = (MSAProviderProfileViewController*)[mainStoryboard
                                                                                   instantiateViewControllerWithIdentifier:@"MSAProviderProfileViewController"];
    [self.navigationController pushViewController:providerVC animated:YES];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MSAProviderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSAProviderListTableViewCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.providers.text = @"Provider: XYZ";
    cell.location.text = @"Locations: ABC, DEF";
    cell.specialities.text = @"Specialities: 123, 456";
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
    }
}


@end
