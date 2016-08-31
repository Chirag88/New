//
//  MSAComparePlanViewController.m
//  MySchapp
//
//  Created by CK-Dev on 3/11/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSAComparePlanViewController.h"
#import "MSAComparePlanTableViewCell.h"
#import "MSAConstants.h"
#import "MSAPersonalViewController.h"
#import "MSALoginDecision.h"
#import "MSALabel.h"

@interface MSAComparePlanViewController ()<LoginDecisionDelegate>
{
    NSInteger plan1Index;
    NSInteger plan2Index;
    NSArray *features;
    UIPickerView *pickerView1;
    UIPickerView *pickerView2;
    UIToolbar *toolBar;
    NSInteger selectedIndex;
    NSString *selectedPlanId;
    NSString *selectedPlanName;
    
}
@end

@implementation MSAComparePlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    plan1Index = 0;
    plan2Index = 1;
    self.featureList.dataSource = self;
    self.featureList.delegate = self;
    features = [[self.plansAvailable objectAtIndex:plan1Index] valueForKey:@"features"];
    self.featureList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    self.navigationItem.title = self.navigationItem.title = [NSString stringWithFormat:@"%@ vs %@",[[self.plansAvailable objectAtIndex:plan1Index] valueForKey:@"planname"],[[self.plansAvailable objectAtIndex:plan2Index] valueForKey:@"planname"]];//@"Compare";
    self.choosePlanHeaderView.backgroundColor = kMySchappLightBlueColor;
    self.featureHeaderView.backgroundColor = kPlanDetailCellDarkBackColor;
    self.selectPlan1.backgroundColor = kMySchappDarkBlueColor;
    self.selectPlan1.layer.cornerRadius = 5;
    self.selectPlan2.backgroundColor = kMySchappDarkBlueColor;
    self.selectPlan2.layer.cornerRadius = 5;
    [self.plan1Price adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    [self.plan2Price adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    self.plan1Price.textColor = kMySchappMediumBlueColor;
    self.plan2Price.textColor = kMySchappMediumBlueColor;
    self.plan1Price.text = [[[self.plansAvailable objectAtIndex:plan1Index] valueForKey:@"plancost"] stringValue];
    self.plan2Price.text = [[[self.plansAvailable objectAtIndex:plan2Index] valueForKey:@"plancost"] stringValue];
    
    
    NSString *plan1BtnTitle = [NSString stringWithFormat:@"%@  \u2228",[[self.plansAvailable objectAtIndex:plan1Index] valueForKey:@"planname"]];
    NSString *plan2BtnTitle = [NSString stringWithFormat:@"%@  \u2228",[[self.plansAvailable objectAtIndex:plan2Index] valueForKey:@"planname"]];
  //  CGSize plan1LabelSize = [plan1BtnTitle sizeWithAttributes:@{NSFontAttributeName:kComparePlanSelectorFont}];
  //  CGSize plan2LabelSize = [plan2BtnTitle sizeWithAttributes:@{NSFontAttributeName:kComparePlanSelectorFont}];
    
    UIImage *image = [UIImage imageNamed:@"dropArrow.png"];
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    // Color change of the image -- replace the image with thhe colored image
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToMask(context, rect, image.CGImage);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(context, rect);
   // UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.plan1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.plan1 setImage: img forState:UIControlStateNormal];
//    [self.plan1 setImage: img forState:UIControlStateHighlighted];
//    [self.plan1 setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -10.0, 0.0, 0.0)];
//    [self.plan1 setImageEdgeInsets:UIEdgeInsetsMake(0.0, plan1LabelSize.width+10, 0, 0)];
    [self.plan1 setTitle:plan1BtnTitle forState:UIControlStateNormal];
    [self.plan1 setBackgroundColor:kMySchappMediumBlueColor];
    self.plan1.layer.cornerRadius = 5;
    
    
    [self.plan2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.plan2 setImage: img forState:UIControlStateNormal];
//    [self.plan2 setImage: img forState:UIControlStateHighlighted];
//    [self.plan2 setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -10.0, 0.0, 0.0)];
//    [self.plan2 setImageEdgeInsets:UIEdgeInsetsMake(0.0, plan2LabelSize.width+10, 0, 0)];
    [self.plan2 setTitle:plan2BtnTitle forState:UIControlStateNormal];
    [self.plan2 setBackgroundColor:kMySchappMediumBlueColor];
    self.plan2.layer.cornerRadius = 5;
    
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (void)selectPlan1:(id)sender
{
    if(pickerView1) {
        [pickerView1 removeFromSuperview];
        pickerView1 = nil;
    }
    if(pickerView2) {
        [pickerView2 removeFromSuperview];
        pickerView2 = nil;
    }
    if(toolBar) {
        [toolBar removeFromSuperview];
        toolBar = nil;
    }
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-150-44, self.view.frame.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouched:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTouched:)];
    
    // the middle button is to make the Done button align to right
    [toolBar setItems:[NSArray arrayWithObjects:cancelButton, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneButton, nil]];
    [self.view addSubview:toolBar];
    pickerView1 = [[UIPickerView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-150,self.view.frame.size.width,150)];
    pickerView1.delegate = self;
    pickerView1.dataSource = self;
    pickerView1.showsSelectionIndicator = YES;
    pickerView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pickerView1];
}

