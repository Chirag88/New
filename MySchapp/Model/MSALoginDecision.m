//
//  MSALoginDecision.m
//  MySchapp
//
//  Created by CK-Dev on 3/17/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSALoginDecision.h"
#import "MSAUtils.h"
#import "MSAConstants.h"
#import "MSATermsConditionViewController.h"
#import "MSAPaymentViewController.h"
@interface MSALoginDecision()<UIAlertViewDelegate> {
    BOOL validityCheck;
    NSString *validityRequestID;
    NSUserDefaults *userDefaults;
}
@end

@implementation MSALoginDecision

- (void)checkLoginCriteriaWhileLaunching
{
    userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults valueForKey:kRefreshToken])
    {
        //refresh token available
        if([self isValidRefreshToken])// change logic of valid resfresh instead of time get access token if you get access token then R token is valid before getting new access token check the validity of existing A token // dont change logic as agreed to take 2 months fixed time currently 7 days for testing
        {
            //open landing page without login and signup options.
            if([self.delegate respondsToSelector:@selector(redirectToPage:)])
                [self.delegate redirectToPage:kLandingPageWithoutLoginSignup];
        }
        else
        {
            //open landing page with login and signup options
            if([self.delegate respondsToSelector:@selector(redirectToPage:)])
                [self.delegate redirectToPage:kLandingPageWithLoginSignup];
        }
    }
    else    //refresh token not available
    {
        
        //open landing page with login and signup options
        if([self.delegate respondsToSelector:@selector(redirectToPage:)])
            [self.delegate redirectToPage:kLandingPageWithLoginSignup];
    }
}

- (void)checkLoginCriteria
{
    validityCheck = NO;
    userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults valueForKey:kRefreshToken])
    {
        //refresh token available
        if([self isValidRefreshToken])
        {
            //refresh token valid
            if([self isValidAccessToken])
            {
                //access token valid
                [self checkProfileStatus];
            }
            else
            {
                //get valid access token(and store all flag in userdefaults using refresh token then check profile status
                [self getAccessToken];
            }
        }
        else
        {
            //open login page
            if([self.delegate respondsToSelector:@selector(redirectToPage:)])
                [self.delegate redirectToPage:kLoginScreen];
        }
    }
    else    //refresh token not available
    {
        //open login page
        if([self.delegate respondsToSelector:@selector(redirectToPage:)])
            [self.delegate redirectToPage:kLoginScreen];
    }
}

- (void)checkTokensValidityWithRequestID:(NSString *)requestID
{
    validityCheck = YES;
    validityRequestID = requestID;
    userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults valueForKey:kRefreshToken])
    {
        //refresh token available
        if([self isValidRefreshToken])
        {
            //refresh token valid
            if([self isValidAccessToken])
            {
                //access token valid
                if([self.delegate respondsToSelector:@selector(redirectToPage:)])
                    [self.delegate redirectToPage:requestID];
            }
            else
            {
                //get valid access token(and store all flag in userdefaults using refresh token then check profile status
                [self getAccessToken];
            }
        }
        else
        {
            //open login page
            if([self.delegate respondsToSelector:@selector(redirectToPage:)])
                [self.delegate redirectToPage:kLoginScreen];
        }
    }
    else    //refresh token not available
    {
        //open login page
        if([self.delegate respondsToSelector:@selector(redirectToPage:)])
            [self.delegate redirectToPage:kLoginScreen];
    }
}


- (void)getAccessToken
{
    userDefaults = [NSUserDefaults standardUserDefaults];
    // get access token first
    NSString *urlString = [NSString stringWithFormat:@"%@?client_id=%@&client_secret=%@&grant_type=%@&refresh_token=%@",[NSString stringWithFormat:@"%@%@",BASEURL,REFRESHTOKENLOGINURL],kLoginServiceClientID,kLoginServiceClientSecret,kAccessTokenServiceGrantType,[userDefaults valueForKey:kDefaultsRefreshToken]];
    
    MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
    networkHanlder.delegate = self;
    [networkHanlder createRequestForURLString:urlString withIdentifier:kAccessTokenIdentifier requestHeaders:nil andRequestParameters:nil inView:nil];
    
}



