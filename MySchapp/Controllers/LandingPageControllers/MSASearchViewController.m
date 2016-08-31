//
//  MSASearchViewController.m
//  MySchapp
//
//  Created by CK-Dev on 23/02/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSASearchViewController.h"
#import "MSAConstants.h"
#import "MSAUtils.h"
#import "MSALocationHelper.h"
#import "MSALabel.h"

//#define SEARCH_BASE_COLOR   [UIColor colorWithRed:6.0/255 green:29.0/255 blue:73.0/255 alpha:1.0]

#define ROW_HEIGHT_NORMAL   44.0

#define TABLE_SEARCH_TAG        200
#define TABLE_PRODUCT_TIMELINE  201

#define SEARCH_BAR_PLACEHOLDER_STRING  @"Search within 10 Miles"
#define SEARCH_RESULT_ZERO_MSG         @"No results found, please try again."


@interface MSASearchViewController () {
    NSTimer *searchTimer;
}

@property (nonatomic, strong) UIImageView *logoImageView;

@property(nonatomic,strong) UIView *searchBarBaseView;
@property(nonatomic,strong) UIView *baseSearchView;

@property(nonatomic,strong) UIView *tblBaseView;
@property(nonatomic,strong) UITableView *tblSearchResult;
@property(nonatomic,strong) MSALabel *searchResultMsg;

@property(nonatomic,strong) UIView *resultDetailBaseView;
@property(nonatomic,strong) UITableView *tblSearchResultDetails;
@property(nonatomic,strong) UIView *searchDetailView;

@property(nonatomic,strong) NSMutableArray *productContracts;

@property(nonatomic,strong) NSIndexPath *selectedIndex;

@end

@implementation MSASearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor colorWithRed:1.0/255 green:1.0/255 blue:1.0/255 alpha:0.5];

    [self setupCustomViews];

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([[touches anyObject] view] == self.baseSearchView) {
        [self cancelSearch:nil];
    }
}

- (void)changeMenuConstraint
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *profStat = [userDefaults valueForKey:kDefaultsProfileStatus];
    if([profStat isEqualToString:@"PC"]) {
        self.menuBtnConstraint.constant = 30;
        [self.view updateConstraintsIfNeeded];
    }
    else {
        self.menuBtnConstraint.constant = 0;
        [self.view updateConstraintsIfNeeded];
    }

}

#pragma mark - Setup UISearchBar

