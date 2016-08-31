//
//  MSAMySchappProfileTableViewCell.m
//  MySchapp
//
//  Created by CK-Dev on 09/08/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSAServiceProfileTableViewCell.h"

@implementation MSAServiceProfileTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.serviceProfileList adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
