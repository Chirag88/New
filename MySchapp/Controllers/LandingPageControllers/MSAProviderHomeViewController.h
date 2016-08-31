//
//  MSAProviderHomeViewController.h
//  MySchapp
//
//  Created by M-Creative on 7/6/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSAProtocols.h"
#import "MSASearchViewController.h"
#import "CLWeeklyCalendarView.h"
#import "MSALoginDecision.h"

@interface MSAProviderHomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CLWeeklyCalendarViewDelegate,MenuButtonDelegate,SubCategoryDelegate,LoginDecisionDelegate>

@end
