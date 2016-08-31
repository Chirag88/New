//
//  MSATermsConditionViewController.m
//  MySchapp
//
//  Created by CK-Dev on 17/04/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSATermsConditionViewController.h"
#import "MSAConstants.h"
#import "MSANetworkHandler.h"
#import "MSAUtils.h"
#import "MSALoginDecision.h"
#import "MSAProtocols.h"

@interface MSATermsConditionViewController ()<MSANetworkDelegate,MSANetworkDelegate,LoginDecisionDelegate>
{
    NSString *termsString;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *agreeViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextView *termsTextView;
@property (weak, nonatomic) IBOutlet UIButton *disagreeBtn;
- (IBAction)disagreeClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
- (IBAction)agreeClicked:(id)sender;

@end

@implementation MSATermsConditionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MSAUtils setNavigationBarAttributes:self.navigationController];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Terms of service";
    
    NSString *urlString = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%@",BASEURL,TERMSCONDITIONURL]];
    MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
    networkHanlder.delegate = self;
    [networkHanlder createRequestForURLString:urlString withIdentifier:@"TermsAndConditions" requestHeaders:nil andRequestParameters:nil inView:self.view];
    
    self.agreeViewHeightConstraint.constant = 0;
    [self.view updateConstraintsIfNeeded];
    self.agreeBtn.hidden = YES;
    self.disagreeBtn.hidden = YES;
    if (self.reacceptTerms) {
        self.agreeViewHeightConstraint.constant = 70;
        [self.view updateConstraintsIfNeeded];
        self.agreeBtn.hidden = NO;
        self.disagreeBtn.hidden = NO;
        
        self.agreeBtn.backgroundColor = kMySchappLightBlueColor;
        [self.agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
        self.agreeBtn.layer.cornerRadius = 5.0;
        
        self.disagreeBtn.backgroundColor = kMySchappMediumBlueColor;
        [self.disagreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
        self.disagreeBtn.layer.cornerRadius = 5.0;

    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"logo_landing.png"] style:UIBarButtonItemStylePlain target:self action:nil];

    self.navigationItem.rightBarButtonItem = item;
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
    if ([requestId isEqualToString:@"TermsAndConditions"]) {
        if([[responseDict valueForKey:@"rCode"] isEqualToString:@"00"]) {
            NSLog(@"Got Terms Data");
            termsString = [responseDict objectForKey:@"fileContents"];
            self.termsTextView.text = termsString;
        }
        else {
            [MSAUtils showAlertWithTitle:kAlertMessageTitle message:[responseDict valueForKey:@"rMsg"] cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
            [self.navigationController popViewControllerAnimated:NO];
        }

    }
    else if ([requestId isEqualToString:@"DisagreeTerms"] || [requestId isEqualToString:@"AgreeTerms"]) {
        if([[responseDict valueForKey:@"rCode"] isEqualToString:@"00"]) {
           
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            [MSAUtils showAlertWithTitle:kAlertMessageTitle message:[responseDict valueForKey:@"rMsg"] cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
        }
        
    }

    
    
    
    
}

- (void)didFailWithError:(NSError *)error forRequest:(NSString *)requestId
{
    [MSAUtils showAlertWithTitle:kAlertMessageTitle message:kAlertInternalErrorMsg cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
}


- (IBAction)disagreeClicked:(id)sender {
    MSALoginDecision *loginDecision = [[MSALoginDecision alloc]init];
    loginDecision.delegate = self;
    [loginDecision checkTokensValidityWithRequestID:@"DisagreeTerms"];
}
- (IBAction)agreeClicked:(id)sender {
    MSALoginDecision *loginDecision = [[MSALoginDecision alloc]init];
    loginDecision.delegate = self;
    [loginDecision checkTokensValidityWithRequestID:@"AgreeTerms"];
}


#pragma mark LoginDecision Delegate
- (void)redirectToPage:(NSString *)pageToBeOpened {
    if ([pageToBeOpened isEqualToString:@"DisagreeTerms"])
    {
        NSString *urlString = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%@",BASEURL,REACCEPTURL]];
        MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
        networkHanlder.delegate = self;
        NSDictionary *reqHeadDict = @{@"Authorization":[NSString stringWithFormat:@"bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:kAccessToken]]};
        [networkHanlder createRequestForURLString:urlString withIdentifier:@"DisagreeTerms" requestHeaders:reqHeadDict andRequestParameters:@{@"hPlan":@"N"} inView:self.view];
        
    }
    else if ([pageToBeOpened isEqualToString:@"AgreeTerms"])
    {
        NSString *urlString = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%@",BASEURL,REACCEPTURL]];
        MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
        networkHanlder.delegate = self;
        NSDictionary *reqHeadDict = @{@"Authorization":[NSString stringWithFormat:@"bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:kAccessToken]]};
        [networkHanlder createRequestForURLString:urlString withIdentifier:@"AgreeTerms" requestHeaders:reqHeadDict andRequestParameters:@{@"hPlan":@"Y"} inView:self.view];
        
    }
}



@end
