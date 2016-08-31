//
//  MSASecurityViewController.m
//  MySchapp
//
//  Created by CK-Dev on 25/03/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSASecurityViewController.h"
#import "MSAConstants.h"
#import "MSANetworkHandler.h"
#import "MSAUtils.h"
#import "MSAQuestionsTableViewController.h"
#import "MSANotificationViewController.h"
#import "MSALoginDecision.h"
#import "MSAPrivacyPolicyViewController.h"
#import "MSALoginViewController.h"
#import "MSALabel.h"

@interface MSASecurityViewController ()<MSANetworkDelegate,LoginDecisionDelegate>
{
    NSMutableDictionary *securityData;
    NSMutableDictionary *securityDataToSend;
    
    __weak IBOutlet UIView *resetPasswordView;
    __weak IBOutlet UITextField *reenterPassTxt;
    __weak IBOutlet UITextField *passwordTxt;
    __weak IBOutlet NSLayoutConstraint *passwordViewHeight;
    __weak IBOutlet UIView *questionView1;
    __weak IBOutlet UIView *questionView2;
    __weak IBOutlet UIView *questionView3;
    __weak IBOutlet MSALabel *question1Lbl;
    __weak IBOutlet MSALabel *question2Lbl;
    __weak IBOutlet MSALabel *question3Lbl;
    __weak IBOutlet UITextField *answerQuest1Txt;
    __weak IBOutlet UITextField *answerQuest2Txt;
    __weak IBOutlet UITextField *answerQuest3Txt;
    UIButton *saveButton;
    UIButton *newContinueBtn;
}
@property (weak, nonatomic) IBOutlet UIView *customSegmentView;
@property (weak, nonatomic) IBOutlet MSALabel *selectedPlanLbl;
@property (weak, nonatomic) IBOutlet UIButton *privacyBtn;
@property (weak, nonatomic) IBOutlet UIButton *disableBtn;
@property (weak, nonatomic) IBOutlet UIButton *skipBtn;
@property (weak, nonatomic) IBOutlet UIButton *continueBtn;
@property (weak, nonatomic) IBOutlet MSALabel *welcomeUser;

- (IBAction)diasbleAccountClicked:(id)sender;
- (IBAction)privacyClicked:(id)sender;
- (IBAction)skipContinue:(id)sender;
- (IBAction)continueToNotification:(id)sender;
@end

