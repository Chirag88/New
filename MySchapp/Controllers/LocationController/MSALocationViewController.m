//
//  MSALocationViewController.m
//  MySchapp
//
//  Created by M-Creative on 5/10/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSALocationViewController.h"
#import "MSAConstants.h"
#import "MSAUtils.h"
#import "MSALabel.h"

@interface MSALocationViewController ()
{
    NSInteger selectedIndex;
    MSALabel *countryLabel;
    MSALabel *addressLabel;
    UITextField *countryPickerTxt;
    UIPickerView *countryPicker;
    UITextField *addressLineTxt;
    MSALabel *showingResultLbl;
    UITableView *resultList;
    NSTimer *searchTimer;
}
//@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *countries;
@property (nonatomic, strong) NSMutableArray *searchResults;

@end

@implementation MSALocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchResults = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    MSANetworkHandler *networkHandler = [[MSANetworkHandler alloc] init];
    networkHandler.delegate = self;
    [networkHandler createRequestForURLString:[NSString stringWithFormat:@"%@%@",BASEURL,COUNTRYLISTURL] withIdentifier:@"countryList" requestHeaders:nil andRequestParameters:nil inView:self.view];
    [self createUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [MSAUtils setNavigationBarAttributes:self.navigationController];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = NO;
    self.navigationItem.title = @"Location";
}

// Create UI
- (void)createUI {
    
    //    self.scrollView = [[UIScrollView alloc] init];
    //    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    //    [self.view addSubview:self.scrollView];
    
    addressLabel = [[MSALabel alloc] init];
    addressLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [addressLabel setText:@"Address:"];
    [addressLabel adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    [self.view addSubview:addressLabel];
    
    countryLabel = [[MSALabel alloc] init];
    countryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [countryLabel setText:@"Country:"];
    [countryLabel adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    [self.view addSubview:countryLabel];
    
    addressLineTxt = [[UITextField alloc]initWithFrame:CGRectZero];
    addressLineTxt.translatesAutoresizingMaskIntoConstraints = NO;
    addressLineTxt.placeholder = @"Address";
    addressLineTxt.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:addressLineTxt];
    [addressLineTxt addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    
    countryPickerTxt = [[UITextField alloc]initWithFrame:CGRectZero];
    countryPickerTxt.translatesAutoresizingMaskIntoConstraints = NO;
    countryPickerTxt.placeholder = @"Select";
    countryPickerTxt.borderStyle = UITextBorderStyleRoundedRect;
    countryPickerTxt.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:countryPickerTxt];
    
    UIImageView *rightViewCountryImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 20, 12)];
    rightViewCountryImg.image = [UIImage imageNamed:@"dropArrow.png"];
    rightViewCountryImg.contentMode = UIViewContentModeScaleAspectFit;
    UIView *rightViewCountry = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightViewCountry addSubview:rightViewCountryImg];
    countryPickerTxt.rightView = rightViewCountry;
    countryPickerTxt.rightViewMode = UITextFieldViewModeAlways;
    
    // Adding PickerView
    countryPicker = [[UIPickerView alloc] init];
    countryPicker.dataSource = self;
    countryPicker.delegate = self;
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,44)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                      style:UIBarButtonItemStyleBordered target:self action:@selector(setCountry:)];
    UIBarButtonItem *barButtonCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                        style:UIBarButtonItemStyleBordered target:self action:@selector(resetCountry:)];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    toolBar.items = @[barButtonCancel,flex,barButtonDone];
    barButtonDone.tintColor=[UIColor blackColor];
    countryPickerTxt.inputAccessoryView = toolBar;
    countryPickerTxt.delegate = self;
    countryPickerTxt.inputView = countryPicker;
    
    showingResultLbl = [[MSALabel alloc] init];
    showingResultLbl.translatesAutoresizingMaskIntoConstraints = NO;
    showingResultLbl.text = @"Showing 10 results";
    [showingResultLbl adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    [self.view addSubview:showingResultLbl];
    
    resultList = [[UITableView alloc] init];
    resultList.translatesAutoresizingMaskIntoConstraints = NO;
    resultList.dataSource = self;
    resultList.delegate = self;
    [self.view addSubview:resultList];
    
    [self applyConstraints];
}

