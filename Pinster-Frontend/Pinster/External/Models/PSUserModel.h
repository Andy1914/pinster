//
//  PSUserModel.h
//  Pinster
//
//  Created by Mobiledev on 29/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kUserIdKey      @"id"
#define kUser_IdKey      @"user_id"
#define kEmailKey       @"email"
#define kPasswordKey    @"password"
#define kMobileKey      @"mobile"
#define kNameKey        @"name"
#define kDOBKey         @"date_of_birth"
#define kProfileImageKey @"profile_picture"
#define kFacebookIdKey     @"uid"
#define kMobileVerificationCodeKey @"mobile_code"
#define kMobileVerificationStatusKey @"mobile_verification_status"
#define kMobileNumberKey      @"mobile_number"

@interface PSUserModel : NSObject
@property (nonatomic, strong) NSString *psUserId;
@property (nonatomic, strong) NSString *psEmail;
@property (nonatomic, strong) NSString *psPassword;
@property (nonatomic, strong) NSString *psMobile;
@property (nonatomic, strong) NSString *psName;
@property (nonatomic, strong) NSString *psDOB;
@property (nonatomic, strong) NSString *psProfilePic;
@property (nonatomic, strong) NSString *psFBId;
@property (nonatomic, strong) NSString *psVerificationCode;
@property (nonatomic, strong) NSString *psVerificationStatus;
-(id)initWithDictonery:(NSDictionary *)userData;
@end
