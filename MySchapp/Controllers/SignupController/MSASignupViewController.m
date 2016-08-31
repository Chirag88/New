//
//  MSASignupViewController.m
//  MySchapp
//
//  Created by CK-Dev on 23/02/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSASignupViewController.h"
#import "MSAUtils.h"
#import "MSAConstants.h"
#import "MSAOTPViewController.h"
#import "MSAPrivacyPolicyViewController.h"
#import "MSATermsConditionViewController.h"
#import "MSAConstants.h"
#import "MSALocationHelper.h"

@interface MSASignupViewController ()
{
    NSDictionary *requestJSON;
    MSALocationHelper *location;
}
- (IBAction)closeClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@end

@implementation MSASignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.emailField.text = @"ConsultantwithAssoc@test.com";
//    self.pwdField.text = @"Pass@123";
//    self.rePwdField.text = @"Pass@123";
//    
    self.emailField.text = @"Dummymyschapp2@gmail.com";
    self.pwdField.text = @"Dummy@123";
    self.rePwdField.text = @"Dummy@123";
    
//    self.emailField.text = @"c.khatter1988@gmail.com";
//    self.pwdField.text = @"Chirag@1234";
//    self.rePwdField.text = @"Chirag@1234";
    // Do any additional setup after loading the view.
    [self addAttributesAndLinksToLabels];
    UITapGestureRecognizer *checkGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkBoxClicked:)];
    checkGesture.numberOfTapsRequired = 1;
    [self.alreadyCheckImgView addGestureRecognizer:checkGesture];
    [self.view bringSubviewToFront:self.closeBtn];
    
    location = [MSALocationHelper sharedInstance];
    [location updateCurrentLocation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkBoxClicked:(id)sender
{
    if(self.alreadyCheckImgView.highlighted)
    {
        self.alreadyCheckImgView.highlighted = NO;
    }
    else
    {
        self.alreadyCheckImgView.highlighted = YES;
    }
}

- (void)addAttributesAndLinksToLabels
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
    
    UIImageView *leftViewConfPwdImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    leftViewConfPwdImg.image = [UIImage imageNamed:@"login_iconInactive_password.png"];
    leftViewConfPwdImg.contentMode = UIViewContentModeScaleAspectFit;
    UIView *leftViewConfPwd = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftViewConfPwd addSubview:leftViewConfPwdImg];
    self.rePwdField.leftView = leftViewConfPwd;
    self.rePwdField.leftViewMode = UITextFieldViewModeAlways;
    
    self.tncPolicyLbl.delegate = self;
    self.loginLbl.delegate = self;
    
    NSURL *tncUrl = [NSURL URLWithString:[NSString stringWithFormat:@"TermsConditions%@", @""]];
    [self.tncPolicyLbl addLinkToURL:tncUrl withRange:NSMakeRange(25, 16)];
    NSURL *policyUrl = [NSURL URLWithString:[NSString stringWithFormat:@"Privacy%@", @""]];
    [self.tncPolicyLbl addLinkToURL:policyUrl withRange:NSMakeRange(44, 14)];
    
    NSMutableAttributedString *testString = [[NSMutableAttributedString alloc] initWithString:self.tncPolicyLbl.text];
    [testString addAttribute:NSFontAttributeName value:kLoginSignUpMsgFont range:NSMakeRange(0, [testString length])];
    [testString addAttribute:NSForegroundColorAttributeName value:kLoginSignUpMsgFontColor range:NSMakeRange(0, [testString length])];
    [testString addAttribute:NSForegroundColorAttributeName value:kUrlFontColor range:NSMakeRange(25, 16)];
    [testString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:(NSUnderlinePatternSolid|NSUnderlineStyleSingle)] range:NSMakeRange(25, 16)];
    [testString addAttribute:NSUnderlineColorAttributeName value:kUrlFontColor range:NSMakeRange(25, 16)];
    [testString addAttribute:NSForegroundColorAttributeName value:kUrlFontColor range:NSMakeRange(44, 14)];
    [testString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:(NSUnderlinePatternSolid|NSUnderlineStyleSingle)] range:NSMakeRange(44, 14)];
    [testString addAttribute:NSUnderlineColorAttributeName value:kUrlFontColor range:NSMakeRange(44, 14)];
    self.tncPolicyLbl.attributedText = testString;

    NSURL *loginUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://google.com/%@", @""]];
    [self.loginLbl addLinkToURL:loginUrl withRange:NSMakeRange(31, 5)];

    NSMutableAttributedString *loginUrlString = [[NSMutableAttributedString alloc] initWithString:self.loginLbl.text];
    [loginUrlString addAttribute:NSFontAttributeName value:kLoginSignUpMsgFont range:NSMakeRange(0, [loginUrlString length])];
    [loginUrlString addAttribute:NSForegroundColorAttributeName value:kLoginSignUpMsgFontColor range:NSMakeRange(0, [loginUrlString length])];
    [loginUrlString addAttribute:NSFontAttributeName value:kMyschappFont range:NSMakeRange(13, 8)];
    [loginUrlString addAttribute:NSForegroundColorAttributeName value:kMyschappFontColor range:NSMakeRange(13, 8)];
    [loginUrlString addAttribute:NSForegroundColorAttributeName value:kUrlFontColor range:NSMakeRange(31, 5)];
    [loginUrlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:(NSUnderlinePatternSolid|NSUnderlineStyleSingle)] range:NSMakeRange(31, 5)];
    [loginUrlString addAttribute:NSUnderlineColorAttributeName value:kUrlFontColor range:NSMakeRange(31, 5)];
    self.loginLbl.attributedText = loginUrlString;
}

