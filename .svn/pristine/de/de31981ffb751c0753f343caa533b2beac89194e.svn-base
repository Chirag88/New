//
//  MSAPrivacyPolicyViewController.m
//  MySchapp
//
//  Created by CK-Dev on 17/04/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSAPrivacyPolicyViewController.h"
#import "MSAConstants.h"
#import "MSANetworkHandler.h"
#import "MSAUtils.h"

@interface MSAPrivacyPolicyViewController ()<MSANetworkDelegate>
{
    NSString *privacyString;
}
@property (weak, nonatomic) IBOutlet UITextView *privacyTextView;

@end

@implementation MSAPrivacyPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MSAUtils setNavigationBarAttributes:self.navigationController];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Privacy Policy";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"logo_landing.png"] style:UIBarButtonItemStylePlain target:self action:nil];
    
    self.navigationItem.rightBarButtonItem = item;
    
    NSString *urlString = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%@",BASEURL,PRIVACYPOLICYURL]];
    MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
    networkHanlder.delegate = self;
    [networkHanlder createRequestForURLString:urlString withIdentifier:@"PrivacyPolicy" requestHeaders:nil andRequestParameters:nil inView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MSANetworkDelegate

- (void)didReceiveData:(NSData *)responseData forRequest:(NSString *)requestId
{
    //received response comes here
    NSError* err;
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&err];
    
   // NSLog(@"%@",responseDict);
    if([[responseDict valueForKey:@"rCode"] isEqualToString:@"00"]) {
        NSLog(@"Got Privacy Data");
        privacyString = [responseDict objectForKey:@"fileContents"];
        self.privacyTextView.text = privacyString;
    }
    else {
        [MSAUtils showAlertWithTitle:kAlertMessageTitle message:[responseDict valueForKey:@"rMsg"] cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
        [self.navigationController popViewControllerAnimated:NO];
    }



}

- (void)didFailWithError:(NSError *)error forRequest:(NSString *)requestId
{
    [MSAUtils showAlertWithTitle:kAlertMessageTitle message:kAlertInternalErrorMsg cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
}


@end
