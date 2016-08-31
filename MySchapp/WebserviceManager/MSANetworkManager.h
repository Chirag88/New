//
//  MSAWebserviceManager.h
//  MySchapp
//
//  Created by CK-Dev on 23/02/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MSARequest.h"

@protocol MSAConnectionDelegate <NSObject>

- (void)didReceiveData:(NSData *)responseData forRequest:(NSString *)requestId;
- (void)didFailWithError:(NSError *)error forRequest:(NSString *)requestId;

@end

@interface MSANetworkManager : NSObject<NSURLSessionDataDelegate>

/*!
 * @brief delegate to cater network response.
 */
@property (nonatomic, strong) id<MSAConnectionDelegate> delegate;

/*!
 * @discussion initialization method to get an object of the class.
 * @return The object of the class
 */
+ (id)sharedInstance;

/*!
 * @discussion To initiate a network request.
 * @param request An MSARequest object which contains the details of request parameters
 */
- (void)createRequest:(MSARequest *)request inView:(UIView *)requestingView;

@end
