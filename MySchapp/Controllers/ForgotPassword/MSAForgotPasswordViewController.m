//
//  ForgotPasswordViewController.m
//  MySchapp
//
//  Created by CK-Dev on 20/04/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSAForgotPasswordViewController.h"
#import "MSAUtils.h"
#import "MSAConstants.h"
#import "MSANetworkHandler.h"
#import "MSAChangePwdViewController.h"
#import "MSAOTPViewController.h"
#import "MSALabel.h"

@interface MSAForgotPasswordViewController ()<UITextFieldDelegate,MSANetworkDelegate>{
    UIImageView *backImageView;
    UIView *backView;
    UIImageView *logoImage;
    MSALabel *answerSecurityLbl;
    MSALabel *questionLbl;
    UITextField *answerTxt;
    UIButton *requestOTPButton;
    UIButton *submitButton;
}

@end

@implementation MSAForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [MSAUtils setNavigationBarAttributes:self.navigationController];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Security Check";
    
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
    answerSecurityLbl.text = @"Answer the security question below and submit Or Request OTP";
    answerSecurityLbl.translatesAutoresizingMaskIntoConstraints = NO;
    answerSecurityLbl.textAlignment = NSTextAlignmentCenter;
    answerSecurityLbl.numberOfLines = 3;
    [answerSecurityLbl adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    answerSecurityLbl.textColor = [UIColor grayColor];
    [backView addSubview:answerSecurityLbl];
    
    questionLbl = [[MSALabel alloc]initWithFrame:CGRectZero];
    questionLbl.text = self.question;
    //questionLbl.backgroundColor = kProfileRowBackColor;
    [questionLbl adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    questionLbl.translatesAutoresizingMaskIntoConstraints = NO;
    questionLbl.numberOfLines = 2;
    [backView addSubview:questionLbl];
    
    answerTxt = [[UITextField alloc]initWithFrame:CGRectZero];
    answerTxt.translatesAutoresizingMaskIntoConstraints = NO;
    answerTxt.placeholder = @"Answer to security question";
    answerTxt.borderStyle = UITextBorderStyleRoundedRect;
    answerTxt.returnKeyType = UIReturnKeyGo;
    answerTxt.delegate = self;
    [backView addSubview:answerTxt];
    
    submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitButton.translatesAutoresizingMaskIntoConstraints = NO;
    [submitButton setTitle:@"Submit Answer" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitSecurityQuestion:) forControlEvents:UIControlEventTouchUpInside];
    submitButton.backgroundColor = kMySchappMediumBlueColor;
    submitButton.layer.cornerRadius = 5;
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backView addSubview:submitButton];
    
    
    requestOTPButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    requestOTPButton.translatesAutoresizingMaskIntoConstraints = NO;
    [requestOTPButton setTitle:@"Request OTP" forState:UIControlStateNormal];
    [requestOTPButton addTarget:self action:@selector(requestOTPButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    requestOTPButton.backgroundColor = kMySchappMediumBlueColor;
    requestOTPButton.layer.cornerRadius = 5;
    [requestOTPButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backView addSubview:requestOTPButton];
    
    [self applyConstraints];
    
}

- (void)applyConstraints {
    NSDictionary *views = @{@"answerSecurityLbl":answerSecurityLbl,@"questionLbl":questionLbl,@"answerTxt":answerTxt,@"submitButton":submitButton,@"requestOTPButton":requestOTPButton,@"backImageView":backImageView,@"logoImage":logoImage};
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[logoImage(50)]-10-[answerSecurityLbl(50)]-20-[questionLbl(50)]-20-[answerTxt(40)]-30-[requestOTPButton(40)]-20-[submitButton(40)]" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backImageView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[backImageView]|" options:0 metrics:nil views:views]];
    
    [backImageView addConstraint:[NSLayoutConstraint constraintWithItem:backView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:backImageView attribute:NSLayoutAttributeWidth multiplier:0.9 constant:0]];
    [backImageView addConstraint:[NSLayoutConstraint constraintWithItem:backView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backImageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [backImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[backView]|" options:0 metrics:nil views:@{@"backView":backView}]];
    
    
    [backView addConstraint:[NSLayoutConstraint constraintWithItem:answerSecurityLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:backView attribute:NSLayoutAttributeWidth multiplier:0.9 constant:0]];
    [backView addConstraint:[NSLayoutConstraint constraintWithItem:answerSecurityLbl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [backView addConstraint:[NSLayoutConstraint constraintWithItem:questionLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:backView attribute:NSLayoutAttributeWidth multiplier:0.9 constant:0]];
    [backView addConstraint:[NSLayoutConstraint constraintWithItem:questionLbl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [backView addConstraint:[NSLayoutConstraint constraintWithItem:answerTxt attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:backView attribute:NSLayoutAttributeWidth multiplier:0.9 constant:0]];
    [backView addConstraint:[NSLayoutConstraint constraintWithItem:answerTxt attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [backView addConstraint:[NSLayoutConstraint constraintWithItem:submitButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:150]];
    [backView addConstraint:[NSLayoutConstraint constraintWithItem:submitButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [backView addConstraint:[NSLayoutConstraint constraintWithItem:requestOTPButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:150]];
    [backView addConstraint:[NSLayoutConstraint constraintWithItem:requestOTPButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [backView addConstraint:[NSLayoutConstraint constraintWithItem:logoImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
    [backView addConstraint:[NSLayoutConstraint constraintWithItem:logoImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    
    
}

- (void)submitSecurityQuestion:(id)sender {
    
    NSString *urlString = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%@",BASEURL,FORGOTPASSSECUIRTYURL]];
    MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
    networkHanlder.delegate = self;
    NSDictionary *requestDict = @{@"sq":questionLbl.text,@"answer":answerTxt.text,@"email":self.emailId};
    [networkHanlder createRequestForURLString:urlString withIdentifier:@"SubmitSecurityAnswer" requestHeaders:nil andRequestParameters:requestDict inView:self.view];

    
}

- (void)requestOTPButtonClicked:(id)sender {
    NSString *urlString = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%@",BASEURL,FORGOTPASSWORDURL]];
    MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
    networkHanlder.delegate = self;
    NSDictionary *requestDict = @{@"email":self.emailId,@"requestOtp":@"Y"};
    [networkHanlder createRequestForURLString:urlString withIdentifier:@"RequestOTP" requestHeaders:nil andRequestParameters:requestDict inView:self.view];
    
}

#pragma mark - MSANetworkDelegate

- (void)didReceiveData:(NSData *)responseData forRequest:(NSString *)requestId
{
    //received response comes here
    NSError* err;
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&err];
    
    NSLog(@"%@",responseDict);
    if([[responseDict valueForKey:@"rCode"] isEqualToString:@"00"] && [requestId isEqualToString:@"SubmitSecurityAnswer"]) {
        [MSAUtils showAlertWithTitle:kAlertMessageTitle message:[responseDict valueForKey:@"rMsg"] cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
        
        MSAChangePwdViewController *controller = [[MSAChangePwdViewController alloc]init];
        controller.emailId = self.emailId;
        
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
        UIViewController *tempVC = [viewControllers objectAtIndex:0];
        [viewControllers removeAllObjects];
        [viewControllers addObject:tempVC];
        [viewControllers addObject:controller];
        [self.navigationController setViewControllers: viewControllers animated: YES];
        
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    else if([[responseDict valueForKey:@"rCode"] isEqualToString:@"00"] && [requestId isEqualToString:@"RequestOTP"]) {
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
    }
    else {
        [MSAUtils showAlertWithTitle:kAlertMessageTitle message:[responseDict valueForKey:@"rMsg"] cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
    }
    
    
    
}

- (void)didFailWithError:(NSError *)error forRequest:(NSString *)requestId
{
    [MSAUtils showAlertWithTitle:kAlertMessageTitle message:kAlertInternalErrorMsg cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder]; // Dismiss the keyboard.
    [self submitSecurityQuestion:nil];
    
    return YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in backView.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
