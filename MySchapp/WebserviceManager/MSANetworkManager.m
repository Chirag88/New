//
//  MSAWebserviceManager.m
//  MySchapp
//
//  Created by CK-Dev on 23/02/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MSANetworkManager.h"
#import "UIActivityIndicatorView+AFNetworking.h"
#import "AFNetworking.h"

static MSANetworkManager *sharedObject = nil;
static dispatch_once_t dispatchToken;

@interface MSANetworkManager()
{
    NSOperationQueue *queue;
}

@end


@implementation MSANetworkManager

+ (id)sharedInstance
{
    dispatch_once(&dispatchToken, ^{
        sharedObject = [[self alloc] init];
    });
    
    return sharedObject;
}

- (void)createRequest:(MSARequest *)request inView:(UIView *)requestingView
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[request.urlString stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionAllowLossy]]];
    NSMutableURLRequest *aReq = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:1 timeoutInterval:30];
    [aReq setHTTPMethod:request.requestMethod];
    NSError *error;
    if (request.requestBody) {
        NSData *postData = [NSJSONSerialization dataWithJSONObject:request.requestBody options:0 error:&error];
        [aReq setHTTPBody:postData];
        NSString *postLength = [NSString stringWithFormat:@"%ld",(long)[postData length]];
        [aReq setValue:postLength forHTTPHeaderField:@"Content-Length"];
    }
    [aReq setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    for(NSString *key in request.requestHeaders)
    {
        [aReq setValue:[request.requestHeaders valueForKey:key] forHTTPHeaderField:key];
    }
    
    UIActivityIndicatorView *indctr = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    // change done to position the indicator at the center of the requesting view.
    indctr.frame = CGRectMake(requestingView.frame.size.width/2-10, requestingView.frame.size.height/2-10, 20, 20);
    indctr.transform = CGAffineTransformMakeScale(1.5, 1.5);
    
    indctr.hidesWhenStopped = YES;
    [requestingView addSubview:indctr];
    [indctr startAnimating];
    
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:aReq];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate didReceiveData:responseObject forRequest:request.identifier];
        [indctr stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%ldError",operation.response.statusCode);
        if (operation.response.statusCode == 400 || operation.response.statusCode == 401) {
            [self.delegate didReceiveData:operation.responseObject forRequest:request.identifier];
        }
        else {
            [self.delegate didFailWithError:error forRequest:request.identifier];
        }
        [indctr stopAnimating];
    }];
    [operation start];
    
    
    
    // NSURL Session
    
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
//    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSError *err;
//        NSLog(@"%@  --------error%@",[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err],error);
//        [self.delegate didReceiveData:data forRequest:request.identifier];
//        [indctr stopAnimating];
//        
//        
//    }];
//    
//    [postDataTask resume];
    
}

@end
