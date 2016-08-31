//
//  MSASecurityViewController.h
//  MySchapp
//
//  Created by CK-Dev on 25/03/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSAProtocols.h"

@interface MSASecurityViewController : UIViewController<SelectedQuestionDelegate>
@property (nonatomic, strong) NSMutableDictionary *securityDataFromPersonal;
@property (nonatomic, assign) BOOL resetPasswordEnabled;
@property (nonatomic, strong) NSString *selectedPlanId;
@property (nonatomic, strong) NSString *selectedPlanName;
@property (nonatomic, assign) BOOL isComingFromMenu;

@end
