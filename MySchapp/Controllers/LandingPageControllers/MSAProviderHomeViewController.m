//
//  MSAProviderHomeViewController.m
//  MySchapp
//
//  Created by M-Creative on 7/6/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSAProviderHomeViewController.h"
#import "NSDate+CL.h"
#import "MSAConstants.h"
#import "MSAUtils.h"
#import "MSAPersonalViewController.h"
#import "MSASecurityViewController.h"
#import "MSANotificationViewController.h"
#import "MSATermsConditionViewController.h"
#import "MSAPrivacyPolicyViewController.h"
#import "MSALoginViewController.h"

@interface MSAProviderHomeViewController ()
{
    UIView *navView;
    UIView *midView;
    UIView *summaryView;
    MSASearchViewController *objSearchVC;
    CLWeeklyCalendarView *calendarView;
    UIView *menuView;
    NSMutableArray *menuItems;
    NSMutableArray *tableItems;
    UIButton *backButton;
    UIView *navMenuView;
    UITableView *menuList;
}
@end

@implementation MSAProviderHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self designProviderLandingPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)designProviderLandingPage
{
    navView = [[UIView alloc] init];
    navView.translatesAutoresizingMaskIntoConstraints = NO;
    navView.backgroundColor = [UIColor blueColor];
    midView = [[UIView alloc] init];
    midView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:navView];
    [self.view addSubview:midView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[navView]|" options:0 metrics:nil views:@{@"navView":navView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[midView]|" options:0 metrics:nil views:@{@"midView":midView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-[navView(44)][midView(%f)]-|",self.view.frame.size.height-44] options:0 metrics:nil views:@{@"navView":navView,@"midView":midView}]];
    [self designNavigationView];
    [self designMiddleView];
}

- (void)designNavigationView
{
    objSearchVC = [[MSASearchViewController alloc] init];
    objSearchVC.menuDelegate = self;
    objSearchVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 64);
    //objSearchVC.providerName = @"Pankaj";
    [navView addSubview:objSearchVC.view];
    
}
- (void)designMiddleView
{
    summaryView = [[UIView alloc] init];
    summaryView.translatesAutoresizingMaskIntoConstraints = NO;
    summaryView.backgroundColor = [UIColor redColor];
    [midView addSubview:summaryView];
    [self designSummaryView];
    
    UIView *appointmentCalView = [[UIView alloc] init];
    appointmentCalView.translatesAutoresizingMaskIntoConstraints = NO;
    [midView addSubview:appointmentCalView];
    
    UILabel *appointmentLbl = [[UILabel alloc] init];
    appointmentLbl.translatesAutoresizingMaskIntoConstraints = NO;
    appointmentLbl.text = @" Appointments";
    appointmentLbl.backgroundColor = [UIColor colorWithRed:44/255.0 green:141/255.0 blue:208/255.0 alpha:1.0];
    [appointmentCalView addSubview:appointmentLbl];
    
    NSDate *curDate = [NSDate date];
    NSDate *impDate = [curDate addDays:2];
    calendarView = [[CLWeeklyCalendarView alloc] init];
    calendarView.translatesAutoresizingMaskIntoConstraints = NO;
    calendarView.backgroundColor = [UIColor colorWithRed:15/255.0 green:110/255.0 blue:191/255.0 alpha:1.0];
    calendarView.delegate = self;
    calendarView.importantDates = [NSMutableArray arrayWithObjects:impDate, nil];
    [appointmentCalView addSubview:calendarView];
    [calendarView setupUI];
    
    [appointmentCalView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[appointmentLbl(30)][calendar(75)]|" options:0 metrics:nil views:@{@"appointmentLbl":appointmentLbl,@"calendar":calendarView}]];
    [appointmentCalView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[appointmentLbl]|" options:0 metrics:nil views:@{@"appointmentLbl":appointmentLbl}]];
    [appointmentCalView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[calendar]|" options:0 metrics:nil views:@{@"calendar":calendarView}]];
    
    UIView *appointmentDetailView = [[UIView alloc] init];
    appointmentDetailView.translatesAutoresizingMaskIntoConstraints = NO;
    appointmentDetailView.backgroundColor = [UIColor greenColor];
    [midView addSubview:appointmentDetailView];
    
    [midView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[summaryView]|" options:0 metrics:nil views:@{@"summaryView":summaryView}]];
    [midView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[appointmentcalendarView]|" options:0 metrics:nil views:@{@"appointmentcalendarView":appointmentCalView}]];
    [midView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[appointmentDetailView]|" options:0 metrics:nil views:@{@"appointmentDetailView":appointmentDetailView}]];
    [midView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[summaryView(100)][appointmentcalendarView(105)][appointmentDetailView]-|" options:0 metrics:nil views:@{@"summaryView":summaryView,@"appointmentcalendarView":appointmentCalView,@"appointmentDetailView":appointmentDetailView}]];
    
}

- (void)designSummaryView
{
    UIView *locationSummaryView = [[UIView alloc] init];
    locationSummaryView.translatesAutoresizingMaskIntoConstraints = NO;
    locationSummaryView.backgroundColor = [UIColor whiteColor];
    UIView *locView = [self viewWithImage:[UIImage imageNamed:@"icon_Finance.png"] countLabelString:@"10" labelSring:@"Locations"];
    locView.translatesAutoresizingMaskIntoConstraints = NO;
    locView.backgroundColor = [UIColor colorWithRed:206/255.0 green:231/255.0 blue:246/255.0 alpha:1];
    [locationSummaryView addSubview:locView];
    [locationSummaryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[location]-5-|" options:0 metrics:nil views:@{@"location":locView}]];
    [locationSummaryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[location]-10-|" options:0 metrics:nil views:@{@"location":locView}]];
    
    UIView *workingHrsSummaryView = [[UIView alloc] init];
    workingHrsSummaryView.translatesAutoresizingMaskIntoConstraints = NO;
    workingHrsSummaryView.backgroundColor = [UIColor whiteColor];
    UIView *wrkView = [self viewWithImage:[UIImage imageNamed:@"icon_Finance.png"] countLabelString:@"10" labelSring:@"Working Hours"];
    wrkView.translatesAutoresizingMaskIntoConstraints = NO;
    wrkView.backgroundColor = [UIColor colorWithRed:206/255.0 green:231/255.0 blue:246/255.0 alpha:1];
    [workingHrsSummaryView addSubview:wrkView];
    [workingHrsSummaryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[work]-5-|" options:0 metrics:nil views:@{@"work":wrkView}]];
    [workingHrsSummaryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[work]-10-|" options:0 metrics:nil views:@{@"work":wrkView}]];
    
    UIView *associationSummaryView = [[UIView alloc] init];
    associationSummaryView.translatesAutoresizingMaskIntoConstraints = NO;
    associationSummaryView.backgroundColor = [UIColor whiteColor];
    UIView *assocView = [self viewWithImage:[UIImage imageNamed:@"icon_Finance.png"] countLabelString:@"10" labelSring:@"Associations"];
    assocView.translatesAutoresizingMaskIntoConstraints = NO;
    assocView.backgroundColor = [UIColor colorWithRed:206/255.0 green:231/255.0 blue:246/255.0 alpha:1];
    [associationSummaryView addSubview:assocView];
    [associationSummaryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[assoc]-10-|" options:0 metrics:nil views:@{@"assoc":assocView}]];
    [associationSummaryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[assoc]-10-|" options:0 metrics:nil views:@{@"assoc":assocView}]];
    
    [summaryView addSubview:locationSummaryView];
    [summaryView addSubview:workingHrsSummaryView];
    [summaryView addSubview:associationSummaryView];
    [summaryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[locsummaryView]|" options:0 metrics:nil views:@{@"locsummaryView":locationSummaryView}]];
    [summaryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[wrksummaryView]|" options:0 metrics:nil views:@{@"wrksummaryView":workingHrsSummaryView}]];
    [summaryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[assocsummaryView]|" options:0 metrics:nil views:@{@"assocsummaryView":associationSummaryView}]];
    [summaryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[locsummaryView(==wrksummaryView)][wrksummaryView(==assocsummaryView)][assocsummaryView(==locsummaryView)]|" options:0 metrics:nil views:@{@"locsummaryView":locationSummaryView,@"wrksummaryView":workingHrsSummaryView,@"assocsummaryView":associationSummaryView}]];
    
}

- (UIView *)viewWithImage:(UIImage *)img countLabelString:(NSString *)countStr labelSring:(NSString *)lblStr
{
    UIView *aView = [[UIView alloc] init];
    UIImageView *iconImg = [[UIImageView alloc] init];
    UILabel *countLbl = [[UILabel alloc] init];
    countLbl.textAlignment = NSTextAlignmentRight;
    countLbl.font = [UIFont systemFontOfSize:40.0];
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont systemFontOfSize:17.0];
    iconImg.translatesAutoresizingMaskIntoConstraints = NO;
    countLbl.translatesAutoresizingMaskIntoConstraints = NO;
    titleLbl.translatesAutoresizingMaskIntoConstraints = NO;
    iconImg.image = img;
    countLbl.text = countStr;
    titleLbl.text = lblStr;
    [aView addSubview:iconImg];
    [aView addSubview:countLbl];
    [aView addSubview:titleLbl];
    [aView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[icon(50)][title]|" options:0 metrics:nil views:@{@"icon":iconImg,@"title":titleLbl}]];
    [aView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[icon(50)][count]-5-|" options:0 metrics:nil views:@{@"icon":iconImg,@"count":countLbl}]];
    [aView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[count(==icon)]" options:0 metrics:nil views:@{@"icon":iconImg,@"count":countLbl}]];
    [aView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[title]|" options:0 metrics:nil views:@{@"title":titleLbl}]];
    
    return aView;
}

- (void)menuClicked:(id)sender
{
    [self designMenu];
    backButton.hidden = YES;
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

- (void)goBackFromSubMenu:(id)sender
{
    tableItems = menuItems;
    [menuList reloadData];
    backButton.hidden = YES;
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
    else
    {
        [MSAUtils showAlertWithTitle:@"Message" message:@"Feature not implemented" cancelButton:@"OK" otherButton:nil delegate:nil];
    }
}

#pragma mark - CLWeeklyCalendarViewDelegate
-(NSDictionary *)CLCalendarBehaviorAttributes
{
    return @{
            CLCalendarWeekStartDay : @1,                 //Start Day of the week, from 1-7 Mon-Sun -- default 1
            CLCalendarDayTitleTextColor : [UIColor whiteColor],
            CLCalendarSelectedDatePrintColor : [UIColor greenColor],
             };
}

-(void)dailyCalendarViewDidSelect:(NSDate *)date
{
    //You can do any logic after the view select the date
    NSLog(@"%@",date);
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

@end
