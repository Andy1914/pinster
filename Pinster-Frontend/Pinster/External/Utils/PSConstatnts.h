//
//  PSConstatnts.h
//  Pinster
//
//  Created by Mobiledev on 25/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSConstatnts : NSObject

#define kUserDetailsKey    @"USER_DETAILS"
#define KDataKey           @"data"
#define kMessageKey        @"message"
#define kSuccessKey        @"success"


#define kMyPinsKey        @"my_pins"
#define kReceivedPinsKey        @"shared_with_me"


//#define kBaseOnlineUrl @"http://54.183.73.230/api/"

// Old Url
//#define kBaseOnlineUrl @"http://54.183.78.243/api/"

// New Url
#define kBaseOnlineUrl @"http://54.183.220.28/api/"

#define kBaseLocalUrl   @"http://192.168.0.106:3000/api/"
#define kBaseUrl    kBaseOnlineUrl

//#define kBaseImageOnlineUrl @"http://54.183.73.230"
//#define kBaseImageOnlineUrl @"http://54.183.78.243"

#define kBaseImageOnlineUrl @"http://54.183.220.28"

#define  kGetContactDetail  @"get_contact_detail"
#pragma mark - User & Authentication

#define kRegistrationApi @"user_create"
#define kLoginWithEmailApi @"users/sign_in"
#define kLoginWithFacebookApi @"facebook_login"
#define kGenerateVerificationCodeApi @"update_mobile"
#define kVerificationStatus @"mobile_verification"
#define kForgetPasswordApi @"send_reset_pasword"

#pragma mar - Pins
#define kAddPinApi @"add_pin"

#define kAddPinLaterApiForGroup @"share_this_pin"

#define kAddPinLaterApi @"share_pin"

#define kListOfPinApi @"pins"
#define kListOfReceivedPins @"received_pins"
#define kPinDetailsApi @"pins/"// optional if all detailes available in list per pin
#define kLikePinApi @"pin_likes"
#define kMarkAsShareApi @""
#define kCategoriesApi  @"categories"
#define kGetGroups  @"user_groups"
#define kBookmarkApi @"pins/"
//#define kRemoveBookmark @"remove_bookmark"

#define kRemoveBookmark @"delete_pin"

#define kRemoveReceivedPin @"delete_received_pin"

#define kCheckPinsterUserOrNot   @"user_mutual_share"

#define kCheckUserExistsApi @""
#define kCheckUserExists @"check_exist_user"
#define kInviteContactApi @""
#define kInviteContact @"invite_contact"

#pragma mark - Friends List
#define kFriendsListApi @""

#pragma mark - Change Password
#define kChangePasswordApi @"update_user"

#pragma mark - Change MobileNumber
#define kChangeMobileNumberApi @""

#pragma mark - Get Profile
#define kProfileApi @""

#pragma mark - Update Profile
#define kUpdateProfileApi @"update_user"

#pragma mark - Notifications
#define kNotificationsApi @"notifications"
#define kRequestAcceptOrRejectApi @"change_status"

#define KpushNotificationToken @"token"
#define KpushNotificationData @"push_data"

@end
