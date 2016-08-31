//
//  MSAOTPSuccessViewController.m
//  MySchapp
//
//  Created by CK-Dev on 3/10/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSAOTPSuccessViewController.h"
#import "MSAConstants.h"
#import "MSASignupViewController.h"

@interface MSAOTPSuccessViewController ()

@end

@implementation MSAOTPSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.continueBtn.backgroundColor = kMySchappMediumBlueColor;
    self.continueBtn.layer.cornerRadius = 5;
    [self.continueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)continueLogin:(id)sender
{
    MSASignupViewController *ctrl = (MSASignupViewController *)[self.navigationController.viewControllers firstObject];
    [ctrl.signupDelegate controllerGotDissmissed:ctrl];
    
    
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//    UIStoryboard *mainStoryboard = UISTORYBOARD;
//    MSALoginViewController *controller = (MSALoginViewController*)[mainStoryboard
//                                                                   instantiateViewControllerWithIdentifier: @"LoginViewController"];
//    
//    UINavigationController *navLoginController = [[UINavigationController alloc] initWithRootViewController:controller];
//    [self presentViewController:navLoginController animated:YES completion:nil];
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
