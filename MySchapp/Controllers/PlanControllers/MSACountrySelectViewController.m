//
//  MSACountrySelectViewController.m
//  MySchapp
//
//  Created by CK-Dev on 10/03/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSACountrySelectViewController.h"
#import "MSAPlanViewContoller.h"
#import "MSAConstants.h"
#import "MSANetworkHandler.h"
#import "MSALoginDecision.h"
#import "MSAUtils.h"

@interface MSACountrySelectViewController()<MSANetworkDelegate>
{
    NSInteger selectedIndex;
}
@property (weak, nonatomic) IBOutlet UIPickerView *countryPicker;
@end

@implementation MSACountrySelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.countryPicker.dataSource = self;
    self.countryPicker.delegate = self;
    self.countryPicker.backgroundColor = [UIColor colorWithRed:166.0/255.0 green:198/255.0 blue:243/255.0 alpha:.2];
    [self.view addSubview:self.countryPicker];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)continueClicked:(id)sender {
    
        MSALoginDecision *loginDecision = [[MSALoginDecision alloc] init];
        loginDecision.delegate = self;
        [loginDecision checkTokensValidityWithRequestID:@"CountrySelection"];
   
}

#pragma mark - MSANetworkDelegate

- (void)didReceiveData:(NSData *)responseData forRequest:(NSString *)requestId
{
    //received response comes here
    NSError* err;
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&err];
    
    NSLog(@"%@",responseDict);
    
    
    
}

- (void)didFailWithError:(NSError *)error forRequest:(NSString *)requestId
{
    
}

#pragma mark - UIPickerViewDatasource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.countryList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[self.countryList objectAtIndex:row] valueForKey:@"name"];
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedIndex = row;
}

#pragma mark - UITextField

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    return NO;
//}

#pragma LoginDecision Delegate
- (void)redirectToPage:(NSString *)pageToBeOpened {
    if ([pageToBeOpened isEqualToString:kLoginScreen]) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    }
    else if ([pageToBeOpened isEqualToString:@"CountrySelection"])
    {
        NSString *selectedCountryCode = [[self.countryList objectAtIndex:selectedIndex] valueForKey:@"countrycodeid"];
        UIStoryboard *mainStoryboard = UISTORYBOARD;
        MSAPlanViewContoller *controller = (MSAPlanViewContoller*)[mainStoryboard
                                                                   instantiateViewControllerWithIdentifier: @"PlanViewContoller"];
        controller.selectedCountryId = selectedCountryCode;
        controller.selectedCountryName = [[self.countryList objectAtIndex:selectedIndex] valueForKey:@"name"];
        controller.selectedCountryCode = [[self.countryList objectAtIndex:selectedIndex] valueForKey:@"code"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}



@end
