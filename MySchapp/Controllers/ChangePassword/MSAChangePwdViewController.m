//
//  MSAChangePwdViewController.m
//  MySchapp
//
//  Created by CK-Dev on 23/04/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSAChangePwdViewController.h"
#import "MSAUtils.h"
#import "MSAConstants.h"
#import "MSANetworkHandler.h"
#import "MSAOTPViewController.h"
#import "MSAForgotPasswordViewController.h"
#import "MSALabel.h"

@interface MSAChangePwdViewController ()<UITextFieldDelegate,MSANetworkDelegate>
{
    UIImageView *backImageView;
    UIView *backView;
    UIImageView *logoImage;
    MSALabel *answerSecurityLbl;
    UITextField *enterPwd;
    UITextField *reenterPwd;
    UIButton *submitButton;

}
@end

@implementation MSAChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [MSAUtils setNavigationBarAttributes:self.navigationController];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Reset Password";
    
    
    [self setupUI];
}

- (void)setupUI {
    backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_bg.png"]];
    [self.view addSubview:backImageView];
    backImageView.translatesAutoresizingMaskIntoConstraints = NO;
    backImageView.userInteractionEnabled = YES;
    
    backView = [[UIView alloc]initWithFrame:CGRectZero];
    backView.backgroundColor = [UIColor whiteColor];
    backView.translatesAutoresizingMaskIntoConstraints = NO;
    [backImageView addSubview:backView];
    
    logoImage  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo.png"]];
    [backView addSubview:logoImage];
    logoImage.translatesAutoresizingMaskIntoConstraints = NO;
    logoImage.contentMode = UIViewContentModeScaleAspectFit;
    
    answerSecurityLbl = [[MSALabel alloc]initWithFrame:CGRectZero];
    answerSecurityLbl.text = @"Reset password";
    answerSecurityLbl.translatesAutoresizingMaskIntoConstraints = NO;
    answerSecurityLbl.textAlignment = NSTextAlignmentCenter;
    answerSecurityLbl.numberOfLines = 3;
    answerSecurityLbl.textColor = [UIColor grayColor];
    [answerSecurityLbl adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    [backView addSubview:answerSecurityLbl];
    
    enterPwd = [[UITextField alloc]initWithFrame:CGRectZero];
    enterPwd.translatesAutoresizingMaskIntoConstraints = NO;
    enterPwd.placeholder = @"Password";
    enterPwd.borderStyle = UITextBorderStyleRoundedRect;
    enterPwd.returnKeyType = UIReturnKeyNext;
    enterPwd.delegate = self;
    enterPwd.secureTextEntry = YES;
    [backView addSubview:enterPwd];
    
    reenterPwd = [[UITextField alloc]initWithFrame:CGRectZero];
    reenterPwd.translatesAutoresizingMaskIntoConstraints = NO;
    reenterPwd.placeholder = @"Re-enter Password";
    reenterPwd.borderStyle = UITextBorderStyleRoundedRect;
    reenterPwd.returnKeyType = UIReturnKeyGo;
    reenterPwd.delegate = self;
    reenterPwd.secureTextEntry = YES;
    [backView addSubview:reenterPwd];
    
    submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitButton.translatesAutoresizingMaskIntoConstraints = NO;
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitSecurityQuestion:) forControlEvents:UIControlEventTouchUpInside];
    submitButton.backgroundColor = kMySchappMediumBlueColor;
    submitButton.layer.cornerRadius = 5;
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backView addSubview:submitButton];
    
    [self applyConstraints];
    
}

