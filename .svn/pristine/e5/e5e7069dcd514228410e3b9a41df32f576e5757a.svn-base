//
//  MSANetworkHandler.h
//  MySchapp
//
//  Created by CK-Dev on 23/02/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSANetworkManager.h"

@protocol MSANetworkDelegate <NSObject>

- (void)didReceiveData:(NSData *)responseData forRequest:(NSString *)requestId;
- (void)didFailWithError:(NSError *)error forRequest:(NSString *)requestId;

@end

@interface MSANetworkHandler : NSObject <MSAConnectionDelegate>

/*!
 * @brief delegate to cater network response.
 */
@property (strong, nonatomic) id delegate;

/*!
 * @discussion To create and initiate a network request.
 * @param urlString the url to be called
 * @param reqHeaders the dictionary containing header key value pair
 * @param requestId the identifier for a request
 */
- (void)createRequestForURLString:(NSString *)urlString withIdentifier:(NSString *)requestId requestHeaders:(NSDictionary *)reqHeaders andRequestParameters:(NSDictionary *)parameters inView:(UIView *)requestingView;

@end