-(void)setupCustomViews
{
    self.searchBarBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    self.searchBarBaseView.backgroundColor = kMySchappDarkBlueColor;
   
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    self.globalSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(50, 20, self.view.frame.size.width-50, 44)];
    self.globalSearchBar.placeholder = SEARCH_BAR_PLACEHOLDER_STRING;
    self.globalSearchBar.delegate = self;
    self.globalSearchBar.searchBarStyle = UISearchBarStyleDefault;
    [self.searchBarBaseView addSubview:self.globalSearchBar];
    
    self.globalSearchBar.barTintColor = kMySchappDarkBlueColor;
    
    
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 25, 25)];
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.logoImageView.image = [UIImage imageNamed:@"logo_landing.png"];
    [self.searchBarBaseView addSubview:self.logoImageView];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *profStat = [userDefaults valueForKey:kDefaultsProfileStatus];
    self.drawerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.drawerBtn addTarget:self.menuDelegate action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    self.drawerBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.drawerBtn setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [self.searchBarBaseView addSubview:self.drawerBtn];
    if([profStat isEqualToString:@"PC"])
        self.menuBtnConstraint = [NSLayoutConstraint constraintWithItem:self.drawerBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0 constant:30];
    else
        self.menuBtnConstraint = [NSLayoutConstraint constraintWithItem:self.drawerBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0 constant:0];
    [self.searchBarBaseView addConstraint:self.menuBtnConstraint];
    
    [self.globalSearchBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.logoImageView setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self.view addSubview:self.searchBarBaseView];
    
    [self.searchBarBaseView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[globalSearchBar]" options:0 metrics:nil views:@{@"globalSearchBar":self.globalSearchBar}]];
    [self.searchBarBaseView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[drawerBtn]-10.0-[logoImageView(30.0)]-0-[globalSearchBar]|" options:0 metrics:nil views:@{@"logoImageView":self.logoImageView,@"globalSearchBar":self.globalSearchBar,@"drawerBtn":self.drawerBtn}]];
    [self.searchBarBaseView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[logoImageView(35.0)]" options:0 metrics:nil views:@{@"logoImageView":self.logoImageView}]];
    [self.searchBarBaseView addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.searchBarBaseView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:10]];
    [self.searchBarBaseView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[drawerBtn(20.0)]" options:0 metrics:nil views:@{@"drawerBtn":self.drawerBtn}]];
    [self.searchBarBaseView addConstraint:[NSLayoutConstraint constraintWithItem:self.drawerBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.searchBarBaseView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:10]];

}

- (void)cancelSearch:(id)sender
{
    [self.globalSearchBar setShowsCancelButton:NO];
    self.globalSearchBar.text = @"";
    self.searchResultProducts = nil;
    self.productContracts = nil;
    [self.globalSearchBar resignFirstResponder];
    [self.delegate expandSearchResultView:NO];
    self.globalSearchBar.userInteractionEnabled = YES;
    [self changeMenuConstraint];
//    self.cancelBtnConstraint = [NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0 constant:0];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.searchResultProducts.count==0)
        self.searchResultMsg.text = SEARCH_RESULT_ZERO_MSG;
    return self.searchResultProducts.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if(cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = kMySchappDarkBlueColor;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = [self.searchResultProducts objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//        self.selectedIndex = indexPath;
//        self.globalSearchBar.text = @"";
//        [self.globalSearchBar resignFirstResponder];
//        self.globalSearchBar.userInteractionEnabled = NO;
//        [self.tblSearchResult deselectRowAtIndexPath:indexPath animated:YES];
//        
//        NSDictionary *selectedobject = [self.searchResultProducts objectAtIndex:indexPath.row];
//        
//        NSString *url = [NSString stringWithFormat:@""];
//        NSURL *requestUrl = [NSURL URLWithString:url];
//        NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
//        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//        operation.responseSerializer = [AFJSONResponseSerializer serializer];
//        
//        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//            //[self loadtablewithobjects];
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"Error");
//        }];
//        
//        [operation start];
    [MSAUtils showAlertWithTitle:@"" message:@"Feature not implemented" cancelButton:@"OK" otherButton:nil delegate:nil];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(![searchText isEqualToString:@""] && searchText.length >= 3) {
        [searchTimer invalidate];
        searchTimer = nil;
        searchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(searchProduct:) userInfo:searchText repeats:NO];
    }
    else {
        self.searchResultProducts = nil;
        self.productContracts = nil;
        [self.tblSearchResult reloadData];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.delegate expandSearchResultView:YES];
    [self.globalSearchBar setShowsCancelButton:YES];
    self.menuBtnConstraint = [NSLayoutConstraint constraintWithItem:self.drawerBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0 constant:0];
    [self presentSearchResultView];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self cancelSearch:nil];
}

#pragma mark - Utility Methods

-(void)publishMessage:(NSString*)msg
{
    self.searchResultMsg.text = msg;
}

- (void)searchProduct:(NSTimer *)timer
{
    MSALocationHelper *location = [MSALocationHelper sharedInstance];
    if(location.countryCode && ![location.countryCode isEqualToString:@""]) {
        NSDictionary *requestJSON = [[NSDictionary alloc] initWithObjectsAndKeys:self.globalSearchBar.text,@"searchtext",@"1000",@"distance",location.longitude,@"longitude",location.latitude,@"latitude",location.countryCode,@"country", nil];
        MSANetworkHandler *networkHanlder = [[MSANetworkHandler alloc] init];
        networkHanlder.delegate = self;
        [networkHanlder createRequestForURLString:[NSString stringWithFormat:@"%@%@",BASEURL,SEARCHURL] withIdentifier:@"Search" requestHeaders:nil andRequestParameters:requestJSON inView:self.view];
    }
    else
    {
        [MSAUtils showAlertWithTitle:@"Warning" message:@"Please select the location below." cancelButton:@"Ok" otherButton:nil delegate:self];
    }
}

-(CGFloat)getTableHeightForRows:(NSInteger)rowCount
{
    CGFloat maxTableHeight = (ROW_HEIGHT_NORMAL*rowCount > 220) ? 220:ROW_HEIGHT_NORMAL*rowCount;
    return maxTableHeight;
}

#pragma mark - MSANetworkDelegate

- (void)didReceiveData:(NSData *)responseData forRequest:(NSString *)requestId
{
    //received response comes here
    NSError* err;
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&err];
    if ([[responseDict objectForKey:@"rCode"] isEqualToString:@"00"] && [requestId isEqualToString:@"Search"]) {
        [self loadTableDataForSearchResult:[[responseDict objectForKey:@"autoSearchResultsVO"] valueForKey:@"specialities"]];
    }
    else {
        UIAlertView *alert  = [[UIAlertView alloc]initWithTitle:@"Message" message:[responseDict objectForKey:@"rMsg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] ;
        [alert show];
    }
}

- (void)didFailWithError:(NSError *)error forRequest:(NSString *)requestId
{
    [MSAUtils showAlertWithTitle:kAlertMessageTitle message:kAlertInternalErrorMsg cancelButton:kAlertOkButtonTitle otherButton:nil delegate:self];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Search Products Functionality

-(void)presentSearchResultView
{
    self.baseSearchView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    self.baseSearchView.backgroundColor = [UIColor clearColor];
    
    self.tblBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ROW_HEIGHT_NORMAL*5)];
    self.tblBaseView.backgroundColor = kMySchappDarkBlueColor;
    [self.baseSearchView addSubview:self.tblBaseView];
    
    if(self.searchResultProducts.count>0) {
        CGFloat maxTableHeight = [self getTableHeightForRows:self.searchResultProducts.count];
        self.tblSearchResult = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, maxTableHeight) style:UITableViewStylePlain];
        self.tblSearchResult.tag = TABLE_SEARCH_TAG;
        self.tblSearchResult.delegate = self;
        self.tblSearchResult.dataSource = self;
        [self.tblBaseView addSubview:self.tblSearchResult];
    }
    else {
        self.searchResultMsg = [[MSALabel alloc] initWithFrame:CGRectMake(40, 80, 300, 30)];
        self.searchResultMsg.text = @"No results found";
        [self.searchResultMsg adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
        self.searchResultMsg.textColor = [UIColor whiteColor];
        self.searchResultMsg.numberOfLines = 1;
        [self.tblBaseView addSubview:self.searchResultMsg];
        self.searchResultMsg.adjustsFontSizeToFitWidth = YES;
        
        [self.searchResultMsg setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.tblBaseView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[searchResultMsg]-30-|" options:0 metrics:nil views:@{@"searchResultMsg":self.searchResultMsg}]];
        [self.tblBaseView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-70-[searchResultMsg]" options:0 metrics:nil views:@{@"searchResultMsg":self.searchResultMsg}]];

    }

    [self.view addSubview:self.baseSearchView];
}

-(void)loadTableDataForSearchResult:(NSArray*)searchResult
{
    if(self.searchResultProducts!=nil)
        self.searchResultProducts = nil;

    self.searchResultProducts = [[NSMutableArray alloc] init];
    if(searchResult!=(NSArray*)[NSNull null])
    {
        if(searchResult.count>0) {
            for(NSInteger counter = 0; counter < searchResult.count; counter++) {
                [self.searchResultProducts addObject:[searchResult objectAtIndex:counter]];
            }
        }
    }
    else {
        [self publishMessage:@"Something went wrong. Response is null"];
    }

    [self presentSearchResultView];
    [self.tblSearchResult reloadData];
    [self.globalSearchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
