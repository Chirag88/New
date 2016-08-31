//
//  MSALoginViewController.m
//  MySchapp
//
//  Created by CK-Dev on 23/02/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSALoginViewController.h"
#import "MSASignupViewController.h"
#import "MSAConstants.h"
#import "MSACountrySelectViewController.h"
#import "MSAUtils.h"
#import "MSALoginDecision.h"
#import "MSAAssociationViewController.h"
#import "MSAOTPViewController.h"
#import "MSAForgotPasswordViewController.h"
#import "MSATermsConditionViewController.h"


@interface MSALoginViewController ()<NSURLSessionDelegate,LoginDecisionDelegate>
@property (weak, nonatomic) IBOutlet UIButton *forgotPwdBtn;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *signupMessage;
- (IBAction)closeClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
- (IBAction)loginClicked:(id)sender;
- (IBAction)forgotPasswordClicked:(id)sender;

@end

@implementation MSALoginViewController

- (void)viewDidLoad {
//    self.emailField.text = @"c.khatter1988@gmail.com";
//    self.pwdField.text = @"Chirag@1234";
//    self.emailField.text = @"ConsultantwithAssoc@test.com";
//    self.pwdField.text = @"Pass@123";
//    self.emailField.text = @"Dummymyschapp2@gmail.com";
//    self.pwdField.text = @"Dummy@123";
    self.emailField.text = @"amits8072@gmail.com";
    self.pwdField.text = @"Pass@123";


    [super viewDidLoad];
    [self addAttributesToTextFields];
    // Do any additional setup after loading the view.
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:@"Forgot password?"];
    // making text property to underline text-
    [titleString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:(NSUnderlinePatternDot|NSUnderlineStyleSingle)] range:NSMakeRange(0, [titleString length])];
    [titleString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, [titleString length])];
    [titleString addAttribute:NSUnderlineColorAttributeName value:kUrlFontColor range:NSMakeRange(0, [titleString length])];
    // using text on button
    [self.forgotPwdBtn setAttributedTitle: titleString forState:UIControlStateNormal];
    
    self.signupMessage.delegate = self;
    NSURL *tncUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://google.com/%@", @""]];
    [self.signupMessage addLinkToURL:tncUrl withRange:NSMakeRange(28, 6)];
    NSMutableAttributedString *testString = [[NSMutableAttributedString alloc] initWithString:self.signupMessage.text];
    [testString addAttribute:NSFontAttributeName value:kLoginSignUpMsgFont range:NSMakeRange(0, [testString length])];
    [testString addAttribute:NSForegroundColorAttributeName value:kLoginSignUpMsgFontColor range:NSMakeRange(0, [testString length])];
    [testString addAttribute:NSFontAttributeName value:kMyschappFont range:NSMakeRange(11, 8)];
    [testString addAttribute:NSForegroundColorAttributeName value:kMyschappFontColor range:NSMakeRange(11, 8)];
    [testString addAttribute:NSForegroundColorAttributeName value:kUrlFontColor range:NSMakeRange(28, 6)];
    [testString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:(NSUnderlinePatternSolid|NSUnderlineStyleSingle)] range:NSMakeRange(28, 6)];
    [testString addAttribute:NSUnderlineColorAttributeName value:kUrlFontColor range:NSMakeRange(28, 6)];
    self.signupMessage.attributedText = testString;
    
    
    [self.view bringSubviewToFront:self.closeBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)addAttributesToTextFields
{
    UIImageView *leftViewEmailImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    leftViewEmailImg.image = [UIImage imageNamed:@"icon_emailInactive.png"];
    leftViewEmailImg.contentMode = UIViewContentModeScaleAspectFit;
    UIView *leftViewEmail = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftViewEmail addSubview:leftViewEmailImg];
    self.emailField.leftView = leftViewEmail;
    self.emailField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *leftViewPwdImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    leftViewPwdImg.image = [UIImage imageNamed:@"login_iconInactive_password.png"];
    leftViewPwdImg.contentMode = UIViewContentModeScaleAspectFit;
    UIView *leftViewPwd = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftViewPwd addSubview:leftViewPwdImg];
    self.pwdField.leftView = leftViewPwd;
    self.pwdField.leftViewMode = UITextFieldViewModeAlways;
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(__unused TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    NSLog(@"clicked");
    
    [self.loginDelegate controllerGotDissmissed:self];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)closeClicked:(id)sender {
   
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)loginClicked:(id)sender {
    
    NSString *urlString = [NSString stringWithFormat:@"%@?username=%@&password=%@&client_id=%@&client_secret=%@&grant_type=%@&scope=%@",[NSString stringWithFormat:@"%@%@",BASEURL,REFRESHTOKENLOGINURL],self.emailField.text,self.pwdField.text,kLoginServiceClientID,kLoginServiceClientSecret,kLoginServiceGrantType,kLoginServiceScope];
    MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
    networkHanlder.delegate = self;
    [networkHanlder createRequestForURLString:urlString withIdentifier:@"Login" requestHeaders:nil andRequestParameters:nil inView:self.view];
    
    /*
    if (![self.emailField.text isEqualToString:@""]) {
        if(![self.pwdField.text isEqualToString:@""]) {
            
            BOOL isEmailValid = [MSAUtils validateEmail:self.emailField.text];
            if (!isEmailValid) {
                NSString *urlString = [NSString stringWithFormat:@"%@?username=%@&password=%@&client_id=%@&client_secret=%@&grant_type=%@&scope=%@",[NSString stringWithFormat:@"%@%@",BASE_URL,REFRESHTOKENLOGINURL],self.emailField.text,self.pwdField.text,kLoginServiceClientID,kLoginServiceClientSecret,kLoginServiceGrantType,kLoginServiceScope];
                MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
                networkHanlder.delegate = self;
                [networkHanlder createRequestForURLString:urlString withIdentifier:@"Login" andRequestParameters:nil inView:self.view];
                
            }
            else {
                // email not valid
            }
            
        }
        else {
            // password blank
        }

    }
    else {
        // email blank
    }
    
    
    
    
    
    
    */
    
}

