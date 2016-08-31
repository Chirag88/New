//
//  MSAProviderProfileViewController.m
//  MySchapp
//
//  Created by M-Creative on 8/21/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSAProviderProfileViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "MSALabel.h"
#import "MSAUtils.h"
#import "MSAConstants.h"

@interface MSAProviderProfileViewController ()
{
    UITextField *firstNameTxt;
    UITextField *lastNameTxt;
    UITextField *providerCategoryTxt;
    UITextField *emailTxt;
    UITextField *mobileTxt;
    UIPickerView *providerCategoryPicker;
    UIImageView *servicePrflRadioView;
    UIImageView *providerSpfcRadioView;
    
    MSALabel *specialitiesLbl;
    MSALabel *configLbl;
    MSALabel *specialitiesCountLbl;
    MSALabel *configCountLbl;
    UIImageView *specialityAccessoryView;
    UIImageView *configAccessoryView;
    UIView *specialityView;
    UIView *configView;
    UIView *providerConfigSourceView;
    UITapGestureRecognizer *specialityTap;
    UITapGestureRecognizer *configTap;
    
    NSMutableArray *providerCategories;
    NSInteger selectedIndex;
}
@property (nonatomic, weak) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIButton *continueBtn;

@end

@implementation MSAProviderProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    providerCategories = [[NSMutableArray alloc] initWithObjects:@"Employee",@"Provider", nil];
    // Create UI
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Provider at Locations";
    [self.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI {
    
//    genderArray = @[@"M",@"F"];
    providerCategoryTxt = [[UITextField alloc]initWithFrame:CGRectZero];
    providerCategoryTxt.translatesAutoresizingMaskIntoConstraints = NO;
    providerCategoryTxt.placeholder = @"Employee";
    providerCategoryTxt.borderStyle = UITextBorderStyleRoundedRect;
    UIImageView *dropDownArrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 15)];
    dropDownArrow.image = [UIImage imageNamed:@"rightArrow.png"];
//    UILabel *mandIcon9 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 15)];
//    mandIcon9.text = @"*";
//    mandIcon9.textColor = [UIColor redColor];
    providerCategoryTxt.rightViewMode = UITextFieldViewModeAlways;
    providerCategoryTxt.rightView = dropDownArrow;//mandIcon9;
    [providerCategoryTxt setEnabled:YES];
    [self.scrollView addSubview:providerCategoryTxt];
    // Adding PickerView
    providerCategoryPicker = [[UIPickerView alloc] init];
    providerCategoryPicker.dataSource = self;
    providerCategoryPicker.delegate = self;
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,44)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                      style:UIBarButtonItemStyleBordered target:self action:@selector(setProviderCategory:)];
    UIBarButtonItem *barButtonCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                        style:UIBarButtonItemStyleBordered target:self action:@selector(resetProviderCategory:)];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    toolBar.items = @[barButtonCancel,flex,barButtonDone];
    barButtonDone.tintColor=[UIColor blackColor];
    providerCategoryTxt.inputAccessoryView = toolBar;
    providerCategoryTxt.inputView = providerCategoryPicker;
    
    
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
    
    emailTxt = [[UITextField alloc]initWithFrame:CGRectZero];
    emailTxt.translatesAutoresizingMaskIntoConstraints = NO;
    emailTxt.placeholder = @"Email";
    emailTxt.borderStyle = UITextBorderStyleRoundedRect;
    UILabel *mandIcon10 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 15)];
    mandIcon10.text = @"*";
    mandIcon10.textColor = [UIColor redColor];
    emailTxt.rightViewMode = UITextFieldViewModeAlways;
    emailTxt.rightView = mandIcon10;
    [emailTxt setEnabled:NO];
    [self.scrollView addSubview:emailTxt];
    
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
//    if (self.selectedCountryCode) {
//        countryCodeLbl.text = [NSString stringWithFormat:@"+%@",[[MSAUtils getCountryCodeDictionary] valueForKey:self.selectedCountryCode]];
//        
//    }
//    else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *code = [NSString stringWithFormat:@"%@",[defaults valueForKey:kDefaultsSelectedCountry]];
        countryCodeLbl.text = [NSString stringWithFormat:@"+%@",[[MSAUtils getCountryCodeDictionary] valueForKey:[[MSAUtils getCountryFromLocalCodes] valueForKey:code]]];
