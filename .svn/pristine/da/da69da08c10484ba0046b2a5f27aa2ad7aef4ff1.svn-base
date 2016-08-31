//
//  MSAProtocols.h
//  MySchapp
//
//  Created by CK-Dev on 07/03/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#ifndef MSAProtocols_h
#define MSAProtocols_h


#endif /* MSAProtocols_h */

@protocol LoginSignupDismissHandler <NSObject>

- (void)controllerGotDissmissed:(UIViewController *)controller;

@end

@protocol LoginDecisionDelegate <NSObject>

- (void)redirectToPage:(NSString *)pageToBeOpened;

@end

@protocol PlanSelectionDelegate <NSObject>
@required
- (void)selectedPlan:(NSString *)planId andPlanName:(NSString *)planName;
- (void)viewPlanDetail:(id)plan;

@end


@protocol ProfileLanguageDoneCancelDelegate <NSObject>

- (void)languageDoneClickedWithValues:(NSArray *)newLanguages;

@end

@protocol ProfileEducationDoneCancelDelegate <NSObject>

- (void)educationDoneClickedWithValues:(NSArray *)newEducation;

@end

@protocol DeleteEducationFromListDelegate <NSObject>

- (void)deleteEducation:(id)cell;

@end

@protocol SelectedQuestionDelegate <NSObject>

- (void)selectedQuestion:(NSString *)questionText withViewTag:(NSInteger) tag;

@end

@protocol SubCategoryDelegate <NSObject>

- (void)didSelectSubCategory:(NSString *)subCatId;

@end

@protocol AssociationSelectionDelegate <NSObject>
@required
- (void)selectedAssociation:(id)association;

@end

@protocol LocationChangeDelegate <NSObject>

- (void)didSelectedLocation:(NSString *)location;

@end

