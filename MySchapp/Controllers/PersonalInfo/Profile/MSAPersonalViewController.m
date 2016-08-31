//
//  MSAPersonalViewController.m
//  MySchapp
//
//  Created by CK-Dev on 25/03/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSAPersonalViewController.h"
#import "MSAConstants.h"
#import "MSANetworkHandler.h"
#import "MSALoginDecision.h"
#import "MSASecurityViewController.h"
#import "MSAUtils.h"
#import "MSALanguageTableViewController.h"
#import "MSAEducationViewController.h"
#import "MSATermsConditionViewController.h"
#import "MSALoginViewController.h"
#import "MSALabel.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface MSAPersonalViewController ()<LoginDecisionDelegate,MSANetworkDelegate,ProfileLanguageDoneCancelDelegate,ProfileEducationDoneCancelDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate,UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
{
    NSMutableDictionary *personalDetails;
    NSMutableDictionary *submitPersonalDetails;
    
    NSArray *selectedLanguages;
    NSArray *listOfCertifications;
    
    NSArray *genderArray;
    NSInteger selectedIndex;
    UIPickerView *genderPicker;
    
    BOOL profilePhotoTapped;
    UIImageView *profileImage;
    MSALabel *addPhotoLabel;
    UITextField *firstNameTxt;
    UITextField *lastNameTxt;
    
    UIView *companyRegView;
    UIImageView *companyImage;
    MSALabel *addCompPhotoLabel;
    MSALabel *regForCompanyLbl;
    UISwitch *compRegSwitch;
    UITextField *companyNameTxt;
    UITextField *taxIDTxt;
    UITextField *dunsNumberTxt;
    NSLayoutConstraint *companyRegViewHeight;
    
    UITextField *workExpTxt;
    UITextField *addressLine1Txt;
    UITextField *addressLine2Txt;
    UITextField *cityTxt;
    UITextField *stateTxt;
    UITextField *zipTxt;
    UITextField *countryPickerTxt;
    UITextField *emailTxt;
    UITextField *genderPickerTxt;
    MSALabel *genderLbl;
    UITextField *mobileTxt;
    UITextField *phoneTxt;
    UITextField *dobTxt;
    UITextField *currencyTxt;
    MSALabel *languagesLbl;
    MSALabel *educationLbl;
    MSALabel *languagesCountLbl;
    MSALabel *educationCountLbl;
    UIImageView *languageAccessoryView;
    UIImageView *educationAccessoryView;
    UIView *languageView;
    UIView *educationView;
    UITapGestureRecognizer *languageTap;
    UITapGestureRecognizer *educationTap;
    
    UIPopoverController *popover;
    
    UIButton *saveButton;
    UIButton *newContinueBtn;
}
@property (weak, nonatomic) IBOutlet MSALabel *welcomeUserLbl;
@property (weak, nonatomic) IBOutlet UIView *customSegmentView;
@property (weak, nonatomic) IBOutlet MSALabel *selectedPlanLbl;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *skipContinueBtn;
@property (weak, nonatomic) IBOutlet UIButton *continueBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *continueBtnTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *continueBtnLeading;
- (IBAction)skipProfile:(id)sender;
- (IBAction)openSecurityScreen:(id)sender;
@end

@implementation MSAPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   [MSAUtils setNavigationBarAttributes:self.navigationController];

    MSALoginDecision *loginDecision = [[MSALoginDecision alloc]init];
    loginDecision.delegate = self;
    [loginDecision checkTokensValidityWithRequestID:@"PersonalData"];
    
   
    // Create UI
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Profile";
    [self.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
    
    

}

