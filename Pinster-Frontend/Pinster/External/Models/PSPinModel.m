//
//  DAOrderModel.m
//  DeafAidNew
//
//  Created by MobileDev on 24/05/14.
//  Copyright (c) 2014 companyname. All rights reserved.
//

#import "PSPinModel.h"

@implementation PSPinModel
@synthesize  pinDateFullString,pinIsShared,pinDateString,pinLang,pinLat,pinLikedUsersList,pinName,pinOwner,pinTimeString,pinDate;

-(id)initWithDictonery:(NSDictionary *)dict {
    self = [super init];
    if(self) {
        [self setPinFromDictonery:dict];
    }
    return self;

}

- (void)setPinFromDictonery:(NSDictionary *)dict {
    self.pinName = [dict valueForKey:PIN_NAME];
    
    self.receivedPinID =  [dict valueForKey:RECEIVED_PIN_ID];
    
    self.pinId =  [dict valueForKey:PIN_ID];
    
    self.pinIsShareable =  [dict valueForKey:PIN_IS_SHAREABLE];
    
    self.pinMessage = [dict valueForKey:PIN_MESSAGE];
    self.pinDateFullString = [dict valueForKey:PIN_DATE];
    self.pinDate = [PSUtility getDateFromString:[dict valueForKey:PIN_DATE] withFormate:@"yyyy-MM-dd HH:mm:ss Z"];
    self.pinDateString = [NSString stringWithFormat:@"%@th,%@ at",[self.pinDate stringWithFormat:@"MMM dd"],[self.pinDate stringWithFormat:@"yyyy"]];
    self.pinTimeString = [NSString stringWithFormat:@"%@",[self.pinDate stringWithFormat:@"hh.mm a"]];
    self.pinOwner = [dict valueForKey:PIN_OWNER];
    self.pinOwnerName = [dict valueForKey:PIN_OWNER_NAME];
    self.pinIsShared = [PSUtility isTrue:[dict valueForKey:PIN_IS_SHARED]];
    self.pinLat = [dict valueForKey:PIN_LAT];
    self.pinLang = [dict valueForKey:PIN_LANG];
    self.pinLang = [dict valueForKey:PIN_LANG];
    self.pinCategory = [dict valueForKey:PIN_CATEGORY];
    self.pinLocation = [dict valueForKey:PIN_LOCATION];
    self.pinLikedUsersList = [dict valueForKey:PIN_LIKED_USERS];
    self.pinSharedUsersList = [dict valueForKey:PIN_SHARED_USERS];
    self.pinIsLiked = [PSUtility isTrue:[dict valueForKey:PIN_IS_LIKED]];
//    if ([[dict valueForKey:SNAP_IMAGE_NAME] valueForKey:@"url"] == [NSNull null])
//    {
//        
//    }
//    else
//    {
        if([[dict valueForKey:SNAP_IMAGE_NAME] length] > 0) {
            self.snapImageUrl = [NSString stringWithFormat:@"%@%@",kBaseImageOnlineUrl,[dict valueForKey:SNAP_IMAGE_NAME]];
        }
//    }
}

+ (NSMutableArray *)getPinModelsArrayFromArray:(NSArray *)dataArray {
    NSMutableArray *resultArray= [NSMutableArray new];
    for (NSDictionary *pinDict in dataArray) {
        [resultArray addObject:[[PSPinModel alloc] initWithDictonery:pinDict]];
    }
    return resultArray;
}
@end
