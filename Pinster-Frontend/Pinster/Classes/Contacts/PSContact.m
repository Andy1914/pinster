//
//  Contact.m
//  upsi
//
//  Created by Mac on 3/24/14.
//  Copyright (c) 2014 Laith. All rights reserved.
//

#import "PSContact.h"

@implementation PSContact

#pragma mark - NSObject - Creating, Copying, and Deallocating Objects

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:attributes];
    }
    
    return self;
}

#pragma mark - NSKeyValueCoding Protocol

- (void)setValue:(id)value forKey:(NSString *)key {
//    if ([key isEqualToString:@"id"]) {
//        self.recordId = [value longLongValue];
//    } else if ([key isEqualToString:@"firstName"]) {
//        self.firstName = value;
//    }
    if ([key isEqualToString:@"firstName"]) {
        self.firstName = value;
    }
    else if ([key isEqualToString:@"firstName"]) {
        self.firstName = value;
    }
    
    else if ([key isEqualToString:@"id"]) {
        self.friendIds = value;
    }
    
    else if ([key isEqualToString:@"phone"])
    {
        self.phone = value;
        
    }else if ([key isEqualToString:@"email"]) {
        self.email = value;
    }else if ([key isEqualToString:@"image"]) {
        self.image = value;
    }else if ([key isEqualToString:@"isSelected"]) {
        self.selected = [value boolValue];
    }else if ([key isEqualToString:@"date"]) {
        // TODO: Fix
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        self.date = [dateFormatter dateFromString:value];
    } else if ([key isEqualToString:@"dateUpdated"]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
        self.dateUpdated = [dateFormatter dateFromString:value];
    }
    
}

- (NSString *)getfullNameFromContact {
    if(self.firstName != nil && self.lastName != nil) {
        return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
    } else if (self.firstName != nil) {
        return self.firstName;
    } else if (self.lastName != nil) {
        return self.lastName;
    } else {
        return @"";
    }
}
+ (NSString *)setfullNameFromcontact:(PSContact *)contact {
    if(contact.firstName != nil && contact.lastName != nil) {
        return [NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName];
    } else if (contact.firstName != nil) {
        return contact.firstName;
    } else if (contact.lastName != nil) {
        return contact.lastName;
    } else {
        return @"";
    }
}
@end
