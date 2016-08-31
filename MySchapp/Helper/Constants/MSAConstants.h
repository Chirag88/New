//
//  MSAConstants.h
//  MySchapp
//
//  Created by CK-Dev on 23/02/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#ifndef MSAConstants_h
#define MSAConstants_h


#endif /* MSAConstants_h */


#define UISTORYBOARD [UIStoryboard storyboardWithName:@"Main" bundle: nil]


#pragma mark - Application Urls
// URLS
#define BASEURL                         @"http://50.168.110.172:1487/schmobileapp/"
#define SIGNUPURL                       @"loginsignup/A26"
#define VERIFYOTPURL                    @"loginsignup/A27"
#define REFRESHTOKENLOGINURL            @"oauth/token"
#define PLANURL                         @"rest/S99"
#define PERSONALURL                     @"rest/S28"
#define SECURITYURL                     @"rest/S29"
#define ACCEPTASSOCIATIONURL            @"rest/S22"
#define NOTIFICATIONURL                 @"rest/S30"
#define NOTIFICATIONSAVEPAYMENTURL      @"rest/S31"
#define PAYMENTURL                      @"rest/S32"
#define REACCEPTURL                     @"rest/S33"
#define LANGUAGESURL                    @"rest/S36"
#define DISABLEACCOUNTURL               @"rest/S37"
#define LOGOUTURL                       @"rest/S38"
#define SKIPCONTINUEURL                 @"rest/S39"
#define PRIVACYPOLICYURL                @"rest/A15"
#define TERMSCONDITIONURL               @"rest/A14"
#define FORGOTPASSWORDURL               @"rest/A23"
#define FORGOTPASSSECUIRTYURL           @"rest/A24"
#define CHANGEPWDURL                    @"rest/A25"
#define SUBCATURL                       @"rest/A33"
#define CATURL                          @"rest/A11"
#define SEARCHURL                       @"rest/A16"
#define COUNTRYLISTURL                  @"rest/A17"
#define ADDRESSSEARCHURL                @"rest/A13"

#define kLoginServiceClientID           @"mysupplycompany"
#define kLoginServiceClientSecret       @"mycompanykey"
#define kLoginServiceGrantType          @"password"
#define kLoginServiceScope              @"read write trust"
#define kAccessTokenServiceGrantType    @"refresh_token"

#define kAccessTokenIdentifier          @"AccessToken"


#pragma mark - login service keys
// Login service response keys
#define kRefreshToken                           @"refresh_token"
#define kAccessToken                            @"access_token"
#define kAccessTokenType                        @"token_type"
#define kAccessTokenExpiresIn                   @"expires_in"
#define kLoginScope                             @"scope"
#define kFirstTimeLogin                         @"ftl"
#define kFirstTimeLoginValue                    @"First time login"
#define kCountryList                            @"countrylist"
#define kUserRole                               @"role"
#define kProfileStatus                          @"ps"
#define kPID                                    @"pid"
#define kPName                                  @"pname"
#define kSelectedCountry                        @"sc"
#define kAppVersion                             @"version"
#define kAssociationList                        @"associations"
#define kBlockedFlag                            @"bl"
#define kPaymentRequiredFlag                    @"pr"
#define kReacceptTermsFlag                      @"rt"
#define kPaymentDueFlag                         @"pd"

#define kRefreshTokenExpiresIn                   86400

#pragma mark - Userdefaults keys
#define kDefaultsRefreshToken                   @"refresh_token"
#define kDefaultsAccessToken                    @"access_token"
#define kDefaultsAccessTokenType                @"token_type"
#define kDefaultsAccessTokenExpiresIn           @"accTokExpires_in"
#define kDefaultsRefreshTokenExpiresIn          @"refTokExpires_in"
#define kDefaultsLoginScope                     @"scope"
#define kDefaultsAccessTokenReceivedTime        @"accessTokenReceivedTime"
#define kDefaultsRefreshTokenReceivedTime       @"refreshTokenReceivedTime"
#define kDefaultsAccessTokenType                @"token_type"
#define kDefaultsUserRole                       @"role"
#define kDefaultsProfileStatus                  @"ps"
#define kDefaultsCountryList                    @"countryList"
#define kDefaultsFirstTimeLogin                 @"ftl"
#define kDefaultsPID                            @"pid"
#define kDefaultsPName                          @"pname"
#define kDefaultsHigherPlanSelected             @"higherPlanSelected"

#define kDefaultsSelectedCountry                        @"sc"
#define kDefaultsAppVersion                     @"version"
#define kDefaultsAssociationList                @"associationsList"
#define kDefaultsBlockedFlag                    @"bl"
#define kDefaultsPaymentRequiredFlag            @"pr"
#define kDefaultsReacceptTermsFlag              @"rt"
#define kDefaultsPaymentDueFlag                 @"pd"


#pragma mark - application fonts/colors
// Login Signup screen color fonts
#define kUrlFontColor                           [UIColor colorWithRed:2.0/255.0 green:136/255.0 blue:209.0/255.0 alpha:1.0]
#define kLoginSignUpMsgFont                     [UIFont fontWithName:@"Helvetica Neue" size:14]
#define kLoginSignUpMsgFontColor                [UIColor darkGrayColor]
#define kMyschappFont                           [UIFont fontWithName:@"BoldBrush" size:16]
#define kMyschappFontColor                      [UIColor colorWithRed:2.0/255.0 green:42/255.0 blue:90.0/255.0 alpha:1.0]

