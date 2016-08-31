//
//  MSALabel.m
//  MySchapp
//
//  Created by CK-Dev on 04/06/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSALabel.h"
#import "MSAUtils.h"
@interface MSALabel() {
    
}
@property (nonatomic,assign) UIEdgeInsets insets;
@end
@implementation MSALabel


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}

- (void)setCustomEdgeInsets:(UIEdgeInsets) edgeInsets {
    self.insets = edgeInsets;
}

- (void)drawTextInRect:(CGRect)rect {
   
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect,self.insets)];
}

- (void)adjustFontSizeAccToScreenWidth:(UIFont *)font {
    
    [self setFont:[MSAUtils adjustFontSizeAccToScreenWidth:font]];
    
    
}
@end
