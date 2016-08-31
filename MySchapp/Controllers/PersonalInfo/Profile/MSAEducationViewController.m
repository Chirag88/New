//
//  MSAEducationViewController.m
//  MySchapp
//
//  Created by CK-Dev on 06/04/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSAEducationViewController.h"
#import "MSAEducationTableViewCell.h"
#import "MSAUtils.h"
#import "MSAConstants.h"
#import "MSAProtocols.h"
@interface MSAEducationViewController ()<UITableViewDataSource,UITableViewDelegate,DeleteEducationFromListDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    __weak IBOutlet UITextField *qualificationTxt;
    __weak IBOutlet UITextField *yearOfPassingTxt;
    __weak IBOutlet UITableView *educationList;
    NSMutableArray *localEducationList;
    NSMutableArray *years;
    NSInteger selectedIndex;
}
@property (strong, nonatomic) UIPickerView *yearPicker;
- (IBAction)addEducationClicked:(id)sender;

@end

@implementation MSAEducationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Education";
    
    if (self.savedEducationArray) {
        localEducationList = [NSMutableArray arrayWithArray:self.savedEducationArray];
    }
    else {
        localEducationList = [[NSMutableArray alloc]init];
    }
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveSelectedEducations)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelSelectedEducations)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    educationList.separatorStyle = UITableViewCellSelectionStyleNone;
    qualificationTxt.delegate = self;
    
//    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
//    [datePicker setDate:[NSDate date]];
//    datePicker.datePickerMode = UIDatePickerModeDate;
//    [datePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    
    //Get Current Year into i2
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    int i2  = [[formatter stringFromDate:[NSDate date]] intValue];
    
    
    //Create Years Array from 1960 to This year
    years = [[NSMutableArray alloc] init];
    for (int i=1960; i<=i2; i++) {
        [years addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    // Adding PickerView
    self.yearPicker = [[UIPickerView alloc] init];
    self.yearPicker.dataSource = self;
    self.yearPicker.delegate = self;
    
    UIToolbar *toolBar1= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,44)];
    [toolBar1 setBarStyle:UIBarStyleBlackOpaque];
    UIBarButtonItem *barButtonDone1 = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleBordered target:self action:@selector(setYear:)];
    UIBarButtonItem *barButtonCancel1 = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                         style:UIBarButtonItemStyleBordered target:self action:@selector(resetYear:)];
    UIBarButtonItem *flex1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    toolBar1.items = @[barButtonCancel1,flex1,barButtonDone1];
    barButtonDone1.tintColor=[UIColor blackColor];
    yearOfPassingTxt.inputAccessoryView = toolBar1;
    [yearOfPassingTxt setInputView:self.yearPicker];


}

//-(void) dateTextField:(id)sender
//{
//    UIDatePicker *picker = (UIDatePicker*)yearOfPassingTxt.inputView;
//    [picker setMaximumDate:[NSDate date]];
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    NSDate *eventDate = picker.date;
//    [dateFormat setDateFormat:@"yyyy"];
//    
//    NSString *dateString = [dateFormat stringFromDate:eventDate];
//    yearOfPassingTxt.text = [NSString stringWithFormat:@"%@",dateString];
//}


//- (void)setDOB:(id)sender
//{
//    if ([yearOfPassingTxt.text isEqualToString:@""]) {
//        [self dateTextField:yearOfPassingTxt];
//    }
//    [yearOfPassingTxt resignFirstResponder];
//}
//
//- (void)resetDOB:(id)sender
//{
//    yearOfPassingTxt.text = @"";
//    [yearOfPassingTxt resignFirstResponder];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 30;
}

#pragma mark TableView Delegates
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return localEducationList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MSAEducationTableViewCell";
    
    MSAEducationTableViewCell *cell = (MSAEducationTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = (MSAEducationTableViewCell *) [[[NSBundle mainBundle] loadNibNamed:@"MSAEducationTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backView.backgroundColor = kProfileRowBackColor;
    cell.backView.layer.cornerRadius = 5;
    cell.qualificationLabel.text = [localEducationList objectAtIndex:indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.view.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}

#pragma mark - Add Action Method
- (IBAction)addEducationClicked:(id)sender {
    
    if (![qualificationTxt.text isEqualToString:@""] && ![yearOfPassingTxt.text isEqualToString:@""]) {
        [localEducationList addObject:[NSString stringWithFormat:@"%@ - %@",qualificationTxt.text,yearOfPassingTxt.text]];
        [educationList reloadData];
        qualificationTxt.text = @"";
        yearOfPassingTxt.text = @"";
        [qualificationTxt resignFirstResponder];
        [yearOfPassingTxt resignFirstResponder];
    }
    else {
        NSString *alertMsg = @"";
        if([qualificationTxt.text isEqualToString:@""])
            alertMsg = @"Qualification is mandatory";
        else
            alertMsg = @"Year is mandatory";
        [MSAUtils showAlertWithTitle:@"Warning !" message:alertMsg cancelButton:kAlertOkButtonTitle otherButton:nil delegate:nil];
    }
    
    
}

#pragma - Selector Methods
- (void)saveSelectedEducations {
    if ([qualificationTxt.text isEqualToString:@""] && [yearOfPassingTxt.text isEqualToString:@""]) {
        [self.delegate educationDoneClickedWithValues:localEducationList];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        NSString *alertMsg = @"";
        if([qualificationTxt.text isEqualToString:@""])
            alertMsg = @"Qualification is mandatory, continue without saving this record?";
        else
            alertMsg = @"Year is mandatory, continue without saving this record?";
        [MSAUtils showAlertWithTitle:@"Warning !" message:alertMsg cancelButton:@"Yes" otherButton:@"No" delegate:self];
    }
    
}

- (void)cancelSelectedEducations {
    [self.navigationController popViewControllerAnimated:YES];
//    if ([qualificationTxt.text isEqualToString:@""] && [yearOfPassingTxt.text isEqualToString:@""]) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    else {
//        NSString *alertMsg = @"";
//        if([qualificationTxt.text isEqualToString:@""])
//            alertMsg = @"Qualification is mandatory, continue without saving this record?";
//        else
//            alertMsg = @"Year is mandatory, continue without saving this record?";
//        [MSAUtils showAlertWithTitle:@"Warning !" message:alertMsg cancelButton:@"Yes" otherButton:@"No" delegate:self];
//    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
}

#pragma mark - DeleteEducation Delegate Method
- (void)deleteEducation:(id)cell {
    [localEducationList removeObject:[cell qualificationLabel].text];
    [educationList reloadData];
}

#pragma mark - UIPickerViewDatasource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return years.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [years objectAtIndex:row];
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedIndex = row;
}

#pragma mark - Selector Methods
- (void)setYear:(id)sender
{
    yearOfPassingTxt.text = [years objectAtIndex:selectedIndex];
    [yearOfPassingTxt resignFirstResponder];
}

- (void)resetYear:(id)sender
{
    [yearOfPassingTxt resignFirstResponder];
}


@end