//Plan screen color fonts
#define kPlanCellBackGroundColor                [UIColor colorWithRed:125.0/255.0 green:214/255.0 blue:227.0/255.0 alpha:1.0]
#define kPlanNameColor                          [UIColor colorWithRed:4/255.0 green:31/255.0 blue:65/255.0 alpha:1.0]
#define kPlanDescColor                          [UIColor colorWithRed:19/255.0 green:69/255.0 blue:110/255.0 alpha:1.0]


#define kPlanDetailCellDarkBackColor                [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]
#define kPlanDetailCellLightBackColor               [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]
#define kPlanDetailCompareBtnBackColor              [UIColor colorWithRed:223.0/255.0 green:245.0/255.0 blue:248.0/255.0 alpha:1.0]


#define kPlanNameFont                           [UIFont fontWithName:@"Helvetica-Bold" size:19]
#define kPlanDescFont                           [UIFont fontWithName:@"Helvetica" size:16]
#define kPlanPriceFont                          [UIFont fontWithName:@"Helvetica" size:18]
#define kPlanFeatureFont                        [UIFont fontWithName:@"Helvetica" size:13]
#define kComparePlanSelectorFont                [UIFont fontWithName:@"Helvetica" size:17]

#define kAlertHigherPlanMessage          @"MySchapp support team will connect with you for customizing your plan, till then choose any paid plan and complete your profile."

#pragma mark - screens keys
// Login Decision - Navigation Screens
#define kCountrySelectionScreen         @"CountrySelectionScreen"
#define kLandingPageWithoutLoginSignup  @"LandingPageWithoutLoginSignup"
#define kLandingPageWithLoginSignup     @"LandingPageWithLoginSignup"
#define kLoginScreen                    @"LoginScreen"
#define kAssociationScreen              @"AssociationScreen"
#define kReacceptTermsScreen            @"ReacceptTermsScreen"
#define kPaymentScreen                  @"PaymentScreen"
#define kConsumerLandingScreen          @"ConsumerLandingScreen"

#define kTokensAreValid                 @"TokensAreValid"



#pragma mark - ALertView
// AlertView Messages
#define kAlertInternalErrorMsg          @"Internal error, Please try later."
#define kAlertBlockedUserMsg            @"Your account is disable, Are you sure you want to re-enable your and all other accounts associated with you."

// AlertView Titles
#define kAlertBlockedTitle              @"User Blocked"
#define kAlertMessageTitle              @"Message"

// AlertView Button Titles
#define kAlertOkButtonTitle             @"Ok"
#define kAlertCancelButtonTitle         @"Cancel"

// Profile data Keys
#define kProfileEmail               @"email"
#define kProfileMobile              @"mobile"
#define kProfilePhone               @"phone"
#define kProfileGender              @"gender"
#define kProfileBillingType         @"billingType"
#define kProfileSelectedCurrency    @"selectedCurrency"
#define kProfileWorkExperience      @"workexperience"
#define kProfileSelectedLanguages   @"selectedLanguages"
#define kProfileListofCert          @"listofCert"
#define kProfileState               @"state"
#define kProfileCountry             @"country"
#define kProfileFname               @"fname"
#define kProfileMname               @"mname"
#define kProfileLname               @"lname"
#define kProfileZip                 @"zip"
#define kProfileAddress1            @"address1"
#define kProfileAddress2            @"address2"
#define kProfileCity                @"city"
#define kProfileTaxid               @"taxid"
#define kProfileCname               @"cname"
#define kProfileDuns                @"duns"
#define kProfileDob                 @"dob"
#define kProfileCountryId           @"countryCodeId"
#define kProfilePlanId              @"planId"

#define kProfileLanguagesKey        @"languages"


// profile segment color

#define kProfileSegmentFont                 [UIFont fontWithName:@"Helvetica-Bold" size:15]
#define kProfileSegmentSelectedFontColor    [UIColor colorWithRed:93.0/255.0 green:204/255.0 blue:220.0/255.0 alpha:1.0]
#define kProfileSegmentDefaultFontColor     [UIColor colorWithRed:185.0/255.0 green:230.0/255.0 blue:238.0/255.0 alpha:1.0]
#define kProfileRowBackColor                [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]
#define kProfileSelPlanColor                [UIColor colorWithRed:2.0/255.0 green:136.0/255.0 blue:209.0/255.0 alpha:1.0]
#define kProfilePrivacyBtnColor             [UIColor colorWithRed:93.0/255.0 green:204.0/255.0 blue:220.0/255.0 alpha:1.0]
#define kProfileAddPhotoColor               [UIColor colorWithRed:166.0/255.0 green:167.0/255.0 blue:167.0/255.0 alpha:1.0]


#define kMySchappLightBlueColor             [UIColor colorWithRed:93.0/255.0 green:204.0/255.0 blue:220.0/255.0 alpha:1.0]
#define kMySchappMediumBlueColor            [UIColor colorWithRed:2.0/255.0 green:136.0/255.0 blue:209.0/255.0 alpha:1.0]
#define kMySchappDarkBlueColor              [UIColor colorWithRed:0.0/255.0 green:42.0/255.0 blue:92.0/255.0 alpha:1.0]