- (void)applyConstraints {
    NSDictionary *views = @{@"answerSecurityLbl":answerSecurityLbl,@"enterPwd":enterPwd,@"reenterPwd":reenterPwd,@"submitButton":submitButton,@"backImageView":backImageView,@"logoImage":logoImage};
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[logoImage(50)]-10-[answerSecurityLbl(40)]-20-[enterPwd(40)]-20-[reenterPwd(40)]-30-[submitButton(40)]" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backImageView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[backImageView]|" options:0 metrics:nil views:views]];
    
    [backImageView addConstraint:[NSLayoutConstraint constraintWithItem:backView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:backImageView attribute:NSLayoutAttributeWidth multiplier:0.9 constant:0]];
    [backImageView addConstraint:[NSLayoutConstraint constraintWithItem:backView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backImageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [backImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[backView]|" options:0 metrics:nil views:@{@"backView":backView}]];
    
    
    [backView addConstraint:[NSLayoutConstraint constraintWithItem:answerSecurityLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:backView attribute:NSLayoutAttributeWidth multiplier:0.9 constant:0]];
    [backView addConstraint:[NSLayoutConstraint constraintWithItem:answerSecurityLbl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [backView addConstraint:[NSLayoutConstraint constraintWithItem:enterPwd attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:backView attribute:NSLayoutAttributeWidth multiplier:0.9 constant:0]];
    [backView addConstraint:[NSLayoutConstraint constraintWithItem:enterPwd attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [backView addConstraint:[NSLayoutConstraint constraintWithItem:reenterPwd attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:backView attribute:NSLayoutAttributeWidth multiplier:0.9 constant:0]];
    [backView addConstraint:[NSLayoutConstraint constraintWithItem:reenterPwd attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [backView addConstraint:[NSLayoutConstraint constraintWithItem:submitButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:150]];
    [backView addConstraint:[NSLayoutConstraint constraintWithItem:submitButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [backView addConstraint:[NSLayoutConstraint constraintWithItem:logoImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
    [backView addConstraint:[NSLayoutConstraint constraintWithItem:logoImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    
    
}

- (void)submitSecurityQuestion:(id)sender {
    
    NSString *urlString = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%@",BASEURL,CHANGEPWDURL]];
    MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
    networkHanlder.delegate = self;
    NSDictionary *requestDict = @{@"pwd":enterPwd.text,@"cpwd":reenterPwd.text,@"email":self.emailId};
    [networkHanlder createRequestForURLString:urlString withIdentifier:@"ChangePassword" requestHeaders:nil andRequestParameters:requestDict inView:self.view];
    
    
}

#pragma mark - MSANetworkDelegate

- (void)didReceiveData:(NSData *)responseData forRequest:(NSString *)requestId
{
    //received response comes here
    NSError* err;
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&err];
    
    NSLog(@"%@",responseDict);
    if ([requestId isEqualToString:@"ChangePassword"]) {
        if([[responseDict valueForKey:@"rCode"] isEqualToString:@"00"]) {
            [MSAUtils showAlertWithTitle:kAlertMessageTitle message:@"Password has been reset successfully, Try to login with your new password." cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
            [self.navigationController popToRootViewControllerAnimated:NO];
            
        }
        else if ([[responseDict valueForKey:@"rCode"] isEqualToString:@"09"]||[[responseDict valueForKey:@"rCode"] isEqualToString:@"10"]) {
            
            [MSAUtils showAlertWithTitle:kAlertMessageTitle message:[responseDict valueForKey:@"rMsg"] cancelButton:kAlertCancelButtonTitle otherButton:@"Verify" delegate:self];
        }
        else {
            [MSAUtils showAlertWithTitle:kAlertMessageTitle message:[responseDict valueForKey:@"rMsg"] cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
        }
    }
    else if ([requestId isEqualToString:@"Reverify"] && [[responseDict objectForKey:@"rCode"] isEqualToString:@"00"]) {
        if ([[responseDict objectForKey:@"otpsent"] isEqualToString:@"Y"] || [[responseDict objectForKey:@"oas"] isEqualToString:@"Y"]) {
            //Open otp screen
            UIStoryboard *mainStoryboard = UISTORYBOARD;
            MSAOTPViewController *controller = (MSAOTPViewController*)[mainStoryboard
                                                                       instantiateViewControllerWithIdentifier: @"MSAOTPViewController"];
            controller.signupDict = @{@"email":self.emailId};
            controller.isComingFromForgotPass = YES;
            
            NSMutableArray *viewControllers = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
            UIViewController *tempVC = [viewControllers objectAtIndex:0];
            [viewControllers removeAllObjects];
            [viewControllers addObject:tempVC];
            [viewControllers addObject:controller];
            [self.navigationController setViewControllers: viewControllers animated: YES];
            
            [self.navigationController pushViewController:controller animated:YES];
        }
        else {
            //open security question screen
            MSAForgotPasswordViewController *controller = [[MSAForgotPasswordViewController alloc]init];
            controller.question = [responseDict objectForKey:@"sq"];
            controller.emailId = self.emailId;
            
            NSMutableArray *viewControllers = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
            UIViewController *tempVC = [viewControllers objectAtIndex:0];
            [viewControllers removeAllObjects];
            [viewControllers addObject:tempVC];
            [viewControllers addObject:controller];
            [self.navigationController setViewControllers: viewControllers animated: YES];
            
            [self.navigationController pushViewController:controller animated:YES];
            
           
        }

    }
    else {
        [MSAUtils showAlertWithTitle:kAlertMessageTitle message:[responseDict valueForKey:@"rMsg"] cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"Reverify");
    
        NSString *urlString = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%@",BASEURL,FORGOTPASSWORDURL]];
        MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
        networkHanlder.delegate = self;
        NSDictionary *requestDict = @{@"email":self.emailId};
        [networkHanlder createRequestForURLString:urlString withIdentifier:@"Reverify" requestHeaders:nil andRequestParameters:requestDict inView:self.view];
        
    }
}

- (void)didFailWithError:(NSError *)error forRequest:(NSString *)requestId
{
    [MSAUtils showAlertWithTitle:kAlertMessageTitle message:kAlertInternalErrorMsg cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == enterPwd) {
        [reenterPwd becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder]; // Dismiss the keyboard.
        [self submitSecurityQuestion:nil];
    }
    
    
    return YES;
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in backView.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}


@end