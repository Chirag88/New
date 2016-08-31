//
//  MSANetworkHandler.m
//  MySchapp
//
//  Created by CK-Dev on 23/02/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSANetworkHandler.h"
#import "AppDelegate.h"
#import "MSAConstants.h"

@implementation MSANetworkHandler

/**************************************************************************
 // Create request to download data from server
 **************************************************************************/
- (void)createRequestForURLString:(NSString *)urlString withIdentifier:(NSString *)requestId requestHeaders:(NSDictionary *)reqHeaders andRequestParameters:(NSDictionary *)parameters inView:(UIView *)requestingView
{
    MSARequest *request = [[MSARequest alloc] init];
    request.urlString = urlString;
    request.identifier = requestId;
    request.requestMethod = @"POST";
    request.requestBody = parameters;
    if(reqHeaders)
        request.requestHeaders = reqHeaders;
   // request.baseURL = BASE_URL;
    
    MSANetworkManager *obj=[MSANetworkManager sharedInstance];
    obj.delegate=self;
    [obj createRequest:request inView:requestingView];
    
}
#pragma NetwokManagerDelegate

/**************************************************************************
 // Delegate methods for the network manager.
 **************************************************************************/
- (void)didReceiveData:(NSData *)responseData forRequest:(NSString *)requestId
{
    if([self.delegate respondsToSelector:@selector(didReceiveData:forRequest:)])
        [self.delegate didReceiveData:responseData forRequest:requestId];
}

- (void)didFailWithError:(NSError *)error forRequest:(NSString *)requestId
{
    if([self.delegate respondsToSelector:@selector(didFailWithError:forRequest:)])
        [self.delegate didFailWithError:error forRequest:requestId];
}

@end
