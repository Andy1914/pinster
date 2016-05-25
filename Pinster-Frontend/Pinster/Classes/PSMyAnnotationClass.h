//
//  PSMyAnnotationClass.h
//  Pinster
//
//  Created by Mobiledev on 01/07/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSMyAnnotationClass : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
-(id) initWithCoordinate:(CLLocationCoordinate2D) coordinate;
@end