//    }
    
    
    [countryCodeLbl adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    mobileTxt.leftViewMode = UITextFieldViewModeAlways;
    mobileTxt.leftView = countryCodeLbl;
    mobileTxt.borderStyle = UITextBorderStyleRoundedRect;
    [self.scrollView addSubview:mobileTxt];
    
    //Provider Config Source Selection View
    providerConfigSourceView = [[UIView alloc] initWithFrame:CGRectZero];
    providerConfigSourceView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:providerConfigSourceView];
    
    UILabel *providerConfigLbl = [[UILabel alloc] init];
    providerConfigLbl.translatesAutoresizingMaskIntoConstraints = NO;
    providerConfigLbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    providerConfigLbl.text = @"Provider Configuration";
    [providerConfigSourceView addSubview:providerConfigLbl];
    
    UILabel *servicePrflLbl = [[UILabel alloc] init];
    servicePrflLbl.translatesAutoresizingMaskIntoConstraints = NO;
    servicePrflLbl.font = [UIFont fontWithName:@"Helvetica" size:16];
    servicePrflLbl.text = @"Use from service profile";
    [providerConfigSourceView addSubview:servicePrflLbl];
    
    UILabel *providerSpfcLbl = [[UILabel alloc] init];
    providerSpfcLbl.translatesAutoresizingMaskIntoConstraints = NO;
    providerSpfcLbl.font = [UIFont fontWithName:@"Helvetica" size:16];
    providerSpfcLbl.text = @"Provider specific";
    providerSpfcLbl.textAlignment = NSTextAlignmentRight;
    [providerConfigSourceView addSubview:providerSpfcLbl];
    
    servicePrflRadioView = [[UIImageView alloc] init];
    servicePrflRadioView.translatesAutoresizingMaskIntoConstraints = NO;
    servicePrflRadioView.userInteractionEnabled = YES;
    servicePrflRadioView.highlighted = YES;
    servicePrflRadioView.image = [UIImage imageNamed:@"radio.png"];
    servicePrflRadioView.highlightedImage = [UIImage imageNamed:@"radio_select.png"];
    [providerConfigSourceView addSubview:servicePrflRadioView];
    UITapGestureRecognizer *servicePrflRadioTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(providerConfigRadioTapped:)];
    [servicePrflRadioView addGestureRecognizer:servicePrflRadioTap];
    
    providerSpfcRadioView = [[UIImageView alloc] init];
    providerSpfcRadioView.translatesAutoresizingMaskIntoConstraints = NO;
    providerSpfcRadioView.userInteractionEnabled = YES;
    providerSpfcRadioView.image = [UIImage imageNamed:@"radio.png"];
    providerSpfcRadioView.highlightedImage = [UIImage imageNamed:@"radio_select.png"];
    [providerConfigSourceView addSubview:providerSpfcRadioView];
    UITapGestureRecognizer *providerSpfcRadioTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(providerConfigRadioTapped:)];
    [providerSpfcRadioView addGestureRecognizer:providerSpfcRadioTap];
    
    [providerConfigSourceView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[providerConfigLbl(30)][servicePrflLbl(30)][providerSpfcLbl(30)]|" options:0 metrics:nil views:@{@"providerConfigLbl":providerConfigLbl,@"servicePrflLbl":servicePrflLbl,@"providerSpfcLbl":providerSpfcLbl}]];
    [providerConfigSourceView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[providerConfigLbl(220)]" options:0 metrics:nil views:@{@"providerConfigLbl":providerConfigLbl}]];
    [providerConfigSourceView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[servicePrflLbl(170)]-30-[servicePrflRadio(30)]" options:0 metrics:nil views:@{@"servicePrflLbl":servicePrflLbl,@"servicePrflRadio":servicePrflRadioView}]];
    [providerConfigSourceView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[providerSpfcLbl(170)]-30-[providerSpfcRadio(30)]" options:0 metrics:nil views:@{@"providerSpfcLbl":providerSpfcLbl,@"providerSpfcRadio":providerSpfcRadioView}]];
    [providerConfigSourceView addConstraint:[NSLayoutConstraint constraintWithItem:servicePrflRadioView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:servicePrflLbl attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [providerConfigSourceView addConstraint:[NSLayoutConstraint constraintWithItem:providerSpfcRadioView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:providerSpfcLbl attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    // speciality View
    specialityView = [[UIView alloc]initWithFrame:CGRectZero];
    specialityView.translatesAutoresizingMaskIntoConstraints = NO;
    specialityView.layer.borderWidth = 0.5;
    specialityView.layer.cornerRadius = 5;
    specialityView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    specialityView.backgroundColor = kProfileRowBackColor;
    [self.scrollView addSubview:specialityView];
    
    specialitiesLbl = [[MSALabel alloc]initWithFrame:CGRectZero];
    specialitiesLbl.translatesAutoresizingMaskIntoConstraints = NO;
    specialitiesLbl.text = @"Choose Provider's Speciality(ies)";
    [specialitiesLbl adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    [specialityView addSubview:specialitiesLbl];
    
    specialitiesCountLbl = [[MSALabel alloc]initWithFrame:CGRectZero];
    specialitiesCountLbl.translatesAutoresizingMaskIntoConstraints = NO;
    specialitiesCountLbl.textAlignment = NSTextAlignmentRight;
    [specialitiesCountLbl adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    [specialityView addSubview:specialitiesCountLbl];
    
    specialityAccessoryView = [[UIImageView alloc]initWithFrame:CGRectZero];
    specialityAccessoryView.translatesAutoresizingMaskIntoConstraints = NO;
    specialityAccessoryView.image = [UIImage imageNamed:@"rightArrow.png"];
    specialityAccessoryView.contentMode = UIViewContentModeScaleAspectFit;
    [specialityView addSubview:specialityAccessoryView];
    
    
    configView = [[UIView alloc]initWithFrame:CGRectZero];
    configView.translatesAutoresizingMaskIntoConstraints = NO;
    configView.layer.borderWidth = 0.5;
    configView.layer.cornerRadius = 5;
    configView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    configView.backgroundColor = kProfileRowBackColor;
    [self.scrollView addSubview:configView];
    
    
    configLbl =  [[MSALabel alloc]initWithFrame:CGRectZero];
    configLbl.translatesAutoresizingMaskIntoConstraints = NO;
    configLbl.text = @"Configuration";
    [configLbl adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    [configView addSubview:configLbl];
    
    configCountLbl = [[MSALabel alloc]initWithFrame:CGRectZero];
    configCountLbl.translatesAutoresizingMaskIntoConstraints = NO;
    configCountLbl.textAlignment = NSTextAlignmentRight;
    [configCountLbl adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    [configView addSubview:configCountLbl];
    
    configAccessoryView = [[UIImageView alloc]initWithFrame:CGRectZero];
    configAccessoryView.translatesAutoresizingMaskIntoConstraints = NO;
    configAccessoryView.image = [UIImage imageNamed:@"rightArrow.png"];
    configAccessoryView.contentMode = UIViewContentModeScaleAspectFit;
    [configView addSubview:configAccessoryView];
    
    specialityTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(specialityViewTapped:)];
    [specialityView addGestureRecognizer:specialityTap];
    
    configTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(configViewTapped:)];
    [configView addGestureRecognizer:configTap];
    
    self.continueBtn.backgroundColor = kMySchappMediumBlueColor;
    [self.continueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    self.continueBtn.layer.cornerRadius = 5.0;
    
    [self applyConstraints];
}

// Apply constraints
- (void)applyConstraints {
    
    NSDictionary *views = @{@"providerCategoryTxt":providerCategoryTxt,@"firstNameTxt":firstNameTxt,@"lastNameTxt":lastNameTxt,@"emailTxt":emailTxt,@"mobileTxt":mobileTxt,@"specialityView":specialityView,@"configView":configView,@"providerConfigSourceView":providerConfigSourceView};
    
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[providerCategoryTxt(45)]-10-[firstNameTxt(45)]-10-[lastNameTxt(45)]-10-[emailTxt(45)]-10-[mobileTxt(45)]-10-[providerConfigSourceView(90)]-10-[specialityView(45)]-10-[configView(45)]-10-|" options:0 metrics:nil views:views]];
    
    // Provider Category
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:providerCategoryTxt attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:0.90 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:providerCategoryTxt attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    // First Name
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:firstNameTxt attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:0.90 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:firstNameTxt attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    // Last Name
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:lastNameTxt attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:0.90 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:lastNameTxt attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    // email
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:emailTxt attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:0.90 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:emailTxt attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    // Mobile Text
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:mobileTxt attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:0.90 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:mobileTxt attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    // Provider Config Source View
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:providerConfigSourceView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:0.90 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:providerConfigSourceView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    //speciality view
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:specialityView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:0.90 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:specialityView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    NSDictionary *specialitiesViews = @{@"specialitiesCountLbl":specialitiesCountLbl,@"specialitiesLbl":specialitiesLbl,@"specialityAccessoryView":specialityAccessoryView};
    [specialityView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[specialitiesLbl]|" options:0 metrics:nil views:specialitiesViews]];
    [specialityView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[specialitiesLbl]" options:0 metrics:nil views:specialitiesViews]];
    [specialityView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[specialitiesCountLbl]-10-[specialityAccessoryView(12)]-|" options:0 metrics:nil views:specialitiesViews]];
    
    // lang Lbl
    [specialityView addConstraint:[NSLayoutConstraint constraintWithItem:specialitiesLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:specialityView attribute:NSLayoutAttributeWidth multiplier:0.30 constant:0]];
    
    
    // Speciality Text
    [specialityView addConstraint:[NSLayoutConstraint constraintWithItem:specialitiesCountLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:specialityView attribute:NSLayoutAttributeWidth multiplier:0.40 constant:0]];
    
    [specialityView addConstraint:[NSLayoutConstraint constraintWithItem:specialitiesCountLbl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:specialitiesLbl attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [specialityView addConstraint:[NSLayoutConstraint constraintWithItem:specialitiesCountLbl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:specialitiesLbl attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    
    
    // add cert Button
    [specialityView addConstraint:[NSLayoutConstraint constraintWithItem:specialityAccessoryView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20]];
    [specialityView addConstraint:[NSLayoutConstraint constraintWithItem:specialityAccessoryView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:specialitiesCountLbl attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    
    //education view
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:configView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:0.90 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:configView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    NSDictionary *configViews = @{@"configCountLbl":configCountLbl,@"configLbl":configLbl,@"configAccessoryView":configAccessoryView};
    [configView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[configLbl]|" options:0 metrics:nil views:configViews]];
    [configView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[configLbl]" options:0 metrics:nil views:configViews]];
    [configView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[configCountLbl]-10-[configAccessoryView(12)]-|" options:0 metrics:nil views:configViews]];
    
    
    // Cert Lbl
    [configView addConstraint:[NSLayoutConstraint constraintWithItem:configLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:configView attribute:NSLayoutAttributeWidth multiplier:0.30 constant:0]];
    
    // Cert Text
    [configView addConstraint:[NSLayoutConstraint constraintWithItem:configCountLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:configView attribute:NSLayoutAttributeWidth multiplier:0.40 constant:0]];
    [configView addConstraint:[NSLayoutConstraint constraintWithItem:configCountLbl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:configLbl attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [configView addConstraint:[NSLayoutConstraint constraintWithItem:configCountLbl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:configLbl attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    
    // add education Button
    [configView addConstraint:[NSLayoutConstraint constraintWithItem:configAccessoryView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20]];
    [configView addConstraint:[NSLayoutConstraint constraintWithItem:configAccessoryView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:configCountLbl attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
}

- (void)specialityViewTapped:(UITapGestureRecognizer *)recognizer
{
    MSASpecialitiesTableViewController *specialitiesVC = [[MSASpecialitiesTableViewController alloc]init];
    specialitiesVC.delegate = self;
//    if (![[personalDetails objectForKey:kProfileSelectedLanguages] isKindOfClass:[NSNull class]]) {
//        specialitiesVC.savedSpecialitiesArray = (NSArray *)[personalDetails objectForKey:kProfileSelectedLanguages];
//    }
    specialitiesVC.savedSpecialitiesArray = [NSMutableArray arrayWithObjects:@"Cardiac",@"Neuro",@"Physician", nil];
    [self.navigationController pushViewController:specialitiesVC animated:YES];
}

- (void)configViewTapped:(UITapGestureRecognizer *)recognizer
{
    
}

- (void)providerConfigRadioTapped:(UITapGestureRecognizer *)recognizer
{
    servicePrflRadioView.highlighted = NO;
    providerSpfcRadioView.highlighted = NO;
    UIImageView *selectedRadioImageView = (UIImageView *)recognizer.view;
    selectedRadioImageView.highlighted = YES;
}

- (void)setProviderCategory:(id)sender
{
    providerCategoryTxt.text = [providerCategories objectAtIndex:selectedIndex];
    [providerCategoryTxt resignFirstResponder];
}

- (void)resetProviderCategory:(id)sender
{
    [providerCategoryTxt resignFirstResponder];
}

#pragma mark - SpecialityDoneCancelDelegate

- (void)specialityDoneClickedWithValues:(NSArray *)newSpecialities
{
    
}

#pragma mark - UIPickerViewDatasource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return providerCategories.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [providerCategories objectAtIndex:row];
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedIndex = row;
}


@end
