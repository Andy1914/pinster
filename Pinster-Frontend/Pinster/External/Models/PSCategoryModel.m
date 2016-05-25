//
//  DAOrderModel.m
//  DeafAidNew
//
//  Created by MobileDev on 24/05/14.
//  Copyright (c) 2014 companyname. All rights reserved.
//

#import "PSCategoryModel.h"

@implementation PSCategoryModel
@synthesize  cat_id,name,count,image;

-(id)initWithDictonery:(NSDictionary *)dict {
    self = [super init];
    if(self) {
        [self setCategotyFromDictonery:dict];
    }
    return self;
}

- (void)setCategotyFromDictonery:(NSDictionary *)dict {
    self.cat_id = [dict valueForKey:CAT_ID];
    self.name  = [dict valueForKey:CAT_NAME];
    self.image  = [dict valueForKey:CAT_IMAGE];
    self.count  = [dict valueForKey:CAT_COUNT];
    self.pinsList = [dict valueForKey:CAT_PINS_LIST];
}
+ (NSMutableArray *)getCategoryModelsArrayFromArray:(NSArray *)dataArray {
    NSMutableArray *resultArray= [NSMutableArray new];
    for (NSDictionary *catDict in dataArray) {
        [resultArray addObject:[[PSCategoryModel alloc] initWithDictonery:catDict]];
    }
    return resultArray;
}

@end
