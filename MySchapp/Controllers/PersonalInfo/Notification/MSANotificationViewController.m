//
//  MSANotificationViewController.m
//  MySchapp
//
//  Created by CK-Dev on 25/03/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSANotificationViewController.h"
#import "MSANetworkHandler.h"
#import "MSAConstants.h"
#import "MSAProtocols.h"
#import "MSAUtils.h"
#import "MSAPaymentViewController.h"
#import "MSALoginDecision.h"
#import "MSALoginViewController.h"
#import "MSALabel.h"

@interface MSANotificationViewController ()<MSANetworkDelegate,UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate,LoginDecisionDelegate>
{
    NSMutableDictionary *notificationData;
    NSMutableDictionary *submitNotificationData;
    NSArray *reminderHoursArray;
    NSString *reminderHourSelectedValue;
    NSInteger selectedIndex;
    UIPickerView *reminderPicker;
    UIButton *saveButton;
    UIButton *newContinueBtn;
    __weak IBOutlet UIView *bottomView;
    __weak IBOutlet UIButton *continueBtn;
    __weak IBOutlet UIButton *skipContinueBtn;
    __weak IBOutlet UIImageView *emailSelectionRadio;
    __weak IBOutlet UIImageView *smsSelectionRadio;
    __weak IBOutlet UIImageView *bothSelectionRadio;
    __weak IBOutlet UITextField *reminderPickerTxt;
    __weak IBOutlet UIImageView *acceptPromosCheckbox;
    __weak IBOutlet UIImageView *appointmentsCheckbox;
    __weak IBOutlet UIImageView *newMsgCheckbox;
    __weak IBOutlet UIImageView *remindersCheckbox;
    __weak IBOutlet UIImageView *assoReqChecbox;
}
@property (weak, nonatomic) IBOutlet UIView *customSegmentView;
@property (weak, nonatomic) IBOutlet MSALabel *selectedPlanLbl;
@property (weak, nonatomic) IBOutlet MSALabel *welcomeUser;
- (IBAction)skipAndContinue:(id)sender;
- (IBAction)continueClicked:(id)sender;
@end

