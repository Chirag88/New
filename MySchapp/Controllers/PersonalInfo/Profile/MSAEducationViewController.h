//
//  MSAEducationViewController.h
//  MySchapp
//
//  Created by CK-Dev on 06/04/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSAProtocols.h"

@interface MSAEducationViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic,strong)NSArray *savedEducationArray;
@property (nonatomic,weak) id<ProfileEducationDoneCancelDelegate> delegate;

@end