- (void)selectPlan2:(id)sender
{
    if(pickerView1) {
        [pickerView1 removeFromSuperview];
        pickerView1 = nil;
    }
    if(pickerView2) {
        [pickerView2 removeFromSuperview];
        pickerView2 = nil;
    }
    if(toolBar) {
        [toolBar removeFromSuperview];
        toolBar = nil;
    }
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-150-44, self.view.frame.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouched:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTouched:)];
    // the middle button is to make the Done button align to right
    [toolBar setItems:[NSArray arrayWithObjects:cancelButton, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneButton, nil]];
    [self.view addSubview:toolBar];
    pickerView2 = [[UIPickerView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-150,self.view.frame.size.width,150)];
    pickerView2.delegate = self;
    pickerView2.dataSource = self;
    pickerView2.showsSelectionIndicator = YES;
    pickerView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pickerView2];
}

- (IBAction)choosePlan:(id)sender {
    
    if (sender == self.selectPlan1) {
        selectedPlanId = [[self.plansAvailable objectAtIndex:plan1Index] valueForKey:@"planid"];
        selectedPlanName = [[self.plansAvailable objectAtIndex:plan1Index] valueForKey:@"planname"];
    }
    else  if (sender == self.selectPlan2){
        selectedPlanId = [[self.plansAvailable objectAtIndex:plan2Index] valueForKey:@"planid"];
        selectedPlanName = [[self.plansAvailable objectAtIndex:plan2Index] valueForKey:@"planname"];
    }
    
    MSALoginDecision *loginDecision = [[MSALoginDecision alloc]init];
    loginDecision.delegate = self;
    [loginDecision checkTokensValidityWithRequestID:@"ChoosePlan"];
    
    
    
}

- (void)cancelTouched:(UIBarButtonItem *)sender
{
    if(pickerView1)
    {
        [pickerView1 removeFromSuperview];
        pickerView1 = nil;
    }
    if(pickerView2)
    {
        [pickerView2 removeFromSuperview];
        pickerView2 = nil;
    }
    if(toolBar)
    {
        [toolBar removeFromSuperview];
        toolBar = nil;
    }
}

- (void)doneTouched:(UIBarButtonItem *)sender
{
    if(pickerView1)
    {
        if(selectedIndex != plan2Index) {
            plan1Index = selectedIndex;
            [self.plan1 setTitle:[NSString stringWithFormat:@"%@  \u2228",[[self.plansAvailable objectAtIndex:plan1Index] valueForKey:@"planname"] ] forState:UIControlStateNormal];
            self.plan1Price.text = [[[self.plansAvailable objectAtIndex:plan1Index] valueForKey:@"plancost"] stringValue];
        }
        [pickerView1 removeFromSuperview];
        pickerView1 = nil;
    }
    if(pickerView2)
    {
        if(selectedIndex != plan1Index) {
            plan2Index = selectedIndex;
            [self.plan2 setTitle:[NSString stringWithFormat:@"%@  \u2228",[[self.plansAvailable objectAtIndex:plan2Index] valueForKey:@"planname"]] forState:UIControlStateNormal];
             self.plan2Price.text = [[[self.plansAvailable objectAtIndex:plan2Index] valueForKey:@"plancost"] stringValue];
        }
        [pickerView2 removeFromSuperview];
        pickerView2 = nil;
    }
    if(toolBar)
    {
        [toolBar removeFromSuperview];
        toolBar = nil;
    }
    self.navigationItem.title = [NSString stringWithFormat:@"%@ vs %@",[[self.plansAvailable objectAtIndex:plan1Index] valueForKey:@"planname"],[[self.plansAvailable objectAtIndex:plan2Index] valueForKey:@"planname"]];
    [self.featureList reloadData];
}

