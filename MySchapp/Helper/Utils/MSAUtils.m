//
//  MSAUtils.m
//  MySchapp
//
//  Created by CK-Dev on 23/02/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSAUtils.h"
#import "MSAConstants.h"

@implementation MSAUtils

+ (BOOL)validateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)validatePassword:(NSString *)password {
    NSString *pwdRegex = @"^(?=.{10,})(?=.*[0-9])(?=.*[a-zA-Z])([@#$%^&=a-zA-Z0-9_-]+)$";//@"^(?=.{2,8}$)(?=.*?[A-Za-z0-9])(?=.*?[\W_])[\w\W]+";
    
   
    
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdRegex];
    
    return [pwdTest evaluateWithObject:password];
}

+ (void)showAlertWithTitle: (NSString *) title message:(NSString *)message cancelButton:(NSString*)cancelTitle otherButton:(NSString *) buttonTitle delegate:(id) sender {
    //ios 8 and below
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:sender cancelButtonTitle:cancelTitle otherButtonTitles:buttonTitle, nil];
    
    [alert show];
    
    // ios 8 and later
//    UIAlertController* alertC = [UIAlertController alertControllerWithTitle:title
//                                                                   message:message
//                                                            preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action) {}];
//    
//    
//    [alertC addAction:defaultAction];
//    
//    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleCancel
//                                                          handler:^(UIAlertAction * action) {}];
//    
//    
//    [alertC addAction:cancelAction];
//    [sender presentViewController:alertC animated:YES completion:nil];
}

+ (NSString *)convertNullToEmptyString:(NSString *)nullString {
    if ([nullString isKindOfClass:[NSNull class]]) {
        nullString = @"";
        return nullString;
    }
    return nullString;
    
}

+ (void)setNavigationBarAttributes:(UINavigationController*) navigationController{
    navigationController.navigationBar.barTintColor = kMySchappDarkBlueColor;
    navigationController.navigationBar.translucent = NO;
    navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

+ (void)resetDefaults {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}

+(CGFloat)getDeviceWidth
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    return screenBounds.size.width;
}

+(UIFont *)adjustFontSizeAccToScreenWidth:(UIFont *)font {
    
    CGFloat screenWidth = [MSAUtils getDeviceWidth];
    UIFont *fontUpdated;
    if(screenWidth == 320) {
        CGFloat fontSize = font.pointSize - 2.0;
        fontUpdated = [UIFont fontWithName:font.fontName size:fontSize];
        return fontUpdated;
    }
    return font;
    
}

