//
//  MSAEducationTableViewCell.m
//  MySchapp
//
//  Created by CK-Dev on 08/04/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSAEducationTableViewCell.h"

@implementation MSAEducationTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.qualificationLabel adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)qualificationDelete:(id)sender {
    [self.delegate deleteEducation:self];
}
@end
