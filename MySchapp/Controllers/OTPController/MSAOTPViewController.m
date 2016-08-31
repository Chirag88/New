//
//  MSAOTPViewController.m
//  MySchapp
//
//  Created by CK-Dev on 3/9/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSAOTPViewController.h"
#import "MSAConstants.h"
#import "MSAOTPSuccessViewController.h"
#import "MSAOTPFailureViewController.h"
#import "MSAUtils.h"
#import "MSAChangePwdViewController.h"

@interface MSAOTPViewController ()<UITextFieldDelegate>

@end

@implementation MSAOTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.otpLbl adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    self.navigationController.navigationBarHidden = NO;
    [MSAUtils setNavigationBarAttributes:self.navigationController];
    self.navigationItem.title = @"Verify OTP";
    
    self.otpField.delegate = self;
    NSString *emailId = [self.signupDict valueForKey:@"email"];
    NSArray *components = [emailId componentsSeparatedByString:@"@"];
    NSString *firstComp = [components firstObject];
    NSString *emailToShow = [NSString stringWithFormat:@"xxxx%@@%@",[firstComp substringWithRange:NSMakeRange(firstComp.length-4, 4)],[components lastObject]];
    if (_isComingFromForgotPass) {
        self.otpLbl.text = [NSString stringWithFormat:@"Enter OTP to reset your password, that we have sent to your Email ID %@",emailToShow];
    }
    else {
        self.otpLbl.text = [NSString stringWithFormat:@"Activate your account. \nEnter the one time password (OTP), we have sent to your Email ID %@",emailToShow];
    }
    
    self.verifyBtn.backgroundColor = kMySchappMediumBlueColor;
    self.verifyBtn.layer.cornerRadius = 5;
    [self.verifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.resendBtn.backgroundColor = kMySchappMediumBlueColor;
    self.resendBtn.layer.cornerRadius = 5;
    [self.resendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(limitTextFieldReached) name:UITextFieldTextDidChangeNotification object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openThanksAndLoginPage
{
    UIStoryboard *mainStoryboard = UISTORYBOARD;
    MSAOTPSuccessViewController *controller = (MSAOTPSuccessViewController*)[mainStoryboard
                                                               instantiateViewControllerWithIdentifier: @"MSAOTPSuccessViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)openInvalidOTPPage
{
    UIStoryboard *mainStoryboard = UISTORYBOARD;
    MSAOTPFailureViewController *controller = (MSAOTPFailureViewController*)[mainStoryboard
                                                                             instantiateViewControllerWithIdentifier: @"MSAOTPFailureViewController"];
    controller.signupDict = self.signupDict;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)verifyOTP:(id)sender
{
    //call otp service
    NSDictionary *requestJSON = [[NSDictionary alloc] initWithObjectsAndKeys:[self.signupDict valueForKey:@"email"],@"email",self.otpField.text,@"otp", nil];
    
    MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
    networkHanlder.delegate = self;
    if (_isComingFromForgotPass) {
         [networkHanlder createRequestForURLString:[NSString stringWithFormat:@"%@%@",BASEURL,FORGOTPASSSECUIRTYURL] withIdentifier:@"ForgotPassOTP" requestHeaders:nil andRequestParameters:requestJSON inView:self.view];
    }
    else {
        [networkHanlder createRequestForURLString:[NSString stringWithFormat:@"%@%@",BASEURL,VERIFYOTPURL] withIdentifier:@"SignUPOTP" requestHeaders:nil andRequestParameters:requestJSON inView:self.view];
    }
    
   
}

#pragma mark - MSANetworkDelegate

- (void)didReceiveData:(NSData *)responseData forRequest:(NSString *)requestId
{
    //received response comes here
    NSError* err;
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&err];
    if ([[responseDict objectForKey:@"rCode"] isEqualToString:@"00"] && [requestId isEqualToString:@"SignUPOTP"]) {
        [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];

        //successfully verified page
        [self openThanksAndLoginPage];
        
    }
    else if ([[responseDict objectForKey:@"rCode"] isEqualToString:@"00"] && [requestId isEqualToString:@"ForgotPassOTP"]) {
        // Open Change Password Screen
        MSAChangePwdViewController *controller = [[MSAChangePwdViewController alloc]init];
        controller.emailId = [self.signupDict valueForKey:@"email"];
        
        [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
        UIViewController *tempVC = [viewControllers objectAtIndex:0];
        [viewControllers removeAllObjects];
        [viewControllers addObject:tempVC];
        [viewControllers addObject:controller];
        [self.navigationController setViewControllers: viewControllers animated: YES];
        
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    else if ([[responseDict objectForKey:@"rCode"] isEqualToString:@"00"] && [requestId isEqualToString:@"RequestOTP"]) {
        if ([[responseDict objectForKey:@"otpsent"] isEqualToString:@"Y"] || [[responseDict objectForKey:@"oas"] isEqualToString:@"Y"]) {
        UIAlertView *alert  = [[UIAlertView alloc]initWithTitle:@"Message" message:@"OTP resent to your Email ID" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] ;
        [alert show];
        }
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.otpField resignFirstResponder];
}   



- (IBAction)resendOTP:(id)sender {
    if (_isComingFromForgotPass) {
        NSString *urlString = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%@",BASEURL,FORGOTPASSWORDURL]];
        MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
        networkHanlder.delegate = self;
        NSDictionary *requestDict = @{@"email":[self.signupDict valueForKey:@"email"],@"requestOtp":@"Y"};
        [networkHanlder createRequestForURLString:urlString withIdentifier:@"RequestOTP" requestHeaders:nil andRequestParameters:requestDict inView:self.view];
    }
    else {
    //call signup service
    MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
    networkHanlder.delegate = self;
    
    [networkHanlder createRequestForURLString:[NSString stringWithFormat:@"%@%@",BASEURL,SIGNUPURL] withIdentifier:@"RequestOTP" requestHeaders:nil andRequestParameters:self.signupDict inView:self.view];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if (textField == self.otpField) {
        
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        if(newLength <= 6)
            return YES;
        else {
            return NO;
        }
    }
    return YES;
}

-(void)limitTextFieldReached {
    
    if (self.otpField.text.length == 6) {
         [self verifyOTP:nil];
        
    }
}


@end