+ (NSDictionary *)getCountryCodeDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:@"972", @"IL",
            @"93", @"AF", @"355", @"AL", @"213", @"DZ", @"1", @"AS",
            @"376", @"AD", @"244", @"AO", @"1", @"AI", @"1", @"AG",
            @"54", @"AR", @"374", @"AM", @"297", @"AW", @"61", @"AU",
            @"43", @"AT", @"994", @"AZ", @"1", @"BS", @"973", @"BH",
            @"880", @"BD", @"1", @"BB", @"375", @"BY", @"32", @"BE",
            @"501", @"BZ", @"229", @"BJ", @"1", @"BM", @"975", @"BT",
            @"387", @"BA", @"267", @"BW", @"55", @"BR", @"246", @"IO",
            @"359", @"BG", @"226", @"BF", @"257", @"BI", @"855", @"KH",
            @"237", @"CM", @"1", @"CA", @"238", @"CV", @"345", @"KY",
            @"236", @"CF", @"235", @"TD", @"56", @"CL", @"86", @"CN",
            @"61", @"CX", @"57", @"CO", @"269", @"KM", @"242", @"CG",
            @"682", @"CK", @"506", @"CR", @"385", @"HR", @"53", @"CU",
            @"537", @"CY", @"420", @"CZ", @"45", @"DK", @"253", @"DJ",
            @"1", @"DM", @"1", @"DO", @"593", @"EC", @"20", @"EG",
            @"503", @"SV", @"240", @"GQ", @"291", @"ER", @"372", @"EE",
            @"251", @"ET", @"298", @"FO", @"679", @"FJ", @"358", @"FI",
            @"33", @"FR", @"594", @"GF", @"689", @"PF", @"241", @"GA",
            @"220", @"GM", @"995", @"GE", @"49", @"DE", @"233", @"GH",
            @"350", @"GI", @"30", @"GR", @"299", @"GL", @"1", @"GD",
            @"590", @"GP", @"1", @"GU", @"502", @"GT", @"224", @"GN",
            @"245", @"GW", @"595", @"GY", @"509", @"HT", @"504", @"HN",
            @"36", @"HU", @"354", @"IS", @"91", @"IN", @"62", @"ID",
            @"964", @"IQ", @"353", @"IE", @"972", @"IL", @"39", @"IT",
            @"1", @"JM", @"81", @"JP", @"962", @"JO", @"77", @"KZ",
            @"254", @"KE", @"686", @"KI", @"965", @"KW", @"996", @"KG",
            @"371", @"LV", @"961", @"LB", @"266", @"LS", @"231", @"LR",
            @"423", @"LI", @"370", @"LT", @"352", @"LU", @"261", @"MG",
            @"265", @"MW", @"60", @"MY", @"960", @"MV", @"223", @"ML",
            @"356", @"MT", @"692", @"MH", @"596", @"MQ", @"222", @"MR",
            @"230", @"MU", @"262", @"YT", @"52", @"MX", @"377", @"MC",
            @"976", @"MN", @"382", @"ME", @"1", @"MS", @"212", @"MA",
            @"95", @"MM", @"264", @"NA", @"674", @"NR", @"977", @"NP",
            @"31", @"NL", @"599", @"AN", @"687", @"NC", @"64", @"NZ",
            @"505", @"NI", @"227", @"NE", @"234", @"NG", @"683", @"NU",
            @"672", @"NF", @"1", @"MP", @"47", @"NO", @"968", @"OM",
            @"92", @"PK", @"680", @"PW", @"507", @"PA", @"675", @"PG",
            @"595", @"PY", @"51", @"PE", @"63", @"PH", @"48", @"PL",
            @"351", @"PT", @"1", @"PR", @"974", @"QA", @"40", @"RO",
            @"250", @"RW", @"685", @"WS", @"378", @"SM", @"966", @"SA",
            @"221", @"SN", @"381", @"RS", @"248", @"SC", @"232", @"SL",
            @"65", @"SG", @"421", @"SK", @"386", @"SI", @"677", @"SB",
            @"27", @"ZA", @"500", @"GS", @"34", @"ES", @"94", @"LK",
            @"249", @"SD", @"597", @"SR", @"268", @"SZ", @"46", @"SE",
            @"41", @"CH", @"992", @"TJ", @"66", @"TH", @"228", @"TG",
            @"690", @"TK", @"676", @"TO", @"1", @"TT", @"216", @"TN",
            @"90", @"TR", @"993", @"TM", @"1", @"TC", @"688", @"TV",
            @"256", @"UG", @"380", @"UA", @"971", @"AE", @"44", @"GB",
            @"1", @"US", @"598", @"UY", @"998", @"UZ", @"678", @"VU",
            @"681", @"WF", @"967", @"YE", @"260", @"ZM", @"263", @"ZW",
            @"591", @"BO", @"673", @"BN", @"61", @"CC", @"243", @"CD",
            @"225", @"CI", @"500", @"FK", @"44", @"GG", @"379", @"VA",
            @"852", @"HK", @"98", @"IR", @"44", @"IM", @"44", @"JE",
            @"850", @"KP", @"82", @"KR", @"856", @"LA", @"218", @"LY",
            @"853", @"MO", @"389", @"MK", @"691", @"FM", @"373", @"MD",
            @"258", @"MZ", @"970", @"PS", @"872", @"PN", @"262", @"RE",
            @"7", @"RU", @"590", @"BL", @"290", @"SH", @"1", @"KN",
            @"1", @"LC", @"590", @"MF", @"508", @"PM", @"1", @"VC",
            @"239", @"ST", @"252", @"SO", @"47", @"SJ", @"963", @"SY",
            @"886", @"TW", @"255", @"TZ", @"670", @"TL", @"58", @"VE",
            @"84", @"VN", @"1", @"VG", @"1", @"VI", nil];
}

+(NSDictionary *)getCountryFromLocalCodes {
    return [NSDictionary dictionaryWithObjectsAndKeys:@"US",@"101",@"IN",@"102",
            @"GB",@"103",@"AU",@"104",nil];
}

/*
 + (NSString *)stringFromArray:(NSArray *)list {
 NSString *concatString;
 for (NSInteger i = 0; i<list.count; i++) {
 concatString = [concatString stringByAppendingString:[list objectAtIndex:i]];
 }
 return concatString;
 }
 
 + (id)arrayFromString:(NSString *)list {
 NSArray *stringArray;
 stringArray = [list componentsSeparatedByString:@","];
 
 return stringArray;
 }
 
 + (NSArray *)arrayFromArray:(NSArray *)list {
 NSMutableArray *tempArr = [[NSMutableArray alloc]init];
 
 for (NSInteger i = 0; i<list.count; i++) {
 [tempArr addObject:[list objectAtIndex:i]];
 }
 return tempArr;
 }
 */


@end
