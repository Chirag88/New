//
//  MSAUtils.h
//  MySchapp
//
//  Created by CK-Dev on 23/02/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MSAUtils : NSObject

+ (BOOL)validateEmail:(NSString *)email;
+ (BOOL)validatePassword:(NSString *)password;
+ (void)showAlertWithTitle: (NSString *) title message:(NSString *)message cancelButton:(NSString*)cancelTitle  otherButton:(NSString *) buttonTitle delegate:(id) sender;
+ (NSString *)convertNullToEmptyString:(NSString *)nullString;
+ (void)setNavigationBarAttributes:(UINavigationController *)navigationController;
+ (void)resetDefaults;
+ (CGFloat)getDeviceWidth;
+ (UIFont *)adjustFontSizeAccToScreenWidth:(UIFont *)font;
+ (NSDictionary *)getCountryCodeDictionary;
+ (NSDictionary *)getCountryFromLocalCodes;
@end