- (void)checkProfileStatus
{
    userDefaults = [NSUserDefaults standardUserDefaults];
    if(![[userDefaults valueForKey:kDefaultsProfileStatus] isEqualToString:@"PC"])
    {
        if([[userDefaults valueForKey:kDefaultsUserRole] isEqualToString:@"C"])// check role
        {
                //check association
           if((![NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults valueForKey:kDefaultsAssociationList]] || [[NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults valueForKey:kDefaultsAssociationList]] count]==0))
            {
                //open country selection page > select country> hit S99
                if([self.delegate respondsToSelector:@selector(redirectToPage:)])
                    [self.delegate redirectToPage:kCountrySelectionScreen];
            }
            else {
                //open Association selection
                if([self.delegate respondsToSelector:@selector(redirectToPage:)])
                    [self.delegate redirectToPage:kAssociationScreen];
                
                //Open association screen > Select association> continue hit S22 with regdid
                //in response of S22
                // "role": "EP", Fixed from now cannot be changed
                // "countrycodeid":101 Fixed from now cannot be changed
                // skip country selection open personal details page
            }
        }
        else    //other roles except IP and SA
        {
            // its profile must be PC in this case
            
//            open Personal details hit S28 without request parameter
//            show the data of personal details received in S28 (Personal service)
//            send request with update data of S28 in S29 (security service)
//            send request with update data of S29 in S30 (notification service)
//            send data of S30 in request of S31
//            in response of S31 success profile completed.
            
        }
    }
    else
    {
        //check below flags and open landing pages
//        priority high to low if ps == pc
//            1. bl show message  if yes hit S35 else delete r and A token from the app.
//                2. pr take to payment Screen
//                3. rt
//                4. pd
        
        
        [self checkForAdditionalFlags];
        
    }
}

-(void)checkForAdditionalFlags {
    if (![userDefaults valueForKey:kDefaultsBlockedFlag]) {
        if (![userDefaults valueForKey:kDefaultsPaymentRequiredFlag]) {
            if (![userDefaults valueForKey:kDefaultsReacceptTermsFlag]) {
                if (![userDefaults valueForKey:kDefaultsPaymentDueFlag]) {
                    
                    // check for the roles and open the appropriate landing pages
                    //open landing pages based on the roles EP , CP, LA, TA ,IP, SA, C
                    //open login page
                    if (!validityCheck) {
                        [self checkForLandingPages];
                    }
                    else{
                        if([self.delegate respondsToSelector:@selector(redirectToPage:)])
                            [self.delegate redirectToPage:validityRequestID];
                    }
                    
                    
                }
                else {
                    // open alert warning message payment is due
                    [MSAUtils showAlertWithTitle:@"Warning" message:@"Your payment is due" cancelButton:nil otherButton:@"Ok" delegate:self.delegate];
                }
                
            }
            else {
                // Open Reaccept terms page
               // if([self.delegate respondsToSelector:@selector(redirectToPage:)])
                   // [self.delegate redirectToPage:kReacceptTermsScreen];
#warning todo make a super viewcontroller.
                
                UIViewController *vc = (UIViewController *)self.delegate;
                UIStoryboard *mainStoryboard = UISTORYBOARD;
                MSATermsConditionViewController *termsVC  = (MSATermsConditionViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"MSATermsConditionViewController"];
                termsVC.reacceptTerms = YES;
                [vc presentViewController:termsVC animated:YES completion:nil];

                
                //[MSAUtils showAlertWithTitle:@"Warning" message:@"open reaccept t&c page" cancelButton:nil otherButton:@"Ok" delegate:self.delegate];
                
            }
            
        }
        else {
            // Open Payment page
//            if([self.delegate respondsToSelector:@selector(redirectToPage:)])
//                [self.delegate redirectToPage:kPaymentScreen];
            
            //[MSAUtils showAlertWithTitle:@"Warning" message:@"open payment screen" cancelButton:nil otherButton:@"Ok" delegate:self.delegate];
            
            UIViewController *vc = (UIViewController *)self.delegate;
            
            MSAPaymentViewController *termsVC  = [[MSAPaymentViewController alloc]init];
            [vc presentViewController:termsVC animated:YES completion:nil];
            
        }
    }
    else {
        [MSAUtils showAlertWithTitle:kAlertBlockedTitle message:kAlertBlockedUserMsg cancelButton:kAlertCancelButtonTitle otherButton:kAlertOkButtonTitle delegate:self];
    }
    
    
}

