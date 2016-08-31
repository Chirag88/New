//
//  MSASignupViewController.h
//  MySchapp
//
//  Created by CK-Dev on 23/02/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
#import "MSANetworkHandler.h"
#import "MSAProtocols.h"

@interface MSASignupViewController : UIViewController<TTTAttributedLabelDelegate, MSANetworkDelegate>

@property (nonatomic, weak) IBOutlet UITextField *emailField;
@property (nonatomic, weak) IBOutlet UITextField *pwdField;
@property (nonatomic, weak) IBOutlet UITextField *rePwdField;
@property (nonatomic, weak) IBOutlet UIImageView *alreadyCheckImgView;
@property (nonatomic, weak) IBOutlet TTTAttributedLabel *tncPolicyLbl;
@property (nonatomic, weak) IBOutlet TTTAttributedLabel *loginLbl;
@property (nonatomic, weak) id signupDelegate;
- (IBAction)signupClicked:(id)sender;

@end
