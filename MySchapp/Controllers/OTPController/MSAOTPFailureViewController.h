//
//  MSAOTPFailureViewController.h
//  MySchapp
//
//  Created by CK-Dev on 3/10/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSAOTPFailureViewController : UIViewController

@property (nonatomic, strong) NSDictionary *signupDict;
@property (nonatomic, weak) IBOutlet UIButton *requestBtn;
@property (nonatomic, weak) IBOutlet UIButton *reEnterBtn;

- (IBAction)reEnterOTP:(id)sender;
- (IBAction)requestOTP:(id)sender;

@end
