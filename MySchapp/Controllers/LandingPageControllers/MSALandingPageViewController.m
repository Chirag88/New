//
//  MSALandingPageViewController.m
//  MySchapp
//
//  Created by CK-Dev on 23/02/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSALandingPageViewController.h"
#import "MSASplashViewController.h"
#import "MSAConstants.h"
#import "MSALoginViewController.h"
#import "MSASignupViewController.h"
#import "MSASubCategoryViewController.h"
#import "MSAUtils.h"
#import "MSALocationHelper.h"
#import "MSAPersonalViewController.h"
#import "MSASecurityViewController.h"
#import "MSANotificationViewController.h"
#import "MSALoginDecision.h"
#import "MSALocationViewController.h"
#import "MSALabel.h"
#import "MSATermsConditionViewController.h"
#import "MSAPrivacyPolicyViewController.h"
#import "MSALocationListViewController.h"
#import "MSAMySchappProfileVC.h"
#import "MSAServiceProfileVC.h"


#define xGap 15
#define ICONS_IMAGES [NSArray arrayWithObjects:@"icon_healthcare.png",@"icon_education.png",@"icon_fitness.png",@"icon_Finance.png",@"icon_Yoga.png",@"icon_Legal.png",@"icon_Household.png",@"icon_RealEstate.png",@"icon_Professional.png",@"icon_FoodEntertainment.png",@"icon_PersonalCare.png",@"icon_Automotive.png",@"icon_PetServices.png",@"icon_LeisureTravel.png",@"icon_EventManagement.png",nil]
#define TRAY_ICONS_IMAGES [NSArray arrayWithObjects:@"icon_tr_healthcare.png",@"icon_tr_education.png",@"icon_tr_fitness.png",@"icon_tr_Finance.png",@"icon_tr_Yoga.png",@"icon_tr_Legal.png",@"icon_tr_Household.png",@"icon_tr_RealEstate.png",@"icon_tr_Professional.png",@"icon_tr_FoodEntertainment.png",@"icon_tr_PersonalCare.png",@"icon_tr_Automotive.png",@"icon_tr_PetServices.png",@"icon_tr_LeisureTravel.png",@"icon_tr_EventManagement.png",nil]
@interface MSALandingPageViewController ()<LoginSignupDismissHandler,LoginDecisionDelegate>
{
    UIView *navView;
    UIView *midView;
    UIView *loginSignupView;
    UIView *menuView;
    iCarousel *categoryView;
    NSLayoutConstraint *loginSignupViewHeight;
    UIView *navMenuView;
    UITableView *menuList;
    NSMutableArray *menuItems;
    NSMutableArray *tableItems;
    UIButton *backButton;
    MSALabel *locationLabel;
    NSArray *distancePickerValues;
    UITextField *distanceField;
    MSASearchViewController *objSearchVC;
    NSInteger selectedPickerIndex;
}

@property (nonatomic, strong) NSMutableArray *categories;

- (IBAction)loginClicked:(id)sender;
- (IBAction)signupClicked:(id)sender;

@end

