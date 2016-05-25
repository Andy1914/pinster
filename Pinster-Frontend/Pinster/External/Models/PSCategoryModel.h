//
//  DAOrderModel.h
//  DeafAidNew
//
//  Created by MobileDev on 24/05/14.
//  Copyright (c) 2014 companyname. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CAT_ID          @"id"
#define CAT_NAME        @"name"
#define CAT_IMAGE       @"image"
#define CAT_COUNT       @"count"
#define CAT_PINS_LIST       @"pins_list"

@interface PSCategoryModel : NSObject
@property (nonatomic, strong) NSString *cat_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSMutableArray *pinsList;

-(id)initWithDictonery:(NSDictionary *)dict;
+ (NSMutableArray *)getCategoryModelsArrayFromArray:(NSArray *)dataArray;
@end
