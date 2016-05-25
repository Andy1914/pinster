//
//  PSLabel.m
//  Pinster
//
//  Created by MobileDev on 23/05/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSLabel.h"

@implementation PSLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)awakeFromNib {
    [self setApperenceSettings];
}
- (void)setApperenceSettings {
    [PSUtility setBorderSettings:self];
    if([self.psFontName length] > 0)
        [self setFont:[UIFont fontWithName:self.psFontName  size:self.font.pointSize]];
}

@end
