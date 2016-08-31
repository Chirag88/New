//
//  MSAOTPViewController.h
//  MySchapp
//
//  Created by CK-Dev on 3/9/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSANetworkHandler.h"
#import "MSALabel.h"

@interface MSAOTPViewController : UIViewController<MSANetworkDelegate>

@property (nonatomic, strong) NSDictionary *signupDict;
@property (nonatomic, assign) BOOL isComingFromForgotPass;
@property (nonatomic, weak) IBOutlet MSALabel *otpLbl;
@property (nonatomic, weak) IBOutlet UITextField *otpField;
@property (nonatomic, weak) IBOutlet UIButton *verifyBtn;
- (IBAction)verifyOTP:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *resendBtn;
- (IBAction)resendOTP:(id)sender;

@end
