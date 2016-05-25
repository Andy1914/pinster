//
//  DAOrderModel.h
//  DeafAidNew
//
//  Created by MobileDev on 24/05/14.
//  Copyright (c) 2014 companyname. All rights reserved.
//

#import <Foundation/Foundation.h>
#define PIN_DETAILS        @"pinDetails"
#define PIN_ID          @"id"

#define RECEIVED_PIN_ID          @"received_pin_id"

#define PIN_NAME        @"title"
#define PIN_MESSAGE        @"message"
#define PIN_DATE        @"date"
#define PIN_OWNER       @"owner_id"
#define PIN_OWNER_NAME       @"owner_name"
#define PIN_IS_SHARED   @"is_shared"
#define PIN_LAT         @"longitude"
#define PIN_LANG        @"latitude"
#define PIN_IS_LIKED    @"is_liked"

#define PIN_IS_SHAREABLE     @"is_shareable"

#define PIN_LIKED_USERS @"pin_likes"
#define PIN_CATEGORY    @"category_id"
#define PIN_LOCATION    @"location"
#define PIN_SHARED_USERS    @"shared_users"
#define SNAP_IMAGE_NAME        @"shared_picture"



@interface PSPinModel : NSObject
@property (nonatomic, strong) NSString *pinName;
@property (nonatomic, strong) NSString *pinMessage;
@property (nonatomic, strong) NSString *pinId, *receivedPinID, *pinIsShareable;
@property (nonatomic, strong) NSString *pinDateFullString;
@property (nonatomic, strong) NSDate *pinDate;
@property (nonatomic, strong) NSString *pinDateString;
@property (nonatomic, strong) NSString *pinTimeString;
@property (nonatomic, strong) NSString *pinOwner;
@property (nonatomic, strong) NSString *pinOwnerName;
@property (nonatomic, readwrite) BOOL pinIsShared;
@property (nonatomic, readwrite) BOOL pinIsLiked;
@property (nonatomic, strong) NSString *pinLat;
@property (nonatomic, strong) NSString *pinLang;
@property (nonatomic, strong) NSString *pinCategory;
@property (nonatomic, strong) NSString *pinLocation;
@property (nonatomic, strong) NSMutableArray *pinLikedUsersList;
@property (nonatomic, strong) NSMutableArray *pinSharedUsersList;
@property (nonatomic, strong) NSString *snapImageUrl;

-(id)initWithDictonery:(NSDictionary *)dict;
+ (NSMutableArray *)getPinModelsArrayFromArray:(NSArray *)dataArray;
@end
