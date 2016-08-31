//
//  MSAMySchappProfileVC.m
//  MySchapp
//
//  Created by CK-Dev on 09/08/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSAMySchappProfileVC.h"
#import "MSAConstants.h"
#import "MSAUtils.h"
#import "MSAMySchappProfileTableViewCell.h"
#import "MSALocationListViewController.h"
#import "MSAServiceProfileVC.h"

@interface MSAMySchappProfileVC (){
    NSArray *homeItems;
    __weak IBOutlet UITableView *homeList;
}

@end

@implementation MSAMySchappProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [MSAUtils setNavigationBarAttributes:self.navigationController];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"MySchapp Profile";
    
    homeItems = @[@"Service Profile",@"Work Location",@"Services at Location",@"Providers at Location"];
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
    
    static NSString *CellIdentifier = @"MSAMySchappProfileTableViewCell";
    
    MSAMySchappProfileTableViewCell *cell = (MSAMySchappProfileTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = (MSAMySchappProfileTableViewCell *) [[[NSBundle mainBundle] loadNibNamed:@"MSAMySchappProfileTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.backView.backgroundColor = kMySchappLightBlueColor;
    cell.itemLabel.text = [homeItems objectAtIndex:indexPath.row];
    cell.itemLabel.backgroundColor = [UIColor clearColor];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    if (indexPath.row == 1) {
        MSALocationListViewController *addLocation  = [[MSALocationListViewController alloc]init];
        [self.navigationController pushViewController:addLocation animated:YES];
    }
    else if (indexPath.row == 0) {
        UIStoryboard *mainStoryboard = UISTORYBOARD;
        MSAServiceProfileVC *serviceProfile  = (MSAServiceProfileVC*)[mainStoryboard
                                                                      instantiateViewControllerWithIdentifier:@"MSAServiceProfileVC"];
        [self.navigationController pushViewController:serviceProfile animated:YES];    }
    
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