@implementation MSANotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MSAUtils setNavigationBarAttributes:self.navigationController];

    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Profile";
    if (self.notificationDataFromSecurity) {
        notificationData = self.notificationDataFromSecurity;
        [self autofillData];
    }
    else {
        MSALoginDecision *loginDecision = [[MSALoginDecision alloc]init];
        loginDecision.delegate = self;
        [loginDecision checkTokensValidityWithRequestID:@"Notification"];
    }

    
    [self createUI];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)createUI {
    
    [self createSegmentView];
    self.selectedPlanLbl.text = [NSString stringWithFormat:@"Selected Plan : %@",self.selectedPlanName];
    [self.selectedPlanLbl adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    [self.welcomeUser adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    self.selectedPlanLbl.textColor = kProfileSelPlanColor;
    self.welcomeUser.textColor = kProfileSelPlanColor;
    
    UITapGestureRecognizer *selectNMEmailTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectNotificationMethod:)];
    emailSelectionRadio.tag = 101;
    [emailSelectionRadio addGestureRecognizer:selectNMEmailTap];
    
    UITapGestureRecognizer *selectNMSmsTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectNotificationMethod:)];
    smsSelectionRadio.tag = 102;
    [smsSelectionRadio addGestureRecognizer:selectNMSmsTap];
    
    UITapGestureRecognizer *selectNMBothTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectNotificationMethod:)];
    bothSelectionRadio.tag = 103;
    [bothSelectionRadio addGestureRecognizer:selectNMBothTap];
    
    
    UITapGestureRecognizer *selectCheckBoxTap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectCheckBoxMethod:)];
    acceptPromosCheckbox.tag = 104;
    [acceptPromosCheckbox addGestureRecognizer:selectCheckBoxTap1];
    
    UITapGestureRecognizer *selectCheckBoxTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectCheckBoxMethod:)];
    appointmentsCheckbox.tag = 105;
    [appointmentsCheckbox addGestureRecognizer:selectCheckBoxTap2];

    UITapGestureRecognizer *selectCheckBoxTap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectCheckBoxMethod:)];
    newMsgCheckbox.tag = 106;
    [newMsgCheckbox addGestureRecognizer:selectCheckBoxTap3];
    
    UITapGestureRecognizer *selectCheckBoxTap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectCheckBoxMethod:)];
    remindersCheckbox.tag = 107;
    [remindersCheckbox addGestureRecognizer:selectCheckBoxTap4];
    
    UITapGestureRecognizer *selectCheckBoxTap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectCheckBoxMethod:)];
    assoReqChecbox.tag = 108;
    [assoReqChecbox addGestureRecognizer:selectCheckBoxTap5];
    
    
    // Adding PickerView
    reminderPicker = [[UIPickerView alloc] init];
    reminderPicker.dataSource = self;
    reminderPicker.delegate = self;
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,44)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                      style:UIBarButtonItemStyleBordered target:self action:@selector(setReminderHours:)];
    UIBarButtonItem *barButtonCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                        style:UIBarButtonItemStyleBordered target:self action:@selector(resetReminderHours:)];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    toolBar.items = @[barButtonCancel,flex,barButtonDone];
    barButtonDone.tintColor=[UIColor blackColor];
    reminderPickerTxt.inputAccessoryView = toolBar;
    reminderPickerTxt.delegate = self;
    reminderPickerTxt.inputView = reminderPicker;
    
    skipContinueBtn.backgroundColor = kMySchappLightBlueColor;
    [skipContinueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    skipContinueBtn.layer.cornerRadius = 5.0;
    
    continueBtn.backgroundColor = kMySchappMediumBlueColor;
    [continueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    continueBtn.layer.cornerRadius = 5.0;
    
    if (self.isComingFromMenu) {
        [skipContinueBtn setHidden:YES];
        [continueBtn setHidden:YES];
        
        // add save button
        saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        saveButton.backgroundColor = kMySchappMediumBlueColor;
        [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
        saveButton.layer.cornerRadius = 5.0;
        [saveButton setTitle:@"Save" forState:UIControlStateNormal];
        saveButton.translatesAutoresizingMaskIntoConstraints = NO;
        [bottomView addSubview:saveButton];
        [saveButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[saveButton(42)]-10-|" options:0 metrics:nil views:@{@"saveButton":saveButton}]];
        [bottomView addConstraint:[NSLayoutConstraint constraintWithItem:saveButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [bottomView addConstraint:[NSLayoutConstraint constraintWithItem:saveButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeWidth multiplier:0.40 constant:0]];
        

    }
    else if (self.selectedPlanId.integerValue != 1) {
        [skipContinueBtn setHidden:YES];
        [continueBtn setHidden:YES];
        
        newContinueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        newContinueBtn.backgroundColor = kMySchappMediumBlueColor;
        [newContinueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
        newContinueBtn.layer.cornerRadius = 5.0;
        [newContinueBtn setTitle:@"Continue" forState:UIControlStateNormal];
        newContinueBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:newContinueBtn];
        [newContinueBtn addTarget:self action:@selector(continueClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[continueBtn(42)]-10-|" options:0 metrics:nil views:@{@"continueBtn":newContinueBtn}]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:newContinueBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:newContinueBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.40 constant:0]];
    }


    
}

- (void)setReminderHours:(id)sender
{
    reminderPickerTxt.text = [reminderHoursArray objectAtIndex:selectedIndex];
    [reminderPickerTxt resignFirstResponder];
}

- (void)resetReminderHours:(id)sender
{
    [reminderPickerTxt resignFirstResponder];
}


- (void)autofillData {
    submitNotificationData = [[NSMutableDictionary alloc]init];
    // set notification Method data
    if (![[MSAUtils convertNullToEmptyString:[notificationData objectForKey:@"nm"]] isEqualToString:@""] && [notificationData objectForKey:@"nm"]) {
        if ([[notificationData objectForKey:@"nm"]isEqualToString:@"email"]) {
            [emailSelectionRadio setHighlighted:YES];
        }
        else if ([[notificationData objectForKey:@"nm"]isEqualToString:@"sms"]) {
            [smsSelectionRadio setHighlighted:YES];
        }
        else if ([[notificationData objectForKey:@"nm"]isEqualToString:@"both"]) {
            [bothSelectionRadio setHighlighted:YES];
        }
    }
    
    //reminder hours list
    if (![[MSAUtils convertNullToEmptyString:[notificationData objectForKey:@"ril"]] isEqualToString:@""] && [notificationData objectForKey:@"ril"]) {
        reminderHoursArray = [[NSArray alloc]init];
        reminderHoursArray = [self arrayFromString:[notificationData objectForKey:@"ril"]];
        [submitNotificationData setObject:[notificationData objectForKey:@"ril"] forKey:@"ril"];
    }
    else {
        [submitNotificationData setObject:@"1,2,4,8,12,24" forKey:@"ril"];
        reminderHoursArray = [[NSArray alloc]init];
        reminderHoursArray = [self arrayFromString:[submitNotificationData objectForKey:@"ril"]];

    }
    
    // reminder hours selected value
    if (![[MSAUtils convertNullToEmptyString:[notificationData objectForKey:@"ris"]] isEqualToString:@""] && [notificationData objectForKey:@"ris"]) {
        reminderHourSelectedValue = [notificationData objectForKey:@"ris"];
        reminderPickerTxt.text = reminderHourSelectedValue;
        [reminderPicker selectRow:[reminderHoursArray indexOfObject:reminderHourSelectedValue] inComponent:0 animated:YES];
    }
    
    
    // access promos
    if (![[MSAUtils convertNullToEmptyString:[notificationData objectForKey:@"apo"]] isEqualToString:@""] && [notificationData objectForKey:@"apo"]) {
        if ([[notificationData objectForKey:@"apo"] isEqualToString:@"Y"]) {
            [acceptPromosCheckbox setHighlighted:YES];
        }
        else {
            [acceptPromosCheckbox setHighlighted:NO];
        }
    }
    
    //['A', 'NM', 'REM', 'ARQ']
    // receive notification for
    if (![[notificationData objectForKey:@"rnf"] isKindOfClass:[NSNull class]] && [notificationData objectForKey:@"rnf"]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:[notificationData objectForKey:@"rnf"]];
        if ([tempArray containsObject:@"A"] ) {
            [appointmentsCheckbox setHighlighted:YES];
        }
        if ([tempArray containsObject:@"NM"] ) {
            [newMsgCheckbox setHighlighted:YES];
        }
        if ([tempArray containsObject:@"REM"] ) {
            [remindersCheckbox setHighlighted:YES];
        }
        if ([tempArray containsObject:@"ARQ"] ) {
            [assoReqChecbox setHighlighted:YES];
        }
        
        
    }
    
}

- (id)arrayFromString:(NSString *)list {
    NSArray *stringArray;
    stringArray = [list componentsSeparatedByString:@","];
    
    return stringArray;
}

- (void)getFilledData {
     // get notification Method data
    if ([emailSelectionRadio isHighlighted]) {
        [submitNotificationData setObject:@"email" forKey:@"nm"];
    }
    else if ([smsSelectionRadio isHighlighted]) {
        [submitNotificationData setObject:@"sms" forKey:@"nm"];
    }
    else {
        [submitNotificationData setObject:@"both" forKey:@"nm"];
    }
    if (![reminderPickerTxt.text isEqualToString:@""]) {
         [submitNotificationData setObject:reminderPickerTxt.text forKey:@"ris"];
    }
   
    
    if ([acceptPromosCheckbox isHighlighted]) {
        [submitNotificationData setObject:@"Y" forKey:@"apo"];
    }
    else {
        [submitNotificationData setObject:@"N" forKey:@"apo"];

    }
    
    NSMutableArray *receiveNotiArray = [[NSMutableArray alloc]init];
    if ([appointmentsCheckbox isHighlighted]) {
        [receiveNotiArray addObject:@"A"];
    }
    if ([newMsgCheckbox isHighlighted]) {
        [receiveNotiArray addObject:@"NM"];
    }
    if ([remindersCheckbox isHighlighted]) {
        [receiveNotiArray addObject:@"REM"];
    }
    if ([assoReqChecbox isHighlighted]) {
        [receiveNotiArray addObject:@"ARQ"];
    }
    [submitNotificationData setObject:receiveNotiArray forKey:@"rnf"];
}

- (void)createSegmentView {
    
    MSALabel *personalLbl = [[MSALabel alloc]initWithFrame:CGRectZero];
    personalLbl.translatesAutoresizingMaskIntoConstraints = NO;
    personalLbl.text = @"Personal";
    personalLbl.textColor = kProfileSegmentDefaultFontColor;
    //personalLbl.font = kProfileSegmentFont;
    [personalLbl adjustFontSizeAccToScreenWidth:kProfileSegmentFont];
    personalLbl.textAlignment = NSTextAlignmentCenter;
    
    MSALabel *securityLbl = [[MSALabel alloc]initWithFrame:CGRectZero];
    securityLbl.translatesAutoresizingMaskIntoConstraints = NO;
    securityLbl.text = @"Security";
    securityLbl.textColor = kProfileSegmentDefaultFontColor;
//    securityLbl.font = kProfileSegmentFont;
    [securityLbl adjustFontSizeAccToScreenWidth:kProfileSegmentFont];
    securityLbl.textAlignment = NSTextAlignmentCenter;
    
    MSALabel *notificationLbl = [[MSALabel alloc]initWithFrame:CGRectZero];
    notificationLbl.translatesAutoresizingMaskIntoConstraints = NO;
    notificationLbl.text = @"Notification";
    notificationLbl.textColor = kProfileSegmentSelectedFontColor;
//    notificationLbl.font = kProfileSegmentFont;
    [notificationLbl adjustFontSizeAccToScreenWidth:kProfileSegmentFont];
    notificationLbl.textAlignment = NSTextAlignmentCenter;
    
    MSALabel *paymentLbl = [[MSALabel alloc]initWithFrame:CGRectZero];
    paymentLbl.translatesAutoresizingMaskIntoConstraints = NO;
    paymentLbl.text = @"Payment";
    paymentLbl.textColor = kProfileSegmentDefaultFontColor;
    paymentLbl.font = kProfileSegmentFont;
    [paymentLbl adjustFontSizeAccToScreenWidth:kProfileSegmentFont];
    paymentLbl.textAlignment = NSTextAlignmentCenter;
    
    UIView *highlightedView = [[UIView alloc]initWithFrame:CGRectZero];
    highlightedView.translatesAutoresizingMaskIntoConstraints = NO;
    highlightedView.backgroundColor = kProfileSegmentSelectedFontColor;
    [notificationLbl addSubview:highlightedView];
    
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
    
    [notificationLbl addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[highlightedView(2)]|" options:0 metrics:nil views:@{@"highlightedView":highlightedView}]];
    [notificationLbl addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[highlightedView]|" options:0 metrics:nil views:@{@"highlightedView":highlightedView}]];
    
    
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
    if ([requestId isEqualToString:@"Payment"]) {
        if([[responseDict valueForKey:@"rCode"] isEqualToString:@"00"]) {
            NSLog(@"Got Payment Data");
            if (self.selectedPlanId.integerValue != 1) {
                // paid plan open payment screen
                MSAPaymentViewController *controller = [[MSAPaymentViewController alloc]init];
                NSMutableDictionary *paymentDetails = [NSMutableDictionary dictionaryWithDictionary:responseDict];
                [paymentDetails removeObjectForKey:@"rCode"];
                [paymentDetails removeObjectForKey:@"rMsg"];
                controller.paymentDetails = paymentDetails;
#warning need to test before delivery
                // it should not be there
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setValue:[responseDict objectForKey:kRefreshToken] forKey:kDefaultsRefreshToken];
                [userDefaults setValue:[responseDict objectForKey:kAccessToken] forKey:kDefaultsAccessToken];
                // reset from the service data
                [userDefaults setValue:[NSNumber numberWithInteger:[[responseDict objectForKey:kAccessTokenExpiresIn] integerValue]] forKey:kDefaultsAccessTokenExpiresIn];
                [userDefaults setValue:[NSNumber numberWithInteger:kRefreshTokenExpiresIn] forKey:kDefaultsRefreshTokenExpiresIn];

                
                [self.navigationController pushViewController:controller animated:YES];
                
            }
            else {
                // Free Plan
                
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
            
            
        }
        else {
            [MSAUtils showAlertWithTitle:kAlertMessageTitle message:[responseDict valueForKey:@"rMsg"] cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
        }
    }
    else if ([requestId isEqualToString:@"SaveNotification"]) {
        if([[responseDict valueForKey:@"rCode"] isEqualToString:@"00"]) {
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:[responseDict objectForKey:kUserRole] forKey:kDefaultsUserRole];
            [userDefaults setValue:[responseDict objectForKey:kRefreshToken] forKey:kDefaultsRefreshToken];
            [userDefaults setValue:[responseDict objectForKey:kAccessToken] forKey:kDefaultsAccessToken];
            [userDefaults setValue:[responseDict objectForKey:kPID] forKey:kDefaultsPID];
            [userDefaults setValue:[responseDict objectForKey:kPName] forKey:kDefaultsPName];
            // reset from the service data
            [userDefaults setValue:[NSNumber numberWithInteger:[[responseDict objectForKey:kAccessTokenExpiresIn] integerValue]] forKey:kDefaultsAccessTokenExpiresIn];
            [userDefaults setValue:[NSNumber numberWithInteger:kRefreshTokenExpiresIn] forKey:kDefaultsRefreshTokenExpiresIn];
            [userDefaults synchronize];
            [MSAUtils showAlertWithTitle:kAlertMessageTitle message:@"Data Saved Successfully." cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
        }
        else {
            [MSAUtils showAlertWithTitle:kAlertMessageTitle message:[responseDict valueForKey:@"rMsg"] cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
        }
        
    }
    else if ([requestId isEqualToString:@"Notification"]){
        if([[responseDict valueForKey:@"rCode"] isEqualToString:@"00"]) {
            NSLog(@"Got Notification Data");
            notificationData = [NSMutableDictionary dictionaryWithDictionary:responseDict];
            [self autofillData];
        }
        else {
            [MSAUtils showAlertWithTitle:kAlertMessageTitle message:[responseDict valueForKey:@"rMsg"] cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
            [self.navigationController popViewControllerAnimated:NO];
        }
    }
    
    
}

- (void)didFailWithError:(NSError *)error forRequest:(NSString *)requestId
{
    [MSAUtils showAlertWithTitle:kAlertMessageTitle message:kAlertInternalErrorMsg cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
}


#pragma mark - Selector methods

- (void)saveButtonClicked:(id)sender {
    [self getFilledData];
    
    MSALoginDecision *loginDecision = [[MSALoginDecision alloc]init];
    loginDecision.delegate = self;
    [loginDecision checkTokensValidityWithRequestID:@"SaveNotification"];
    
}

- (void)selectNotificationMethod:(id)sender {
    UIImageView *imageViewTapped = (UIImageView *)[sender view];
    if (imageViewTapped.tag == 101) {
        if (![imageViewTapped isHighlighted]) {
            [imageViewTapped setHighlighted:YES];
            if ([smsSelectionRadio isHighlighted]) {
                [smsSelectionRadio setHighlighted:NO];
            }
            else {
                [bothSelectionRadio setHighlighted:NO];
            }
        }
    }
    else if (imageViewTapped.tag == 102) {
        if (![imageViewTapped isHighlighted]) {
            [imageViewTapped setHighlighted:YES];
            if ([emailSelectionRadio isHighlighted]) {
                [emailSelectionRadio setHighlighted:NO];
            }
            else {
                [bothSelectionRadio setHighlighted:NO];
            }
        }
    }
    else {
        if (![imageViewTapped isHighlighted]) {
            [imageViewTapped setHighlighted:YES];
            if ([emailSelectionRadio isHighlighted]) {
                [emailSelectionRadio setHighlighted:NO];
            }
            else {
                [smsSelectionRadio setHighlighted:NO];
            }
        }
    }
    
    
}

- (void)selectCheckBoxMethod:(id)sender {
    UIImageView *imageViewTapped = (UIImageView *)[sender view];
    if ([imageViewTapped isHighlighted]) {
        [imageViewTapped setHighlighted:NO];
    }
    else {
        [imageViewTapped setHighlighted:YES];
    }
    
}

#pragma mark actionMethods

- (IBAction)skipAndContinue:(id)sender {
    
    MSALoginDecision *loginDecision = [[MSALoginDecision alloc]init];
    loginDecision.delegate = self;
    [loginDecision checkTokensValidityWithRequestID:@"SkipContinueService"];
    

}

- (IBAction)continueClicked:(id)sender {
    [self getFilledData];
    // testing

    MSALoginDecision *loginDecision = [[MSALoginDecision alloc]init];
    loginDecision.delegate = self;
    [loginDecision checkTokensValidityWithRequestID:@"Payment"];
    
   
    
}

#pragma mark - UIPickerViewDatasource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return reminderHoursArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [reminderHoursArray objectAtIndex:row];
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedIndex = row;
}


#pragma mark Login Decision Delegate
- (void)redirectToPage:(NSString *)pageToBeOpened {
    
    if ([pageToBeOpened isEqualToString:@"Notification"]) {
        NSString *urlString = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%@",BASEURL,NOTIFICATIONURL]];
        MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
        networkHanlder.delegate = self;
        NSDictionary *reqHeadDict = @{@"Authorization":[NSString stringWithFormat:@"bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:kAccessToken]]};
        if (!self.isComingFromMenu) {
            [networkHanlder createRequestForURLString:urlString withIdentifier:@"Notification" requestHeaders:reqHeadDict andRequestParameters:notificationData inView:self.view];
        }
        else {
            [networkHanlder createRequestForURLString:urlString withIdentifier:@"Notification" requestHeaders:reqHeadDict andRequestParameters:@{} inView:self.view];
        }

        
    }
    
    else if ([pageToBeOpened isEqualToString:kLoginScreen]) {
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
    else if ([pageToBeOpened isEqualToString:@"SaveNotification"]){
        NSString *urlString = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%@",BASEURL,NOTIFICATIONSAVEPAYMENTURL]];
        MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
        networkHanlder.delegate = self;
        NSDictionary *reqHeadDict = @{@"Authorization":[NSString stringWithFormat:@"bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:kAccessToken]]};
        [networkHanlder createRequestForURLString:urlString withIdentifier:@"SaveNotification" requestHeaders:reqHeadDict andRequestParameters:submitNotificationData inView:self.view];
    }
    else if ([pageToBeOpened isEqualToString:@"SkipContinueService"]){
        NSString *urlString = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%@",BASEURL,SKIPCONTINUEURL]];
        MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
        networkHanlder.delegate = self;
        NSDictionary *reqHeadDict = @{@"Authorization":[NSString stringWithFormat:@"bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:kAccessToken]]};
        [networkHanlder createRequestForURLString:urlString withIdentifier:@"SkipContinueService" requestHeaders:reqHeadDict andRequestParameters:nil inView:self.view];

    }
    else if ([pageToBeOpened isEqualToString:@"Payment"]){
        NSString *urlString = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%@",BASEURL,NOTIFICATIONSAVEPAYMENTURL]];
        MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
        networkHanlder.delegate = self;
        NSDictionary *reqHeadDict = @{@"Authorization":[NSString stringWithFormat:@"bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:kAccessToken]]};
        [networkHanlder createRequestForURLString:urlString withIdentifier:@"Payment" requestHeaders:reqHeadDict andRequestParameters:submitNotificationData inView:self.view];
    }
    
    
    
}


@end
