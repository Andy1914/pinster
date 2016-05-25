//
//  PSMyAnnotationClass.m
//  Pinster
//
//  Created by Mobiledev on 01/07/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSMyAnnotationClass.h"

static NSString* const ANNOTATION_SELECTED_DESELECTED = @"mapAnnotationSelectedOrDeselected";

@implementation PSMyAnnotationClass
-(id) initWithCoordinate:(CLLocationCoordinate2D) coordinate{
    self=[super init];
    if(self){
        _coordinate=coordinate;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    NSString *action = (__bridge NSString *)context;
	if ([action isEqualToString:ANNOTATION_SELECTED_DESELECTED]) {
		BOOL annotationSelected = [[change valueForKey:@"new"] boolValue];
		if (annotationSelected) {
			NSLog(@"Annotation was selected, do whatever required");
            // Accions when annotation selected
		}else {
			NSLog(@"Annotation was deselected, do what you must");
            // Accions when annotation deselected
		}
	}
}

@end
