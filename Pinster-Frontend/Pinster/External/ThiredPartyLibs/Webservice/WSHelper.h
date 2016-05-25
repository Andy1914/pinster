//
//  WSHelper.h
//  Pinster
//
//  Created by Mobiledev on 28/05/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface WSHelper : NSObject
+ (WSHelper *)sharedInstance;

- (void)getArrayFromPostURL:(NSString *)url parmeters:(NSDictionary *)dicParams completionHandler:(void (^)(id result, NSString *url, NSError *error))block;
- (void)getArrayFromGetURL:(NSString *)url parmeters:(NSDictionary *)dicParams completionHandler:(void (^)(id result, NSString *url, NSError *error))block;
- (void)getArrayFromPutURL:(NSString *)url parmeters:(NSDictionary *)dicParams completionHandler:(void (^)(id result, NSString *url, NSError *error))block;

-(void)uploadFileWithURL:(NSString *)url withMethod:(NSString *)method withParmeters:(NSDictionary *)dicParams mediaData:(NSData *)fileData withKey:(NSString *)key completionHandler:(void (^)(id result, NSString *url, NSError *error))block;
- (void)cancelAllPreviousOperations;
+ (BOOL)isInternetAvailable;

@end