-(void)checkForLandingPages {
    if ([[userDefaults valueForKey:kDefaultsUserRole] isEqualToString:@"C"]) {
        //check association
        if(([NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults valueForKey:kDefaultsAssociationList]] || [[NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults valueForKey:kDefaultsAssociationList]] count]>0))  {
            
            //open Association selection
            if([self.delegate respondsToSelector:@selector(redirectToPage:)])
                [self.delegate redirectToPage:kAssociationScreen];
        }
        else if([self.delegate respondsToSelector:@selector(redirectToPage:)])
            [self.delegate redirectToPage:kConsumerLandingScreen];
    }
    else if ([[userDefaults valueForKey:kDefaultsUserRole] isEqualToString:@"P"] ||[[userDefaults valueForKey:kDefaultsUserRole] isEqualToString:@"SA"]||[[userDefaults valueForKey:kDefaultsUserRole] isEqualToString:@"TSA"]) {
        if([self.delegate respondsToSelector:@selector(redirectToPage:)])
            [self.delegate redirectToPage:kConsumerLandingScreen];
    }
    else if ([[userDefaults valueForKey:kDefaultsUserRole] isEqualToString:@"LA"]) {
        if([self.delegate respondsToSelector:@selector(redirectToPage:)])
            [self.delegate redirectToPage:kConsumerLandingScreen];
    }
    else if ([[userDefaults valueForKey:kDefaultsUserRole] isEqualToString:@"EP"] ||[[userDefaults valueForKey:kDefaultsUserRole] isEqualToString:@"CP"]) {
        if([self.delegate respondsToSelector:@selector(redirectToPage:)])
            [self.delegate redirectToPage:kConsumerLandingScreen];
    }
    

}

-(BOOL)isValidRefreshToken {
    userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *expireTimeInterval = [userDefaults valueForKey:kDefaultsRefreshTokenExpiresIn];
    NSDate *refeshTokenReceiveTime = [userDefaults valueForKey:kDefaultsRefreshTokenReceivedTime];
    
    NSDate *currentDateTime = [NSDate date];
    NSDate *newDate = [refeshTokenReceiveTime dateByAddingTimeInterval:[expireTimeInterval doubleValue]];
    if ([currentDateTime compare:newDate]== NSOrderedAscending) {
        // Not Expired
        return YES;
    }
    return NO;
    
}

-(BOOL)isValidAccessToken {
    userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *expireTimeInterval = [userDefaults valueForKey:kDefaultsAccessTokenExpiresIn];
    NSDate *accessTokenReceiveTime = [userDefaults valueForKey:kDefaultsAccessTokenReceivedTime];
    
    NSDate *currentDateTime = [NSDate date];
    NSDate *newDate = [accessTokenReceiveTime dateByAddingTimeInterval:[expireTimeInterval doubleValue]];
    if ([currentDateTime compare:newDate]== NSOrderedAscending) {
        // Not Expired
        return YES;
    }
    return NO;
}

#pragma mark - MSANetworkDelegate

