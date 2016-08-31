//
//  MSAOTPFailureViewController.m
//  MySchapp
//
//  Created by CK-Dev on 3/10/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSAOTPFailureViewController.h"
#import "MSANetworkHandler.h"
#import "MSAConstants.h"
#import "MSAUtils.h"
@interface MSAOTPFailureViewController ()

@end

@implementation MSAOTPFailureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.reEnterBtn.backgroundColor = kMySchappMediumBlueColor;
    self.reEnterBtn.layer.cornerRadius = 5;
    [self.reEnterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.requestBtn.backgroundColor = kMySchappMediumBlueColor;
    self.requestBtn.layer.cornerRadius = 5;
    [self.requestBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reEnterOTP:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)requestOTP:(id)sender
{
    //call signup service
//    MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
//    networkHanlder.delegate = self;
//    [networkHanlder createRequestForURLString:[NSString stringWithFormat:@"%@%@",BASE_URL,SIGNUP_URL] withIdentifier:@"OTP" andRequestParameters:self.signupDict inView:self.view];
    [self reEnterOTP:nil];//temporary
    
}

#pragma mark - MSANetworkDelegate

- (void)didReceiveData:(NSData *)responseData forRequest:(NSString *)requestId
{
    //received response comes here
    NSError* err;
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&err];
    if ([[responseDict objectForKey:@"rc"] isEqualToString:@"S"]) {
        NSLog(@"OPEN OTP");
        [self reEnterOTP:nil];
    }
    else {
        UIAlertView *alert  = [[UIAlertView alloc]initWithTitle:@"Message" message:[responseDict objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] ;
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

@end