- (IBAction)forgotPasswordClicked:(id)sender {
    
    NSString *urlString = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%@",BASEURL,FORGOTPASSWORDURL]];
    MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
    networkHanlder.delegate = self;
    NSDictionary *requestDict = @{@"email":self.emailField.text};
    [networkHanlder createRequestForURLString:urlString withIdentifier:@"ForgotPassword" requestHeaders:nil andRequestParameters:requestDict inView:self.view];
    
    
}


#pragma mark - MSANetworkDelegate

- (void)didReceiveData:(NSData *)responseData forRequest:(NSString *)requestId
{
    //received response comes here
    NSError* err;
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&err];
    
    NSLog(@"%@",responseDict);
        
   
    if ([[responseDict objectForKey:@"rCode"] isEqualToString:@"00"] && [requestId isEqualToString:@"Login"]) {
        NSLog(@"Login successful");
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
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
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
        
        MSALoginDecision *loginDecision = [[MSALoginDecision alloc]init];
        loginDecision.delegate = self;
        [loginDecision checkLoginCriteria];
        
    }
    else if ([[responseDict objectForKey:@"rCode"] isEqualToString:@"00"] && [requestId isEqualToString:@"ForgotPassword"]){
        
        if ([[responseDict objectForKey:@"otpsent"] isEqualToString:@"Y"] || [[responseDict objectForKey:@"oas"] isEqualToString:@"Y"]) {
            //Open otp screen
            UIStoryboard *mainStoryboard = UISTORYBOARD;
            MSAOTPViewController *controller = (MSAOTPViewController*)[mainStoryboard
                                                                       instantiateViewControllerWithIdentifier: @"MSAOTPViewController"];
            controller.signupDict = @{@"email":self.emailField.text};
            controller.isComingFromForgotPass = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
        else {
            //open security question screen
            MSAForgotPasswordViewController *controller = [[MSAForgotPasswordViewController alloc]init];
            controller.question = [responseDict objectForKey:@"sq"];
            controller.emailId = self.emailField.text;
            [self.navigationController pushViewController:controller animated:YES];
            
        }
        
    }
    else if([[responseDict objectForKey:@"rCode"] isEqualToString:@"04"]) {
        UIAlertView *alert  = [[UIAlertView alloc]initWithTitle:@"Warning!" message:[responseDict objectForKey:@"rMsg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Activate", nil] ;
        alert.tag = 1101;
        [alert show];
        
    }
    else {
        UIAlertView *alert  = [[UIAlertView alloc]initWithTitle:@"Warning!" message:[responseDict objectForKey:@"rMsg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] ;
        [alert show];
        
    }

    
    
}

- (void)didFailWithError:(NSError *)error forRequest:(NSString *)requestId
{
    
     [MSAUtils showAlertWithTitle:kAlertMessageTitle message:kAlertInternalErrorMsg cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
    
}

#pragma LoginDecision Delegate
- (void)redirectToPage:(NSString *)pageToBeOpened {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    UIStoryboard *mainStoryboard = UISTORYBOARD;
    if ([pageToBeOpened isEqualToString:kCountrySelectionScreen]) {
        
        MSACountrySelectViewController *controller = (MSACountrySelectViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"CountrySelectController"];
        
        controller.countryList = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults valueForKey:kDefaultsCountryList]];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if ([pageToBeOpened isEqualToString:kAssociationScreen]) {
         MSAAssociationViewController *controller = (MSAAssociationViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"MSAAssociationController"];
        controller.associationList = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults valueForKey:kDefaultsAssociationList]];
         [self.navigationController pushViewController:controller animated:YES];
    }
    else if ([pageToBeOpened isEqualToString:kConsumerLandingScreen]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1101) {
        if (buttonIndex == 1) {
            //Account not active request otp service call
        }
    }
}

@end