@implementation MSALandingPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
    networkHanlder.delegate = self;
    [networkHanlder createRequestForURLString:[NSString stringWithFormat:@"%@%@",BASEURL,CATURL] withIdentifier:@"Category" requestHeaders:nil andRequestParameters:nil inView:self.view];
    
    MSALocationHelper *locationDetail = [MSALocationHelper sharedInstance];
    [locationDetail addObserver:self forKeyPath:@"address" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    // Do any additional setup after loading the view.
    distancePickerValues = @[@"5 Miles",@"10 Miles",@"15 Miles",@"20 Miles",@"25 Miles"];
    self.categories = [[NSMutableArray alloc] init];
    [self designLandingPage];
    //[self designMenu];
    menuItems = [[NSMutableArray alloc] init];
    tableItems = menuItems;
     
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.hidesBackButton = YES;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *profStat = [userDefaults valueForKey:kDefaultsProfileStatus];
    if([profStat isEqualToString:@"PC"]) {
        objSearchVC.menuBtnConstraint.constant = 30;
        [objSearchVC.view updateConstraintsIfNeeded];
        loginSignupViewHeight.constant = 0;
        [self.view updateConstraintsIfNeeded];
    }
    else {
        objSearchVC.menuBtnConstraint.constant = 0;
        [objSearchVC.view updateConstraintsIfNeeded];
        loginSignupViewHeight.constant = 60;
        [self.view updateConstraintsIfNeeded];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([[touches anyObject] view] == menuView) {
        [self designMenu];
    }
}

- (void)designMenu
{
    if(!menuView)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *role = [userDefaults valueForKey:kDefaultsUserRole];
        
        NSError* err;
        NSData *fileData = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu" ofType:@"json"]];
        NSDictionary *menuJSON = [NSJSONSerialization JSONObjectWithData:fileData options:0 error:&err];
        menuItems = [menuJSON valueForKey:role];
        tableItems = menuItems;
        
        menuView = [[UIView alloc] init];
        menuView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        menuView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:menuView];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[menu]|" options:0 metrics:nil views:@{@"menu":menuView}]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[menu]|" options:0 metrics:nil views:@{@"menu":menuView}]];
        
        navMenuView = [[UIView alloc] init];
        navMenuView.backgroundColor = [UIColor colorWithRed:6.0/255.0 green:29.0/255.0 blue:73.0/255.0 alpha:1];
        navMenuView.translatesAutoresizingMaskIntoConstraints = NO;
        [menuView addSubview:navMenuView];
        [menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[navMenu(200)]" options:0 metrics:nil views:@{@"navMenu":navMenuView}]];
        
        backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        backButton.translatesAutoresizingMaskIntoConstraints = NO;
        [backButton setTitle:@"Back" forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [navMenuView addSubview:backButton];
        [backButton addTarget:self action:@selector(goBackFromSubMenu:) forControlEvents:UIControlEventTouchUpInside];
        [navMenuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[back(80)]" options:0 metrics:nil views:@{@"back":backButton}]];
        [navMenuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[back]|" options:0 metrics:nil views:@{@"back":backButton}]];
        
        UIButton *drawerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        drawerBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [drawerBtn setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
        [drawerBtn addTarget:self action:@selector(menuClicked:) forControlEvents:UIControlEventTouchUpInside];
        [navMenuView addSubview:drawerBtn];
        [navMenuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[menu(30)]-5-|" options:0 metrics:nil views:@{@"menu":drawerBtn}]];
        [navMenuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[menu(20)]" options:0 metrics:nil views:@{@"menu":drawerBtn}]];
        [navMenuView addConstraint:[NSLayoutConstraint constraintWithItem:drawerBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:navMenuView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
        menuList = [[UITableView alloc] init];
        menuList.dataSource = self;
        menuList.delegate = self;
        menuList.translatesAutoresizingMaskIntoConstraints = NO;
        [menuView addSubview:menuList];
        [menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[menuList(200)]" options:0 metrics:nil views:@{@"menuList":menuList}]];
        [menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[navMenu(44)][menuList]|" options:0 metrics:nil views:@{@"menuList":menuList,@"navMenu":navMenuView}]];
    }
    else
    {
        [menuView removeFromSuperview];
        menuView = nil;
    }
}

- (void)cancelTouched:(UIBarButtonItem *)sender
{
    selectedPickerIndex = 0;
    [distanceField resignFirstResponder];
}

- (void)doneTouched:(UIBarButtonItem *)sender
{
    distanceField.text = [NSString stringWithFormat:@" %@",[distancePickerValues objectAtIndex:selectedPickerIndex]];
    [distanceField resignFirstResponder];
}

- (void)goBackFromSubMenu:(id)sender
{
    tableItems = menuItems;
    [menuList reloadData];
    backButton.hidden = YES;
}

- (void)removeMenuView:(id)sender
{
//    [menuView removeFromSuperview];
//    menuView = nil;
}

- (void)designLandingPage
{
    navView = [[UIView alloc] init];
    navView.translatesAutoresizingMaskIntoConstraints = NO;
    navView.backgroundColor = [UIColor colorWithRed:6.0/255.0 green:29.0/255.0 blue:73.0/255.0 alpha:1];
    midView = [[UIView alloc] init];
    midView.translatesAutoresizingMaskIntoConstraints = NO;
    loginSignupView = [[UIView alloc] init];
    loginSignupView.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:233.0/255.0 blue:232.0/255.0 alpha:1];
    loginSignupView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:navView];
    [self.view addSubview:midView];
    [self.view addSubview:loginSignupView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[navView]|" options:0 metrics:nil views:@{@"navView":navView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[midView]|" options:0 metrics:nil views:@{@"midView":midView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[loginSignupView]|" options:0 metrics:nil views:@{@"loginSignupView":loginSignupView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[navView(44)][midView]-[loginSignupView]|" options:0 metrics:nil views:@{@"navView":navView,@"midView":midView,@"loginSignupView":loginSignupView}]];
    loginSignupViewHeight = [NSLayoutConstraint constraintWithItem:loginSignupView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:60];
    [self.view addConstraint:loginSignupViewHeight];
    
    [self designNavigationView];
    [self designMiddleView];
    [self designLoginSignupView];
}
- (void)designNavigationView
{
    objSearchVC = [[MSASearchViewController alloc] init];
    objSearchVC.delegate = self;
    objSearchVC.menuDelegate = self;
    objSearchVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 64);
    
    [self.view addSubview:objSearchVC.view];
    
}
- (void)designMiddleView
{
    //label
    MSALabel *infoLabel = [[MSALabel alloc] init];
    infoLabel.text = @"Find providers for a service category near you, check availability and request for appointments";
    infoLabel.numberOfLines = 3;
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [infoLabel adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    [midView addSubview:infoLabel];
    //image
    UIImageView *infoImg = [[UIImageView alloc] init];
    infoImg.image = [UIImage imageNamed:@"secure&free.png"];
    infoImg.translatesAutoresizingMaskIntoConstraints = NO;
    infoImg.contentMode = UIViewContentModeScaleAspectFit;
    [midView addSubview:infoImg];
    //carousel
    categoryView = [[iCarousel alloc] init];
    categoryView.type = 0;
    categoryView.dataSource = self;
    categoryView.delegate = self;
    categoryView.backgroundColor = [UIColor colorWithRed:206/255.0 green:231.0/255.0 blue:246.0/255.0 alpha:1];
    categoryView.translatesAutoresizingMaskIntoConstraints = NO;
    [midView addSubview:categoryView];
    //label
    MSALabel *distanceLabel = [[MSALabel alloc] init];
    distanceLabel.text = @"Search with in";
    [distanceLabel adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    distanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [midView addSubview:distanceLabel];
    //textfield
    UIPickerView *distanceInputView = [[UIPickerView alloc] init];
    distanceInputView.dataSource = self;
    distanceInputView.delegate = self;
    distanceField = [[UITextField alloc] init];
    distanceField.text = @" 10 Miles";
    distanceField.layer.borderWidth = 1;
    distanceField.layer.cornerRadius = 10;
    distanceField.inputView = distanceInputView;
    distanceField.translatesAutoresizingMaskIntoConstraints = NO;
    [midView addSubview:distanceField];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-150-44, self.view.frame.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouched:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTouched:)];
    [toolBar setItems:[NSArray arrayWithObjects:cancelButton, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneButton, nil]];
    distanceField.inputAccessoryView = toolBar;
    //label
    locationLabel = [[MSALabel alloc] init];
    locationLabel.text = @"of location";
    locationLabel.numberOfLines = 3;
    [locationLabel adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    locationLabel.textAlignment = NSTextAlignmentCenter;
    locationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    locationLabel.textColor = kUrlFontColor;
    UITapGestureRecognizer *locationTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeLocation:)];
    locationTap.numberOfTapsRequired = 1;
    [locationLabel addGestureRecognizer:locationTap];
    locationLabel.userInteractionEnabled = YES;
    [midView addSubview:locationLabel];
    
    //button
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    searchButton.backgroundColor = [UIColor blueColor];
    [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchButton setTitle:@"Search" forState:UIControlStateNormal];
    searchButton.translatesAutoresizingMaskIntoConstraints = NO;
    [searchButton addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    //[midView addSubview:searchButton];
    
    [midView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[infoLabel]-%f-|",self.view.frame.size.width*0.05,self.view.frame.size.width*0.05] options:0 metrics:nil views:@{@"infoLabel":infoLabel}]];
    [midView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[infoImg]-%f-|",self.view.frame.size.width*0.2,self.view.frame.size.width*0.2] options:0 metrics:nil views:@{@"infoImg":infoImg}]];
    [midView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[category]|" options:0 metrics:nil views:@{@"category":categoryView}]];
    [midView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[distanceLabel]-%f-|",self.view.frame.size.width*0.05,self.view.frame.size.width*0.05] options:0 metrics:nil views:@{@"distanceLabel":distanceLabel}]];
    [midView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[distanceField]-%f-|",self.view.frame.size.width*0.05,self.view.frame.size.width*0.05] options:0 metrics:nil views:@{@"distanceField":distanceField}]];
    [midView addConstraint:[NSLayoutConstraint constraintWithItem:locationLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:midView attribute:NSLayoutAttributeWidth multiplier:0.75 constant:0]];
    [midView addConstraint:[NSLayoutConstraint constraintWithItem:locationLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:midView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
   // [midView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[searchButton]-%f-|",self.view.frame.size.width*0.05,self.view.frame.size.width*0.05] options:0 metrics:nil views:@{@"searchButton":searchButton}]];
    [midView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[infoLabel(70)]-15-[infoImg(50)]-15-[category(130)]-20-[distanceLabel(20)]-5-[distanceField(42)]-10-[locationLabel(>=50)]-(>=5)-|" options:0 metrics:nil views:@{@"infoLabel":infoLabel,@"infoImg":infoImg,@"category":categoryView,@"distanceLabel":distanceLabel,@"distanceField":distanceField,@"locationLabel":locationLabel,@"searchButton":searchButton}]];
    
}
- (void)designLoginSignupView
{
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    loginButton.translatesAutoresizingMaskIntoConstraints = NO;
    [loginButton addTarget:self action:@selector(loginClicked:) forControlEvents:UIControlEventTouchUpInside];
    [loginSignupView addSubview:loginButton];
    UIButton *signupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [signupButton setTitle:@"Signup" forState:UIControlStateNormal];
    signupButton.translatesAutoresizingMaskIntoConstraints = NO;
    [signupButton addTarget:self action:@selector(signupClicked:) forControlEvents:UIControlEventTouchUpInside];
    [loginSignupView addSubview:signupButton];
    [loginSignupView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[login(80)]-(>=10)-[signup(80)]-%f-|",self.view.frame.size.width/10,self.view.frame.size.width/10] options:0 metrics:nil views:@{@"login":loginButton,@"signup":signupButton}]];
    [loginSignupView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[login(45)]" options:0 metrics:nil views:@{@"login":loginButton}]];
    [loginSignupView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[signup(45)]" options:0 metrics:nil views:@{@"signup":signupButton}]];
}

- (void)search:(id)sender
{
    
}

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"country"]) {
        NSLog(@"The name of the child was changed.");
        NSLog(@"%@", change);
    }
    
    if ([keyPath isEqualToString:@"address"]) {
        NSLog(@"The address of the child was changed.");
        NSLog(@"%@", change);
        locationLabel.text = [change valueForKey:@"new"];
    }
    
}

#pragma mark - SearchResultCallbackDelegate

-(void)expandSearchResultView:(BOOL)expand
{
    if(expand) {
        objSearchVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view bringSubviewToFront:objSearchVC.view];
    }
    else {
        
        objSearchVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 64);
    }
}

#pragma mark - MenuButtonDelegate

- (void)showMenu:(id)sender
{
    [self menuClicked:sender];
}


#pragma mark - LoginDecision Delegate
- (void)redirectToPage:(NSString *)pageToBeOpened {
    
    if ([pageToBeOpened isEqualToString:@"LogoutService"]) {
        NSString *urlString = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%@",BASEURL,LOGOUTURL]];
        MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
        networkHanlder.delegate = self;
        NSDictionary *reqHeadDict = @{@"Authorization":[NSString stringWithFormat:@"bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:kAccessToken]]};
        [networkHanlder createRequestForURLString:urlString withIdentifier:@"LogoutService" requestHeaders:reqHeadDict andRequestParameters:nil inView:self.view];
    }
    else if ([pageToBeOpened isEqualToString:kLoginScreen]) {
        [self designMenu];
        UIStoryboard *mainStoryboard = UISTORYBOARD;
        MSALoginViewController *controller = (MSALoginViewController*)[mainStoryboard
                                                                       instantiateViewControllerWithIdentifier: @"LoginViewController"];
        
        controller.loginDelegate = self;
        UINavigationController *navLoginController = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:navLoginController animated:YES completion:nil];
    }
    
}

#pragma mark - MSANetworkDelegate

- (void)didReceiveData:(NSData *)responseData forRequest:(NSString *)requestId
{
    //received response comes here
    NSError* err;
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&err];
    NSLog(@"%@",responseDict);
    if ([[responseDict objectForKey:@"rCode"] isEqualToString:@"00"] &&[requestId isEqualToString:@"LogoutService"]) {
        // remove all keys
        [MSAUtils resetDefaults];
        [self designMenu];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *profStat = [userDefaults valueForKey:kDefaultsProfileStatus];
        if([profStat isEqualToString:@"PC"]) {
            objSearchVC.menuBtnConstraint.constant = 30;
            [objSearchVC.view updateConstraintsIfNeeded];
            loginSignupViewHeight.constant = 0;
            [self.view updateConstraintsIfNeeded];
        }
        else {
            objSearchVC.menuBtnConstraint.constant = 0;
            [objSearchVC.view updateConstraintsIfNeeded];
            loginSignupViewHeight.constant = 80;
            [self.view updateConstraintsIfNeeded];
            
        }

    }
    else if ([[responseDict objectForKey:@"rCode"] isEqualToString:@"00"] && [requestId isEqualToString:@"Category"]) {
        self.categories = [responseDict valueForKey:@"categories"];
        [categoryView reloadData];
        [categoryView scrollToItemAtIndex:1 animated:YES];
    }
    else {
        UIAlertView *alert  = [[UIAlertView alloc]initWithTitle:@"Message" message:[responseDict objectForKey:@"rMsg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] ;
        [alert show];
    }
}

- (void)didFailWithError:(NSError *)error forRequest:(NSString *)requestId
{
    [MSAUtils showAlertWithTitle:kAlertMessageTitle message:kAlertInternalErrorMsg cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
    //[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIPickerViewDatasource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [distancePickerValues count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [distancePickerValues objectAtIndex:row];
}

#pragma mark - UIPickerViewDelegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedPickerIndex = row;
//    distanceField.text = [NSString stringWithFormat:@" %@",[distancePickerValues objectAtIndex:row]];
}

#pragma mark - UITableViewDatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MSAComparePlanTableViewCell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = [[tableItems objectAtIndex:indexPath.row] valueForKey:@"item"];
    NSArray *subItems = [[tableItems objectAtIndex:indexPath.row] valueForKey:@"subItems"];
    if([subItems count] > 0)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *subItems = [[tableItems objectAtIndex:indexPath.row] valueForKey:@"subItems"];
    if([subItems count] > 0)
    {
        tableItems = subItems;
        [menuList reloadData];
        backButton.hidden = NO;
    }
    else
    {
        //open the related page
        [self didSelectMenu:[[tableItems objectAtIndex:indexPath.row] valueForKey:@"item"]];
    }
}

#pragma mark - iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.categories.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    NSDictionary *detail = [self.categories objectAtIndex:index];
    NSString *image = [ICONS_IMAGES objectAtIndex:index];//@"icon_health1.png";//[detail valueForKey:@"icon"];
    NSString *title = [detail valueForKey:@"name"];
    
    UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 65+2*xGap, categoryView.frame.size.height)];
    
    UIImageView *itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xGap/2, 5, 65, categoryView.frame.size.height-50-5*2)];
    UIImage *itemImage = [UIImage imageNamed:image];
    itemImageView.image = itemImage;
    itemImageView.userInteractionEnabled = YES;
    itemImageView.contentMode = UIViewContentModeScaleAspectFit;
    [itemView addSubview:itemImageView];
    
    MSALabel *aLabel = [[MSALabel alloc] initWithFrame:CGRectMake(0, categoryView.frame.size.height-50, 65+xGap, 50)];
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.textColor = [UIColor blackColor];
    aLabel.textAlignment = NSTextAlignmentCenter;
    [aLabel adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    aLabel.text = title;
    aLabel.numberOfLines = 2;
    [aLabel adjustFontSizeAccToScreenWidth:[UIFont fontWithName:@"Helvetica" size:13]];
    [itemView addSubview:aLabel];
    
    return itemView;
    
}

- (void)carouselWillBeginDragging:(iCarousel *)carousel
{
    // DLog(@"Carousel will begin dragging");
    
}

- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate
{
    //DLog(@"Carousel did end dragging and %@ decelerate", decelerate? @"will": @"won't");
}

- (void)carouselWillBeginDecelerating:(iCarousel *)carousel
{
    //DLog(@"Carousel will begin decelerating");
}

- (void)carouselDidEndDecelerating:(iCarousel *)carousel
{
    // DLog(@"Carousel did end decelerating");
}

- (void)carouselWillBeginScrollingAnimation:(iCarousel *)carousel
{
    //DLog(@"Carousel will begin scrolling");
}

//- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
//{
//    // DLog(@"Carousel did end scrolling%ld",(long)carousel.currentItemIndex);
//    // Update the page control
//    self.pageControl.currentPage = [self.carousel currentItemIndex];
//    
//}

- (BOOL)carousel:(iCarousel *)carousel shouldSelectItemAtIndex:(NSInteger)index
{
    if (index == carousel.currentItemIndex)
    {
        // DLog(@"Should select current item");
    }
    else
    {
        //DLog(@"Should select item number %li", (long)index);
    }
    return YES;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    NSDictionary *detail = [self.categories objectAtIndex:index];
    //navigate to the sub category
    MSASubCategoryViewController *subCatController = [[MSASubCategoryViewController alloc] init];
    subCatController.categoryDetail = detail;
    subCatController.subCatDelegate = self;
    subCatController.catIconImage = [UIImage imageNamed:[TRAY_ICONS_IMAGES objectAtIndex:index]];
    [self.navigationController pushViewController:subCatController animated:YES];
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return NO;
        }
        default:
        {
            return value;
        }
    }
}

#pragma mark - SubCatDelegate

- (void)didSelectSubCategory:(NSString *)subCatId
{
    [MSAUtils showAlertWithTitle:@"Message" message:@"Feature not implemented" cancelButton:@"OK" otherButton:nil delegate:nil];
}

- (void)didSelectMenu:(NSString *)menuId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([menuId isEqualToString:@"Personal Details"])
    {
        UIStoryboard *mainStoryboard = UISTORYBOARD;
        
        MSAPersonalViewController *controller = (MSAPersonalViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"MSAPersonalViewController"];
    
        controller.isComingFromMenu = YES;
        controller.selectedPlanName = [defaults valueForKey:kDefaultsPName];
        controller.selectedPlanId = [defaults valueForKey:kDefaultsPID];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if([menuId isEqualToString:@"Security"])
    {
        UIStoryboard *mainStoryboard = UISTORYBOARD;
        
        MSASecurityViewController *controller = (MSASecurityViewController*)[mainStoryboard
                                                                             instantiateViewControllerWithIdentifier:@"MSASecurityViewController"];
        controller.isComingFromMenu = YES;
        controller.selectedPlanName = [defaults valueForKey:kDefaultsPName];
        controller.selectedPlanId = [defaults valueForKey:kDefaultsPID];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if([menuId isEqualToString:@"Notifications"])
    {
        UIStoryboard *mainStoryboard = UISTORYBOARD;
        
        MSANotificationViewController *controller = (MSANotificationViewController*)[mainStoryboard
                                                                                     instantiateViewControllerWithIdentifier:@"MSANotificationViewController"];
        
        controller.isComingFromMenu = YES;
        controller.selectedPlanName = [defaults valueForKey:kDefaultsPName];
        controller.selectedPlanId = [defaults valueForKey:kDefaultsPID];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if([menuId isEqualToString:@"Logout"])
    {
        MSALoginDecision *loginDecision = [[MSALoginDecision alloc]init];
        loginDecision.delegate = self;
        [loginDecision checkTokensValidityWithRequestID:@"LogoutService"];
        
    }
    else if([menuId isEqualToString:@"Terms of service"])
    {
        UIStoryboard *mainStoryboard = UISTORYBOARD;
        MSATermsConditionViewController *termsVC  = (MSATermsConditionViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"MSATermsConditionViewController"];
        [self.navigationController pushViewController:termsVC animated:YES];
        
    }
    else if([menuId isEqualToString:@"Privacy Policy"])
    {
        UIStoryboard *mainStoryboard = UISTORYBOARD;
        MSAPrivacyPolicyViewController *privacyVC  = (MSAPrivacyPolicyViewController*)[mainStoryboard
                                                                                       instantiateViewControllerWithIdentifier:@"MSAPrivacyPolicyViewController"];
        [self.navigationController pushViewController:privacyVC animated:YES];
      
    }
    else if([menuId isEqualToString:@"Work Location"])
    {
        if(true) {
            UIStoryboard *mainStoryboard = UISTORYBOARD;
            MSAMySchappProfileVC *profile  = (MSAMySchappProfileVC*)[mainStoryboard
                                                                                 instantiateViewControllerWithIdentifier:@"MSAMySchappProfileVC"];
            [self.navigationController pushViewController:profile animated:YES];
        }
        else {
            
            MSALocationListViewController *addLocation  = [[MSALocationListViewController alloc]init];
            [self.navigationController pushViewController:addLocation animated:YES];

        }
        
    }
    else if([menuId isEqualToString:@"Service Profile"])
    {
        UIStoryboard *mainStoryboard = UISTORYBOARD;

        if(true) {
            MSAMySchappProfileVC *profile  = (MSAMySchappProfileVC*)[mainStoryboard
                                                                     instantiateViewControllerWithIdentifier:@"MSAMySchappProfileVC"];
            [self.navigationController pushViewController:profile animated:YES];
        }
        else {
            
            MSAServiceProfileVC *serviceProfile  = (MSAServiceProfileVC*)[mainStoryboard
                                                                   instantiateViewControllerWithIdentifier:@"MSAServiceProfileVC"];
            [self.navigationController pushViewController:serviceProfile animated:YES];
        }

        
    }
    else
    {
        [MSAUtils showAlertWithTitle:@"Message" message:@"Feature not implemented" cancelButton:@"OK" otherButton:nil delegate:nil];
    }
}

#pragma mark - LocationChangeDelegate

- (void)didSelectedLocation:(NSString *)location
{
    locationLabel.text = location;
}

#pragma mark - IBAction
- (IBAction)loginClicked:(id)sender {
    
    UIStoryboard *mainStoryboard = UISTORYBOARD;
    MSALoginViewController *controller = (MSALoginViewController*)[mainStoryboard
                                                                      instantiateViewControllerWithIdentifier: @"LoginViewController"];
    
    controller.loginDelegate = self;
    UINavigationController *navLoginController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navLoginController animated:YES completion:nil];
    
    
}

- (IBAction)signupClicked:(id)sender {
    
    UIStoryboard *mainStoryboard = UISTORYBOARD;
    
    
    MSASignupViewController *controller = (MSASignupViewController*)[mainStoryboard
                                                                     instantiateViewControllerWithIdentifier: @"SignupViewController"];
    
    controller.signupDelegate = self;
    UINavigationController *navSignupController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navSignupController animated:YES completion:nil];

}

- (void)menuClicked:(id)sender
{
    [self designMenu];
    backButton.hidden = YES;
}

-(void)controllerGotDissmissed:(UIViewController *)controller {
    if ([controller isKindOfClass:[MSALoginViewController class]]) {
        [controller dismissViewControllerAnimated:NO completion:nil];
        [self signupClicked:nil];
    }
    else if ([controller isKindOfClass:[MSASignupViewController class]]) {
        [controller dismissViewControllerAnimated:NO completion:nil];
        [self loginClicked:nil];
    }
    
    
}

#pragma mark Selector Methods 
- (void)changeLocation:(id)sender {
    // open location page
    NSLog(@"open location page");
    MSALocationViewController *locationController = [[MSALocationViewController alloc] init];
    locationController.delegate = self;
    [self.navigationController pushViewController:locationController animated:YES];
}


@end