// Apply constraints
- (void)applyConstraints {
    
    //    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[scroll]-0-|" options:0 metrics:nil views:@{@"scroll":self.scrollView}]];
    //    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[scroll]-0-|" options:0 metrics:nil views:@{@"scroll":self.scrollView}]];
    
    //    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    //    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[country(45)]-10-[address(45)]-10-[showingMsg(25)]-10-[resultList(>=150)]-|" options:0 metrics:nil views:@{@"country":countryPickerTxt,@"address":addressLineTxt,@"showingMsg":showingResultLbl,@"resultList":resultList}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[countryLbl(45)]-10-[addressLbl(45)]" options:0 metrics:nil views:@{@"countryLbl":countryLabel,@"addressLbl":addressLabel}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[countryLbl(70)]-30-[country]-20-|" options:0 metrics:nil views:@{@"countryLbl":countryLabel,@"country":countryPickerTxt}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[addressLbl(70)]-30-[address]-20-|" options:0 metrics:nil views:@{@"addressLbl":addressLabel,@"address":addressLineTxt}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[resultList]-10-|" options:0 metrics:nil views:@{@"resultList":resultList}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[showingMsg]-10-|" options:0 metrics:nil views:@{@"showingMsg":showingResultLbl}]];
    
}

- (void)loadSearchResults:(NSDictionary *)results
{
    [self.searchResults addObjectsFromArray:[results valueForKey:@"postalCityVOs"]];
    [resultList reloadData];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *localName = [[self.searchResults objectAtIndex:indexPath.row] valueForKey:@"localname"];
    NSString *city = [[self.searchResults objectAtIndex:indexPath.row] valueForKey:@"city"];
    NSString *zipcode = [[self.searchResults objectAtIndex:indexPath.row] valueForKey:@"zipcode"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@,%@,%@",localName,city,zipcode];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableCell = [tableView cellForRowAtIndexPath:indexPath];
    [self.delegate didSelectedLocation:tableCell.textLabel.text];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -Selector Methods

- (void)setCountry:(id)sender {
    countryPickerTxt.text = [[self.countries objectAtIndex:selectedIndex] valueForKey:@"name"];
    [countryPickerTxt resignFirstResponder];
}

- (void)resetCountry:(id)sender {
    [countryPickerTxt resignFirstResponder];
}

- (void)searchAddress:(id)sender
{
    if(![countryPickerTxt.text isEqualToString:@""])
    {
        NSDictionary *requestJSON = [[NSDictionary alloc] initWithObjectsAndKeys:[[self.countries objectAtIndex:selectedIndex] valueForKey:@"code"],@"countryCode",addressLineTxt.text,@"searchtext",@"0",@"offset", nil];
        MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
        networkHanlder.delegate = self;
        [networkHanlder createRequestForURLString:[NSString stringWithFormat:@"%@%@",BASEURL,ADDRESSSEARCHURL] withIdentifier:@"search" requestHeaders:nil andRequestParameters:requestJSON inView:self.view];
    }
    else
    {
        [MSAUtils showAlertWithTitle:@"" message:@"Select the country first" cancelButton:@"OK" otherButton:nil delegate:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField text change notification

- (void)textChanged:(id)sender
{
    UITextField *txtfld = (UITextField *)sender;
    if(![txtfld.text isEqualToString:@""] && txtfld.text.length >= 3) {
        [searchTimer invalidate];
        searchTimer = nil;
        searchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(searchAddress:) userInfo:txtfld.text repeats:NO];
    }
    else {
        
    }
}

#pragma mark - UIPickerViewDatasource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.countries.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[self.countries objectAtIndex:row] valueForKey:@"name"];
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedIndex = row;
}

#pragma mark - MSANetworkDelegate

- (void)didReceiveData:(NSData *)responseData forRequest:(NSString *)requestId
{
    NSError* err;
    if([requestId isEqualToString:@"countryList"]) {
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&err];
        NSLog(@"RESP : %@",responseDict);
        self.countries = [responseDict valueForKey:@"countryList"];
        [countryPicker reloadAllComponents];
    }
    else if([requestId isEqualToString:@"search"])
    {
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&err];
        NSLog(@"RESPSEARCH : %@",responseDict);
        [self loadSearchResults:responseDict];
    }
}

- (void)didFailWithError:(NSError *)error forRequest:(NSString *)requestId
{
    NSLog(@"fail");
}

#pragma mark - touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [addressLineTxt resignFirstResponder];
}

@end
