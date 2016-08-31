//
//  MSALoginViewController.h
//  MySchapp
//
//  Created by CK-Dev on 23/02/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
#import "MSANetworkHandler.h"
#import "MSAProtocols.h"

@interface MSALoginViewController : UIViewController<TTTAttributedLabelDelegate,MSANetworkDelegate,UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UITextField *emailField;
@property (nonatomic, weak) IBOutlet UITextField *pwdField;
@property (nonatomic, weak) id loginDelegate;

@end
