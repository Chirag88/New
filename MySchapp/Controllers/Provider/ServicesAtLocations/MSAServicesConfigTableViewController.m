//
//  MSASpecialitiesTableViewController.m
//  MySchapp
//
//  Created by CK-Dev on 25/08/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSASpecialitiesTableViewController.h"
#import "MSANetworkHandler.h"
#import "MSAConstants.h"
#import "MSAUtils.h"
#import "MSALoginDecision.h"
#import "MSALoginViewController.h"


@interface MSASpecialitiesTableViewController ()<LoginDecisionDelegate>
{
    NSMutableArray *specialitiesList;
    NSMutableArray *selectedSpecialitiesList;
}


@end

@implementation MSASpecialitiesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Select Specialities";
    specialitiesList = [[NSMutableArray alloc]initWithArray:self.savedSpecialitiesArray];
    if (self.savedSpecialitiesArray) {
        selectedSpecialitiesList = [NSMutableArray arrayWithArray:self.savedSpecialitiesArray];
    }
    else {
        selectedSpecialitiesList = [[NSMutableArray alloc]init];
    }
    
    self.tableView.allowsMultipleSelection = YES;
    
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveSelectedlanguages)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelSelectedlanguages)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    MSALoginDecision *loginDecision = [[MSALoginDecision alloc]init];
//    loginDecision.delegate = self;
//    [loginDecision checkTokensValidityWithRequestID:@"PersonalLanguages"];

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
    return [specialitiesList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"specialityCell";
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([self.savedSpecialitiesArray containsObject:[[specialitiesList objectAtIndex:indexPath.row] objectForKey:@"description"]]) {
        cell.imageView.highlighted = YES;
    }
    if ([selectedSpecialitiesList containsObject:[[specialitiesList objectAtIndex:indexPath.row] objectForKey:@"description"]]) {
        cell.imageView.highlighted = YES;
    }
    
    [cell.imageView setImage:[UIImage imageNamed:@"checkBox.png"]];
    [cell.imageView setHighlightedImage:[UIImage imageNamed:@"checkBox_selected.png"]];
    cell.textLabel.text = [[specialitiesList objectAtIndex:indexPath.row] objectForKey:@"description"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView cellForRowAtIndexPath:indexPath].imageView.highlighted == YES) {
        [tableView cellForRowAtIndexPath:indexPath].imageView.highlighted = NO;
        if ([selectedSpecialitiesList containsObject:[[specialitiesList objectAtIndex:indexPath.row] objectForKey:@"description"]]) {
            [selectedSpecialitiesList removeObject:[[specialitiesList objectAtIndex:indexPath.row] objectForKey:@"description"]];
        }
        
    }
    else {
        [tableView cellForRowAtIndexPath:indexPath].imageView.highlighted = YES;
        [selectedSpecialitiesList addObject:[[specialitiesList objectAtIndex:indexPath.row] objectForKey:@"description"]];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView cellForRowAtIndexPath:indexPath].imageView.highlighted == YES) {
        [tableView cellForRowAtIndexPath:indexPath].imageView.highlighted = NO;
        if ([selectedSpecialitiesList containsObject:[[specialitiesList objectAtIndex:indexPath.row] objectForKey:@"description"]]) {
            [selectedSpecialitiesList removeObject:[[specialitiesList objectAtIndex:indexPath.row] objectForKey:@"description"]];
        }
        
    }
    else {
        [tableView cellForRowAtIndexPath:indexPath].imageView.highlighted = YES;
        [selectedSpecialitiesList addObject:[[specialitiesList objectAtIndex:indexPath.row] objectForKey:@"description"]];
    }
}


#pragma mark - MSANetworkDelegate

- (void)didReceiveData:(NSData *)responseData forRequest:(NSString *)requestId
{
    //received response comes here
    NSError* err;
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&err];
    
   // NSLog(@"%@",responseDict);
    if([[responseDict valueForKey:@"rCode"] isEqualToString:@"00"]) {
        NSLog(@"Got Languages data");
        specialitiesList = [responseDict objectForKey:kProfileLanguagesKey];
        
        [self.tableView reloadData];
    }
    else {
        [MSAUtils showAlertWithTitle:kAlertMessageTitle message:[responseDict valueForKey:@"rMsg"] cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
    }
    
}

- (void)didFailWithError:(NSError *)error forRequest:(NSString *)requestId
{
    [MSAUtils showAlertWithTitle:kAlertMessageTitle message:kAlertInternalErrorMsg cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
}


- (void)saveSelectedlanguages {
    
    [self.delegate specialityDoneClickedWithValues:selectedSpecialitiesList];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)cancelSelectedlanguages {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark Login Decision Delegate
- (void)redirectToPage:(NSString *)pageToBeOpened {
    
    if ([pageToBeOpened isEqualToString:@"PersonalLanguages"]) {
        NSString *urlString = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%@",BASEURL,LANGUAGESURL]];
        MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
        networkHanlder.delegate = self;
        NSDictionary *reqHeadDict = @{@"Authorization":[NSString stringWithFormat:@"bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:kAccessToken]]};
        [networkHanlder createRequestForURLString:urlString withIdentifier:@"PersonalLanguages" requestHeaders:reqHeadDict andRequestParameters:nil inView:self.view];
        
    }
    
    else if ([pageToBeOpened isEqualToString:kLoginScreen]) {
        
        UIStoryboard *mainStoryboard = UISTORYBOARD;
        
        MSALoginViewController *controller = (MSALoginViewController*)[mainStoryboard
                                                            instantiateViewControllerWithIdentifier: @"LoginViewController"];
        
        controller.loginDelegate = self;
        UINavigationController *navLoginController = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:navLoginController animated:YES completion:nil];
        
    }
    
    
    
}




@end
