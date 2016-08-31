//
//  MSALoginDecision.h
//  MySchapp
//
//  Created by CK-Dev on 3/17/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSANetworkHandler.h"
#import "MSAProtocols.h"

@interface MSALoginDecision : NSObject<MSANetworkDelegate,NSURLSessionDelegate>

@property (nonatomic, weak) id<LoginDecisionDelegate> delegate;

- (void)checkLoginCriteriaWhileLaunching;
- (void)checkLoginCriteria;
- (void)checkTokensValidityWithRequestID:(NSString *)requestID;

@end
