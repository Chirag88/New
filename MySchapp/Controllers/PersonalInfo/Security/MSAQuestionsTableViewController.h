//
//  MSAQuestionsTableViewController.h
//  MySchapp
//
//  Created by CK-Dev on 11/04/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSAProtocols.h"

@interface MSAQuestionsTableViewController : UITableViewController
@property (nonatomic, assign) NSInteger tappedViewTag;
@property (nonatomic, strong) NSArray *questionList;
@property (nonatomic ,weak) id<SelectedQuestionDelegate> delegate;
@end
