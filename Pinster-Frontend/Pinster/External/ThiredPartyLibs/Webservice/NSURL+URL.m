//
//  NSURL+URL.m
//  NSURLTest
//
//  Created by MobileDev on 2/18/13.
//  Copyright (c) 2013 MobileDev. All rights reserved.
//

#import "NSURL+URL.h"

@implementation NSURL (URL)

+ (NSURL*)urlWithEncoding:(NSString*)urlString
{
    NSURL *urlStr = [NSURL URLWithString:urlString];
    return urlStr;
}

+ (NSURL*)fileURLWithEncoding:(NSString*)pathString
{
    NSURL *tempUrl  =  [self fileURLWithPath:[pathString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if(tempUrl==nil)
        tempUrl  =  [self fileURLWithPath:[pathString stringByReplacingPercentEscapesUsingEncoding:NSStringEncodingConversionAllowLossy]];
    else if(tempUrl == nil)
        tempUrl  =  [self fileURLWithPath:[pathString stringByReplacingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation]];
    return tempUrl;
}

+ (NSURL*)fileURLWithEncoding:(NSString*)pathString andDirectory:(BOOL)isDirectory
{
    NSURL *tempUrl = [NSURL fileURLWithPath:[pathString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] isDirectory:isDirectory];
    if(tempUrl == nil)
        tempUrl = [NSURL fileURLWithPath:[pathString stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionAllowLossy] isDirectory:isDirectory];
    else if(tempUrl == nil)
        tempUrl = [NSURL fileURLWithPath:[pathString stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation] isDirectory:isDirectory];
    return tempUrl;
}

+ (NSURL *)initFileURLWithPathEncoding:(NSString*)pathString andDirectory:(BOOL)isDirectory
{
    NSURL *tempUrl = [[NSURL alloc] initFileURLWithPath:[pathString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] isDirectory:isDirectory];
    if(tempUrl == nil)
        tempUrl = [[NSURL alloc] initFileURLWithPath:[pathString stringByReplacingPercentEscapesUsingEncoding:NSStringEncodingConversionAllowLossy] isDirectory:isDirectory];
    else if(tempUrl == nil)
        tempUrl = [[NSURL alloc] initFileURLWithPath:[pathString stringByReplacingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation] isDirectory:isDirectory];
    return tempUrl;
}

+ (NSURL *)initFileURLWithPathEncoding:(NSString*)pathString{
     NSURL *tempUrl = [[NSURL alloc] initFileURLWithPath:[pathString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if(tempUrl== nil)
        tempUrl = [[NSURL alloc] initFileURLWithPath:[pathString stringByReplacingPercentEscapesUsingEncoding:NSStringEncodingConversionAllowLossy]];
    else if(tempUrl == nil)
        tempUrl = [[NSURL alloc] initFileURLWithPath:[pathString stringByReplacingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation]];
    return  tempUrl;
}

@end
