//
//  PSUserModel.m
//  Pinster
//
//  Created by Mobiledev on 29/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSUserModel.h"

@implementation PSUserModel

-(id)initWithDictonery:(NSDictionary *)userData {
    self = [super init];
    if(self) {
        [self fillDataIntoUserModel:userData];
    }
    return self;
}

- (void)fillDataIntoUserModel:(NSDictionary *)userData {
    self.psUserId = [userData valueForKey:kUserIdKey];
    self.psEmail = [userData valueForKey:kEmailKey];
    self.psPassword = [userData valueForKey:kPasswordKey];
    self.psMobile = [userData valueForKey:kMobileKey];
    self.psName = [userData valueForKey:kNameKey];
    self.psDOB = [userData valueForKey:kDOBKey];
    self.psProfilePic = [userData valueForKey:kProfileImageKey];
    self.psFBId = [userData valueForKey:kFacebookIdKey];
    self.psVerificationCode = [userData valueForKey:kMobileVerificationCodeKey];
    self.psVerificationStatus = [userData valueForKey:kMobileVerificationStatusKey];
}
@end
