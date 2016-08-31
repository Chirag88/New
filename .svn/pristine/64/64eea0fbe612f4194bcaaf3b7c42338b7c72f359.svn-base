//
//  MSAPlanDetailViewController.m
//  MySchapp
//
//  Created by CK-Dev on 12/03/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSAPlanDetailViewController.h"
#import "MSAPlanDetailTableViewCell.h"
#import "MSAConstants.h"
#import "MSALabel.h"

@interface MSAPlanDetailViewController()<UITableViewDataSource,UITableViewDelegate> {
    
    __weak IBOutlet MSALabel *planFeesLbl;
    __weak IBOutlet UIView *headerView;
    __weak IBOutlet UIView *footerView;
    __weak IBOutlet UIButton *comparePlanBtn;
    __weak IBOutlet UIView *footerTopBorder;
}
@property (weak, nonatomic) IBOutlet UITableView *planDetailsTable;
@end

@implementation MSAPlanDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = self.planName;
    [planFeesLbl adjustFontSizeAccToScreenWidth:[UIFont boldSystemFontOfSize:16]];
    planFeesLbl.text = self.planFees;
    self.planDetailsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    headerView.backgroundColor = kMySchappLightBlueColor;
    footerView.backgroundColor = kPlanDetailCompareBtnBackColor;
    footerTopBorder.backgroundColor = kMySchappLightBlueColor;
    comparePlanBtn.backgroundColor = kMySchappMediumBlueColor;
    comparePlanBtn.layer.cornerRadius = 8;
    
    
}

#pragma mark TableView Delegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.planFeatures.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MSAPlanDetailTableViewCell";
    
    MSAPlanDetailTableViewCell *cell = (MSAPlanDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    //[2] When using Storyboard, dequeueReusableCellWithIdentifier DOES create a cell and so (cell == nil) condition never occurs

//    if (cell == nil) {
//        cell = (MSAPlanDetailTableViewCell *) [[[NSBundle mainBundle] loadNibNamed:@"MSAPlanDetailTableViewCell" owner:self options:nil] objectAtIndex:0];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row%2 == 0) {
        cell.cellBackgroundView.backgroundColor = kPlanDetailCellDarkBackColor;
    }
    else {
        cell.cellBackgroundView.backgroundColor = kPlanDetailCellLightBackColor;
    }
    cell.featureNameLbl.text = [[self.planFeatures objectAtIndex:indexPath.row] objectForKey:@"description"];
    id value1 = [[self.planFeatures objectAtIndex:indexPath.row] objectForKey:@"value"];
    
    if([value1 isEqualToString:@"YES"])
    {
        UIImageView *availabilityInPlan1 = [cell.featureValueView.subviews objectAtIndex:0];
        availabilityInPlan1.image = [UIImage imageNamed:@"tickGreen.png"];
        [[cell.featureValueView.subviews objectAtIndex:0] setHidden:NO];
        [[cell.featureValueView.subviews objectAtIndex:1] setHidden:YES];
    }
    else if ([value1 isEqualToString:@"NO"])
    {
        UIImageView *availabilityInPlan1 = [cell.featureValueView.subviews objectAtIndex:0];
        availabilityInPlan1.image = [UIImage imageNamed:@"cross.png"];
        [[cell.featureValueView.subviews objectAtIndex:0] setHidden:NO];
        [[cell.featureValueView.subviews objectAtIndex:1] setHidden:YES];

    }
    else
    {
        MSALabel *plan1Value = [cell.featureValueView.subviews objectAtIndex:1];
        plan1Value.text = value1;
        [plan1Value adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
        [[cell.featureValueView.subviews objectAtIndex:0] setHidden:YES];
        [[cell.featureValueView.subviews objectAtIndex:1] setHidden:NO];
        
    }

    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
