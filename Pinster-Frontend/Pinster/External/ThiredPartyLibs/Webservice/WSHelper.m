//
//  WSHelper.m
//  Pinster
//
//  Created by Mobiledev on 28/05/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "WSHelper.h"
#import "AFNetworking.h"
#import "PSUtility.h"
@interface WSHelper()
@property(nonatomic, strong)NSOperationQueue *queueManager;
@end
@implementation WSHelper

+(WSHelper *)sharedInstance {
    static WSHelper *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] init];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    });
    return _sharedClient;
}


- (void)getArrayFromPostURL:(NSString *)url parmeters:(NSDictionary *)dicParams completionHandler:(void (^)(id result, NSString *url, NSError *error))block {
    
    NSData *data = nil;
    if(dicParams != nil) {
        NSString *stringData = [self prepareBody:dicParams];
        data = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    }
    NSString *urlString = nil;
    if([PSUtility isValidURL:url]) {
        urlString = url;
    } else {
        urlString = [NSString stringWithFormat:@"%@%@",kBaseUrl,url];
    }
    NSURL *URL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:120];
    [request setHTTPMethod:@"POST"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: data];
    dLog(@"URL: %@",[URL absoluteString]);
    dLog(@"Parameters: %@",dicParams);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"]; 
    self.queueManager = [NSOperationQueue new];
    AFHTTPRequestOperation *operation =
    [manager HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         dLog(@"Success %@", responseObject);
                                         block(responseObject,operation.response.URL.absoluteString,nil);
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         dLog(@"Failure %@", error.description);
                                         block(nil,operation.response.URL.absoluteString,error);
                                     }];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.queueManager addOperation:operation];
    [operation start];
    
}

- (void)getArrayFromGetURL:(NSString *)url parmeters:(NSDictionary *)dicParams completionHandler:(void (^)(id result, NSString *url, NSError *error))block {
    NSString *urlString = nil;
    if([PSUtility isValidURL:url]) {
        urlString = url;
    } else {
        urlString = [NSString stringWithFormat:@"%@%@",kBaseUrl,url];
    }
    NSURL *URL = [NSURL URLWithString:urlString];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    dLog(@"URL: %@",[URL absoluteString]);
    dLog(@"Parameters: %@",dicParams);
    [manager GET:[URL absoluteString] parameters:dicParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dLog(@"Success %@", responseObject);
        block((NSMutableArray *)responseObject,operation.response.URL.absoluteString,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dLog(@"Failure %@", error.description);
        block(nil,operation.response.URL.absoluteString,error);
    }];
}

- (void)getArrayFromPutURL:(NSString *)url parmeters:(NSDictionary *)dicParams completionHandler:(void (^)(id result, NSString *url, NSError *error))block
{
    NSData *data = nil;
    if(dicParams != nil)
    {
        NSString *stringData = [self prepareBody:dicParams];
        data = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    }
    NSString *urlString = nil;
    if([PSUtility isValidURL:url])
    {
        urlString = url;
    }
    else
    {
        urlString = [NSString stringWithFormat:@"%@%@",kBaseUrl,url];
    }
    NSURL *URL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:120];
    [request setHTTPMethod:@"PUT"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: data];
    dLog(@"URL: %@",[URL absoluteString]);
    dLog(@"Parameters: %@",dicParams);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    self.queueManager = [NSOperationQueue new];
    AFHTTPRequestOperation *operation =
    [manager HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         dLog(@"Success %@", responseObject);
                                         block(responseObject,operation.response.URL.absoluteString,nil);
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         dLog(@"Failure %@", error.description);
                                         block(nil,operation.response.URL.absoluteString,error);
                                     }];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.queueManager addOperation:operation];
    [operation start];
    
}
-(void)uploadFileWithURL:(NSString *)url withMethod:(NSString *)method withParmeters:(NSDictionary *)dicParams mediaData:(NSData *)fileData withKey:(NSString *)key completionHandler:(void (^)(id result, NSString *url, NSError *error))block {
    NSString *urlString = nil;
    if([PSUtility isValidURL:url]) {
        urlString = url;
    } else {
        urlString = [NSString stringWithFormat:@"%@%@",kBaseUrl,url];
    }
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSError *error;
    NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:method URLString:urlString parameters:dicParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        if (fileData == nil)
        {
            
        }
        else
        {
            [formData appendPartWithFileData:fileData name:key fileName:[NSString stringWithFormat:@"%f.jpg",[NSDate timeIntervalSinceReferenceDate]] mimeType:@"image/jpeg"];
        }
    } error:&error];
    if(error) {
        dLog(@"Failure %@", error.description);
        block(nil,urlString,error);
        return;
    }
    [request setTimeoutInterval:1000];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    self.queueManager = [NSOperationQueue new];
    AFHTTPRequestOperation *operation =
    [manager HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         dLog(@"Success %@", responseObject);
                                         block(responseObject,operation.response.URL.absoluteString,nil);
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         dLog(@"Failure %@", error.description);
                                         block(nil,operation.response.URL.absoluteString,error);
                                     }];
    
    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                        long long totalBytesWritten,
                                        long long totalBytesExpectedToWrite) {
//        loadBlock(bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
        NSLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    [self.queueManager addOperation:operation];
    [operation start];
}
- (NSString *)prepareBody:(NSDictionary *)dicParams {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicParams
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if(!jsonData) {
        return nil;
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    
}


- (void)cancelAllPreviousOperations {
    if(self.queueManager) {
        [self.queueManager cancelAllOperations];
    }
    
}

+ (BOOL)isInternetAvailable {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}
@end
