//
//  ToggleButton.m
//  ToggleView
//
//  Created by SOMTD on 12/10/15.
//  Copyright (c) 2012年 somtd.com. All rights reserved.
//

#import "ToggleButton.h"

//change button image option
NSString *const TOGGLE_BUTTON_IMAGE_L    = @"toggle_button_l.png";
NSString *const TOGGLE_BUTTON_IMAGE_R    = @"toggle_button_r.png";

NSString *const TOGGLE_BUTTON_IMAGE_LRe    = @"list-selected-btn.png";
NSString *const TOGGLE_BUTTON_IMAGE_RRe    = @"saved-selected-btn.png";

@implementation ToggleButton
@synthesize buttonType;

- (id)initWithImage:(UIImage *)image buttonType:(ToggleButtonType)aButtonType
{
    self = [super initWithImage:image];
    if (self) {
        self.buttonType = aButtonType;
        if (self.buttonType == ToggleButtonTypeChangeImage)
        {
            //default select "L"
//            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"togglereceived"])
//            {
//                self.image = [UIImage imageNamed:TOGGLE_BUTTON_IMAGE_LRe];
//            }
//            else
//            {
                self.image = [UIImage imageNamed:TOGGLE_BUTTON_IMAGE_L];
//            }
            
            return self;
        }
    }
    return self;
}

- (void)selectedLeftToggleButton
{
    if (self.buttonType == ToggleButtonTypeChangeImage)
    {
//        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"togglereceived"])
//        {
//            self.image = [UIImage imageNamed:TOGGLE_BUTTON_IMAGE_LRe];
//        }
//        else
//        {
            self.image = [UIImage imageNamed:TOGGLE_BUTTON_IMAGE_L];
//        }
    }
}

- (void)selectedRightToggleButton
{
    if (self.buttonType == ToggleButtonTypeChangeImage)
    {
//        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"togglereceived"])
//        {
//            self.image = [UIImage imageNamed:TOGGLE_BUTTON_IMAGE_RRe];
//        }
//        else
//        {
            self.image = [UIImage imageNamed:TOGGLE_BUTTON_IMAGE_R];
//        }

    }
}
@end