- (void)openOTPPage
{
    UIStoryboard *mainStoryboard = UISTORYBOARD;
    MSAOTPViewController *controller = (MSAOTPViewController*)[mainStoryboard
                                                               instantiateViewControllerWithIdentifier: @"MSAOTPViewController"];
    controller.signupDict = requestJSON;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)signupClicked:(id)sender
{
    if(![self.emailField.text isEqualToString:@""] && ![self.pwdField.text isEqualToString:@""] && ![self.rePwdField.text isEqualToString:@""]) {
        if([self.pwdField.text isEqualToString:self.rePwdField.text]) {
            BOOL isEmailValid = [MSAUtils validateEmail:self.emailField.text];
            BOOL isPwdValid = [MSAUtils validatePassword:self.pwdField.text];
            isPwdValid = YES;
            if(isEmailValid && isPwdValid) {
                if(self.alreadyCheckImgView.highlighted) {
                    NSString *latitude = location.latitude;
                    NSString *longitude = location.longitude;
                    NSString *uid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
                    NSString *tnc = @"y";
                    requestJSON = [[NSDictionary alloc] initWithObjectsAndKeys:self.emailField.text,@"email",self.pwdField.text,@"password",self.rePwdField.text,@"confpassword",tnc,@"termsconditions",uid,@"uid",latitude,@"latitude",longitude,@"longitude", nil];
                    
                    //call signup service
                    MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
                    networkHanlder.delegate = self;
                    [networkHanlder createRequestForURLString:[NSString stringWithFormat:@"%@%@",BASEURL,SIGNUPURL] withIdentifier:@"Signup" requestHeaders:nil andRequestParameters:requestJSON inView:self.view];
                    //to be removed
//                    [self openOTPPage];
                }
                else {
                    //accept terms and conditions
                    UIAlertView *acceptTnC = [[UIAlertView alloc] initWithTitle:@"" message:@"Please check the box to confirm that you've read and accepted the terms of service and privacy policy" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [acceptTnC show];
                }
            }
            else {
                //email/password is not valid
                UIAlertView *validateAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"email/password doesn't match the criteria" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [validateAlert show];
            }
        }
        else {
            //password and confirmPassword doesn't match
            UIAlertView *passwordConf = [[UIAlertView alloc] initWithTitle:@"" message:@"Passwords doesn't match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [passwordConf show];
        }
    }
    else {
        //empty email and/or password
        UIAlertView *emptyFieldAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Fields can't be empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [emptyFieldAlert show];
    }
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSLog(@"clicked");
    
    if (label == self.loginLbl) {
        [self.signupDelegate controllerGotDissmissed:self];
    }
    else {
        if ([url.absoluteString isEqualToString:@"TermsConditions"]) {
            UIStoryboard *mainStoryboard = UISTORYBOARD;
            MSATermsConditionViewController *termsVC  = (MSATermsConditionViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"MSATermsConditionViewController"];
            [self.navigationController pushViewController:termsVC animated:YES];

            
        }
        else if ([url.absoluteString isEqualToString:@"Privacy"]) {
            
            UIStoryboard *mainStoryboard = UISTORYBOARD;
            MSAPrivacyPolicyViewController *privacyVC  = (MSAPrivacyPolicyViewController*)[mainStoryboard
                    instantiateViewControllerWithIdentifier:@"MSAPrivacyPolicyViewController"];
            [self.navigationController pushViewController:privacyVC animated:YES];
        }
        
    }
    
}

- (void)attributedLabel:(__unused TTTAttributedLabel *)label didLongPressLinkWithURL:(__unused NSURL *)url atPoint:(__unused CGPoint)point {

}

#pragma mark - MSANetworkDelegate

- (void)didReceiveData:(NSData *)responseData forRequest:(NSString *)requestId
{
    //received response comes here
    NSError* err;
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&err];
    if ([[responseDict objectForKey:@"rCode"] isEqualToString:@"00"]) {
        NSLog(@"OPEN OTP");
        [self openOTPPage];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closeClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
