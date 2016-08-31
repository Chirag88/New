//
//  MSAPlanViewContoller.m
//  MySchapp
//
//  Created by CK-Dev on 10/03/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSAPlanViewContoller.h"
#import "MSAPlanTableViewCell.h"
#import "MSAConstants.h"
#import "MSAPlanDetailViewController.h"
#import "MSAPersonalViewController.h"
#import "MSALoginDecision.h"
#import "MSAUtils.h"
#import "MSAComparePlanViewController.h"
#import "MSALoginViewController.h"

@interface MSAPlanViewContoller()<LoginDecisionDelegate>
{
    NSMutableArray *plansAvailable;
    NSString *selectedPlanId;
    NSString *selectedPlanName;
    __weak IBOutlet MSALabel *selectedCountryOutlet;
    __weak IBOutlet MSALabel *selectMessageOutlet;
    __weak IBOutlet MSALabel *welcomeUserOutlet;
    __weak IBOutlet UIImageView *countryImageOutlet;
}
@end

@implementation MSAPlanViewContoller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [MSAUtils setNavigationBarAttributes:self.navigationController];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Plans";
    
    [selectedCountryOutlet adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    selectedCountryOutlet.text = self.selectedCountryName;
    
    [countryImageOutlet setImage:[UIImage imageNamed:@"flag_US.png"]];
    [welcomeUserOutlet adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:14]];
    welcomeUserOutlet.textColor = kProfileSelPlanColor;
    MSALoginDecision *loginDecision = [[MSALoginDecision alloc]init];
    loginDecision.delegate = self;
    [loginDecision checkTokensValidityWithRequestID:@"Plans"];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark TableView Delegates
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return plansAvailable.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MSAPlanTableViewCell";
    
    MSAPlanTableViewCell *cell = (MSAPlanTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = (MSAPlanTableViewCell *) [[[NSBundle mainBundle] loadNibNamed:@"MSAPlanTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.planName.text = [[plansAvailable objectAtIndex:indexPath.row] valueForKey:@"planname"];
    //cell.planFees.text = [NSString stringWithFormat:@"%@ User",[[[plansAvailable objectAtIndex:indexPath.row] valueForKey:@"plancost"] stringValue]];
    cell.planFees.text = @"";
   //cell.planDescription.text = [[plansAvailable objectAtIndex:indexPath.row] valueForKey:@"plantype"];
    cell.planDescription.numberOfLines =2;
    if (indexPath.row == 0) {
        cell.planDescription.text = @"For Consumers, no Service Provider";
    }
    else if (indexPath.row == 1) {
        cell.planDescription.text = @"1 Service Provider";
    }
    else if (indexPath.row == 2) {
        cell.planDescription.text = @"Up to 5 Service Providers";
    }
    else if (indexPath.row == 3) {
        cell.planDescription.text = @"Up to 10 Service Providers";
    }
    else if (indexPath.row == 4) {
        cell.planDescription.text = @"Up to 25 Service Providers";
    }
    
    cell.features = [[plansAvailable objectAtIndex:indexPath.row] valueForKey:@"features"];
    cell.delegate = self;
    cell.planId = [[plansAvailable objectAtIndex:indexPath.row] valueForKey:@"planid"];
    return cell;
}


- (IBAction)comparePlans:(id)sender
{
    // open compare plan screen
    UIStoryboard *mainStoryboard = UISTORYBOARD;
    
    MSAComparePlanViewController *controller = (MSAComparePlanViewController*)[mainStoryboard
                                                                             instantiateViewControllerWithIdentifier:@"ComparePlanController"];
    controller.plansAvailable = plansAvailable;
    controller.selectedCountryId = self.selectedCountryId;
    controller.selectedCountryName = self.selectedCountryName;
    controller.selectedCountryCode = self.selectedCountryCode;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)customizedPlan:(id)sender {
     [MSAUtils showAlertWithTitle:kAlertMessageTitle message:kAlertHigherPlanMessage cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setValue:@"Y" forKey:kDefaultsHigherPlanSelected];
    [userdefaults synchronize];
}


#pragma mark - PlanSelection and Detail Delegate

- (void)selectedPlan:(NSString *)planId andPlanName:(NSString *)planName {
    // open personal detail page
    // and fetch the details hit S28 with planid and countryid
    
    selectedPlanId = planId;
    selectedPlanName = planName;
    MSALoginDecision *loginDecision = [[MSALoginDecision alloc]init];
    loginDecision.delegate = self;
    [loginDecision checkTokensValidityWithRequestID:@"ChoosePlan"];
    
    
    
    
}

- (void)viewPlanDetail:(id)plan {
    
    //open plan detail screen
    
    MSAPlanTableViewCell *planSelected = plan;
    UIStoryboard *mainStoryboard = UISTORYBOARD;
    
    MSAPlanDetailViewController *controller = (MSAPlanDetailViewController*)[mainStoryboard
                                                                                   instantiateViewControllerWithIdentifier:@"PlanDetailController"];
    controller.planFeatures = planSelected.features;
    controller.planName = planSelected.planName.text;
    controller.planFees = planSelected.planFees.text;
    [self.navigationController pushViewController:controller animated:YES];
    
    
}

#pragma mark - MSANetworkDelegate

- (void)didReceiveData:(NSData *)responseData forRequest:(NSString *)requestId
{
    //received response comes here
    NSError* err;
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&err];
    
    //NSLog(@"%@",responseDict);
    if([[responseDict valueForKey:@"rCode"] isEqualToString:@"00"]) {
        plansAvailable = [responseDict valueForKey:@"plans"];
        [self.plansTableView reloadData];
    }
    else {
        UIAlertView *alert  = [[UIAlertView alloc]initWithTitle:@"Message" message:[responseDict objectForKey:@"rMsg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] ;
        [alert show];
    }

}

- (void)didFailWithError:(NSError *)error forRequest:(NSString *)requestId
{
     [MSAUtils showAlertWithTitle:kAlertMessageTitle message:kAlertInternalErrorMsg cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
}

#pragma LoginDecision Delegate
- (void)redirectToPage:(NSString *)pageToBeOpened {
    if ([pageToBeOpened isEqualToString:kLoginScreen]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (![[defaults valueForKey:kDefaultsProfileStatus]isEqualToString:@"PC"]) {
            [self.navigationController popViewControllerAnimated:NO];
        }
        else {
            UIStoryboard *mainStoryboard = UISTORYBOARD;
            
            MSALoginViewController *controller = (MSALoginViewController*)[mainStoryboard
                                                                           instantiateViewControllerWithIdentifier: @"LoginViewController"];
            
            controller.loginDelegate = self;
            UINavigationController *navLoginController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:navLoginController animated:YES completion:nil];
        }

        
    }
    else if ([pageToBeOpened isEqualToString:@"ChoosePlan"])
    {
        UIStoryboard *mainStoryboard = UISTORYBOARD;
        
        MSAPersonalViewController *controller = (MSAPersonalViewController*)[mainStoryboard
                                                                             instantiateViewControllerWithIdentifier:@"MSAPersonalViewController"];
        controller.selectedCountryId = self.selectedCountryId;
        controller.selectedPlanId = selectedPlanId;
        controller.selectedCountryName = self.selectedCountryName;
        controller.selectedCountryCode = self.selectedCountryCode;
        controller.selectedPlanName = selectedPlanName;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if ([pageToBeOpened isEqualToString:@"Plans"]){
        NSString *urlString = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%@",BASEURL,PLANURL]];
        MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
        networkHanlder.delegate = self;
        NSDictionary *reqHeadDict = @{@"Authorization":[NSString stringWithFormat:@"bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:kAccessToken]]};
        [networkHanlder createRequestForURLString:urlString withIdentifier:@"Plans" requestHeaders:reqHeadDict andRequestParameters:@{@"countrycodeid":self.selectedCountryId} inView:self.view];
    }
}



@end
