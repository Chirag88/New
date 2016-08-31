//
//  MSAAssociationTableViewCell.m
//  MySchapp
//
//  Created by CK-Dev on 04/30/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSAAssociationTableViewCell.h"


@implementation MSAAssociationTableViewCell

- (void)awakeFromNib {
    // Initialization code
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(radioTapped:)];
//    [self.radioImage setUserInteractionEnabled:YES];
//    [self.radioImage addGestureRecognizer:tap];
    [self.fromLabel adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
    [self.typeLabel adjustFontSizeAccToScreenWidth:[UIFont systemFontOfSize:16]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)radioTapped:(UITapGestureRecognizer *)recognizer
//{
//    UIImageView *imageView = (UIImageView *)recognizer.view;
//    if(imageView.highlighted)
//    {
//        imageView.highlighted = NO;
//    }
//    else
//    {
//        imageView.highlighted = YES;
//    }
//    [self.delegate selectedAssociation:self];
//}

@end