// Create UI
- (void)createUI {
    
    genderArray = @[@"M",@"F"];
    
    [self createSegmentView];
    [self.welcomeUserLbl adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    [self.selectedPlanLbl adjustFontSizeAccToScreenWidth:[UIFont boldSystemFontOfSize:16]];
    self.selectedPlanLbl.textColor = kProfileSelPlanColor;
    self.welcomeUserLbl.textColor = kProfileSelPlanColor;
    
    profileImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    profileImage.translatesAutoresizingMaskIntoConstraints = NO;
    profileImage.backgroundColor = kProfileAddPhotoColor;
    profileImage.layer.cornerRadius = 40;
    [self.scrollView addSubview:profileImage];
    UITapGestureRecognizer *profileImageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(profileImageTapped:)];
    [profileImage addGestureRecognizer:profileImageTap];
    [profileImage setUserInteractionEnabled:YES];
    
    addPhotoLabel = [[MSALabel alloc]initWithFrame:CGRectZero];
    addPhotoLabel.textColor = [UIColor whiteColor];
    addPhotoLabel.text = @"Photo";
    [addPhotoLabel adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    addPhotoLabel.numberOfLines = 2;
    addPhotoLabel.textAlignment = NSTextAlignmentCenter;
    addPhotoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [profileImage addSubview:addPhotoLabel];
    
    firstNameTxt = [[UITextField alloc]initWithFrame:CGRectZero];
    firstNameTxt.translatesAutoresizingMaskIntoConstraints = NO;
    firstNameTxt.placeholder = @"First Name";
    firstNameTxt.borderStyle = UITextBorderStyleRoundedRect;
    UILabel *mandIcon = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 15)];
    mandIcon.text = @"*";
    mandIcon.textColor = [UIColor redColor];
    firstNameTxt.rightViewMode = UITextFieldViewModeAlways;
    firstNameTxt.rightView = mandIcon;
    [self.scrollView addSubview:firstNameTxt];
    
    lastNameTxt = [[UITextField alloc]initWithFrame:CGRectZero];
    lastNameTxt.translatesAutoresizingMaskIntoConstraints = NO;
    lastNameTxt.placeholder = @"Last Name";
    lastNameTxt.borderStyle = UITextBorderStyleRoundedRect;
    UILabel *mandIcon1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 15)];
    mandIcon1.text = @"*";
    mandIcon1.textColor = [UIColor redColor];
    lastNameTxt.rightViewMode = UITextFieldViewModeAlways;
    lastNameTxt.rightView = mandIcon1;
    [self.scrollView addSubview:lastNameTxt];
    
    companyRegView = [[UIView alloc]initWithFrame:CGRectZero];
    companyRegView.translatesAutoresizingMaskIntoConstraints = NO;
    companyRegView.layer.borderWidth = 0.5;
    companyRegView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.scrollView addSubview:companyRegView];
    companyRegView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:220.0/255.0 alpha:1.0];
    
    companyImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    companyImage.translatesAutoresizingMaskIntoConstraints = NO;
    companyImage.backgroundColor = kProfileAddPhotoColor;
    companyImage.layer.cornerRadius = 40;
    [companyRegView addSubview:companyImage];
    UITapGestureRecognizer *companyImageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(companyImageTapped:)];
    [companyImage addGestureRecognizer:companyImageTap];
    [companyImage setUserInteractionEnabled:YES];
    
    addCompPhotoLabel = [[MSALabel alloc]initWithFrame:CGRectZero];
    addCompPhotoLabel.textColor = [UIColor whiteColor];
    addCompPhotoLabel.text = @"Add Logo";
    [addCompPhotoLabel adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    addCompPhotoLabel.numberOfLines = 2;
    addCompPhotoLabel.textAlignment = NSTextAlignmentCenter;
    addCompPhotoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [companyImage addSubview:addCompPhotoLabel];

    
    regForCompanyLbl = [[MSALabel alloc]initWithFrame:CGRectZero];
    regForCompanyLbl.translatesAutoresizingMaskIntoConstraints = NO;
    regForCompanyLbl.text = @"Register for Company";
    [regForCompanyLbl adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:15]];
    regForCompanyLbl.adjustsFontSizeToFitWidth = YES;
    [companyRegView addSubview:regForCompanyLbl];
    
    compRegSwitch = [[UISwitch alloc]initWithFrame:CGRectZero];
    compRegSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [compRegSwitch addTarget:self action:@selector(setSwitchState:) forControlEvents:UIControlEventValueChanged];
    [compRegSwitch setOn: NO];
    [companyRegView addSubview:compRegSwitch];
    [self setSwitchState:compRegSwitch];
    
    companyNameTxt = [[UITextField alloc]initWithFrame:CGRectZero];
    companyNameTxt.translatesAutoresizingMaskIntoConstraints = NO;
    companyNameTxt.placeholder = @"Company Name";
    companyNameTxt.borderStyle = UITextBorderStyleRoundedRect;
    UILabel *mandIcon2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 15)];
    mandIcon2.text = @"*";
    mandIcon2.textColor = [UIColor redColor];
    companyNameTxt.rightViewMode = UITextFieldViewModeAlways;
    companyNameTxt.rightView = mandIcon2;
    [companyRegView addSubview:companyNameTxt];
    
    taxIDTxt = [[UITextField alloc]initWithFrame:CGRectZero];
    taxIDTxt.translatesAutoresizingMaskIntoConstraints = NO;
    taxIDTxt.placeholder = @"Tax ID";
    taxIDTxt.borderStyle = UITextBorderStyleRoundedRect;
    UILabel *mandIcon3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 15)];
    mandIcon3.text = @"*";
    mandIcon3.textColor = [UIColor redColor];
    taxIDTxt.rightViewMode = UITextFieldViewModeAlways;
    taxIDTxt.rightView = mandIcon3;
    [companyRegView addSubview:taxIDTxt];
    
    dunsNumberTxt = [[UITextField alloc]initWithFrame:CGRectZero];
    dunsNumberTxt.translatesAutoresizingMaskIntoConstraints = NO;
    dunsNumberTxt.placeholder = @"Duns Number";
    dunsNumberTxt.borderStyle = UITextBorderStyleRoundedRect;
    UILabel *mandIcon4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 15)];
    mandIcon4.text = @"*";
    mandIcon4.textColor = [UIColor redColor];
    dunsNumberTxt.rightViewMode = UITextFieldViewModeAlways;
    dunsNumberTxt.rightView = mandIcon4;
    [companyRegView addSubview:dunsNumberTxt];
    
    addressLine1Txt = [[UITextField alloc]initWithFrame:CGRectZero];
    addressLine1Txt.translatesAutoresizingMaskIntoConstraints = NO;
    addressLine1Txt.placeholder = @"Address Line1";
    addressLine1Txt.borderStyle = UITextBorderStyleRoundedRect;
    UILabel *mandIcon5 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 15)];
    mandIcon5.text = @"*";
    mandIcon5.textColor = [UIColor redColor];
    addressLine1Txt.rightViewMode = UITextFieldViewModeAlways;
    addressLine1Txt.rightView = mandIcon5;
    [self.scrollView addSubview:addressLine1Txt];
    
    addressLine2Txt = [[UITextField alloc]initWithFrame:CGRectZero];
    addressLine2Txt.translatesAutoresizingMaskIntoConstraints = NO;
    addressLine2Txt.placeholder = @"Address Line2";
    addressLine2Txt.borderStyle = UITextBorderStyleRoundedRect;
    [self.scrollView addSubview:addressLine2Txt];
    
    cityTxt = [[UITextField alloc]initWithFrame:CGRectZero];
    cityTxt.translatesAutoresizingMaskIntoConstraints = NO;
    cityTxt.placeholder = @"City";
    cityTxt.borderStyle = UITextBorderStyleRoundedRect;
    UILabel *mandIcon6 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 15)];
    mandIcon6.text = @"*";
    mandIcon6.textColor = [UIColor redColor];
    cityTxt.rightViewMode = UITextFieldViewModeAlways;
    cityTxt.rightView = mandIcon6;
    [self.scrollView addSubview:cityTxt];
    
    stateTxt = [[UITextField alloc]initWithFrame:CGRectZero];
    stateTxt.translatesAutoresizingMaskIntoConstraints = NO;
    stateTxt.delegate = self;
    stateTxt.returnKeyType = UIReturnKeyNext;
    stateTxt.placeholder = @"State";
    stateTxt.borderStyle = UITextBorderStyleRoundedRect;
    UILabel *mandIcon7 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 15)];
    mandIcon7.text = @"*";
    mandIcon7.textColor = [UIColor redColor];
    stateTxt.rightViewMode = UITextFieldViewModeAlways;
    stateTxt.rightView = mandIcon7;
    [self.scrollView addSubview:stateTxt];
    
    zipTxt = [[UITextField alloc]initWithFrame:CGRectZero];
    zipTxt.translatesAutoresizingMaskIntoConstraints = NO;
    zipTxt.placeholder = @"Zip";
    zipTxt.borderStyle = UITextBorderStyleRoundedRect;
    UILabel *mandIcon8 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 15)];
    mandIcon8.text = @"*";
    mandIcon8.textColor = [UIColor redColor];
    zipTxt.rightViewMode = UITextFieldViewModeAlways;
    zipTxt.rightView = mandIcon8;
    [self.scrollView addSubview:zipTxt];
    zipTxt.keyboardType = UIKeyboardTypeNumberPad;
    
    countryPickerTxt = [[UITextField alloc]initWithFrame:CGRectZero];
    countryPickerTxt.translatesAutoresizingMaskIntoConstraints = NO;
    countryPickerTxt.placeholder = @"Country";
    countryPickerTxt.borderStyle = UITextBorderStyleRoundedRect;
    UILabel *mandIcon9 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 15)];
    mandIcon9.text = @"*";
    mandIcon9.textColor = [UIColor redColor];
    countryPickerTxt.rightViewMode = UITextFieldViewModeAlways;
    countryPickerTxt.rightView = mandIcon9;
    [countryPickerTxt setEnabled:NO];
    [self.scrollView addSubview:countryPickerTxt];
    
    emailTxt = [[UITextField alloc]initWithFrame:CGRectZero];
    emailTxt.translatesAutoresizingMaskIntoConstraints = NO;
    emailTxt.borderStyle = UITextBorderStyleRoundedRect;
    UILabel *mandIcon10 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 15)];
    mandIcon10.text = @"*";
    mandIcon10.textColor = [UIColor redColor];
    emailTxt.rightViewMode = UITextFieldViewModeAlways;
    emailTxt.rightView = mandIcon10;
    [emailTxt setEnabled:NO];
    [self.scrollView addSubview:emailTxt];
    
    genderPickerTxt = [[UITextField alloc]initWithFrame:CGRectZero];
    genderPickerTxt.translatesAutoresizingMaskIntoConstraints = NO;
    genderPickerTxt.placeholder = @"Select";
    genderPickerTxt.borderStyle = UITextBorderStyleRoundedRect;
    genderPickerTxt.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:genderPickerTxt];
    
    genderLbl = [[MSALabel alloc]initWithFrame:CGRectZero];
    genderLbl.translatesAutoresizingMaskIntoConstraints = NO;
    genderLbl.text = @"Gender";
    [genderLbl adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    [self.scrollView addSubview:genderLbl];
    
    UIImageView *rightViewGenderImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 20, 12)];
    rightViewGenderImg.image = [UIImage imageNamed:@"dropArrow.png"];
    rightViewGenderImg.contentMode = UIViewContentModeScaleAspectFit;
    UIView *rightViewGender = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightViewGender addSubview:rightViewGenderImg];
    genderPickerTxt.rightView = rightViewGender;
    genderPickerTxt.rightViewMode = UITextFieldViewModeAlways;
    
    mobileTxt = [[UITextField alloc]initWithFrame:CGRectZero];
    mobileTxt.translatesAutoresizingMaskIntoConstraints = NO;
    mobileTxt.placeholder = @"Mobile";
    mobileTxt.delegate = self;
    UILabel *mandIcon11 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 15)];
    mandIcon11.text = @"*";
    mandIcon11.textColor = [UIColor redColor];
    mobileTxt.rightViewMode = UITextFieldViewModeAlways;
    mobileTxt.rightView = mandIcon11;

    mobileTxt.keyboardType = UIKeyboardTypeNumberPad;
    MSALabel *countryCodeLbl = [[MSALabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    if (self.selectedCountryCode) {
        countryCodeLbl.text = [NSString stringWithFormat:@"+%@",[[MSAUtils getCountryCodeDictionary] valueForKey:self.selectedCountryCode]];
        
    }
    else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *code = [NSString stringWithFormat:@"%@",[defaults valueForKey:kDefaultsSelectedCountry]];
        countryCodeLbl.text = [NSString stringWithFormat:@"+%@",[[MSAUtils getCountryCodeDictionary] valueForKey:[[MSAUtils getCountryFromLocalCodes] valueForKey:code]]];
    }
    
    
    [countryCodeLbl adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    mobileTxt.leftViewMode = UITextFieldViewModeAlways;
    mobileTxt.leftView = countryCodeLbl;
    mobileTxt.borderStyle = UITextBorderStyleRoundedRect;
    [self.scrollView addSubview:mobileTxt];
    
    phoneTxt = [[UITextField alloc]initWithFrame:CGRectZero];
    phoneTxt.translatesAutoresizingMaskIntoConstraints = NO;
    phoneTxt.placeholder = @"Phone";
    UILabel *mandIcon12 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 15)];
    mandIcon12.text = @"*";
    mandIcon12.textColor = [UIColor redColor];
    phoneTxt.rightViewMode = UITextFieldViewModeAlways;
    phoneTxt.rightView = mandIcon12;
    phoneTxt.delegate = self;
    phoneTxt.keyboardType = UIKeyboardTypeNumberPad;
    MSALabel *countryCodeLbl1 = [[MSALabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    if (self.selectedCountryCode) {
        countryCodeLbl1.text = [NSString stringWithFormat:@"+%@",[[MSAUtils getCountryCodeDictionary] valueForKey:self.selectedCountryCode]];

    }
    else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *code = [NSString stringWithFormat:@"%@",[defaults valueForKey:kDefaultsSelectedCountry]];
        countryCodeLbl1.text = [NSString stringWithFormat:@"+%@",[[MSAUtils getCountryCodeDictionary] valueForKey:[[MSAUtils getCountryFromLocalCodes] valueForKey:code]]];
    }
    
    
    [countryCodeLbl1 adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    phoneTxt.leftViewMode = UITextFieldViewModeAlways;
    phoneTxt.leftView = countryCodeLbl1;
    phoneTxt.borderStyle = UITextBorderStyleRoundedRect;
    [self.scrollView addSubview:phoneTxt];

    
    dobTxt = [[UITextField alloc]initWithFrame:CGRectZero];
    dobTxt.translatesAutoresizingMaskIntoConstraints = NO;
    dobTxt.borderStyle = UITextBorderStyleRoundedRect;
    dobTxt.placeholder = @"Date of Birth";
    [self.scrollView addSubview:dobTxt];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    [dobTxt setInputView:datePicker];
    
    UIToolbar *toolBar1= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,44)];
    [toolBar1 setBarStyle:UIBarStyleBlackOpaque];
    UIBarButtonItem *barButtonDone1 = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                      style:UIBarButtonItemStyleBordered target:self action:@selector(setDOB:)];
    UIBarButtonItem *barButtonCancel1 = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                        style:UIBarButtonItemStyleBordered target:self action:@selector(resetDOB:)];
    UIBarButtonItem *flex1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    toolBar1.items = @[barButtonCancel1,flex1,barButtonDone1];
    barButtonDone1.tintColor=[UIColor blackColor];
    dobTxt.inputAccessoryView = toolBar1;
    
    
    currencyTxt = [[UITextField alloc]initWithFrame:CGRectZero];
    currencyTxt.translatesAutoresizingMaskIntoConstraints = NO;
    currencyTxt.placeholder = @"Currency";
    currencyTxt.borderStyle = UITextBorderStyleRoundedRect;
    [self.scrollView addSubview:currencyTxt];
    
    workExpTxt = [[UITextField alloc]initWithFrame:CGRectZero];
    workExpTxt.translatesAutoresizingMaskIntoConstraints = NO;
    workExpTxt.placeholder = @"Work Experience (in Months)";
    workExpTxt.borderStyle = UITextBorderStyleRoundedRect;
    [self.scrollView addSubview:workExpTxt];

    
    // language View
    languageView = [[UIView alloc]initWithFrame:CGRectZero];
    languageView.translatesAutoresizingMaskIntoConstraints = NO;
    languageView.layer.borderWidth = 0.5;
    languageView.layer.cornerRadius = 5;
    languageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    languageView.backgroundColor = kProfileRowBackColor;
    [self.scrollView addSubview:languageView];
    
    languagesLbl = [[MSALabel alloc]initWithFrame:CGRectZero];
    languagesLbl.translatesAutoresizingMaskIntoConstraints = NO;
    languagesLbl.text = @"Languages";
    [languagesLbl adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    [languageView addSubview:languagesLbl];
    
    languagesCountLbl = [[MSALabel alloc]initWithFrame:CGRectZero];
    languagesCountLbl.translatesAutoresizingMaskIntoConstraints = NO;
    languagesCountLbl.textAlignment = NSTextAlignmentRight;
    [languagesCountLbl adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    [languageView addSubview:languagesCountLbl];
    
    languageAccessoryView = [[UIImageView alloc]initWithFrame:CGRectZero];
    languageAccessoryView.translatesAutoresizingMaskIntoConstraints = NO;
    languageAccessoryView.image = [UIImage imageNamed:@"rightArrow.png"];
    languageAccessoryView.contentMode = UIViewContentModeScaleAspectFit;
    [languageView addSubview:languageAccessoryView];

    
    educationView = [[UIView alloc]initWithFrame:CGRectZero];
    educationView.translatesAutoresizingMaskIntoConstraints = NO;
    educationView.layer.borderWidth = 0.5;
    educationView.layer.cornerRadius = 5;
    educationView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    educationView.backgroundColor = kProfileRowBackColor;
    [self.scrollView addSubview:educationView];
    
    
    educationLbl =  [[MSALabel alloc]initWithFrame:CGRectZero];
    educationLbl.translatesAutoresizingMaskIntoConstraints = NO;
    educationLbl.text = @"Education";
    [educationLbl adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    [educationView addSubview:educationLbl];
    
    educationCountLbl = [[MSALabel alloc]initWithFrame:CGRectZero];
    educationCountLbl.translatesAutoresizingMaskIntoConstraints = NO;
    educationCountLbl.textAlignment = NSTextAlignmentRight;
    [educationCountLbl adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    [educationView addSubview:educationCountLbl];
    
    educationAccessoryView = [[UIImageView alloc]initWithFrame:CGRectZero];
    educationAccessoryView.translatesAutoresizingMaskIntoConstraints = NO;
    educationAccessoryView.image = [UIImage imageNamed:@"rightArrow.png"];
    educationAccessoryView.contentMode = UIViewContentModeScaleAspectFit;
    [educationView addSubview:educationAccessoryView];
    
    languageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(languageViewTapped:)];
    [languageView addGestureRecognizer:languageTap];
    
    educationTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(educationViewTapped:)];
    [educationView addGestureRecognizer:educationTap];
    
    
    self.skipContinueBtn.backgroundColor = kMySchappLightBlueColor;
    [self.skipContinueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    self.skipContinueBtn.layer.cornerRadius = 5.0;
    
    self.continueBtn.backgroundColor = kMySchappMediumBlueColor;
    [self.continueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    self.continueBtn.layer.cornerRadius = 5.0;
    
    // Adding PickerView
    genderPicker = [[UIPickerView alloc] init];
    genderPicker.dataSource = self;
    genderPicker.delegate = self;
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,44)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                      style:UIBarButtonItemStyleBordered target:self action:@selector(setGender:)];
    UIBarButtonItem *barButtonCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                        style:UIBarButtonItemStyleBordered target:self action:@selector(resetGender:)];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    toolBar.items = @[barButtonCancel,flex,barButtonDone];
    barButtonDone.tintColor=[UIColor blackColor];
    genderPickerTxt.inputAccessoryView = toolBar;
    genderPickerTxt.inputView = genderPicker;
    
    [self applyConstraints];
    [self setSwitchState:compRegSwitch];
    
    if (self.isComingFromMenu) {
        [self.skipContinueBtn setHidden:YES];
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
    else if (self.selectedPlanId.integerValue != 1) {
        [self.skipContinueBtn setHidden:YES];
        [self.continueBtn setHidden:YES];
        
        newContinueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        newContinueBtn.backgroundColor = kMySchappMediumBlueColor;
        [newContinueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
        newContinueBtn.layer.cornerRadius = 5.0;
        [newContinueBtn setTitle:@"Continue" forState:UIControlStateNormal];
        newContinueBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:newContinueBtn];
        [newContinueBtn addTarget:self action:@selector(openSecurityScreen:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[continueBtn(42)]-10-|" options:0 metrics:nil views:@{@"continueBtn":newContinueBtn}]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:newContinueBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:newContinueBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.40 constant:0]];
    }
}


// Apply constraints
- (void)applyConstraints {
    
    NSDictionary *views = @{@"firstNameTxt":firstNameTxt,@"lastNameTxt":lastNameTxt,@"companyRegView":companyRegView,@"addressLine1Txt":addressLine1Txt,@"addressLine2Txt":addressLine2Txt,@"zipTxt":zipTxt,@"cityTxt":cityTxt,@"stateTxt":stateTxt,@"countryPickerTxt":countryPickerTxt,@"emailTxt":emailTxt,@"genderLbl":genderLbl,@"phoneTxt":phoneTxt,@"mobileTxt":mobileTxt,@"dobTxt":dobTxt,@"currencyTxt":currencyTxt,@"languageView":languageView,@"educationView":educationView,@"profileImage":profileImage,@"workExpTxt":workExpTxt};
    
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[firstNameTxt(45)]-10-[lastNameTxt(45)]-10-[companyRegView]-10-[addressLine1Txt(45)]-10-[addressLine2Txt(45)]-10-[zipTxt(45)]-10-[cityTxt(45)]-10-[stateTxt(45)]-10-[countryPickerTxt(45)]-10-[emailTxt(45)]-10-[genderLbl(45)]-10-[phoneTxt(45)]-10-[mobileTxt(45)]-10-[dobTxt(45)]-10-[currencyTxt(45)]-10-[workExpTxt(45)]-10-[languageView(45)]-10-[educationView(45)]-10-|" options:0 metrics:nil views:views]];
    
    // profileImage
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:profileImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:profileImage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:addressLine1Txt attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:profileImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:profileImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:firstNameTxt attribute:NSLayoutAttributeTop multiplier:1 constant:5]];
    
    
     [profileImage addConstraint:[NSLayoutConstraint constraintWithItem:addPhotoLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:profileImage attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
     [profileImage addConstraint:[NSLayoutConstraint constraintWithItem:addPhotoLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:profileImage attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
     [profileImage addConstraint:[NSLayoutConstraint constraintWithItem:addPhotoLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
    
    // First Name
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:firstNameTxt attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:addressLine1Txt attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:firstNameTxt attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:profileImage attribute:NSLayoutAttributeTrailing multiplier:1 constant:10]];

    // Last Name
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:lastNameTxt attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:addressLine1Txt attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:lastNameTxt attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:profileImage attribute:NSLayoutAttributeTrailing multiplier:1 constant:10]];
    
    
    // CompanyRegView
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:companyRegView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:companyRegView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    companyRegViewHeight = [NSLayoutConstraint constraintWithItem:companyRegView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:225];
    [self.scrollView addConstraint:companyRegViewHeight];
    
    NSDictionary *compRegViews = @{@"companyNameTxt":companyNameTxt,@"taxIDTxt":taxIDTxt,@"dunsNumberTxt":dunsNumberTxt,@"regForCompanyLbl":regForCompanyLbl,@"compRegSwitch":compRegSwitch,@"companyImage":companyImage};
    [companyRegView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[regForCompanyLbl(45)]-10-[companyNameTxt(45)]-10-[taxIDTxt(45)]-[dunsNumberTxt(45)]" options:0 metrics:nil views:compRegViews]];
    
    // company Image
    [companyRegView addConstraint:[NSLayoutConstraint constraintWithItem:companyImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80]];
    [companyRegView addConstraint:[NSLayoutConstraint constraintWithItem:companyImage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:regForCompanyLbl attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [companyRegView addConstraint:[NSLayoutConstraint constraintWithItem:companyImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80]];
    [companyRegView addConstraint:[NSLayoutConstraint constraintWithItem:companyImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:companyNameTxt attribute:NSLayoutAttributeTop multiplier:1 constant:5]];
    
    // company image label
    [companyImage addConstraint:[NSLayoutConstraint constraintWithItem:addCompPhotoLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:companyImage attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [companyImage addConstraint:[NSLayoutConstraint constraintWithItem:addCompPhotoLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:companyImage attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [companyImage addConstraint:[NSLayoutConstraint constraintWithItem:addCompPhotoLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];


    // regForCompanyLbl
    [companyRegView addConstraint:[NSLayoutConstraint constraintWithItem:regForCompanyLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:companyRegView attribute:NSLayoutAttributeWidth multiplier:0.50 constant:0]];
    [companyRegView addConstraint:[NSLayoutConstraint constraintWithItem:regForCompanyLbl attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:dunsNumberTxt attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    
    // compRegSwitch
    [companyRegView addConstraint:[NSLayoutConstraint constraintWithItem:compRegSwitch attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:companyRegView attribute:NSLayoutAttributeWidth multiplier:0.20 constant:0]];
    [companyRegView addConstraint:[NSLayoutConstraint constraintWithItem:compRegSwitch attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:companyNameTxt attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10]];
    [companyRegView addConstraint:[NSLayoutConstraint constraintWithItem:compRegSwitch attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:regForCompanyLbl attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    // companyNameTxt
    [companyRegView addConstraint:[NSLayoutConstraint constraintWithItem:companyNameTxt attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:dunsNumberTxt attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [companyRegView addConstraint:[NSLayoutConstraint constraintWithItem:companyNameTxt attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:companyImage attribute:NSLayoutAttributeTrailing multiplier:1 constant:10]];
    
    // taxIdTxt
    [companyRegView addConstraint:[NSLayoutConstraint constraintWithItem:taxIDTxt attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:dunsNumberTxt attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [companyRegView addConstraint:[NSLayoutConstraint constraintWithItem:taxIDTxt attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:companyImage attribute:NSLayoutAttributeTrailing multiplier:1 constant:10]];
    
    // DunsNumberTxt
    [companyRegView addConstraint:[NSLayoutConstraint constraintWithItem:dunsNumberTxt attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:companyRegView attribute:NSLayoutAttributeWidth multiplier:0.90 constant:0]];
    [companyRegView addConstraint:[NSLayoutConstraint constraintWithItem:dunsNumberTxt attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:companyRegView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    // addressLine1Txt
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:addressLine1Txt attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:0.90 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:addressLine1Txt attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    // addressLine2Txt
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:addressLine2Txt attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:0.90 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:addressLine2Txt attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    // zip
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:zipTxt attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:0.90 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:zipTxt attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

    // cityTxt
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:cityTxt attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:0.90 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:cityTxt attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

    // State
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:stateTxt attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:0.90 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:stateTxt attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    // Country
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:countryPickerTxt attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:0.90 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:countryPickerTxt attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    // email
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:emailTxt attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:0.90 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:emailTxt attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    // genderLbl
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:genderLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:0.40 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:genderLbl attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:emailTxt attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    // genderTxt
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:genderPickerTxt attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:0.40 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:genderPickerTxt attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:zipTxt attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:genderPickerTxt attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:genderLbl attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:genderPickerTxt attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:genderLbl attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    
    // Phone Text
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:phoneTxt attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:0.90 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:phoneTxt attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    // Mobile Text
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:mobileTxt attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:0.90 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:mobileTxt attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    // DOB
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:dobTxt attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:0.90 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:dobTxt attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    // Currency
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:currencyTxt attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:0.90 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:currencyTxt attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    // workExpTxt
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:workExpTxt attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:0.90 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:workExpTxt attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    
    
    //language view
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:languageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:0.90 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:languageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    NSDictionary *languageViews = @{@"languagesCountLbl":languagesCountLbl,@"languagesLbl":languagesLbl,@"languageAccessoryView":languageAccessoryView};
    [languageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[languagesLbl]|" options:0 metrics:nil views:languageViews]];
    [languageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[languagesLbl]" options:0 metrics:nil views:languageViews]];
    [languageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[languagesCountLbl]-10-[languageAccessoryView(12)]-|" options:0 metrics:nil views:languageViews]];
    
    // lang Lbl
    [languageView addConstraint:[NSLayoutConstraint constraintWithItem:languagesLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:languageView attribute:NSLayoutAttributeWidth multiplier:0.30 constant:0]];
    

    // Language Text
    [languageView addConstraint:[NSLayoutConstraint constraintWithItem:languagesCountLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:languageView attribute:NSLayoutAttributeWidth multiplier:0.40 constant:0]];
    
    [languageView addConstraint:[NSLayoutConstraint constraintWithItem:languagesCountLbl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:languagesLbl attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [languageView addConstraint:[NSLayoutConstraint constraintWithItem:languagesCountLbl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:languagesLbl attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    
    
    // add cert Button
    [languageView addConstraint:[NSLayoutConstraint constraintWithItem:languageAccessoryView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20]];
    [languageView addConstraint:[NSLayoutConstraint constraintWithItem:languageAccessoryView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:languagesCountLbl attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    
    //education view
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:educationView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:0.90 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:educationView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    NSDictionary *educationViews = @{@"educationCountLbl":educationCountLbl,@"educationLbl":educationLbl,@"educationAccessoryView":educationAccessoryView};
    [educationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[educationLbl]|" options:0 metrics:nil views:educationViews]];
    [educationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[educationLbl]" options:0 metrics:nil views:educationViews]];
    [educationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[educationCountLbl]-10-[educationAccessoryView(12)]-|" options:0 metrics:nil views:educationViews]];

    
    // Cert Lbl
    [educationView addConstraint:[NSLayoutConstraint constraintWithItem:educationLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:educationView attribute:NSLayoutAttributeWidth multiplier:0.30 constant:0]];
    
    // Cert Text
    [educationView addConstraint:[NSLayoutConstraint constraintWithItem:educationCountLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:educationView attribute:NSLayoutAttributeWidth multiplier:0.40 constant:0]];
    [educationView addConstraint:[NSLayoutConstraint constraintWithItem:educationCountLbl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:educationLbl attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [educationView addConstraint:[NSLayoutConstraint constraintWithItem:educationCountLbl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:educationLbl attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    
    // add education Button
    [educationView addConstraint:[NSLayoutConstraint constraintWithItem:educationAccessoryView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20]];
    [educationView addConstraint:[NSLayoutConstraint constraintWithItem:educationAccessoryView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:educationCountLbl attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    
    
    
}

- (void)createSegmentView {
    
    MSALabel *personalLbl = [[MSALabel alloc]initWithFrame:CGRectZero];
    personalLbl.translatesAutoresizingMaskIntoConstraints = NO;
    personalLbl.text = @"Personal";
    personalLbl.textColor = kProfileSegmentSelectedFontColor;
   // personalLbl.font = kProfileSegmentFont;
    [personalLbl adjustFontSizeAccToScreenWidth:kProfileSegmentFont];
    personalLbl.textAlignment = NSTextAlignmentCenter;
    
    MSALabel *securityLbl = [[MSALabel alloc]initWithFrame:CGRectZero];
    securityLbl.translatesAutoresizingMaskIntoConstraints = NO;
    securityLbl.text = @"Security";
    securityLbl.textColor = kProfileSegmentDefaultFontColor;
//    securityLbl.font = kProfileSegmentFont;
    [securityLbl adjustFontSizeAccToScreenWidth:kProfileSegmentFont];
//    securityLbl.adjustsFontSizeToFitWidth = YES;
    securityLbl.textAlignment = NSTextAlignmentCenter;
    
    MSALabel *notificationLbl = [[MSALabel alloc]initWithFrame:CGRectZero];
    notificationLbl.translatesAutoresizingMaskIntoConstraints = NO;
    notificationLbl.text = @"Notification";
    notificationLbl.textColor = kProfileSegmentDefaultFontColor;
//    notificationLbl.font = kProfileSegmentFont;
    [notificationLbl adjustFontSizeAccToScreenWidth:kProfileSegmentFont];
//    notificationLbl.adjustsFontSizeToFitWidth = YES;
    notificationLbl.textAlignment = NSTextAlignmentCenter;
    
    MSALabel *paymentLbl = [[MSALabel alloc]initWithFrame:CGRectZero];
    paymentLbl.translatesAutoresizingMaskIntoConstraints = NO;
    paymentLbl.text = @"Payment";
    paymentLbl.textColor = kProfileSegmentDefaultFontColor;
//    paymentLbl.font = kProfileSegmentFont;
    [paymentLbl adjustFontSizeAccToScreenWidth:kProfileSegmentFont];
//    paymentLbl.adjustsFontSizeToFitWidth = YES;
    paymentLbl.textAlignment = NSTextAlignmentCenter;
    
    UIView *highlightedView = [[UIView alloc]initWithFrame:CGRectZero];
    highlightedView.translatesAutoresizingMaskIntoConstraints = NO;
    highlightedView.backgroundColor = kProfileSegmentSelectedFontColor;
    [personalLbl addSubview:highlightedView];
    
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
    
    [personalLbl addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[highlightedView(2)]|" options:0 metrics:nil views:@{@"highlightedView":highlightedView}]];
    [personalLbl addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[highlightedView]|" options:0 metrics:nil views:@{@"highlightedView":highlightedView}]];
    
    
}

- (void)autoFillData {
    self.selectedPlanLbl.text = [NSString stringWithFormat:@"Selected Plan : %@",self.selectedPlanName];
    
    firstNameTxt.text = [MSAUtils convertNullToEmptyString:[personalDetails objectForKey:kProfileFname]];
    lastNameTxt.text = [MSAUtils convertNullToEmptyString:[personalDetails objectForKey:kProfileLname]];
    
    addressLine1Txt.text = [MSAUtils convertNullToEmptyString:[personalDetails objectForKey:kProfileAddress1]];
    addressLine2Txt.text = [MSAUtils convertNullToEmptyString:[personalDetails objectForKey:kProfileAddress2]];
    zipTxt.text = [MSAUtils convertNullToEmptyString:[personalDetails objectForKey:kProfileZip]];
    cityTxt.text = [MSAUtils convertNullToEmptyString:[personalDetails objectForKey:kProfileCity]];
    stateTxt.text = [MSAUtils convertNullToEmptyString:[personalDetails objectForKey:kProfileState]];
    countryPickerTxt.text = [MSAUtils convertNullToEmptyString:[personalDetails objectForKey:kProfileCountry]];
    if ([countryPickerTxt.text isEqualToString:@""]) {
        countryPickerTxt.text = self.selectedCountryName;
    }
    
    emailTxt.text = [MSAUtils convertNullToEmptyString:[personalDetails objectForKey:kProfileEmail]];
    genderPickerTxt.text = [MSAUtils convertNullToEmptyString:[personalDetails objectForKey:kProfileGender]];
    if (![genderPickerTxt.text isEqualToString:@""]) {
        [genderPicker selectRow:[genderArray indexOfObject:genderPickerTxt.text] inComponent:0 animated:YES];
    }
    
    
    phoneTxt.text = [MSAUtils convertNullToEmptyString:[personalDetails objectForKey:kProfilePhone]];
    mobileTxt.text = [MSAUtils convertNullToEmptyString:[personalDetails objectForKey:kProfileMobile]];
    dobTxt.text = [MSAUtils convertNullToEmptyString:[personalDetails objectForKey:kProfileDob]];
    currencyTxt.text = [MSAUtils convertNullToEmptyString:[personalDetails objectForKey:kProfileSelectedCurrency]];
    
    long workEx = [[MSAUtils convertNullToEmptyString:[personalDetails objectForKey:kProfileWorkExperience]] integerValue];
    workExpTxt.text = [NSString stringWithFormat:@"%ld months",workEx];
    
    
    if ([[personalDetails objectForKey:kProfileSelectedLanguages] isKindOfClass:[NSNull class]]) {
        languagesCountLbl.text = @"0";
    }
    else {
        selectedLanguages = [personalDetails objectForKey:kProfileSelectedLanguages];
        languagesCountLbl.text = [NSString stringWithFormat:@"%ld",[selectedLanguages count]];
    }
    
    if ([[personalDetails objectForKey:kProfileListofCert] isKindOfClass:[NSNull class]]) {
        educationCountLbl.text = @"0";
    }
    else {
        listOfCertifications = [personalDetails objectForKey:kProfileListofCert];
        educationCountLbl.text = [NSString stringWithFormat:@"%ld",[listOfCertifications count]];
    }
    
    NSString * profileImageDataString = [MSAUtils convertNullToEmptyString:[personalDetails objectForKey:@"profileImage"]];
    NSData * profileImageData = [[NSData alloc]initWithBase64EncodedString:profileImageDataString options:0];
    if (profileImageData) {
        [profileImage setImage:[UIImage imageWithData:profileImageData]];
    }
    
    // company details
    companyNameTxt.text = [MSAUtils convertNullToEmptyString:[personalDetails objectForKey:kProfileCname]];
    taxIDTxt.text = [MSAUtils convertNullToEmptyString:[personalDetails objectForKey:kProfileTaxid]];
    dunsNumberTxt.text = [MSAUtils convertNullToEmptyString:[personalDetails objectForKey:kProfileDuns]];
    NSString * companyImageDataString = [MSAUtils convertNullToEmptyString:[personalDetails objectForKey:@"companyImage"]];
    NSData * companyImageData = [[NSData alloc]initWithBase64EncodedString:companyImageDataString options:0];
    if (companyImageData) {
        
        UIImage *image = [UIImage imageWithData:companyImageData];
        [companyImage setImage:image];
    }
    
//    // open company flag if company details are there details
//    if (![companyNameTxt.text isEqualToString:@""]||![taxIDTxt.text isEqualToString:@""]||![dunsNumberTxt.text isEqualToString:@""]||companyImageData) {
//        [compRegSwitch setOn:YES];
//        [self setSwitchState:compRegSwitch];
//        
//    }
    
}

- (void)getFilledData {
    submitPersonalDetails = [[NSMutableDictionary alloc]init];
    
    [submitPersonalDetails setObject:firstNameTxt.text forKey:kProfileFname];
    [submitPersonalDetails setObject:lastNameTxt.text forKey:kProfileLname];
    [submitPersonalDetails setObject:@"" forKey:kProfileMname];
    if ([compRegSwitch isOn]) {
        [submitPersonalDetails setObject:companyNameTxt.text forKey:kProfileCname];
        [submitPersonalDetails setObject:taxIDTxt.text forKey:kProfileTaxid];
        [submitPersonalDetails setObject:dunsNumberTxt.text forKey:kProfileDuns];
    }
    else {
        [submitPersonalDetails setObject:@"" forKey:kProfileCname];
        [submitPersonalDetails setObject:@"" forKey:kProfileTaxid];
        [submitPersonalDetails setObject:@"" forKey:kProfileDuns];
    }
    
    [submitPersonalDetails setObject:addressLine1Txt.text forKey:kProfileAddress1];
    [submitPersonalDetails setObject:addressLine2Txt.text forKey:kProfileAddress2];
    [submitPersonalDetails setObject:zipTxt.text forKey:kProfileZip];
    [submitPersonalDetails setObject:cityTxt.text forKey:kProfileCity];
    [submitPersonalDetails setObject:stateTxt.text forKey:kProfileState];
    [submitPersonalDetails setObject:countryPickerTxt.text forKey:kProfileCountry];
    [submitPersonalDetails setObject:emailTxt.text forKey:kProfileEmail];
    [submitPersonalDetails setObject:genderPickerTxt.text forKey:kProfileGender];
    [submitPersonalDetails setObject:@"M" forKey:kProfileGender];
    
    [submitPersonalDetails setObject:mobileTxt.text forKey:kProfileMobile];
    [submitPersonalDetails setObject:phoneTxt.text forKey:kProfilePhone];
    [submitPersonalDetails setObject:dobTxt.text forKey:kProfileDob];
    [submitPersonalDetails setObject:currencyTxt.text forKey:kProfileSelectedCurrency];
    [submitPersonalDetails setObject:[NSNumber numberWithInteger:[[workExpTxt.text stringByReplacingOccurrencesOfString:@"months" withString:@""] integerValue]] forKey:kProfileWorkExperience];
    
    if ([languagesCountLbl.text isEqualToString:@"0"])
        [submitPersonalDetails setObject:@[] forKey:kProfileSelectedLanguages];
    else
        [submitPersonalDetails setObject:selectedLanguages forKey:kProfileSelectedLanguages];
    
    if ([educationCountLbl.text isEqualToString:@"0"])
        [submitPersonalDetails setObject:@[] forKey:kProfileListofCert];
    else
        [submitPersonalDetails setObject:listOfCertifications forKey:kProfileListofCert];

    if (profileImage.image) {
        NSData * profileImageData = [UIImagePNGRepresentation(profileImage.image) base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSString *base64String = [profileImageData base64EncodedStringWithOptions:0];
        [submitPersonalDetails setObject:base64String forKey:@"profileImage"];
    }
    else {
        [submitPersonalDetails setObject:@"" forKey:@"profileImage"];
    }
    
    if (companyImage.image) {
        NSData * companyImageData = [UIImagePNGRepresentation(companyImage.image) base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSString *base64String = [companyImageData base64EncodedStringWithOptions:0];
        [submitPersonalDetails setObject:base64String forKey:@"companyImage"];
    }
    else {
        [submitPersonalDetails setObject:@"" forKey:@"companyImage"];
    }

    // extra mandatory tags
    [submitPersonalDetails setObject:[personalDetails objectForKey:@"ps"] forKey:@"ps"];
    [submitPersonalDetails setObject:[personalDetails objectForKey:@"billingType"] forKey:@"billingType"];
    [submitPersonalDetails setObject:[personalDetails objectForKey:kProfilePlanId] forKey:kProfilePlanId];
    [submitPersonalDetails setObject:[personalDetails objectForKey:kProfileCountryId] forKey:kProfileCountryId];

}

#pragma mark - MSANetworkDelegate

- (void)didReceiveData:(NSData *)responseData forRequest:(NSString *)requestId
{
    //received response comes here
    NSError* err;
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&err];
    
    NSLog(@"%@",responseDict);
    if ([requestId isEqualToString:@"PersonalData"]) {
        if([[responseDict valueForKey:@"rCode"] isEqualToString:@"00"]) {
            NSLog(@"Got Personal data");
            personalDetails = [NSMutableDictionary dictionaryWithDictionary:responseDict];
            self.selectedCountryCode = [personalDetails objectForKey:@"countryCodeId"];
            // Autofill Data
            [self autoFillData];
        }
        else {
            [MSAUtils showAlertWithTitle:kAlertMessageTitle message:[responseDict valueForKey:@"rMsg"] cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
            [self.navigationController popViewControllerAnimated:NO];
        }

    }
    else if ([requestId isEqualToString:@"SavePersonalData"]) {
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
    else if ([requestId isEqualToString:@"OpenSecurityScreen"])
    {
        if([[responseDict valueForKey:@"rCode"] isEqualToString:@"00"]) {
            UIStoryboard *mainStoryboard = UISTORYBOARD;
            
            MSASecurityViewController *controller = (MSASecurityViewController*)[mainStoryboard
                                                                                 instantiateViewControllerWithIdentifier:@"MSASecurityViewController"];
            controller.securityDataFromPersonal = [NSMutableDictionary dictionaryWithDictionary:responseDict];
            controller.selectedPlanName = self.selectedPlanName;
            controller.selectedPlanId = self.selectedPlanId;
            [self.navigationController pushViewController:controller animated:YES];
        }
        else {
            [MSAUtils showAlertWithTitle:kAlertMessageTitle message:[responseDict valueForKey:@"rMsg"] cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
        }
    }

    
}

- (void)didFailWithError:(NSError *)error forRequest:(NSString *)requestId
{
      [MSAUtils showAlertWithTitle:kAlertMessageTitle message:kAlertInternalErrorMsg cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction Methods
- (IBAction)skipProfile:(id)sender {
    MSALoginDecision *loginDecision = [[MSALoginDecision alloc]init];
    loginDecision.delegate = self;
    [loginDecision checkTokensValidityWithRequestID:@"SkipContinueService"];
}

- (IBAction)openSecurityScreen:(id)sender {
    [self getFilledData];
    if ([compRegSwitch isOn]) {
        if ([companyNameTxt.text isEqualToString:@""]||[dunsNumberTxt.text isEqualToString:@""]||[taxIDTxt.text isEqualToString:@""]) {
            [MSAUtils showAlertWithTitle:@"Warning" message:@"Provide company details and then continue." cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
        }
        else {
            MSALoginDecision *loginDecision = [[MSALoginDecision alloc]init];
            loginDecision.delegate = self;
            [loginDecision checkTokensValidityWithRequestID:@"OpenSecurityScreen"];
        }
    }
    else {
        MSALoginDecision *loginDecision = [[MSALoginDecision alloc]init];
        loginDecision.delegate = self;
        [loginDecision checkTokensValidityWithRequestID:@"OpenSecurityScreen"];
    }

    
}

#pragma mark- Selecter Methods
- (void)saveButtonClicked:(id)sender {
    [self getFilledData];
    if ([compRegSwitch isOn]) {
        if ([companyNameTxt.text isEqualToString:@""]||[dunsNumberTxt.text isEqualToString:@""]||[taxIDTxt.text isEqualToString:@""]) {
            [MSAUtils showAlertWithTitle:@"Warning" message:@"Provide company details and then continue." cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
        }
        else {
            MSALoginDecision *loginDecision = [[MSALoginDecision alloc]init];
            loginDecision.delegate = self;
            [loginDecision checkTokensValidityWithRequestID:@"SavePersonalData"];

        }
    }
    else {
        MSALoginDecision *loginDecision = [[MSALoginDecision alloc]init];
        loginDecision.delegate = self;
        [loginDecision checkTokensValidityWithRequestID:@"SavePersonalData"];
    }
}

- (void)setSwitchState:(id)sender {
    if (![sender isOn]) {
        companyRegViewHeight.constant = 55;
        companyRegView.clipsToBounds = YES;
        [companyRegView updateConstraintsIfNeeded];
        companyNameTxt.text = @"";
        taxIDTxt.text = @"";
        dunsNumberTxt.text = @"";
        companyImage.image = nil;
        if ([addCompPhotoLabel isHidden]) {
            [addCompPhotoLabel setHidden:NO];
        }
    }
    else {
        companyRegViewHeight.constant = 230;
        companyRegView.clipsToBounds = YES;
        [companyRegView updateConstraintsIfNeeded];
    }
    
    
}

- (void)languageViewTapped:(id)sender {
    MSALanguageTableViewController *languageVC = [[MSALanguageTableViewController alloc]init];
    languageVC.delegate = self;
    if (![[personalDetails objectForKey:kProfileSelectedLanguages] isKindOfClass:[NSNull class]]) {
        languageVC.savedLanguagesArray = (NSArray *)[personalDetails objectForKey:kProfileSelectedLanguages];
    }
    [self.navigationController pushViewController:languageVC animated:YES];
    
    
}

- (void)educationViewTapped:(id)sender {
    UIStoryboard *mainStoryboard = UISTORYBOARD;
    
    MSAEducationViewController *educationVC = (MSAEducationViewController*)[mainStoryboard
                                                                             instantiateViewControllerWithIdentifier:@"MSAEducationViewController"];
    educationVC.delegate = self;
    if (![[personalDetails objectForKey:kProfileListofCert] isKindOfClass:[NSNull class]]) {
        educationVC.savedEducationArray = (NSArray *)[personalDetails objectForKey:kProfileListofCert];
    }
    [self.navigationController pushViewController:educationVC animated:YES];
}

#pragma mark - Camera and gallery handlers

- (void)profileImageTapped:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate: self
                                                    cancelButtonTitle: @"Cancel"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"Take a new photo",
                                  @"Choose from existing", nil];
    [actionSheet showInView:self.view];
    profilePhotoTapped = YES;
    
}

- (void)companyImageTapped:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate: self
                                                    cancelButtonTitle: @"Cancel"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"Take a new photo",
                                  @"Choose from existing", nil];
    [actionSheet showInView:self.view];
    profilePhotoTapped = NO;
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSInteger i = buttonIndex;
    
    switch(i) {
            
        case 0:
        {
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.allowsEditing = YES;
                picker.delegate = self;
                [self presentViewController:picker animated:YES completion:nil];
            }
            
        }
            break;
        case 1:
        {
            if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
                {
                    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    popover = [[UIPopoverController alloc] initWithContentViewController: picker];
                    popover.delegate =self;
                    [popover presentPopoverFromRect:self.view.bounds inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                }
            }else{
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
                {
                    UIImagePickerController *picker1 = [[UIImagePickerController alloc]init];
                    picker1.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    picker1.allowsEditing = YES;
                    picker1.delegate = self;
                    [self presentViewController:picker1 animated:YES completion:nil];
                }
            }
            
        }
            
        default:
            // Do Nothing.........
            break;
            
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSLog(@"Picker returned successfully.");
    
    UIImage *selectedImage;
    
    NSURL *mediaUrl;
    
    mediaUrl = (NSURL *)[info valueForKey:UIImagePickerControllerMediaURL];
    
    if (mediaUrl == nil) {
        
        selectedImage = (UIImage *) [info valueForKey:UIImagePickerControllerEditedImage];
        if (selectedImage == nil) {
            
            selectedImage= (UIImage *) [info valueForKey:UIImagePickerControllerOriginalImage];
            NSLog(@"Original image picked.");
            
        }
        else {
            
            NSLog(@"Edited image picked.");
            
        }
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (profilePhotoTapped) {
        [profileImage setImage:selectedImage];
        [addPhotoLabel setHidden:YES];
    }
    else {
        [companyImage setImage:selectedImage];
        [addCompPhotoLabel setHidden:YES];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - LanguageDoneCancelDelegate

- (void)languageDoneClickedWithValues:(NSArray *)newLanguages {
    
    selectedLanguages = newLanguages;
    languagesCountLbl.text = [NSString stringWithFormat:@"%ld",[newLanguages count]];
    
}

#pragma mark - EducationDoneCancelDelegate

- (void)educationDoneClickedWithValues:(NSArray *)newEducation {

    listOfCertifications = newEducation;
    educationCountLbl.text = [NSString stringWithFormat:@"%ld",[newEducation count]];
    [personalDetails setObject:listOfCertifications forKey:kProfileListofCert];
    
}

#pragma mark - UIPickerViewDatasource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return genderArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [genderArray objectAtIndex:row];
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedIndex = row;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == stateTxt) {
        [genderPickerTxt becomeFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if (textField == mobileTxt || textField == phoneTxt) {
        
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 10;
    }
    return YES;
}

#pragma mark - Selector Methods
- (void)setGender:(id)sender
{
    genderPickerTxt.text = [genderArray objectAtIndex:selectedIndex];
    [genderPickerTxt resignFirstResponder];
}

- (void)resetGender:(id)sender
{
    [genderPickerTxt resignFirstResponder];
}

- (void)setDOB:(id)sender
{
    if ([dobTxt.text isEqualToString:@""]) {
        [self dateTextField:dobTxt];
    }
    [dobTxt resignFirstResponder];
}

- (void)resetDOB:(id)sender
{
    dobTxt.text = @"";
    [dobTxt resignFirstResponder];
}




-(void) dateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)dobTxt.inputView;
    [picker setMaximumDate:[NSDate date]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = picker.date;
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    dobTxt.text = [NSString stringWithFormat:@"%@",dateString];
}

#pragma mark LoginDecision Delegate
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
    else if ([pageToBeOpened isEqualToString:@"OpenSecurityScreen"])
    {
        
        NSString *urlString = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%@",BASEURL,SECURITYURL]];
        MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
        networkHanlder.delegate = self;
        NSDictionary *reqHeadDict = @{@"Authorization":[NSString stringWithFormat:@"bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:kAccessToken]]};
        [networkHanlder createRequestForURLString:urlString withIdentifier:@"OpenSecurityScreen" requestHeaders:reqHeadDict andRequestParameters:submitPersonalDetails inView:self.view];
        
        
    }
    else if ([pageToBeOpened isEqualToString:kReacceptTermsScreen]) {
        
        UIStoryboard *mainStoryboard = UISTORYBOARD;
        MSATermsConditionViewController *termsVC  = (MSATermsConditionViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"MSATermsConditionViewController"];
        [self presentViewController:termsVC animated:YES completion:nil];
    }
    else if ([pageToBeOpened isEqualToString:@"SkipContinueService"]) {
        NSString *urlString = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%@",BASEURL,SKIPCONTINUEURL]];
        MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
        networkHanlder.delegate = self;
        NSDictionary *reqHeadDict = @{@"Authorization":[NSString stringWithFormat:@"bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:kAccessToken]]};
        [networkHanlder createRequestForURLString:urlString withIdentifier:@"SkipContinueService" requestHeaders:reqHeadDict andRequestParameters:nil inView:self.view];
    }
    else if ([pageToBeOpened isEqualToString:@"PersonalData"]) {
        NSString *urlString = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%@",BASEURL,PERSONALURL]];
        MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
        networkHanlder.delegate = self;
        NSDictionary *reqHeadDict = @{@"Authorization":[NSString stringWithFormat:@"bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:kAccessToken]]};
        if (!self.isComingFromMenu) {
            [networkHanlder createRequestForURLString:urlString withIdentifier:@"PersonalData" requestHeaders:reqHeadDict andRequestParameters:@{@"countrycodeid":[NSNumber numberWithInteger:[self.selectedCountryId integerValue]],@"planid":self.selectedPlanId} inView:self.view];
        }
        else{
            [networkHanlder createRequestForURLString:urlString withIdentifier:@"PersonalData" requestHeaders:reqHeadDict andRequestParameters:@{} inView:self.view];
        }
        
    }
    else if ([pageToBeOpened isEqualToString:@"SavePersonalData"]){
        NSString *urlString = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%@",BASEURL,SECURITYURL]];
        MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
        networkHanlder.delegate = self;
        NSDictionary *reqHeadDict = @{@"Authorization":[NSString stringWithFormat:@"bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:kAccessToken]]};
        [networkHanlder createRequestForURLString:urlString withIdentifier:@"SavePersonalData" requestHeaders:reqHeadDict andRequestParameters:submitPersonalDetails inView:self.view];
        
        
    }
    
    
    
    
    
    
}





@end
