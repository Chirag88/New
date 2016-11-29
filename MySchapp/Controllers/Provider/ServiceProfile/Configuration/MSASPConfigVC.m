//
//  MSAServiceProfileVC.m
//  MySchapp
//
//  Created by CK-Dev on 09/08/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSASPConfigVC.h"
#import "MSAConstants.h"
#import "MSAUtils.h"
#import "MSASPConfigTableViewCell.h"

@interface MSASPConfigVC (){
    NSArray *homeItems;
    __weak IBOutlet UITableView *homeList;
}

@end

@implementation MSASPConfigVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [MSAUtils setNavigationBarAttributes:self.navigationController];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Configuration";
    
    homeItems = @[@"Generic",@"Speciality",@"Appointment",@"Advance"];
    homeList.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView Delegates
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return homeItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MSASPConfigTableViewCell";
    
    MSASPConfigTableViewCell *cell = (MSASPConfigTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = (MSASPConfigTableViewCell *) [[[NSBundle mainBundle] loadNibNamed:@"MSASPConfigTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.backView.backgroundColor = kMySchappLightBlueColor;
    cell.serviceProfileList.text = [homeItems objectAtIndex:indexPath.row];
    cell.serviceProfileList.backgroundColor = [UIColor clearColor];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    if (indexPath.row == 1) {
        
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
