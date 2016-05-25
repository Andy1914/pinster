//
//  PSTextField.m
//  Pinster
//
//  Created by MobileDev on 23/05/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSTextField.h"

@implementation PSTextField

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
//    if([self tag] == 999)
//    {
        if ([self respondsToSelector:@selector(setAttributedPlaceholder:)] && [self.placeholder length] > 0) {
            UIColor *color = [UIColor blackColor];
            self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: color}];
        }
//    }
    
    [self setLeftPadding];
    [PSUtility setBorderSettings:self];
    if([self.psFontName length] > 0)
        [self setFont:[UIFont fontWithName:self.psFontName  size:self.font.pointSize]];
}

-(void)setLeftPadding {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
}
@end
