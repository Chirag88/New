//
//  MSAMySchappProfileTableViewCell.h
//  MySchapp
//
//  Created by CK-Dev on 09/08/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSALabel.h"

@interface MSAMySchappProfileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet MSALabel *itemLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;
@end