#pragma mark - UIPickerViewDatasource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.plansAvailable.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[self.plansAvailable objectAtIndex:row] valueForKey:@"planname"];
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedIndex = row;
}

#pragma mark TableView Delegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [features count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MSAComparePlanTableViewCell";
    
    MSAComparePlanTableViewCell *cell = (MSAComparePlanTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //[2] When using Storyboard, dequeueReusableCellWithIdentifier DOES create a cell and so (cell == nil) condition never occurs
//    if (cell == nil) {
//        cell = (MSAComparePlanTableViewCell *) [[[NSBundle mainBundle] loadNibNamed:@"MSAComparePlanTableViewCell" owner:self options:nil] objectAtIndex:0];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row%2 == 0) {
        cell.cellBackgroundView.backgroundColor = kPlanDetailCellLightBackColor;
    }
    else {
        cell.cellBackgroundView.backgroundColor = kPlanDetailCellDarkBackColor;
    }
    
    cell.feature.text = [[features objectAtIndex:indexPath.row] valueForKey:@"description"];
    id value1 = [[[[self.plansAvailable objectAtIndex:plan1Index] valueForKey:@"features"] objectAtIndex:indexPath.row] valueForKey:@"value"];
    id value2 = [[[[self.plansAvailable objectAtIndex:plan2Index] valueForKey:@"features"] objectAtIndex:indexPath.row] valueForKey:@"value"];
    if([value1 isEqualToString:@"YES"])
    {
        UIImageView *availabilityInPlan1 = [cell.plan1.subviews objectAtIndex:0];
        availabilityInPlan1.image = [UIImage imageNamed:@"tickGreen.png"];
        [[cell.plan1.subviews objectAtIndex:0] setHidden:NO];
        [[cell.plan1.subviews objectAtIndex:1] setHidden:YES];
    }
    else if ([value1 isEqualToString:@"NO"])
    {
        UIImageView *availabilityInPlan1 = [cell.plan1.subviews objectAtIndex:0];
        availabilityInPlan1.image = [UIImage imageNamed:@"cross.png"];
        [[cell.plan1.subviews objectAtIndex:0] setHidden:NO];
        [[cell.plan1.subviews objectAtIndex:1] setHidden:YES];
    }
    else
    {
        MSALabel *plan1Value = [cell.plan1.subviews objectAtIndex:1];
        plan1Value.text = value1;
        [plan1Value adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
        [[cell.plan1.subviews objectAtIndex:0] setHidden:YES];
        [[cell.plan1.subviews objectAtIndex:1] setHidden:NO];
    }
    
    if([value2 isEqualToString:@"YES"])
    {
        UIImageView *availabilityInPlan2 = [cell.plan2.subviews objectAtIndex:0];
        availabilityInPlan2.image = [UIImage imageNamed:@"tickGreen.png"];
        [[cell.plan2.subviews objectAtIndex:0] setHidden:NO];
        [[cell.plan2.subviews objectAtIndex:1] setHidden:YES];
    }
    else if ([value2 isEqualToString:@"NO"])
    {
        UIImageView *availabilityInPlan2 = [cell.plan2.subviews objectAtIndex:0];
        availabilityInPlan2.image = [UIImage imageNamed:@"cross.png"];
        [[cell.plan2.subviews objectAtIndex:0] setHidden:NO];
        [[cell.plan2.subviews objectAtIndex:1] setHidden:YES];
    }
    else
    {
        MSALabel *plan2Value = [cell.plan2.subviews objectAtIndex:1];
        plan2Value.text = value2;
        [plan2Value adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
        [[cell.plan2.subviews objectAtIndex:0] setHidden:YES];
        [[cell.plan2.subviews objectAtIndex:1] setHidden:NO];
    }
    
    return cell;
}


#pragma LoginDecision Delegate
- (void)redirectToPage:(NSString *)pageToBeOpened {
    if ([pageToBeOpened isEqualToString:kLoginScreen]) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    }
    else if ([pageToBeOpened isEqualToString:@"ChoosePlan"])
    {
        UIStoryboard *mainStoryboard = UISTORYBOARD;
        
        MSAPersonalViewController *controller = (MSAPersonalViewController*)[mainStoryboard
                                                                             instantiateViewControllerWithIdentifier:@"MSAPersonalViewController"];
        controller.selectedCountryId = self.selectedCountryId;
        controller.selectedPlanId = selectedPlanId;
        controller.selectedCountryName = self.selectedCountryName;
        controller.selectedCountryCode = self.selectedCountryCode;
        controller.selectedPlanName = selectedPlanName;
        [self.navigationController pushViewController:controller animated:YES];
    }
}



@end
