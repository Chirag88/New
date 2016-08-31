//
//  MSASplashViewController.m
//  MySchapp
//
//  Created by CK-Dev on 23/02/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSASplashViewController.h"
#import "MSALandingPageViewController.h"
#import "MSAConstants.h"
#import "MSALoginDecision.h"
#import "MSAProviderHomeViewController.h"

@interface MSASplashViewController ()
{
    UIActivityIndicatorView *activityIndicator;
}
@end

@implementation MSASplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden  = YES;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = self.view.center;
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    
    
    MSALoginDecision *loginDecision = [[MSALoginDecision alloc] init];
    loginDecision.delegate = self;
    [loginDecision checkLoginCriteriaWhileLaunching];
//    [self performSelector:@selector(stopAnimation) withObject:self afterDelay:2.0];
    
}


- (void)openLandingPageWithLoginSignupEnabled:(BOOL)optionEnabled {
    [activityIndicator stopAnimating];
    
    UIStoryboard *mainStoryboard = UISTORYBOARD;
    MSALandingPageViewController *controller = (MSALandingPageViewController*)[mainStoryboard
                                                       instantiateViewControllerWithIdentifier: @"LandingPageController"];
    controller.showLoginSignup = optionEnabled;
    
//    MSAProviderHomeViewController *controller = (MSAProviderHomeViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ProviderHomeController"];
    
    [self.navigationController pushViewController:controller animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LoginDecision Delegate

- (void)redirectToPage:(NSString *)pageToBeOpened {
    if([pageToBeOpened isEqualToString:kLandingPageWithLoginSignup])
        [self openLandingPageWithLoginSignupEnabled:YES];
    else
        [self openLandingPageWithLoginSignupEnabled:NO];
}


@end