- (void)didReceiveData:(NSData *)responseData forRequest:(NSString *)requestId
{
    //received response comes here
    NSError* err;
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&err];
    
    NSLog(@"%@",responseDict);
    if ([requestId isEqualToString:kAccessTokenIdentifier]) {
        if ([[responseDict valueForKey:@"rCode"] isEqualToString:@"00"]){
            [MSAUtils resetDefaults];
            
            NSString * refreshToken = [responseDict objectForKey:kRefreshToken];
            NSString * accessToken = [responseDict objectForKey:kAccessToken];
            NSString * expiresIn = [responseDict objectForKey:kAccessTokenExpiresIn];
            NSString * accessTokenType = [responseDict objectForKey:kAccessTokenType];
            NSString * scope = [responseDict objectForKey:kLoginScope];
            NSString * userRole = [responseDict objectForKey:kUserRole];
            NSString * profileStatus = [responseDict objectForKey:kProfileStatus];
            NSArray * countryList = [responseDict objectForKey:kCountryList];
            NSString * firstTimeLogin = [responseDict objectForKey:kFirstTimeLogin];
            NSString * appVersion = [responseDict objectForKey:kAppVersion];
            NSArray * associationList = [responseDict objectForKey:kAssociationList];
            NSString * blockedFlag  = [responseDict objectForKey:kBlockedFlag];
            NSString * paymentReqFlag  = [responseDict objectForKey:kPaymentRequiredFlag];
            NSString * reacceptTermsFlag  = [responseDict objectForKey:kReacceptTermsFlag];
            NSString * paymentDueFlag  = [responseDict objectForKey:kPaymentDueFlag];
            NSString * planId = [responseDict objectForKey:kPID];
            NSString * planName = [responseDict objectForKey:kPName];
            
            userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:refreshToken forKey:kDefaultsRefreshToken];
            [userDefaults setValue:accessToken forKey:kDefaultsAccessToken];
            [userDefaults setValue:[NSNumber numberWithInteger:[expiresIn integerValue]] forKey:kDefaultsAccessTokenExpiresIn];
            
            [userDefaults setValue:accessTokenType forKey:kDefaultsAccessTokenType];
            [userDefaults setValue:[NSNumber numberWithInteger:kRefreshTokenExpiresIn] forKey:kDefaultsRefreshTokenExpiresIn];
            [userDefaults setValue:[NSDate date] forKey:kDefaultsAccessTokenReceivedTime];
            [userDefaults setValue:[NSDate date] forKey:kDefaultsRefreshTokenReceivedTime];
            [userDefaults setValue:scope forKey:kDefaultsLoginScope];
            [userDefaults setValue:userRole forKey:kDefaultsUserRole];
            if (countryList.count>0) {
                [userDefaults setValue:[NSKeyedArchiver archivedDataWithRootObject:countryList] forKey:kDefaultsCountryList];
            }
            if (associationList.count>0) {
                [userDefaults setValue:[NSKeyedArchiver archivedDataWithRootObject:associationList] forKey:kDefaultsAssociationList];
                
            }
            [userDefaults setValue:profileStatus forKey:kDefaultsProfileStatus];
            [userDefaults setValue:firstTimeLogin forKey:kDefaultsFirstTimeLogin];
            [userDefaults setValue:appVersion forKey:kDefaultsAppVersion];
            [userDefaults setValue:blockedFlag forKey:kDefaultsBlockedFlag];
            [userDefaults setValue:paymentReqFlag forKey:kDefaultsPaymentRequiredFlag];
            [userDefaults setValue:reacceptTermsFlag forKey:kDefaultsReacceptTermsFlag];
            [userDefaults setValue:paymentDueFlag forKey:kDefaultsPaymentDueFlag];
            [userDefaults setValue:planId forKey:kDefaultsPID];
            [userDefaults setValue:planName forKey:kDefaultsPName];
            [userDefaults setValue:[responseDict valueForKey:kSelectedCountry] forKey:kDefaultsSelectedCountry];

            [userDefaults synchronize];
            if (!validityCheck) {
                [self checkProfileStatus];
            }
            else {
                [self checkForAdditionalFlags];
//                if([self.delegate respondsToSelector:@selector(redirectToPage:)])
//                    [self.delegate redirectToPage:validityRequestID];
            }
        }
        else {
                userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults removeObjectForKey:kDefaultsRefreshToken];
                [userDefaults removeObjectForKey:kDefaultsAccessToken];
                [userDefaults removeObjectForKey:kDefaultsAccessTokenExpiresIn];
                [userDefaults removeObjectForKey:kDefaultsAccessTokenType];
                [userDefaults removeObjectForKey:kDefaultsAccessTokenReceivedTime];
                [userDefaults synchronize];
                // take to login page invalid refresh token
            //open login page
            if([self.delegate respondsToSelector:@selector(redirectToPage:)])
                [self.delegate redirectToPage:kLoginScreen];

        }
    }
    

}

- (void)didFailWithError:(NSError *)error forRequest:(NSString *)requestId
{
    [MSAUtils showAlertWithTitle:kAlertMessageTitle message:kAlertInternalErrorMsg cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self.delegate];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"Reverify");
        
//        NSString *urlString = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%@",BASEURL,FORGOTPASSWORDURL]];
//        MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
//        networkHanlder.delegate = self;
//        NSDictionary *requestDict = @{@"email":self.emailId};
//        [networkHanlder createRequestForURLString:urlString withIdentifier:@"Reverify" requestHeaders:nil andRequestParameters:requestDict inView:self.view];
        
    }
}

@end