@implementation MSASecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [question1Lbl adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:17]];
    [question2Lbl adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:17]];
    [question3Lbl adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:17]];
    [self.selectedPlanLbl adjustFontSizeAccToScreenWidth:[UIFont boldSystemFontOfSize:15]];
    [self.welcomeUser adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:15]];
    
    [MSAUtils setNavigationBarAttributes:self.navigationController];

    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Profile";
    
    if (self.securityDataFromPersonal) {
        securityData = self.securityDataFromPersonal;
        [self autoFillData];
    }
    else {
        MSALoginDecision *loginDecision = [[MSALoginDecision alloc]init];
        loginDecision.delegate = self;
        [loginDecision checkTokensValidityWithRequestID:@"Security"];
    }
    
    [self updateUI];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)updateUI {
    [self createSegmentView];
    
    
    UITapGestureRecognizer *question1Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(questionsTapped:)];
    questionView1.tag = 101;
    [questionView1 addGestureRecognizer:question1Tap];
    
    UITapGestureRecognizer *question2Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(questionsTapped:)];
    [questionView2 addGestureRecognizer:question2Tap];
    questionView2.tag = 102;
    
    UITapGestureRecognizer *question3Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(questionsTapped:)];
    [questionView3 addGestureRecognizer:question3Tap];
    questionView3.tag = 103;
    
    questionView1.backgroundColor = kProfileRowBackColor;
    questionView2.backgroundColor = kProfileRowBackColor;
    questionView3.backgroundColor = kProfileRowBackColor;
    
    questionView1.layer.cornerRadius = 5;
    questionView2.layer.cornerRadius = 5;
    questionView3.layer.cornerRadius = 5;
    
    self.selectedPlanLbl.textColor = kProfileSelPlanColor;
    self.welcomeUser.textColor = kProfileSelPlanColor;
    
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:self.privacyBtn.titleLabel.text];
    // making text property to underline text-
    [titleString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:(NSUnderlinePatternSolid|NSUnderlineStyleSingle)] range:NSMakeRange(0, [titleString length])];
    [titleString addAttribute:NSForegroundColorAttributeName value:kProfilePrivacyBtnColor range:NSMakeRange(0, [titleString length])];
    [titleString addAttribute:NSUnderlineColorAttributeName value:kProfilePrivacyBtnColor range:NSMakeRange(0, [titleString length])];
    // using text on button
    [self.privacyBtn setAttributedTitle: titleString forState:UIControlStateNormal];
    
    NSMutableAttributedString *titleString1 = [[NSMutableAttributedString alloc] initWithString:self.disableBtn.titleLabel.text];
    // making text property to underline text-
    [titleString1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:(NSUnderlinePatternSolid|NSUnderlineStyleSingle)] range:NSMakeRange(0, [titleString1 length])];
    [titleString1 addAttribute:NSForegroundColorAttributeName value:kProfilePrivacyBtnColor range:NSMakeRange(0, [titleString1 length])];
    [titleString1 addAttribute:NSUnderlineColorAttributeName value:kProfilePrivacyBtnColor range:NSMakeRange(0, [titleString1 length])];
    // using text on button
    [self.disableBtn setAttributedTitle: titleString1 forState:UIControlStateNormal];
    
    self.skipBtn.backgroundColor = kMySchappLightBlueColor;
    [self.skipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    self.skipBtn.layer.cornerRadius = 5.0;
    
    self.continueBtn.backgroundColor = kMySchappMediumBlueColor;
    [self.continueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    self.continueBtn.layer.cornerRadius = 5.0;
    
    
    if (!self.isComingFromMenu) {
        resetPasswordView.clipsToBounds = YES;
        passwordViewHeight.constant = 0;
        [self.view updateConstraintsIfNeeded];
        
        // hide buttons
        [self.disableBtn setHidden:YES];
         if (self.selectedPlanId.integerValue != 1) {
            [self.skipBtn setHidden:YES];
            [self.continueBtn setHidden:YES];
            
            newContinueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            newContinueBtn.backgroundColor = kMySchappMediumBlueColor;
            [newContinueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
            newContinueBtn.layer.cornerRadius = 5.0;
            [newContinueBtn setTitle:@"Continue" forState:UIControlStateNormal];
            newContinueBtn.translatesAutoresizingMaskIntoConstraints = NO;
            [self.view addSubview:newContinueBtn];
            [newContinueBtn addTarget:self action:@selector(continueToNotification:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[continueBtn(42)]-10-|" options:0 metrics:nil views:@{@"continueBtn":newContinueBtn}]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:newContinueBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:newContinueBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.40 constant:0]];
        }

        
    }
    else {
        [self.skipBtn setHidden:YES];
        [self.continueBtn setHidden:YES];
        
        // add save button
        saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        saveButton.backgroundColor = kMySchappMediumBlueColor;
        [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
        saveButton.layer.cornerRadius = 5.0;
        [saveButton setTitle:@"Save" forState:UIControlStateNormal];
        saveButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:saveButton];
        [saveButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[saveButton(42)]-10-|" options:0 metrics:nil views:@{@"saveButton":saveButton}]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:saveButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:saveButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.40 constant:0]];
        
    }


   
}


- (void)createSegmentView {
    
    MSALabel *personalLbl = [[MSALabel alloc]initWithFrame:CGRectZero];
    personalLbl.translatesAutoresizingMaskIntoConstraints = NO;
    personalLbl.text = @"Personal";
    personalLbl.textColor = kProfileSegmentDefaultFontColor;
//    personalLbl.font = kProfileSegmentFont;
    [personalLbl adjustFontSizeAccToScreenWidth:kProfileSegmentFont];
    personalLbl.textAlignment = NSTextAlignmentCenter;
    
    MSALabel *securityLbl = [[MSALabel alloc]initWithFrame:CGRectZero];
    securityLbl.translatesAutoresizingMaskIntoConstraints = NO;
    securityLbl.text = @"Security";
    securityLbl.textColor = kProfileSegmentSelectedFontColor;
//    securityLbl.font = kProfileSegmentFont;
    [securityLbl adjustFontSizeAccToScreenWidth:kProfileSegmentFont];
    securityLbl.textAlignment = NSTextAlignmentCenter;
    
    MSALabel *notificationLbl = [[MSALabel alloc]initWithFrame:CGRectZero];
    notificationLbl.translatesAutoresizingMaskIntoConstraints = NO;
    notificationLbl.text = @"Notification";
    notificationLbl.textColor = kProfileSegmentDefaultFontColor;
//    notificationLbl.font = kProfileSegmentFont;
    [notificationLbl adjustFontSizeAccToScreenWidth:kProfileSegmentFont];
    notificationLbl.textAlignment = NSTextAlignmentCenter;
    
    MSALabel *paymentLbl = [[MSALabel alloc]initWithFrame:CGRectZero];
    paymentLbl.translatesAutoresizingMaskIntoConstraints = NO;
    paymentLbl.text = @"Payment";
    paymentLbl.textColor = kProfileSegmentDefaultFontColor;
//    paymentLbl.font = kProfileSegmentFont;
    [paymentLbl adjustFontSizeAccToScreenWidth:kProfileSegmentFont];
    paymentLbl.textAlignment = NSTextAlignmentCenter;
    
    UIView *highlightedView = [[UIView alloc]initWithFrame:CGRectZero];
    highlightedView.translatesAutoresizingMaskIntoConstraints = NO;
    highlightedView.backgroundColor = kProfileSegmentSelectedFontColor;
    [securityLbl addSubview:highlightedView];
    
    if (self.selectedPlanId.integerValue != 1) {
        [self.customSegmentView addSubview:personalLbl];
        [self.customSegmentView addSubview:securityLbl];
        [self.customSegmentView addSubview:notificationLbl];
        [self.customSegmentView addSubview:paymentLbl];
        
        NSDictionary *views = @{@"personalLbl":personalLbl,@"securityLbl":securityLbl,@"notificationLbl":notificationLbl,@"paymentLbl":paymentLbl};
        [self.customSegmentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[personalLbl(==securityLbl)]-[securityLbl(==paymentLbl)]-[notificationLbl]-[paymentLbl(==securityLbl)]-|" options:0 metrics:nil views:views]];
        
        [self.customSegmentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[personalLbl]|" options:0 metrics:nil views:views]];
        [self.customSegmentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[securityLbl]|" options:0 metrics:nil views:views]];
        [self.customSegmentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[notificationLbl]|" options:0 metrics:nil views:views]];
        [self.customSegmentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[paymentLbl]|" options:0 metrics:nil views:views]];
        [self.skipBtn setHidden:YES];
        
    }
    else {
        [self.customSegmentView addSubview:personalLbl];
        [self.customSegmentView addSubview:securityLbl];
        [self.customSegmentView addSubview:notificationLbl];
        NSDictionary *views = @{@"personalLbl":personalLbl,@"securityLbl":securityLbl,@"notificationLbl":notificationLbl};
        [self.customSegmentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[personalLbl(==securityLbl)]-[securityLbl(==notificationLbl)]-[notificationLbl]-|" options:0 metrics:nil views:views]];
        
        [self.customSegmentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[personalLbl]|" options:0 metrics:nil views:views]];
        [self.customSegmentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[securityLbl]|" options:0 metrics:nil views:views]];
        [self.customSegmentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[notificationLbl]|" options:0 metrics:nil views:views]];
        
        
    }
    
    [securityLbl addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[highlightedView(2)]|" options:0 metrics:nil views:@{@"highlightedView":highlightedView}]];
    [securityLbl addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[highlightedView]|" options:0 metrics:nil views:@{@"highlightedView":highlightedView}]];
    
    
}

- (void)autoFillData {
    self.selectedPlanLbl.text = [NSString stringWithFormat:@"Selected Plan : %@",self.selectedPlanName];

    if (![[MSAUtils convertNullToEmptyString:[securityData objectForKey:@"q1"]]isEqualToString:@""] && [securityData objectForKey:@"q1"]) {
        question1Lbl.text = [MSAUtils convertNullToEmptyString:[securityData objectForKey:@"q1"]];
    }
    if (![[MSAUtils convertNullToEmptyString:[securityData objectForKey:@"q2"]]isEqualToString:@""] && [securityData objectForKey:@"q2"]) {
        question2Lbl.text = [MSAUtils convertNullToEmptyString:[securityData objectForKey:@"q2"]];
    }
    if (![[MSAUtils convertNullToEmptyString:[securityData objectForKey:@"q3"]]isEqualToString:@""] && [securityData objectForKey:@"q3"]) {
        question3Lbl.text = [MSAUtils convertNullToEmptyString:[securityData objectForKey:@"q3"]];
    }
    
}

- (void)getFilledData {
    
    // Validity check here
    
    securityDataToSend = [[NSMutableDictionary alloc ]init];
    [securityDataToSend setObject:question1Lbl.text forKey:@"q1"];
    [securityDataToSend setObject:question2Lbl.text forKey:@"q2"];
    [securityDataToSend setObject:question3Lbl.text forKey:@"q3"];
    [securityDataToSend setObject:answerQuest1Txt.text forKey:@"ans1"];
    [securityDataToSend setObject:answerQuest2Txt.text forKey:@"ans2"];
    [securityDataToSend setObject:answerQuest3Txt.text forKey:@"ans3"];
    
     if (self.isComingFromMenu) {
         
         [securityDataToSend setObject:passwordTxt.text forKey:@"pwd"];
         [securityDataToSend setObject:reenterPassTxt.text forKey:@"cpwd"];
     }
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
    
    NSLog(@"%@",responseDict);
    if ([requestId isEqualToString:@"DisableAccount"]) {
        if([[responseDict valueForKey:@"rCode"] isEqualToString:@"00"]) {
            NSLog(@"Account Disabled Succesfully");
            [MSAUtils showAlertWithTitle:kAlertMessageTitle message:@"Account Disabled Succesfully" cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            [MSAUtils showAlertWithTitle:kAlertMessageTitle message:[responseDict valueForKey:@"rMsg"] cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
            [self.navigationController popViewControllerAnimated:NO];
        }

    }
    else if ([requestId isEqualToString:@"Security"]) {
        if([[responseDict valueForKey:@"rCode"] isEqualToString:@"00"]) {
            NSLog(@"Got security Data");
            securityData = [NSMutableDictionary dictionaryWithDictionary:responseDict];
            [self autoFillData];

        }
        else {
            [MSAUtils showAlertWithTitle:kAlertMessageTitle message:[responseDict valueForKey:@"rMsg"] cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
            [self.navigationController popViewControllerAnimated:NO];
        }
    }
    else if ([requestId isEqualToString:@"SaveSecurityData"]) {
        if([[responseDict valueForKey:@"rCode"] isEqualToString:@"00"]) {
            NSLog(@"Saved Security Data");
            [MSAUtils showAlertWithTitle:kAlertMessageTitle message:@"Data Saved Successfully." cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
        }
        else {
            [MSAUtils showAlertWithTitle:kAlertMessageTitle message:[responseDict valueForKey:@"rMsg"] cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
        }

    }
    else if ([requestId isEqualToString:@"SkipContinueService"]) {
        if([[responseDict valueForKey:@"rCode"] isEqualToString:@"00"]) {

            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:[responseDict objectForKey:kUserRole] forKey:kDefaultsUserRole];
            [userDefaults setValue:[responseDict objectForKey:kRefreshToken] forKey:kDefaultsRefreshToken];
            [userDefaults setValue:[responseDict objectForKey:kAccessToken] forKey:kDefaultsAccessToken];
            [userDefaults setValue:[responseDict objectForKey:kPID] forKey:kDefaultsPID];
            [userDefaults setValue:[responseDict objectForKey:kPName] forKey:kDefaultsPName];
            [userDefaults setValue:[responseDict objectForKey:kProfileStatus] forKey:kDefaultsProfileStatus];
            // reset from the service data
            [userDefaults setValue:[NSNumber numberWithInteger:[[responseDict objectForKey:kAccessTokenExpiresIn] integerValue]] forKey:kDefaultsAccessTokenExpiresIn];
            [userDefaults setValue:[NSNumber numberWithInteger:kRefreshTokenExpiresIn] forKey:kDefaultsRefreshTokenExpiresIn];
            [userDefaults synchronize];
            [MSAUtils showAlertWithTitle:kAlertMessageTitle message:@"Thanks for signing up with MySchapp" cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            [MSAUtils showAlertWithTitle:kAlertMessageTitle message:[responseDict valueForKey:@"rMsg"] cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
        }
    }
    else if ([requestId isEqualToString:@"OpenNotificationScreen"])
    {
        if([[responseDict valueForKey:@"rCode"] isEqualToString:@"00"]) {
            UIStoryboard *mainStoryboard = UISTORYBOARD;
            
            MSANotificationViewController *controller = (MSANotificationViewController*)[mainStoryboard
                                                                                         instantiateViewControllerWithIdentifier:@"MSANotificationViewController"];
            
            controller.notificationDataFromSecurity = [NSMutableDictionary dictionaryWithDictionary:responseDict];
            controller.selectedPlanName = self.selectedPlanName;
            controller.selectedPlanId = self.selectedPlanId;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    
    
}

- (void)didFailWithError:(NSError *)error forRequest:(NSString *)requestId
{
    [MSAUtils showAlertWithTitle:kAlertMessageTitle message:kAlertInternalErrorMsg cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
}


#pragma mark - Action Methods

- (IBAction)diasbleAccountClicked:(id)sender {

    
    MSALoginDecision *loginDecision = [[MSALoginDecision alloc]init];
    loginDecision.delegate = self;
    [loginDecision checkTokensValidityWithRequestID:@"DisableAccount"];

}

- (IBAction)privacyClicked:(id)sender {
    
    UIStoryboard *mainStoryboard = UISTORYBOARD;
    MSAPrivacyPolicyViewController *privacyVC  = (MSAPrivacyPolicyViewController*)[mainStoryboard
                                                                             instantiateViewControllerWithIdentifier:@"MSAPrivacyPolicyViewController"];
    [self.navigationController pushViewController:privacyVC animated:YES];
}

- (IBAction)skipContinue:(id)sender {
    
    MSALoginDecision *loginDecision = [[MSALoginDecision alloc]init];
    loginDecision.delegate = self;
    [loginDecision checkTokensValidityWithRequestID:@"SkipContinueService"];
    
    
}

- (IBAction)continueToNotification:(id)sender {
    [self getFilledData];
    MSALoginDecision *loginDecision = [[MSALoginDecision alloc]init];
    loginDecision.delegate = self;
    [loginDecision checkTokensValidityWithRequestID:@"OpenNotificationScreen"];
    
}

- (void)saveButtonClicked:(id)sender {
    [self getFilledData];
    
   
    
    MSALoginDecision *loginDecision = [[MSALoginDecision alloc]init];
    loginDecision.delegate = self;
    [loginDecision checkTokensValidityWithRequestID:@"SaveSecurityData"];

    
}

#pragma mark selector methods
- (void)questionsTapped:(id)sender {
    UIView * tappedView = [sender view];
    MSAQuestionsTableViewController *questions = [[MSAQuestionsTableViewController alloc]init];
    questions.tappedViewTag = tappedView.tag;
    questions.questionList = [securityData objectForKey:@"listOfQuestions"];
    questions.delegate = self;
    [self.navigationController pushViewController:questions animated:YES];
    
}



#pragma mark - SelectedQuestionDelegate Method
- (void)selectedQuestion:(NSString *)questionText withViewTag:(NSInteger)tag {
    
    if (tag == 101) {
        question1Lbl.text = questionText;
    }
    else if (tag == 102) {
        question2Lbl.text = questionText;
    }
    else {
        question3Lbl.text = questionText;
    }
}

#pragma LoginDecision Delegate
- (void)redirectToPage:(NSString *)pageToBeOpened {
    if ([pageToBeOpened isEqualToString:kLoginScreen]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (![[defaults valueForKey:kDefaultsProfileStatus]isEqualToString:@"PC"]) {
            [self.navigationController popViewControllerAnimated:NO];
        }
        else {
            UIStoryboard *mainStoryboard = UISTORYBOARD;
            
            MSALoginViewController *controller = (MSALoginViewController*)[mainStoryboard
                                                                           instantiateViewControllerWithIdentifier: @"LoginViewController"];
            
            controller.loginDelegate = self;
            UINavigationController *navLoginController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:navLoginController animated:YES completion:nil];
        }

        
    }
    else if ([pageToBeOpened isEqualToString:@"OpenNotificationScreen"])
    {
        NSString *urlString = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%@",BASEURL,NOTIFICATIONURL]];
        MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
        networkHanlder.delegate = self;
        NSDictionary *reqHeadDict = @{@"Authorization":[NSString stringWithFormat:@"bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:kAccessToken]]};
        
        [networkHanlder createRequestForURLString:urlString withIdentifier:@"OpenNotificationScreen" requestHeaders:reqHeadDict andRequestParameters:securityDataToSend inView:self.view];
        
        
    }
    else if ([pageToBeOpened isEqualToString:@"Security"]) {
        NSString *urlString = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%@",BASEURL,SECURITYURL]];
        MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
        networkHanlder.delegate = self;
        NSDictionary *reqHeadDict = @{@"Authorization":[NSString stringWithFormat:@"bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:kAccessToken]]};
        if (self.isComingFromMenu) {
            [networkHanlder createRequestForURLString:urlString withIdentifier:@"Security" requestHeaders:reqHeadDict andRequestParameters:@{} inView:self.view];
        }
        

    }
    else if ([pageToBeOpened isEqualToString:@"DisableAccount"]) {
        
        NSString *urlString = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%@",BASEURL,DISABLEACCOUNTURL]];
        MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
        networkHanlder.delegate = self;
        NSDictionary *reqHeadDict = @{@"Authorization":[NSString stringWithFormat:@"bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:kAccessToken]]};
        [networkHanlder createRequestForURLString:urlString withIdentifier:@"DisableAccount" requestHeaders:reqHeadDict andRequestParameters:nil inView:self.view];
    }
    else if([pageToBeOpened isEqualToString:@"SkipContinueService"]){
        NSString *urlString = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%@",BASEURL,SKIPCONTINUEURL]];
        MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
        networkHanlder.delegate = self;
        NSDictionary *reqHeadDict = @{@"Authorization":[NSString stringWithFormat:@"bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:kAccessToken]]};
        [networkHanlder createRequestForURLString:urlString withIdentifier:@"SkipContinueService" requestHeaders:reqHeadDict andRequestParameters:nil inView:self.view];
    }
    
    else if ([pageToBeOpened isEqualToString:@"SaveSecurityData"]){
        NSString *urlString = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%@",BASEURL,NOTIFICATIONURL]];
        MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
        networkHanlder.delegate = self;
        NSDictionary *reqHeadDict = @{@"Authorization":[NSString stringWithFormat:@"bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:kAccessToken]]};
        
        [networkHanlder createRequestForURLString:urlString withIdentifier:@"SaveSecurityData" requestHeaders:reqHeadDict andRequestParameters:securityDataToSend inView:self.view];
    }
}

@end
